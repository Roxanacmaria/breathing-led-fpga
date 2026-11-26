`timescale 1ns / 1ps
module Top #(
    parameter int CLK_FREQ  = 100_000_000,
    parameter     DEB_LIMIT = 20'd650000
)(
    input  logic       rst,
    input  logic       clk,
    input  logic       toggle,
    output logic       led,
    output logic [1:0] speed
);
localparam int LIMIT_100HZ = CLK_FREQ / (2 * 100);   // 500 000
localparam int LIMIT_200HZ = CLK_FREQ / (2 * 200);   // 250 000
localparam int LIMIT_400HZ = CLK_FREQ / (2 * 400);   // 125 000
localparam int LIMIT_800HZ = CLK_FREQ / (2 * 800);   //  62 500

logic out_f1, out_f2, out_f3, out_f4;
logic out_mux, out_reg, out_and, out_deb, out_sign;
logic [1:0] out_counter;
logic [7:0] out_cnt;
always_ff @(posedge clk) begin
    out_reg <= out_mux;
end
assign out_and = out_mux && ~out_reg;

FreqDiv #(.LIMIT(LIMIT_100HZ)) F1(
    .clk(clk),
    .rst(rst),
    .out(out_f1)
);
FreqDiv #(.LIMIT(LIMIT_200HZ)) F2(
    .clk(clk),
    .rst(rst),
    .out(out_f2)
);
FreqDiv #(.LIMIT(LIMIT_400HZ)) F3(
    .clk(clk),
    .rst(rst),
    .out(out_f3)
);
FreqDiv #(.LIMIT(LIMIT_800HZ)) F4(
    .clk(clk),
    .rst(rst),
    .out(out_f4)
);
Mux m(
    .in0(out_f1),
    .in1(out_f2),
    .in2(out_f3),
    .in3(out_f4),
    .sel(out_counter),
    .out(out_mux)
);
Debouncer #(.limit(DEB_LIMIT)) DB(
    .clk(clk),
    .in(toggle),
    .out(out_deb)
);
Counter CN1(
    .clk(clk),
    .rst(rst),
    .en(out_deb),
    .out(out_counter)
);
CounterUpDown CUP(
    .clk(clk),
    .rst(rst),
    .en(out_and),
    .up(out_sign),
    .out(out_cnt)
);
SignalToggleFsm STF(
    .clk(clk),
    .rst(rst),
    .in(out_cnt),
    .out(out_sign)
);
PWM P(
    .clk(clk),
    .rst(rst),
    .limit(out_cnt),
    .out(led)
);
assign speed = out_counter;
endmodule
