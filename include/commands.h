//
// commands.h
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

#pragma once

#include "test_array.h"

void send_banner(void);
void send_command_description(void);
void set_curr_arr_size(uint32_t);
uint32_t get_curr_arr_size();
void do_fill(TestArray* arr, uint32_t value, const char* reason);
void do_fill_incremental(TestArray* arr);
void do_checksum_xor(TestArray* arr);
void send_first_16_elements(TestArray* arr, uint32_t iteration);