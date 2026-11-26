`timescale 1ns / 1ps
module tb_Top_fast();
logic clk = 0, rst = 1, toggle = 0, led;
logic [1:0] speed;
longint cycles;

Top #(.CLK_FREQ(1_000_000), .DEB_LIMIT(20)) dut(.*);

always #2 clk = ~clk;

task automatic press_button();
    repeat (3) begin                       // contact bounce
        toggle <= 1; repeat (3) @(posedge clk);
        toggle <= 0; repeat (2) @(posedge clk);
    end
    toggle <= 1; repeat (100) @(posedge clk);
    toggle <= 0; repeat (100) @(posedge clk);
endtask

initial begin
    $dumpfile("tb_Top_fast.vcd");
    $dumpvars(0, dut.out_cnt, dut.speed);
    repeat (2) @(negedge clk);
    rst <= 0;
    for (int s = 0; s < 4; s++) begin
        wait (dut.out_cnt == 8'd255);
        cycles = 0;
        while (dut.out_cnt != 8'd0) begin
            @(posedge clk);
            cycles++;
        end
        $display("speed=%0d  ramp 255->0 took %0d clock cycles", speed, cycles);
        press_button();
    end
    if (speed == 0) $display("PASS: speed wrapped around after 4 presses");
    else            $display("FAIL: speed=%0d", speed);
    $finish;
end
endmodule

