//
// pl011_uart.c
//
// PiBase - A Baremetal OS for Raspberry Pi 4 and 5
// Copyright (C) 2025 Martin Monge Reig
//
// This program is free software: it can be redistributed and/or modified
// under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at the option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// A copy of the GNU General Public License should have been received
// along with this program. If not, see <https://www.gnu.org/licenses/>.

#include <stdint.h>
#include <mm.h>

/*
 * PL011 UART driver for PiBase.
 *
 * Provides low-level routines for initializing and using the UART0
 * on Raspberry Pi 4/5. Supports:
 *   - UART initialization (baud rate, GPIO setup, FIFOs)
 *   - Sending and receiving characters, strings, decimal and hex numbers
 *   - Line breaks and input echo with basic editing
 *   - Blocking/non-blocking status checks
 *
 * Used as the primary interface for the PiBase kernel’s interactive
 * command loop and debug output.
 */


// ==== PL011 UART0 Base Address (Raspberry Pi 4) ====
#define UART0_BASE   (PERIPHERAL_BASE + 0x201000)
#define GPIO_BASE    (PERIPHERAL_BASE + 0x200000)   

#define UART0_DR     ((volatile uint32_t *)(UART0_BASE + 0x00))
#define UART0_FR     ((volatile uint32_t *)(UART0_BASE + 0x18))
#define UART0_IBRD   ((volatile uint32_t *)(UART0_BASE + 0x24))
#define UART0_FBRD   ((volatile uint32_t *)(UART0_BASE + 0x28))
#define UART0_LCRH   ((volatile uint32_t *)(UART0_BASE + 0x2C))
#define UART0_CR     ((volatile uint32_t *)(UART0_BASE + 0x30))
#define UART0_ICR    ((volatile uint32_t *)(UART0_BASE + 0x44))

// ==== GPIO (Raspberry Pi 4) ====
#define GPFSEL1      ((volatile uint32_t *)(GPIO_BASE + 0x04))
#define GPPUPPDN0    ((volatile uint32_t *)(GPIO_BASE + 0xE4))

void uart_init() {
    // Disable UART0
    *UART0_CR = 0;

    // Setup GPIO14 (TXD0) and GPIO15 (RXD0) to alt0
    uint32_t r = *GPFSEL1;
    r &= ~((7 << 12) | (7 << 15)); // clear GPIO14/15
    r |= (4 << 12) | (4 << 15);    // set alt0
    *GPFSEL1 = r;

    // Disable pull-up/down on GPIO14/15
    *GPPUPPDN0 &= ~((3 << 28) | (3 << 30));

    // Clear pending interrupts
    *UART0_ICR = 0x7FF;

    // Baudrate 115200 @ 48 MHz clock
    // IBRD = int(48,000,000 / (16 * 115200)) = 26
    // FBRD = round(((48,000,000 / (16 * 115200)) - 26) * 64) = 3
    *UART0_IBRD = 26;
    *UART0_FBRD = 3;

    // 8 bits, no parity, one stop bit, FIFOs enabled
    *UART0_LCRH = (3 << 5) | (1 << 4);

    // Enable UART0, TX and RX
    *UART0_CR = (1 << 9) | (1 << 8) | (1 << 0);
}

void uart_flush() {
    // Wait until TX FIFO is empty
    while (!(*UART0_FR & (1 << 7))) {}
    // RX FIFO flush
    while (!(*UART0_FR & (1 << 4))) {
        volatile char dummy = (char)(*UART0_DR);
        (void)dummy;
    }
}

void uart_send(char c) {
    while (*UART0_FR & (1 << 5)) {} // TX FIFO full?
    *UART0_DR = c;
}

char uart_recv() {
    while (*UART0_FR & (1 << 4)) {} // RX FIFO empty?
    return (char)(*UART0_DR & 0xFF);
}

void uart_send_string(const char *str) {
    while (*str) {
        if (*str == '\n') uart_send('\r');
        uart_send(*str++);
    }
}

void uart_line_breaks(int count) {
    for (int i = 0; i < count; i++) {
        uart_send_string("\n");
    }
}

//UART Hex-Output
void uart_send_hex(uint32_t value) {
    const char hex_chars[] = "0123456789ABCDEF";
    for (int i = 7; i >= 0; i--) {
        char c = hex_chars[(value >> (i * 4)) & 0xF];
        uart_send(c);
    }
}

uint32_t uart_receive_number(void) {
    char buf[16];
    int idx = 0;
    char c;

    while (1) {
        c = uart_recv(); // non-blocking 
        if (c == '\r' || c == '\n') {
            uart_send_string("\n");
            break;
        }

        if (c >= '0' && c <= '9' && idx < 15) {
            buf[idx++] = c;
            uart_send(c); // echo back
        } 
        else if (c == 0x7F && idx > 0) { // Backspace
            idx--; // delete one char
            uart_send_string("\b \b");
        }
    }

    buf[idx] = '\0';

    // Convert to number
    uint32_t value = 0;
    for (int i = 0; i < idx; i++) {
        value = value * 10 + (buf[i] - '0');
    }

    return value;
}

void uart_send_dec(uint32_t num) {
    char buf[11]; // enough for 32-bit int
    int i = 10;
    buf[i] = '\0';

    if (num == 0) {
        uart_send('0');
        return;
    }

    while (num > 0 && i > 0) {
        buf[--i] = '0' + (num % 10);
        num /= 10;
    }
    uart_send_string(&buf[i]);
}

void uart_send_dec64(uint64_t num) {
    char buf[21]; // enough for 32-bit int
    int i = 20;
    buf[i] = '\0';

    if (num == 0) {
        uart_send('0');
        return;
    }

    while (num > 0 && i > 0) {
        buf[--i] = '0' + (num % 10);
        num /= 10;
    }
    uart_send_string(&buf[i]);
}

int uart_read_ready(void) {
    return (*UART0_FR & (1 << 4)) == 0;
}