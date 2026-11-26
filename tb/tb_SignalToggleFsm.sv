`timescale 1ns / 1ps
module tb_SignalToggleFsm();
logic [7:0] in;
logic clk;
logic rst;
logic out;

initial begin
    $dumpfile("tb_SignalToggleFsm.vcd");
    $dumpvars(0, tb_SignalToggleFsm);
end

initial begin
    clk = 0;
    forever #1 clk = ~clk;
end

initial begin
    rst <= 1;
    in  <= 8'd0;
    @(posedge clk);
    @(posedge clk);
    rst <= 0;
    forever begin
        while (in < 8'd255) begin
            in <= in + 8'd1;
            @(posedge clk);
        end
        while (in > 8'd0) begin
            in <= in - 8'd1;
            @(posedge clk);
        end
    end
end
logic exp_state = 0;   
logic exp_out;
int   errors = 0;
always @(negedge clk) begin
    if (rst !== 1'b0) begin
        exp_state = 0;           // in reset (or still X at t = 0): nothing to check
    end
    else begin
        exp_out = (exp_state == 0) ? (in != 8'd255) : (in == 8'd0);
        if (out !== exp_out) begin
            $display("ERROR t=%0t in=%0d out=%b expected=%b", $time, in, out, exp_out);
            errors++;
        end
        if (exp_state == 0 && in == 8'd255)    exp_state = 1;
        else if (exp_state == 1 && in == 8'd0) exp_state = 0;
    end
end

initial begin
    repeat (1021) @(posedge clk);
    if (errors == 0) $display("PASS: out matched the expected behaviour for 1021 cycles");
    else             $display("FAIL: %0d errors", errors);
    $stop();
end

SignalToggleFsm dut(.*);
endmodule

