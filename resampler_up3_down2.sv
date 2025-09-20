module resampler_up3_down2 # (
    integer NUM_TAPS = 3,
    logic [NUM_TAPS-1:0][15:0] TAPS = {NUM_TAPS{16'h0000}},

    integer UP   = 3,
    integer DOWN = 2
) (
    input logic        clk_1x,
    input logic [15:0] sample_i_i,
    input logic [15:0] sample_q_i,
    input logic        sample_valid_i,

    input  logic        clk_1p5x,
    output logic [15:0] sample_i_o,
    output logic [15:0] sample_q_o,
    output logic        sample_valid_o
);

localparam integer NUM_COLS = NUM_TAPS / UP;

logic [NUM_COLS-1:0][15:0] sample_i_sr;
logic [NUM_COLS-1:0][15:0] sample_q_sr;

always @(posedge clk_1x) begin
    if (sample_valid_i == 1'b1) begin
        if (NUM_COLS == 1) begin
            sample_i_sr <= sample_i_i;
            sample_q_sr <= sample_q_i;
        end else begin
            sample_i_sr <= {sample_i_sr[NUM_COLS-2:0], sample_i_i};
            sample_q_sr <= {sample_q_sr[NUM_COLS-2:0], sample_q_i};
        end
    end
end


endmodule
