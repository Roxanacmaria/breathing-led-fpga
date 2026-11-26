`timescale 1ns / 1ps

module CounterUpDown(
    input logic clk,
    input logic rst,
    input logic en,
    input logic up,
    output logic [7:0] out
    );
always_ff @(posedge clk) begin 
    if(rst==1)
        out<=0;
    else if (en==1) begin
       if(up==1) out<=out+1;
       else out<=out-1; 
    end
end
endmodule
