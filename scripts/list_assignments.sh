#!/usr/bin/env bash
set -euo pipefail

cat <<'LIST'
ECE333 Digital Systems Lab inventory

Lab 1 - Seven-segment display systems
  - LED decoder, multiplexed four-digit display driver, debouncing, counters, Nexys A7 constraints.

Lab 2 - UART communication pipeline
  - Baud-rate controller, UART transmitter/receiver, message controller, LED-display integration.

Lab 3 - VGA graphics pipeline
  - VRAM generation, pixel controller, VGA sync controllers, image rendering, optional DVD-logo animation.

Lab 4 - SPI accelerometer interface
  - Binary-to-ASCII conversion, SPI master/slave testing, accelerometer value reader, UART reporting, optional VGA visualization.
LIST
