-j 24
--binary

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
