`timescale 1ns / 1ps

module SignalToggleFsm(
    input logic [7:0] in,
    input logic clk,
    input logic rst,
    output logic out
    );
localparam Q0=1'b0;
localparam Q1=1'b1;
logic state,next_state;
always_ff @(posedge clk)begin
    if(rst)state<=Q0;
    else state<=next_state;
end
always_comb begin
    next_state=state;
    out=1'b1;
    case(state)
        Q0: if(in==8'd255)begin
            next_state=Q1;
            out=1'b0;
        end
        else out=1'b1;
        Q1: if(in==8'd0)begin
            next_state=Q0;
            out=1'b1;
        end
        else out=1'b0;
        default: next_state=Q0;
    endcase
end
endmodule
