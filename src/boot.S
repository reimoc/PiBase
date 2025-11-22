/*
 * boot.S
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
 * Boot code and reset entry point for PiBase.
 * Runs immediately after reset, keeps only core 0 active,
 * clears the .bss section, sets up the stack, and then
 * transfers control to kernel_main(). Other cores and
 * unexpected returns enter an infinite low-power loop.
 */

#include "mm.h"

.section ".text.boot"

.globl _start
_start:                          // CPU execution starts here (reset vector)
    mrs x0, mpidr_el1            // Read Multiprocessor Affinity Register
    and x0, x0, #0xFF            // Extract CPU core ID into x0
    cbz x0, master               // Core 0 continues to initialization
    b proc_hang                  // Other cores enter hang loop

master:
    mrs x1, CurrentEL            // Read current exception level
    lsr x1, x1, #2               // Normalize EL value to 1, 2, or 3

    adrp x0, bss_begin           // Load start address of .bss section
    add  x0, x0, :lo12:bss_begin
    adrp x1, bss_end             // Load end address of .bss section
    add  x1, x1, :lo12:bss_end
    sub x1, x1, x0               // Calculate size of .bss section
    bl memzero                   // Clear .bss to zero (C requires this)

  /* load address of __stack_end into x0 and set SP = __stack_end */
    adrp x0, __stack_end
    add  x0, x0, :lo12:__stack_end
    mov  sp, x0

    bl kernel_main               // Jump to main kernel entry point
    b  proc_hang                 // If kernel returns, hang safely

proc_hang:
    wfe                          // Wait for event (low power)
    b proc_hang                  // Infinite loop to prevent undefined behavior
