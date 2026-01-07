`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2025 01:08:50 AM
// Design Name: 
// Module Name: PATTERN
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


// `define CLK_PERIOD 6 // clock period = 6ns
`define CLK_PERIOD 10 // clock period = 10ns
`define TEST_CASES 2

module PATTERN(
    input out_valid,
    input [4-1 : 0] out,

    output reg clk, rst_n,

    output reg in_valid_num,
    output reg [3-1 : 0] in_num,

    output reg in_valid,
    output reg [4-1 : 0] col, row
);
    reg [3-1 : 0] in_num_arr [0 : `TEST_CASES-1]; // 0 ~ 6 (according to spec)
    reg [4-1 : 0] col_arr [0 : `TEST_CASES -1][6-1 : 0];
    reg [4-1 : 0] row_arr [0 : `TEST_CASES -1][6-1 : 0];

    reg [4-1 : 0] golden_arr [0 : `TEST_CASES-1][12-1 : 0]; // row positions of 12 queens column by column

    reg [40 : 0] counter;
    reg [40 : 0] total_cycle;

    initial begin
        // ----- test case 1 -----
        in_num_arr[0] = 4;

        // (8, 7)
        row_arr[0][0] = 8;
        col_arr[0][0] = 7;

        // (1, 10)
        row_arr[0][1] = 1;
        col_arr[0][1] = 10;

        // (2, 0)
        row_arr[0][2] = 2;
        col_arr[0][2] = 0;

        // (5, 9)
        row_arr[0][3] = 5;
        col_arr[0][3] = 9;

        // ans
        golden_arr[0][0] = 2;
        golden_arr[0][1] = 4;
        golden_arr[0][2] = 7;
        golden_arr[0][3] = 10;
        golden_arr[0][4] = 3;
        golden_arr[0][5] = 11;
        golden_arr[0][6] = 6;
        golden_arr[0][7] = 8;
        golden_arr[0][8] = 0;
        golden_arr[0][9] = 5;
        golden_arr[0][10] = 1;
        golden_arr[0][11] = 9;



        // ----- test case 2 -----
        in_num_arr[1] = 5;

        // (7, 7)
        row_arr[1][0] = 7;
        col_arr[1][0] = 7;

        // (10, 8)
        row_arr[1][1] = 10;
        col_arr[1][1] = 8;

        // (0, 1)
        row_arr[1][2] = 0;
        col_arr[1][2] = 1;

        // (2, 6)
        row_arr[1][3] = 2;
        col_arr[1][3] = 6;

        // (9, 4)
        row_arr[1][4] = 9;
        col_arr[1][4] = 4;

        // ans
        golden_arr[1][0] = 4;
        golden_arr[1][1] = 0;
        golden_arr[1][2] = 3;
        golden_arr[1][3] = 6;
        golden_arr[1][4] = 9;
        golden_arr[1][5] = 11;
        golden_arr[1][6] = 2;
        golden_arr[1][7] = 7;
        golden_arr[1][8] = 10;
        golden_arr[1][9] = 1;
        golden_arr[1][10] = 5;
        golden_arr[1][11] = 8;
    end

    initial begin
        clk = 0;
        forever #(`CLK_PERIOD/2) clk = ~clk;
    end

    integer i, j;

    initial begin
        total_cycle = 0;

        in_valid = 0;
        in_valid_num = 0;
        col = 0;
        row = 0;
        in_num = 0;

        rst_n = 1;
        #(2*`CLK_PERIOD);
        force clk = 0;
        #(2*`CLK_PERIOD);
        rst_n = 0;
        #(2*`CLK_PERIOD);
        rst_n = 1;
        #(2*`CLK_PERIOD);
        release clk;

        @(posedge clk);
        @(posedge clk);
        @(posedge clk);

        for (i = 0; i < `TEST_CASES; i=i+1) begin
            // wait for 2 ~ 5 clock cycles (inclusive)
            repeat ($urandom_range(2, 5)) @(negedge clk);

            // input
            in_valid_num = 1;
            in_num = in_num_arr[i];

            in_valid = 1;
            col = col_arr[i][0];
            row = row_arr[i][0];

            @(negedge clk);

            in_valid_num = 0;
            in_num = 0;

            for (j = 1; j < in_num_arr[i]; j=j+1) begin
                col = col_arr[i][j];
                row = row_arr[i][j];
                @(negedge clk);
            end

            in_valid = 0;
            col = 0;
            row = 0;

            // check answer
            @(posedge out_valid);

            for (j = 0; j < 12; j=j+1) begin
                @(posedge clk);

                if (out != golden_arr[i][j]) begin
                    $display("[%0t] Wrong answer at test case #%0d:", $time, i);
                    $display("out[%0d] = %0d", j, out);
                    $display("golden[%0d] = %0d", j, golden_arr[i][j]);

                    #10 $finish;
                end
            end

            total_cycle = total_cycle + counter;
        end

        $display("All test cases passed!");
        $display("average cycle = %0f", total_cycle/`TEST_CASES);
        #10 $finish;
    end

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) counter <= 0;
        else begin
            if (in_valid_num) counter <= 0;
            else counter <= counter + 1;
        end
    end
endmodule
