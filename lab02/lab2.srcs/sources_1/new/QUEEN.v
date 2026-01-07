`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2025 01:11:24 AM
// Design Name: 
// Module Name: QUEEN
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


`define QUEENS 12
`define INVALID_ANS 15

module QUEEN(
    input clk, rst_n,

    input in_valid_num,
    input [3-1 : 0] in_num,

    input in_valid,
    input [4-1 : 0] col,
    input [4-1 : 0] row,

    output out_valid,
    output [4-1 : 0] out
);
    // DECLARATIONS
    // stores number of inputs
    reg [3-1 : 0] given_in_num;

    // store given queens' columns (1 ~ 6)
    reg [0 : `QUEENS-1] given_col;

    // "stack pointer"
    reg [$clog2(`QUEENS)-1 : 0] current_col;

    // read input
    reg input_read;

    // attack maps
    reg [0 : `QUEENS-1] used_row_bitmap; // 0 ~ 11
    reg [0 : 2*`QUEENS-1] used_main_diagonal_bitmap; // 0 ~ 22 (row + col)
    reg [0 : 2*`QUEENS-1] used_anti_diagonal_bitmap; // -11 ~ 11 (row - col, shifted right by `QUEENS-1 (11))

    // check column
    reg [0: `QUEENS-1] legal_arr; // all legal positions in this column
    reg [$clog2(`QUEENS)-1 : 0] found_row; // place a queen at (place_row, current_col)
    reg placement_found; // if a placement is found

    // if next column is found
    reg col_found;

    reg is_backtracking;

    // answer
    reg [4-1 : 0] ans [0 : `QUEENS-1];

    // counter (output should be high for 12 cycles)
    reg [$clog2(`QUEENS)-1 : 0] counter;

    integer i;
    // END OF DECLARATIONS



    // FSM
    localparam S_IDLE = 0; // clear registers as needed
    localparam S_INPUT = 1; // read input
    localparam S_FIND_NEXT_COL = 2; // explore next legal column
    localparam S_CHECK = 3; // check the legal squares in this column
    localparam S_PLACE = 4; // place the queen and update attack maps
    localparam S_BACKTRACK = 5; // backtrack to the previous legal column
    localparam S_DONE = 6; // output is valid
    reg [3-1 : 0] state, n_state;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) state <= S_IDLE;
        else state <= n_state;
    end

    always @* begin
        case (state)
            S_IDLE: n_state = S_INPUT;
            S_INPUT: n_state = (input_read && !in_valid)? S_FIND_NEXT_COL : S_INPUT;
            S_FIND_NEXT_COL: n_state = (col_found)? S_CHECK : S_DONE;
            S_CHECK: n_state = (placement_found)? S_PLACE : S_BACKTRACK;
            S_PLACE: n_state = S_FIND_NEXT_COL;
            S_BACKTRACK: n_state = S_CHECK;
            S_DONE: n_state = (counter == `QUEENS-1)? S_IDLE : S_DONE; // output will be high for 12 cycles
            default: n_state = S_IDLE;
        endcase
    end
    // END OF FSM



    // READ INPUT
    // input read
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) input_read <= 0;
        else begin
            case (state)
                S_IDLE: input_read <= 0;
                S_INPUT: begin
                    if (in_valid_num) begin
                        input_read <= 1;
                    end
                end 
                default: input_read <= 0;
            endcase
        end
    end

    // given_in_num (number of input queens)
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            given_in_num <= 0;
        end else begin
            case (state)
                S_IDLE: given_in_num <= 0;
                S_INPUT: begin
                    if (in_valid_num) begin
                        given_in_num <= in_num;
                    end
                end
            endcase
        end
    end

    // given_col
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            given_col <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    given_col <= 0;
                end
                S_INPUT: begin
                    if (in_valid) begin
                        // right shift one element
                        given_col[col] <= 1;
                    end
                end
            endcase
        end
    end
    // END OF READ INPUT



    // current_col
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) current_col <= 0;
        else begin
            case (state)
                S_IDLE: current_col <= 0;
                S_FIND_NEXT_COL: begin
                    // number of inputs <= 6
                    if (current_col == 0 && ans[current_col] == `INVALID_ANS) current_col <= 0; // right after S_INPUT, stay in the first column
                    else if ((current_col+1 < `QUEENS) && !given_col[current_col+1]) current_col <= current_col + 1;
                    else if ((current_col+2 < `QUEENS) && !given_col[current_col+2]) current_col <= current_col + 2;
                    else if ((current_col+3 < `QUEENS) && !given_col[current_col+3]) current_col <= current_col + 3;
                    else if ((current_col+4 < `QUEENS) && !given_col[current_col+4]) current_col <= current_col + 4;
                    else if ((current_col+5 < `QUEENS) && !given_col[current_col+5]) current_col <= current_col + 5;
                    else if ((current_col+6 < `QUEENS) && !given_col[current_col+6]) current_col <= current_col + 6;
                    else if ((current_col+7 < `QUEENS) && !given_col[current_col+7]) current_col <= current_col + 7;
                    else current_col <= `QUEENS; // no next column, answer is valid
                end
                S_BACKTRACK: begin
                    if ((current_col-1 >= 0) && !given_col[current_col-1]) current_col <= current_col - 1;
                    else if ((current_col-2 >= 0) && !given_col[current_col-2]) current_col <= current_col - 2;
                    else if ((current_col-3 >= 0) && !given_col[current_col-3]) current_col <= current_col - 3;
                    else if ((current_col-4 >= 0) && !given_col[current_col-4]) current_col <= current_col - 4;
                    else if ((current_col-5 >= 0) && !given_col[current_col-5]) current_col <= current_col - 5;
                    else if ((current_col-6 >= 0) && !given_col[current_col-6]) current_col <= current_col - 6;
                    else if ((current_col-7 >= 0) && !given_col[current_col-7]) current_col <= current_col - 7;
                    else current_col <= `QUEENS; // this branch shouldn't be reached
                end
            endcase
        end
    end

    // col_found
    always @* begin
        case (state)
            S_FIND_NEXT_COL: begin
                // number of inputs <= 6
                col_found = (
                    ((current_col+1 < `QUEENS) && !given_col[current_col+1]) ||
                    ((current_col+2 < `QUEENS) && !given_col[current_col+2]) ||
                    ((current_col+3 < `QUEENS) && !given_col[current_col+3]) ||
                    ((current_col+4 < `QUEENS) && !given_col[current_col+4]) ||
                    ((current_col+5 < `QUEENS) && !given_col[current_col+5]) ||
                    ((current_col+6 < `QUEENS) && !given_col[current_col+6]) ||
                    ((current_col+7 < `QUEENS) && !given_col[current_col+7])
                );
            end
            default: col_found = 0;
        endcase
    end

    // attack maps
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            used_row_bitmap <= 0;
            used_main_diagonal_bitmap <= 0;
            used_anti_diagonal_bitmap <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    used_row_bitmap <= 0;
                    used_main_diagonal_bitmap <= 0;
                    used_anti_diagonal_bitmap <= 0;
                end
                S_INPUT: begin
                    if (in_valid) begin
                        used_row_bitmap[row] <= 1;
                        used_main_diagonal_bitmap[row+col] <= 1;
                        used_anti_diagonal_bitmap[(`QUEENS+row)-col-1] <= 1;
                    end
                end
                S_BACKTRACK: begin
                    if (is_backtracking) begin
                        used_row_bitmap[ans[current_col]] <= 0;
                        used_main_diagonal_bitmap[ans[current_col]+current_col] <= 0;
                        used_anti_diagonal_bitmap[(`QUEENS+ans[current_col])-current_col-1] <= 0;
                    end
                end
                S_CHECK: begin
                    if (is_backtracking && placement_found) begin // next placement found, clear the old one
                        used_row_bitmap[ans[current_col]] <= 0;
                        used_main_diagonal_bitmap[ans[current_col]+current_col] <= 0;
                        used_anti_diagonal_bitmap[(`QUEENS+ans[current_col])-current_col-1] <= 0;
                    end
                end
                S_PLACE: begin
                    used_row_bitmap[found_row] <= 1;
                    used_main_diagonal_bitmap[found_row+current_col] <= 1;
                    used_anti_diagonal_bitmap[(`QUEENS+found_row)-current_col-1] <= 1;
                end
            endcase
        end
    end

    // CHECK COLUMN
    // legal_arr
    always @* begin
        for (i = 0; i < `QUEENS; i=i+1) begin // for each row
            // whether this square is on the existing attack maps
            legal_arr[i] = !(used_row_bitmap[i] || used_main_diagonal_bitmap[i+current_col] || used_anti_diagonal_bitmap[(`QUEENS+i)-current_col-1]);
        end
    end

    // found_row
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) found_row <= 0;
        else begin
            case (state)
                S_CHECK: begin
                    if (is_backtracking) begin
                        if (ans[current_col]+1 < `QUEENS && legal_arr[ans[current_col]+1]) found_row <= ans[current_col] + 1;
                        else if (ans[current_col]+2 < `QUEENS && legal_arr[ans[current_col]+2]) found_row <= ans[current_col] + 2;
                        else if (ans[current_col]+3 < `QUEENS && legal_arr[ans[current_col]+3]) found_row <= ans[current_col] + 3;
                        else if (ans[current_col]+4 < `QUEENS && legal_arr[ans[current_col]+4]) found_row <= ans[current_col] + 4;
                        else if (ans[current_col]+5 < `QUEENS && legal_arr[ans[current_col]+5]) found_row <= ans[current_col] + 5;
                        else if (ans[current_col]+6 < `QUEENS && legal_arr[ans[current_col]+6]) found_row <= ans[current_col] + 6;
                        else if (ans[current_col]+7 < `QUEENS && legal_arr[ans[current_col]+7]) found_row <= ans[current_col] + 7;
                        else if (ans[current_col]+8 < `QUEENS && legal_arr[ans[current_col]+8]) found_row <= ans[current_col] + 8;
                        else if (ans[current_col]+9 < `QUEENS && legal_arr[ans[current_col]+9]) found_row <= ans[current_col] + 9;
                        else if (ans[current_col]+10 < `QUEENS && legal_arr[ans[current_col]+10]) found_row <= ans[current_col] + 10;
                        else if (ans[current_col]+11 < `QUEENS && legal_arr[ans[current_col]+11]) found_row <= ans[current_col] + 11;
                        else found_row <= `INVALID_ANS; // no valid placement in this column
                    end else begin
                        if ((ans[current_col] == `INVALID_ANS) && legal_arr[0]) found_row <= 0;
                        else if ((ans[current_col] == `INVALID_ANS) && legal_arr[1]) found_row <= 1;
                        else if ((ans[current_col] == `INVALID_ANS) && legal_arr[2]) found_row <= 2;
                        else if ((ans[current_col] == `INVALID_ANS) && legal_arr[3]) found_row <= 3;
                        else if ((ans[current_col] == `INVALID_ANS) && legal_arr[4]) found_row <= 4;
                        else if ((ans[current_col] == `INVALID_ANS) && legal_arr[5]) found_row <= 5;
                        else if ((ans[current_col] == `INVALID_ANS) && legal_arr[6]) found_row <= 6;
                        else if ((ans[current_col] == `INVALID_ANS) && legal_arr[7]) found_row <= 7;
                        else if ((ans[current_col] == `INVALID_ANS) && legal_arr[8]) found_row <= 8;
                        else if ((ans[current_col] == `INVALID_ANS) && legal_arr[9]) found_row <= 9;
                        else if ((ans[current_col] == `INVALID_ANS) && legal_arr[10]) found_row <= 10;
                        else if ((ans[current_col] == `INVALID_ANS) && legal_arr[11]) found_row <= 11;
                        else if (ans[current_col]+1 < `QUEENS && legal_arr[ans[current_col]+1]) found_row <= ans[current_col] + 1;
                        else if (ans[current_col]+2 < `QUEENS && legal_arr[ans[current_col]+2]) found_row <= ans[current_col] + 2;
                        else if (ans[current_col]+3 < `QUEENS && legal_arr[ans[current_col]+3]) found_row <= ans[current_col] + 3;
                        else if (ans[current_col]+4 < `QUEENS && legal_arr[ans[current_col]+4]) found_row <= ans[current_col] + 4;
                        else if (ans[current_col]+5 < `QUEENS && legal_arr[ans[current_col]+5]) found_row <= ans[current_col] + 5;
                        else if (ans[current_col]+6 < `QUEENS && legal_arr[ans[current_col]+6]) found_row <= ans[current_col] + 6;
                        else if (ans[current_col]+7 < `QUEENS && legal_arr[ans[current_col]+7]) found_row <= ans[current_col] + 7;
                        else if (ans[current_col]+8 < `QUEENS && legal_arr[ans[current_col]+8]) found_row <= ans[current_col] + 8;
                        else if (ans[current_col]+9 < `QUEENS && legal_arr[ans[current_col]+9]) found_row <= ans[current_col] + 9;
                        else if (ans[current_col]+10 < `QUEENS && legal_arr[ans[current_col]+10]) found_row <= ans[current_col] + 10;
                        else if (ans[current_col]+11 < `QUEENS && legal_arr[ans[current_col]+11]) found_row <= ans[current_col] + 11;
                        else found_row <= `INVALID_ANS; // no valid placement in this column
                    end
                end
                default: begin
                    found_row <= 0;
                end
            endcase
        end
    end

    // placement_found
    always @* begin
        case (state)
            S_CHECK: begin
                if (is_backtracking) begin
                    if (ans[current_col]+1 < `QUEENS && legal_arr[ans[current_col]+1]) placement_found = 1;
                    else if (ans[current_col]+2 < `QUEENS && legal_arr[ans[current_col]+2]) placement_found = 1;
                    else if (ans[current_col]+3 < `QUEENS && legal_arr[ans[current_col]+3]) placement_found = 1;
                    else if (ans[current_col]+4 < `QUEENS && legal_arr[ans[current_col]+4]) placement_found = 1;
                    else if (ans[current_col]+5 < `QUEENS && legal_arr[ans[current_col]+5]) placement_found = 1;
                    else if (ans[current_col]+6 < `QUEENS && legal_arr[ans[current_col]+6]) placement_found = 1;
                    else if (ans[current_col]+7 < `QUEENS && legal_arr[ans[current_col]+7]) placement_found = 1;
                    else if (ans[current_col]+8 < `QUEENS && legal_arr[ans[current_col]+8]) placement_found = 1;
                    else if (ans[current_col]+9 < `QUEENS && legal_arr[ans[current_col]+9]) placement_found = 1;
                    else if (ans[current_col]+10 < `QUEENS && legal_arr[ans[current_col]+10]) placement_found = 1;
                    else if (ans[current_col]+11 < `QUEENS && legal_arr[ans[current_col]+11]) placement_found = 1;
                    else placement_found = 0; // no valid placement in this column
                end else begin
                    if ((ans[current_col] == `INVALID_ANS) && |(legal_arr)) placement_found = 1;
                    else if (ans[current_col]+1 < `QUEENS && legal_arr[ans[current_col]+1]) placement_found = 1;
                    else if (ans[current_col]+2 < `QUEENS && legal_arr[ans[current_col]+2]) placement_found = 1;
                    else if (ans[current_col]+3 < `QUEENS && legal_arr[ans[current_col]+3]) placement_found = 1;
                    else if (ans[current_col]+4 < `QUEENS && legal_arr[ans[current_col]+4]) placement_found = 1;
                    else if (ans[current_col]+5 < `QUEENS && legal_arr[ans[current_col]+5]) placement_found = 1;
                    else if (ans[current_col]+6 < `QUEENS && legal_arr[ans[current_col]+6]) placement_found = 1;
                    else if (ans[current_col]+7 < `QUEENS && legal_arr[ans[current_col]+7]) placement_found = 1;
                    else if (ans[current_col]+8 < `QUEENS && legal_arr[ans[current_col]+8]) placement_found = 1;
                    else if (ans[current_col]+9 < `QUEENS && legal_arr[ans[current_col]+9]) placement_found = 1;
                    else if (ans[current_col]+10 < `QUEENS && legal_arr[ans[current_col]+10]) placement_found = 1;
                    else if (ans[current_col]+11 < `QUEENS && legal_arr[ans[current_col]+11]) placement_found = 1;
                    else placement_found = 0; // no valid placement in this column
                end
            end
            default: placement_found = 0;
        endcase
    end
    // END OF CHECK COLUMN

    // ans
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < `QUEENS; i=i+1) begin
                ans[i] <= `INVALID_ANS; // invalid answer
            end
        end else begin
            case (state)
                S_IDLE: begin
                    for (i = 0; i < `QUEENS; i=i+1) begin
                        ans[i] <= `INVALID_ANS; // invalid answer
                    end
                end
                S_INPUT: begin
                    if (in_valid) begin
                        ans[col] <= row;
                    end
                end
                S_PLACE: begin
                    ans[current_col] <= found_row;
                end
                S_BACKTRACK: begin
                    if (is_backtracking) begin
                        ans[current_col] <= `INVALID_ANS;
                    end
                end
                S_DONE: begin
                    // left shift memory by 1 index
                    for (i = 0; i < `QUEENS-1; i=i+1) begin
                        ans[i] <= ans[i+1];
                    end

                    ans[`QUEENS-1] <= 0;
                end
            endcase
        end
    end

    // is_backtracking
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) is_backtracking <= 0;
        else begin
            case (state)
                S_IDLE: is_backtracking <= 0;
                S_CHECK: begin
                    if (is_backtracking && placement_found) begin
                        is_backtracking <= 0;
                    end
                end
                S_BACKTRACK: is_backtracking <= 1;
            endcase
        end
    end

    // counter
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) counter <= 0;
        else begin
            case (state)
                S_IDLE: counter <= 0;
                S_BACKTRACK: counter <= counter + 1;
                S_PLACE: counter <= 0;
                S_DONE: counter <= counter + 1;
                default: counter <= 0;
            endcase
        end
    end

    // OUTPUT
    // out_valid
    assign out_valid = (state == S_DONE);

    // out
    assign out = (state == S_DONE)? ans[0] : 0;
    // END OF OUTPUT
endmodule
