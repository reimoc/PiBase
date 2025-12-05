//
// emfi_test.c
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

#include "emfi_test.h"
#include "gpio.h"
#include "pl011_uart.h"
#include "checksum.h"
#include "commands.h"
#include <stddef.h>

/*
 * Implements Electro-Magnetic Fault Injection (EMFI) tests for PiBase.
 *
 * Provides routines to generate controlled EMFI pulses via GPIO and
 * apply them during memory operations on the test array. Supports
 * two modes:
 *   - SINGLE: pulse during each element update
 *   - BATCH : pulse after processing the whole array
 *
 * The test loop monitors for checksum mismatches to detect faults,
 * supports user abort via UART, and reports progress and errors
 * over the serial interface.
 */

#define CACHE_LINE_BYTES 64
#define INTERVAL 128
#define VIEW_ARR_ELEMENTS 256
#define SYSTEM_TIMER_BASE 0xFE003000
#define TIME_PRINT_MS 1000
#define TIMER_CLO         (*(volatile uint32_t*)(SYSTEM_TIMER_BASE + 0x04))

static void delay_us(uint32_t us) {
    uint32_t start = TIMER_CLO;
    while ((TIMER_CLO - start) < us) {}
}

static void emfi_pulse_precise(uint32_t pulse_length) {
    gpio_set(EMFI_PIN, 1);
    delay_us(pulse_length);
    gpio_set(EMFI_PIN, 0);
}

