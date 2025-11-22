//
// mm.h
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

/*Constraints for memory layout
Page /section sizes
Defines LOW_MEMORY used for setting up the stack pointer
*/
#ifndef MM_H
#define MM_H

#ifndef RPI_VERSION
#error "RPI_VERSION not defined"
#endif

#ifndef PERIPHERAL_BASE
    #if RPI_VERSION == 4
        #define PERIPHERAL_BASE 0xFE000000UL
    #else
        #error "Unsupported RPI_VERSION"
    #endif
#endif

#endif // MM_H

#define PAGE_SHIFT 12
#define TABLE_SHIFT 9
#define SECTION_SHIFT (PAGE_SHIFT + TABLE_SHIFT)
#define PAGE_SIZE (1 << PAGE_SHIFT)
#define SECTION_SIZE (1 << SECTION_SHIFT)

#define LOW_MEMORY (0x2000000)  // Add a safe buffer

#ifndef __ASSEMBLER__

void memzero(unsigned long src, unsigned int n);

#endif