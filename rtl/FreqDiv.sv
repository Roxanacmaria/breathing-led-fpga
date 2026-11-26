`timescale 1ns / 1ps
module FreqDiv #(parameter int LIMIT=100000)(
    input logic clk,
    input logic rst,
    output logic out
    );
localparam int w=(LIMIT>1) ? $clog2(LIMIT) :1;
logic [w-1:0] count;
always_ff @(posedge clk) begin
    if(rst==1) begin
        out<=0;
        count<=0;
    end
    else if(count==LIMIT-1)begin
        count<=0;
        out<=~out;
    end
    else begin
        count<=count+1;
    end
end
endmodule
