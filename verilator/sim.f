-j 24
--binary
--threads 1
# Change --threads as needed. Seems to slow down low workloads because of the thread coherency?

tb_resampler.sv
../resampler_up3_down2.sv

--trace-fst
--assert
--timing
-Wall
-Wno-DECLFILENAME
-Wno-GENUNNAMED
-Wno-fatal

--top tb_resampler
