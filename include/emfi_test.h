//
// emfi_test.h
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

#ifndef EMFI_TEST_H
#define EMFI_TEST_H

#include "test_array.h"
#include "pl011_uart.h"

#define EMFI_PIN 4

#define SYSTEM_TIMER_BASE 0xFE003000
#define TIMER_CLO         (*(volatile uint32_t*)(SYSTEM_TIMER_BASE + 0x04))

// Run EMFI test with a given mode and delay parameter
void run_emfi_test(TestArray* arr, TestArray* ref_arr, uint32_t curr_arr_size);
void print_diff_range(int start, int end, uint32_t got, uint32_t expected);
void print_array_diffs(TestArray* arr, TestArray* ref_arr, uint32_t len);
#endif