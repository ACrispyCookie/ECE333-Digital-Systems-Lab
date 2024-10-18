#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "No argument provided. Please provide an argument."
  exit 1
fi

# Store the argument
ARG=$1

# Run a command based on the argument
case "$ARG" in
  "part_a")
    iverilog -o ./target/LEDdecoder_tb ./part_a/test/LEDdecoder_tb.v ./part_a/LEDdecoder.v
    vvp ./target/LEDdecoder_tb
    ;;
  "part_b")
    iverilog -o ./target/FourDigitLEDdriver_tb ./part_b/test/FourDigitLEDdriver_tb.v ./part_b/FourDigitLEDdriver.v ./part_a/LEDdecoder.v
    vvp ./target/FourDigitLEDdriver_tb
    ;;
  *)
    echo "Invalid argument. Use 'LEDdecoder' or 'LEDdriver'."
    exit 1
    ;;
esac

