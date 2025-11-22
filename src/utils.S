/*
 * utils.S
 *
 * PiBase - A Baremetal OS for Raspberry Pi 4 and 5
 * Copyright (C) 2025 Martin Monge Reig
 *
 * This program is free software: it can be redistributed and/or modified
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at the option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * A copy of the GNU General Public License should have been received * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

/*
 * Low-level utility routines for PiBase.
 *
 * Provides basic functions for:
 *   - Busy-wait delays (`delay`)
 *   - 32-bit memory-mapped I/O access (`put32` and `get32`)
 *
 * Used throughout the kernel for timing and hardware register
 * manipulation at the bare-metal level.
 */

.globl delay
delay:
    subs x0, x0, #1
    bne delay
    ret

.globl put32
put32:
    str w1, [x0]
    ret

.globl get32
get32:
    ldr w0, [x0]
    ret