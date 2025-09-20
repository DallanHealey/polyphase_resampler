#!/bin/bash

verilator --trace-max-array 128 -f sim.f
ret=$?

if [ $ret -eq 0 ]; then
    obj_dir/Vtb_resampler
    gtkwave vsim.fst
else
    echo "Errors found."
fi

exit $ret
