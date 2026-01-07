`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2025 01:07:18 AM
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

    wire in_valid, in_valid_num;
    wire [4-1 : 0] col, row;
    wire [3-1 : 0] in_num;

    wire [4-1 : 0] out;
    wire out_valid;

    PATTERN pattern (
        .out(out),
        .out_valid(out_valid),

        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid), .in_valid_num(in_valid_num),
        .col(col),
        .row(row),
        .in_num(in_num)
    );

    // QUEEN queen (
    //     .clk(clk), .rst_n(rst_n),

    //     .in_valid(in_valid), .in_valid_num(in_valid_num),
    //     .col(col), .row(row),
    //     .in_num(in_num),

    //     .out(out),
    //     .out_valid(out_valid)
    // );

    QUEEN_orange queen_orange (
        .clk(clk), .rst_n(rst_n),

        .in_valid(in_valid), .in_valid_num(in_valid_num),
        .col(col), .row(row),
        .in_num(in_num),

        .out(out),
        .out_valid(out_valid)
    );
endmodule
