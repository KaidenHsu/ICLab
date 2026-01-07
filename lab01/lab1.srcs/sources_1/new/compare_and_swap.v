`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2025 09:54:52 PM
// Design Name: 
// Module Name: compare_and_swap
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


module compare_and_swap(
    input signed [5-1 : 0] a, b,
    input [3-1 : 0] idx_a, idx_b,
    input opt1, // opt[1]

    output reg [5-1 : 0] A, B,
    output reg [3-1 : 0] idx_A, idx_B
);
    always @* begin
        if (opt1) begin // descending
            if (a < b || (a == b && idx_a > idx_b)) begin
                A = b;
                idx_A = idx_b;

                B = a;
                idx_B = idx_a;
            end else begin
                A = a;
                idx_A = idx_a;

                B = b;
                idx_B = idx_b;
            end
        end else begin // ascending
            if (a > b || (a == b && idx_a > idx_b)) begin
                A = b;
                idx_A = idx_b;

                B = a;
                idx_B = idx_a;
            end else begin
                A = a;
                idx_A = idx_a;

                B = b;
                idx_B = idx_b;
            end
        end
    end
endmodule
