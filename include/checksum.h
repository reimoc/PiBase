//
// checksum.h
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

#ifndef CHECKSUM_H
#define CHECKSUM_H

#include "test_array.h"

uint32_t compute_xor_checksum(const TestArray* arr, uint32_t curr_arr_size);
void update_reference_checksums(TestArray* arr, uint32_t curr_arr_size, const char* reason, int value);

#endif