/*
 * mm.S
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
 * Memory manipulation routines for PiBase.
 *
 * Provides a low-level function `memzero` to clear a block of memory
 * from `bss_begin` to `bss_end`. This is used during early boot to
 * zero-initialize uninitialized global/static variables in the .bss section.
 */
 
 .globl memzero
memzero:
    str xzr, [x0], #8
    subs x1, x1, #8
    b.gt memzero
    ret