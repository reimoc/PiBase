//
// checksum.c
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

#include "checksum.h"
#include "pl011_uart.h"

/*
 * Implements checksum routines for PiBase.
 *
 * Provides functions to compute XOR and CRC32 checksums over the
 * test array, and to update stored reference checksums. Results
 * are reported over UART for debugging and verification.
 *
 * Used by the kernel command loop to validate memory contents
 * and track changes in test data.
 */

uint32_t compute_xor_checksum(const TestArray* arr, uint32_t curr_arr_size) {
    uint32_t sum = 0;
    for (uint32_t i = 0; i < curr_arr_size; i++) {
        sum ^= arr->data[i];
    }
    return sum;
}

void update_reference_checksums(TestArray* arr, uint32_t curr_arr_size, const char* reason, int value) {
    arr->reference_xor_checksum = compute_xor_checksum(arr, curr_arr_size);
    arr->last_checksum_reason = reason;
    arr->is_fill = value;

    uart_send_string("\nReference XOR Checksum: 0x");
    uart_send_hex(arr->reference_xor_checksum);
    uart_send_string("\nUpdated checksum after ");

    // Check if reason is "with 0s" or "with 1s"
    if (arr->is_fill) {
        uart_send_string("filling ");  // "filling with 0s" or "filling with 1s"
    }

    uart_send_string(reason);
    uart_send_string("\n");
}
