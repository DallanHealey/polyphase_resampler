#!/bin/zsh

# This script assumes you have verilator installed and on your PATH
# https://github.com/verilator/verilator

# This script assumes you have surfer installed and on your PATH
# https://gitlab.com/surfer-project/surfer
# I am using WSL. Instead of using the surfer.sh script, I rebuilt the program with eframe->features->wayland commented out
# This fixed the Wayland error I was getting

verilator --trace-max-array 128 -f sim.f
ret=$?

if [ $ret -eq 0 ]; then
    obj_dir/Vtb_resampler

    if [ $# -eq 1 ]; then
        if [ "$1" = "s" ]; then
            surfer -s waveform_view vsim.fst
        fi
    fi
else
    echo "Errors found."
fi

exit $ret
