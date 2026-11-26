`timescale 1ns / 1ps

module Counter(
    input logic clk,
    input logic rst,
    input logic en,
    output logic [1:0] out
    );
always_ff @(posedge clk) begin
    if(rst==1) out<=2'd0;
    else if(en==1) out<=out+2'd1;
end
endmodule
