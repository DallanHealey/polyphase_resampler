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

logic start;
event samples_done;
logic flip_flop;

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

localparam integer NUM_SAMPLES = 4;
logic [0:NUM_SAMPLES-1][15:0] samples = {16'd1, 16'd2, 16'd3, 16'd4};
localparam integer NUM_TAPS = 3;
localparam logic [0:NUM_TAPS-1][15:0] taps = {16'd3, 16'd4, 16'd3};

initial begin
    $dumpfile("vsim.fst");
    $dumpvars(0, tb_resampler);

    clk_1x = 1'b0;
    clk_1p5x = 1'b0;
    start = 1'b0;
    flip_flop = 1'b0;
    #10us;

    // Start sending samples
    $display("%T: Starting to send samples...", $time);
    start = 1'b1;

    // Wait for samples to finish sending
    @(samples_done);
    start = 1'b0;
    $display("%T: Done sending samples...", $time);
    #10us;
    $finish;
end

integer sample_count;
always @(posedge clk_1x) begin
    sample_valid_i <= 1'b0;
    flip_flop <= !flip_flop;

    if (start == 1'b1) begin
        // Flip flop sending samples because I don't want to write a CDC BRAM right now
        if (flip_flop == 1'b0) begin
            sample_valid_i <= 1'b1;
            sample_i_i <= samples[sample_count];
            if (sample_count == NUM_SAMPLES - 1) begin
                sample_count <= 0;
                ->samples_done;
            end else begin
                sample_count <= sample_count + 1;
            end
        end
    end
end

resampler_up3_down2 # (
    .NUM_TAPS(NUM_TAPS),
    .TAPS(taps)
) DUT (
    .*
);


endmodule
