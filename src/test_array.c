//
// test_array.c
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

#include "test_array.h"
#include "pl011_uart.h"
#include "commands.h"

/*
 * Test array manipulation routines for PiBase.
 *
 * Provides functions to initialize, increment, and fill the
 * test array used for memory operations and EMFI tests. Includes:
 *   - Filling with a constant value
 *   - Filling incrementally
 *   - Incrementing all elements
 *
 * Progress and status are optionally reported over UART for feedback
 * during long operations.
 */

extern TestArray arr;

void test_array_fill(TestArray* arr, uint32_t value) {
    uint32_t size = get_curr_arr_size();
    
    uart_send_string("Filling: ");
    for (uint32_t i = 0; i < size; i++) {
        arr->data[i] = value;
        if (i % 100000 == 0) uart_send_string(".");
    }
    asm volatile("dsb sy" ::: "memory");
    uart_send_string("\n");
}

void test_array_fill_incremental(TestArray* arr) {
    uint32_t size = get_curr_arr_size();
    for (uint32_t i = 0; i < size; i++) {
        arr->data[i] = i;
    }
    uart_line_breaks(1);
}

void test_array_increment(TestArray* arr) {
    uint32_t size = get_curr_arr_size();
    for (uint32_t i = 0; i < size; i++) {
        arr->data[i]++;
    }
}
