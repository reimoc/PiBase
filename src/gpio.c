//
// gpio.c
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

#include "gpio.h"
#include "utils.h"

/*
 * GPIO control routines for PiBase.
 *
 * Provides low-level functions to configure GPIO pins, enable
 * them, and set their output values. Supports setting pin
 * function (input/output/alternate), controlling pull-up/down
 * resistors, and writing high/low values to pins.
 *
 * Used by other subsystems such as EMFI tests and peripheral
 * initialization.
 */

void gpio_pin_set_func(u8 pinNumber, GpioFunc func) {
    u8 bitStart = (pinNumber * 3) % 30;
    u8 reg = pinNumber / 10;

    u32 selector = REGS_GPIO->func_select[reg];
    selector &= ~(7 << bitStart);
    selector |= (func << bitStart);

    REGS_GPIO->func_select[reg] = selector;
}

void gpio_pin_enable(u8 pinNumber) {
    REGS_GPIO->pupd_enable = 0;
    delay(150);
    REGS_GPIO->pupd_enable_clocks[pinNumber / 32] = 1 << (pinNumber % 32);
    delay(150);
    REGS_GPIO->pupd_enable = 0;
    REGS_GPIO->pupd_enable_clocks[pinNumber / 32] = 0;
}

void gpio_set(u8 pinNumber, int value) {
    if (value)
        REGS_GPIO->output_set.data[pinNumber / 32] = 1 << (pinNumber % 32);
    else
        REGS_GPIO->output_clear.data[pinNumber / 32] = 1 << (pinNumber % 32);
}