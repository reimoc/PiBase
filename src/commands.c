//
// commands.c
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


#include "commands.h"
#include "pl011_uart.h"
#include "checksum.h"
#include "emfi_test.h"

/*
 * Implements command handling routines for PiBase.
 *
 * Provides functions to display the startup banner and available
 * UART commands, as well as handlers for memory fill operations
 * and checksum verification (XOR and CRC32). Commands update
 * reference checksums and report results back over UART, forming
 * the core of the interactive interface.
 */

 #define GREEN_HASH "\033[32m#\033[0m"
 #define GREEN_LINE   "\033[32m#########################################################################\033[0m"
 #define CONTEXT_RADIUS 10

static volatile bool full_dump_flag = false;
static uint32_t curr_arr_size = TEST_ARRAY_SIZE;

void send_banner() {
uart_line_breaks(5);
uart_send_string("PiBase OS initializing...\n");
uart_line_breaks(2);

uart_send_string(
    GREEN_LINE "\n"
    GREEN_HASH "                                                                       " GREEN_HASH "\n"
    GREEN_HASH "   __        __     _                                     _            " GREEN_HASH "\n"
    GREEN_HASH "   \\ \\      / /___ | |  ___  ___   _ __ ___    ___       | |_  ___     " GREEN_HASH "\n"
    GREEN_HASH "    \\ \\ /\\ / // _ \\| | / __|/ _ \\ | '_ ` _ \\  / _ \\      | __|/ _ \\    " GREEN_HASH "\n"
    GREEN_HASH "     \\ V  V /|  __/| || (__| (_) || | | | | ||  __/      | |_| (_) |   " GREEN_HASH "\n"
    GREEN_HASH "      \\_/\\_/  \\___||_| \\___|\\___/ |_| |_| |_| \\___|       \\__|\\___/    " GREEN_HASH "\n"
    GREEN_HASH "         ____   _  ____                            ___   ____          " GREEN_HASH "\n"
    GREEN_HASH "        |  _ \\ (_)| __ )   __ _  ___   ___        / _ \\ / ___|         " GREEN_HASH "\n"
    GREEN_HASH "        | |_) || ||  _ \\  / _` |/ __| / _ \\      | | | |\\___ \\         " GREEN_HASH "\n"
    GREEN_HASH "        |  __/ | || |_) || (_| |\\__ \\|  __/      | |_| | ___) |        " GREEN_HASH "\n"
    GREEN_HASH "        |_|    |_||____/  \\__,_||___/ \\___|       \\___/ |____/         " GREEN_HASH "\n"
    GREEN_HASH "                                                                       " GREEN_HASH "\n"
    GREEN_HASH "                                                                       " GREEN_HASH "\n"
    GREEN_LINE "\n"
);

#if RPI_VERSION == 4
    uart_send_string("                         for Raspberry Pi 4\n\n");
#elif RPI_VERSION == 5
    uart_send_string("                         for Raspberry Pi 5\n\n");
#endif

uart_send_string("    Copyright (C) 2025 Martin Monge Reig | Licensed under GNU GPLv3\n\n");
uart_send_string("   See https://www.gnu.org/licenses/gpl-3.0.html for license details");
}

void send_command_description() {
    uart_send_string("Enter command:\n");
    uart_send_string(" 0 = Fill with 0s\n");
    uart_send_string(" 1 = Fill with 1s (0xFFFFFFFF)\n");
    uart_send_string(" i = Fill incremental\n");
    uart_send_string(" r = Run EMFI increment loop\n");
    uart_send_string(" x = Compute XOR checksum\n");
    uart_send_string(" d = Dump full array per UART (slow)\n");
    uart_send_string(" D = enable Dump for next EMFI test\n\n");
}

void set_curr_arr_size(uint32_t size){
    curr_arr_size = size;
}

uint32_t get_curr_arr_size(){
    return curr_arr_size;
}

void do_fill(TestArray* arr, uint32_t value, const char* reason) {
    uint32_t size = get_curr_arr_size();
    uart_send_string("Filling array ");
    uart_send_string(reason);
    uart_send_string("\n");
    test_array_fill(arr, value);
    uart_send_string("Done\n\n");

    uart_send_string("Calculating checksums...\n");
    update_reference_checksums(arr, size, reason, 1);
}

void do_fill_incremental(TestArray* arr) {
        uint32_t size = get_curr_arr_size();

    uart_send_string("Filling array incrementally\n");
    test_array_fill_incremental(arr);
    uart_send_string("Done\n\n");

    uart_send_string("Calculating checksum...\n");
    update_reference_checksums(arr, size, "incremental fill", 0);
}

void do_checksum_xor(TestArray* arr) {
    uint32_t size = get_curr_arr_size();

    uart_send_string("Calculating XOR Checksum...\n");
    uint32_t current = compute_xor_checksum(arr, size);

    uart_send_string("Current XOR Checksum: 0x");
    uart_send_hex(current);
    uart_send_string("\nReference XOR Checksum: 0x");
    uart_send_hex(arr->reference_xor_checksum);
    uart_send_string("\nSource: ");
    uart_send_string(arr->last_checksum_reason);
    uart_send_string("\nComparing XOR checksum against reference from: ");
    if(arr->is_fill){
        uart_send_string("filling ");
    }
    uart_send_string(arr->last_checksum_reason);
    uart_send_string(current == arr->reference_xor_checksum ? "\n\033[32m[OK]\033[0m\n" : "\n\033[31m[FAIL]\033[0m\n");
}

void send_first_16_elements(TestArray* arr, uint32_t iteration) {
    uart_send_string("\nFirst 16 Array Elements for iteration ");
    uart_send_dec(iteration);
    uart_send_string(" are:\n");
    for (uint32_t i = 0; i < 16; i++) {
        uart_send_string("Elem[");
        uart_send_dec(i);
        uart_send_string("] = 0x");
        uart_send_hex(arr->data[i]);
        uart_send_string("\n");
    }
}


