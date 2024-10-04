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
  "LEDdecoder")
    iverilog -o ./target/LEDdecoder_tb ./src/LEDdecoder_tb.v ./src/LEDdecoder.v
    vvp ./target/LEDdecoder_tb
    ;;
  "LEDdriver")
    iverilog -o ./target/FourDigitLEDdriver_tb ./src/FourDigitLEDdriver_tb.v ./src/FourDigitLEDdriver.v ./src/LEDdecoder.v
    vvp ./target/FourDigitLEDdriver_tb
    ;;
  *)
    echo "Invalid argument. Use 'LEDdecoder' or 'LEDdriver'."
    exit 1
    ;;
esac

