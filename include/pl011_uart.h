//
// pl011_uart.h
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

#ifndef UART_H
#define UART_H

#include <stdint.h>

void uart_init();
void uart_flush();
char uart_recv();
void uart_send(char c);
void uart_send_string(const char *str);
void uart_send_hex(uint32_t value);
void uart_line_breaks(int count);
uint32_t uart_receive_number();
void uart_send_dec(uint32_t num);
void uart_send_dec64(uint64_t num);
int uart_read_ready();

#endif