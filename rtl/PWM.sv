`timescale 1ns / 1ps

module PWM(
    input logic clk,
    input logic rst,
    input logic [7:0] limit,
    output logic out
    );
logic out_comp;
logic [7:0] out_counter;
logic rst_counter;
assign out_comp=(8'd255<=out_counter);
assign rst_counter=rst|| out_comp;
always_ff @(posedge clk)begin
    if(rst_counter==1) out_counter<=8'd0;
    else out_counter<=out_counter+8'd1;
end
assign out=(limit>out_counter);
endmodule
