//
// base.h
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
/*Defines PBASE depending on pi version*/

#if !defined(RPI_VERSION)
#error RPI_VERSION NOT DEFINED
#endif


#if RPI_VERSION == 4
#define PERIPHERAL_BASE 0xFE000000
#elif RPI_VERSION == 5
#define PERIPHERAL_BASE 0x1000000000
#else
#error Unknown RPI_VERSION
#endif