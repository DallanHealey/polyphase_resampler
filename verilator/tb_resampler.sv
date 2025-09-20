`timescale 1ps/1ps

module tb_resampler ();

logic        clk_1x;
logic [15:0] sample_i_i;
logic [15:0] sample_q_i;
logic        sample_valid_i;
logic        clk_1p5x;
logic [15:0] sample_i_o;
logic [15:0] sample_q_o;
logic        sample_valid_o;

localparam CLK_1X_PERIOD = 10;
always begin
    #(CLK_1X_PERIOD/2);
    clk_1x <= !clk_1x;
end

localparam CLK_1P5X_PERIOD = 7.5;
always begin
    #(CLK_1P5X_PERIOD/2);
    clk_1p5x <= !clk_1p5x;
end

initial begin
    $dumpfile("vsim.fst");
    $dumpvars(0, tb_resampler);

    clk_1x = 1'b0;
    clk_1p5x = 1'b0;

    #10us;
    $finish;
end

resampler_up3_down2 DUT (
    .*
);


endmodule
