//
// kernel.c
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

#include "pl011_uart.h"
#include "gpio.h"
#include "test_array.h"
#include "checksum.h"
#include "emfi_test.h"
#include "commands.h"
#include <stdbool.h>
/**
 * Main entry point for PiBase.
 *
 * This file implements the kernel's initialization and interactive
 * command loop using the PL011 UART. After startup, the kernel enters
 * an infinite loop, continuously listening for UART input and executing
 * commands that perform memory fills, checksum calculations, and EMFI tests.
 *
 * The UART interface serves as the primary means of interacting with
 * PiBase in this minimal bare-metal environment.
 */
TestArray arr __attribute__((section(".large_bss")));
TestArray ref_arr __attribute__((section(".ref_arr_bss")));

extern char __stack_start[];
extern char __stack_end[];
extern char bss_begin[];
extern char bss_end[];

void kernel_main() {
    uart_init();
    gpio_pin_set_func(EMFI_PIN, GFOutput);
    gpio_pin_enable(EMFI_PIN);
    gpio_set(EMFI_PIN, 0);

    send_banner();


    uart_line_breaks(5);

    uart_send_string("=== ADDR REPORT ===\n");
    uart_send_string("arr @ 0x"); uart_send_hex((uint32_t)((uintptr_t)&arr)); uart_send_string("\n");
    uart_send_string("ref arr @ 0x"); uart_send_hex((uint32_t) ((uintptr_t)&ref_arr)); uart_send_string("\n");
    uart_send_string("bss_begin 0x"); uart_send_hex((uint32_t)((uintptr_t)bss_begin)); uart_send_string("\n");
    uart_send_string("bss_end   0x"); uart_send_hex((uint32_t)((uintptr_t)bss_end)); uart_send_string("\n");
    uart_send_string("__stack_start 0x"); uart_send_hex((uint32_t)((uintptr_t)__stack_start)); uart_send_string("\n");
    uart_send_string("__stack_end   0x"); uart_send_hex((uint32_t)((uintptr_t)__stack_end)); uart_send_string("\n");
    uart_send_string("===================\n");
    uart_line_breaks(2);

    uart_send_string("Please specify an array size to proceed with further configuration:  (MAX 524.288) ");
    uint32_t size = uart_receive_number();
    set_curr_arr_size(size);
    uart_send_string("Array size succesfully set to ");
    uart_send_dec(size);
    uart_send_string("\nProceeding with configuration...\n");

    uart_line_breaks(2);
    send_command_description();
    uart_line_breaks(2);

    while (1) {
        char c = uart_recv();
        uart_send_string("\nReceived: ");
        uart_send(c);
        uart_send_string("\n");
        uart_flush();

        bool recognized = true;

        switch (c) { 
            case '0': do_fill(&arr, 0, "with 0s"); do_fill(&ref_arr, 0, "with 0s"); break;
            case '1': do_fill(&arr, 0xFFFFFFFF, "with 1s"); do_fill(&ref_arr, 0xFFFFFFFF, "with 1s"); break;
            case 'i': do_fill_incremental(&arr); do_fill_incremental(&ref_arr); break;
            case 'r': {
                //uart_send_string("Specify N to emit pulse every N flushed data lines: ");
                //uint32_t n = uart_receive_number();
                //uart_send_string("\nValue set successfully set to: ");
                //uart_send_dec(n);
                uart_send_string("\nStarting EMFI test\n");
                uint32_t size = get_curr_arr_size();

                run_emfi_test(&arr, &ref_arr, size);
                break;
            }

            case 'x': do_checksum_xor(&arr); break;
            case 'd': {
                uart_send_string("Doing nothing...\n");
                break;
            }

            case 'D': {
                uart_send_string("Doing nothing...\n");
                break;
                
            }

            default:
                uart_send_string("Unknown command\n\n");
                send_command_description();
                recognized = false;
                break;
        }

        if (recognized) {
            uart_send_string("Done\n");
            uart_line_breaks(2);
            send_command_description();
            uart_flush();
        }
    }
}
