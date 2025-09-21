#!/bin/bash

# This script assumes you have verilator installed and on your PATH
# https://github.com/verilator/verilator

# This script assumes you have surfer installed and on your PATH
# https://gitlab.com/surfer-project/surfer

verilator --trace-max-array 128 -f sim.f
ret=$?

if [ $ret -eq 0 ]; then
    obj_dir/Vtb_resampler
    surfer -s waveform_view vsim.fst
else
    echo "Errors found."
fi

exit $ret
