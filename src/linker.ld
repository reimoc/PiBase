/*
 * linker.ld
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
 * A copy of the GNU General Public License should have been received
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */
 
/*
 * Linker script for PiBase.
 *
 * Defines the memory layout for the bare-metal OS on Raspberry Pi 4/5.
 * Places sections (.text.boot, .text, .rodata, .data, .bss) in RAM.
 * Defines symbols `bss_begin` and `bss_end` for zero-initializing
 * uninitialized data during early boot.
 */

MEMORY
{
    RAM (rwx) : ORIGIN = 0x80000, LENGTH = 0x8000000  /* 128 MB RAM */
}

/* Stack sizing (safe stack size) */
_estack_size = 0x10000; /* 64 KiB */

SECTIONS
{
    .text.boot : {
        *(.text.boot)
    } > RAM

    .text : {
        *(.text)
    } > RAM

    .rodata : {
        *(.rodata)
    } > RAM

    .data : {
        *(.data)
    } > RAM

    . = ALIGN(0x8);
    bss_begin = .;

    .bss (NOLOAD) : {
        *(.bss*)
        *(COMMON)
    } > RAM

    bss_end = .;

    .large_bss (NOLOAD) : ALIGN(8) {
        *(.large_bss)
    } > RAM

    .ref_arr_bss (NOLOAD) : ALIGN(8) {
        *(.ref_arr_bss)
    } > RAM

    /* Reserve fixed stack area at top of RAM */
    _stack_top = ORIGIN(RAM) + LENGTH(RAM);
    . = _stack_top - _estack_size;
    .stack (NOLOAD) : {
        __stack_start = .;
        . = . + _estack_size;
        __stack_end = .;
    } > RAM
}