void run_emfi_test(TestArray* arr,  TestArray* ref_arr, uint32_t curr_arr_size) {
    uart_send_string("Running EMFI test...\n");
    uart_send_string("Press [BACK] to abort\n");
    gpio_pin_set_func(EMFI_PIN, GFOutput);
    gpio_pin_enable(EMFI_PIN);

    uint32_t iteration = 0;
    uint32_t start_time = TIMER_CLO;
    uint32_t last_time_print_ms = 0;

    static uint32_t timer_offset = 0;
    timer_offset = start_time;

    uart_send_string("\n\nCalulcating reference XOR checksum...\n");
    uint32_t ref_xor = compute_xor_checksum(arr, curr_arr_size);
    uart_send_string("Done\n");
    
    while (1) {
        iteration++;

        //Abort Test if necessary
        if (uart_read_ready()) {
            char c = uart_recv();
            if (c == 0x7F) { //Backspace
                uart_send_string("\n[INFO] EMFI test aborted at iteration ");
                uart_send_dec(iteration);
                uart_send_string("\n");

                // Write First 14 elemtens of the Array
                uart_send_string("First 16 Array Elements for iteration ");
                uart_send_dec(iteration);
                uart_send_string(" are\n");
                for (uint32_t i = 0; i < 16; i++) {
                    uart_send_string("Elem[");
                    uart_send_dec(i);
                    uart_send_string("] = 0x");
                    uart_send_hex(arr->data[i]);
                    uart_send_string("\n");
                }
                break;
            }
        }

        for (int i = 0; i < curr_arr_size; i++) { 
            uint32_t v = arr->data[i];           
            v = ((v * 13) ^ (v >> 7)) + 0xA5A5A5A5; 
            arr->data[i] = v;                    
        }

        uintptr_t addr = (uintptr_t)arr->data & ~(CACHE_LINE_BYTES - 1);
        uintptr_t end  = (uintptr_t)arr->data + curr_arr_size * sizeof(arr->data[0]);
        size_t current_line = 0;
        uart_send_string(".\n");

        for (; addr < end; addr += CACHE_LINE_BYTES, current_line++) {
            asm volatile("dc civac, %0" :: "r"(addr) : "memory");
        }
        asm volatile("dsb sy" ::: "memory");
        asm volatile("isb" ::: "memory");

        uint32_t cur_xor = compute_xor_checksum(arr, curr_arr_size);

        if (cur_xor != ref_xor) {
            uart_send_string("\n\033[31m[FAULT DETECTED]\033[0m Iteration ");
            uart_send_dec(iteration);
            uart_send_string(": XOR mismatch \nReference XOR-Checksum: 0x");
            uart_send_hex(ref_xor);
            uart_send_string("\nCurrent XOR-Checksum: 0x");
            uart_send_hex(cur_xor);
            uart_send_string("\n");

            uart_send_string("Waiting to start Fault analysis... (hit 'c' to continue)\n\n");
            while(true){
                if (uart_read_ready()) {
                char c = uart_recv();
                    if (c == 'c') { //Enter
                        break;
                    }
                }
            }

            
            uart_send_string("==== Starting Fault analysis ====\n");
            uart_send_string("Reconstructing reference state and scanning for anomalies...\n");
            int k = 0;
            while(k < iteration){
                uart_send_string(".\n");
                // Compute ref arr again until iteration of fault
                for (int i = 0; i < curr_arr_size; i++) { 
                    uint32_t v = ref_arr->data[i];           
                    v = ((v * 13) ^ (v >> 7)) + 0xA5A5A5A5; 
                    ref_arr->data[i] = v;                    
                }
                k++;
            }
            


            print_array_diffs(arr, ref_arr, curr_arr_size);
            uart_send_string("==== Scan complete ====");
            uart_send_string("\n\nReturning to main screen\n\n");
            return;

        } else {
            // only update if there is no error
            ref_xor = cur_xor;
        }


        if((iteration & (VIEW_ARR_ELEMENTS - 1)) == 0) {
            uart_send_string("\n\nFirst 16 Array Elements for iteration ");
            uart_send_dec(iteration);
            uart_send_string(" are\n");
            for (uint32_t i = 0; i < 16; i++) {
                uart_send_string("Elem[");
                uart_send_dec(i);
                uart_send_string("] = 0x");
                uart_send_hex(arr->data[i]);
                uart_send_string("\n\n");
            }
        }

         // Time-heartbeat through UART
        uint32_t now = TIMER_CLO;
        uint32_t elapsed_us = now - timer_offset;
        uint32_t elapsed_ms = elapsed_us / 1000;

        // Send elapsed time and iterations
        if ((elapsed_ms - last_time_print_ms) >= TIME_PRINT_MS) {
            last_time_print_ms = elapsed_ms;

            uart_send_string("[TIME] elapsed_ms=");
            uart_send_dec(elapsed_ms);
            uart_send_string(" iter=");
            uart_send_dec(iteration);
            uart_send_string("\n");
        }
    }
}

void print_diff_range(int start, int end, uint32_t got, uint32_t expected) {
    uart_send_string("Idx ");
    uart_send_dec(start);
    if (end > start) {
        uart_send_string("-");
        uart_send_dec(end);
    }
    uart_send_string(": got 0x");
    uart_send_hex(got);
    uart_send_string(", expected 0x");
    uart_send_hex(expected);
    uart_send_string("\n");
}

void print_array_diffs(TestArray* arr, TestArray* ref_arr, uint32_t len){
    int start = -1;
    uint32_t last_got = 0, last_expected = 0;

    for (uint32_t i = 0; i < len; ++i) {
        uint32_t got = arr->data[i];
        uint32_t expected = ref_arr->data[i];

        if (got != expected) {
            if (start == -1) {
                /* begin new group */
                start = (int)i;
                last_got = got;
                last_expected = expected;
            } else if (got == last_got && expected == last_expected) {
                /* continue current group */
            } else {
                /* output previous group and start a new one */
                print_diff_range(start, i - 1, last_got, last_expected);
                start = (int)i;
                last_got = got;
                last_expected = expected;
            }
        } else if (start != -1) {
            /* group ended just before i */
            print_diff_range(start, i - 1, last_got, last_expected);
            start = -1;
        }
    }

    /* if a group reached the end of the array, print it */
    if (start != -1) {
        print_diff_range(start, (int)len - 1, last_got, last_expected);
    }
}