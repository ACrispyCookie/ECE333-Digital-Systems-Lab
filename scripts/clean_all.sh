#!/usr/bin/env bash
set -euo pipefail

# Remove generated simulator outputs from local validation runs.
rm -rf target build
find . -type f \( \
  -name '*.vvp' -o \
  -name '*.vcd' -o \
  -name '*.fst' -o \
  -name '*.lxt' -o \
  -name 'a.out' -o \
  -name '*.out' \
\) -delete

# Remove common Vivado run products if they are regenerated locally.
find . -type d \( \
  -name '*.cache' -o \
  -name '*.hw' -o \
  -name '*.ip_user_files' -o \
  -name '*.runs' -o \
  -name '*.sim' -o \
  -name '.Xil' \
\) -prune -exec rm -rf {} +

echo "Cleaned local simulation and Vivado-generated outputs."
