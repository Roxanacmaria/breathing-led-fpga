`timescale 1ns / 1ps
module tb_Top();
logic clk, rst, led, toggle;
logic [1:0] speed;

initial begin
    $dumpfile("tb_Top.vcd");
    $dumpvars(0, tb_Top);
end

initial begin
    clk = 0;
    forever #2 clk = ~clk;
end

initial begin
    rst    <= 1;
    toggle <= 0;
    @(negedge clk);
    @(negedge clk);
    rst <= 0;
end

initial begin
    forever begin
        repeat (50)  @(posedge clk);
        toggle <= 1;
        repeat (700) @(posedge clk);
        toggle <= 0;
    end
end

initial begin
    repeat (2500) @(posedge clk);
    $display("tb_Top done at t=%0t: speed=%0d led=%b", $time, speed, led);
    $stop();
end

Top dut(.*);
endmodule
