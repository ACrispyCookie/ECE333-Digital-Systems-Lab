#!/usr/bin/env bash
set -euo pipefail

if ! command -v iverilog >/dev/null 2>&1; then
  echo "Icarus Verilog (iverilog) is required for these checks." >&2
  exit 1
fi

BUILD_DIR="${TMPDIR:-/tmp}/ece333-check.$$"
mkdir -p "$BUILD_DIR"
trap 'rm -rf "$BUILD_DIR"' EXIT

run_iverilog() {
  local label="$1"
  shift
  local out="$BUILD_DIR/${label//[^A-Za-z0-9_]/_}.vvp"
  echo "==> $label"
  iverilog -g2012 -o "$out" "$@"
}

# Lightweight checks that can run without Vivado's Xilinx primitive libraries.
run_iverilog "Lab1 LED decoder" \
  Lab1/part_a/LEDdecoder.v \
  Lab1/part_a/test/LEDdecoder_tb.v

run_iverilog "Lab2 baud controller" \
  Lab2/part_a/baud_controller.v \
  Lab2/part_a/test/baud_controller_tb.v

run_iverilog "Lab2 UART transmitter" \
  Lab2/part_a/baud_controller.v \
  Lab2/part_b/sample_counter.v \
  Lab2/part_b/transmitter_fsm.v \
  Lab2/part_b/uart_transmitter.v \
  Lab2/part_b/test/uart_transmitter_tb.v

run_iverilog "Lab2 UART receiver success case" \
  Lab2/part_a/baud_controller.v \
  Lab2/part_b/sample_counter.v \
  Lab2/part_c/InputSynchronizer.v \
  Lab2/part_c/receiver_data.v \
  Lab2/part_c/receiver_fsm.v \
  Lab2/part_c/receiver_sampler.v \
  Lab2/part_c/uart_receiver.v \
  Lab2/part_c/test/receiver_success_tb.v

run_iverilog "Lab2 UART receiver framing-error case" \
  Lab2/part_a/baud_controller.v \
  Lab2/part_b/sample_counter.v \
  Lab2/part_c/InputSynchronizer.v \
  Lab2/part_c/receiver_data.v \
  Lab2/part_c/receiver_fsm.v \
  Lab2/part_c/receiver_sampler.v \
  Lab2/part_c/uart_receiver.v \
  Lab2/part_c/test/receiver_ferror_tb.v

run_iverilog "Lab4 binary-to-ASCII and UART formatter" \
  Lab4/part_a/src/binary_to_ascii_4.v \
  Lab4/part_a/src/binary_to_ascii_6.v \
  Lab4/part_a/test/uart_test.v \
  Lab4/part_a/test/part_a_tb.v \
  Lab4/complete/src/Baud_controller.v \
  Lab4/complete/src/uart_transmitter.v \
  Lab4/complete/src/uart_transmitter_data_control.v

run_iverilog "Lab4 accelerometer averaging unit" \
  Lab4/part_c/src/avg_calc.v \
  Lab4/part_c/test/avg_tb.v

run_iverilog "Lab4 display decoder unit" \
  Lab4/test_unit/ssd_display/part_a/LEDdecoder.v \
  Lab4/test_unit/ssd_display/part_a/test/LEDdecoder_tb.v

echo "Skipping full VGA/display-driver elaboration because those designs instantiate Xilinx primitives such as MMCME2_BASE/RAMB18E1 that require Vivado simulation libraries."
echo "Validation checks completed."
