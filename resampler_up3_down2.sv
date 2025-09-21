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
logic                      sample_sr_valid;

logic [UP-1:0][31+NUM_COLS:0] current_phase;
logic [UP-1:0][31+NUM_COLS:0] next_current_phase;

// Shift data in
always @(posedge clk_1x) begin
    sample_sr_valid <= sample_valid_i;

    if (sample_valid_i == 1'b1) begin
        if (NUM_COLS == 1) begin
            sample_i_sr <= sample_i_i;
            sample_q_sr <= sample_q_i;

            current_phase <= next_current_phase;
        end else begin
            sample_i_sr <= {sample_i_sr[NUM_COLS-2:0], sample_i_i};
            sample_q_sr <= {sample_q_sr[NUM_COLS-2:0], sample_q_i};

            current_phase <= next_current_phase;
        end
    end
end

always_comb begin
    next_current_phase = current_phase;

    for (integer i = 0; i < NUM_COLS; i++) begin
        if (sample_sr_valid == 1'b1) begin
            for (integer j = 0; j < UP; j++) begin
                next_current_phase[j] = sample_i_sr[i] * TAPS[i*UP+j];
                $display("%h %h %h", sample_i_sr[i], TAPS[i*UP+j], next_current_phase[j]);
            end
        end
    end
end

endmodule
