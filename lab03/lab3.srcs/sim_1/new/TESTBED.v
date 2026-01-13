`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2025 11:21:52 PM
// Design Name: 
// Module Name: TESTBED
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TESTBED();
    wire clk, rst_n;
    wire in_valid;
    wire [2-1 : 0] init;
    wire [2-1 : 0] in0, in1, in2, in3;

    wire out_valid;
    wire [2-1 : 0] out;

    // solver
    SUBWAY subway (
        .clk(clk), .rst_n(rst_n),

        .in_valid(in_valid), 
        .init(init),
        .in0(in0), .in1(in1), .in2(in2), .in3(in3),

        .out_valid(out_valid), 
        .out(out)
    );

    // testbench
    PATTERN pattern (
        .out_valid(out_valid), 
        .out(out),

        .clk(clk), .rst_n(rst_n),

        .in_valid(in_valid), 
        .init(init),
        .in0(in0), .in1(in1), .in2(in2), .in3(in3)
    );
endmodule
