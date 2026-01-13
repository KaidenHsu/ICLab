`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2025 12:42:59 AM
// Design Name: 
// Module Name: SUBWAY
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


`define COL 64
`define ROW 4

module SUBWAY(
    input clk, rst_n,

    input in_valid,
    input [2-1 : 0] init,
    input [2-1 : 0] in0, in1, in2, in3,

    output out_valid,
    output reg [2-1 : 0] out
);
    // universal counter
    reg [7-1 : 0] counter;

    reg [6-1 : 0] curr_col; // 0 ~ 63
    reg [2-1 : 0] curr_row; // 0 ~ 3

    // 0: forward, 1: right, 2: left
    // 3: jump, 4: backtrack
    reg [3-1 : 0] action; // comb logic

    // 4 bidirectional shift registers (1 each row)
    reg [2-1 : 0] map [0 : `COL-1][0 : `ROW-1];

    // answer
    reg [2-1 : 0] ans [0 : `COL-2];

    integer i, j;

    // --------------- FSM ---------------
    localparam S_IDLE = 0;
    localparam S_INPUT = 1;
    localparam S_FORWARD = 2;
    localparam S_BACKWARD = 3;
    localparam S_OUTPUT = 4;
    reg [3-1 : 0] state, n_state;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) state <= S_IDLE;
        else state <= n_state;
    end

    always @* begin
        case (state)
            S_IDLE: n_state = S_INPUT;
            S_INPUT: n_state = (counter == `COL-1)? S_FORWARD : S_INPUT;
            S_FORWARD: begin
                if (curr_col == `COL-1) n_state = S_OUTPUT;
                else if (action == 4) n_state = S_BACKWARD;
                else n_state = S_FORWARD;
            end
            S_BACKWARD: n_state = (action == 4)? S_BACKWARD : S_FORWARD;
            S_OUTPUT: n_state = (counter == `COL-2)? S_IDLE : S_OUTPUT;
            default: n_state = S_IDLE;
        endcase
    end
    // --------------- END FSM ---------------

    // counter
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) counter <= 0;
        else begin
            case (state)
                S_IDLE: counter <= 0;
                S_INPUT: if (in_valid) counter <= (counter == `COL-1)? 0 : counter+1;
                S_FORWARD: counter <= 0;
                S_OUTPUT: counter <= counter+1;
            endcase
        end
    end

    // curr_col
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) curr_col <= 0;
        else begin
            case (state)
                S_IDLE: curr_col <= 0;
                S_FORWARD, S_BACKWARD: begin
                    if (curr_col != `COL-1) begin
                        curr_col <= (action == 4)? curr_col-1 : curr_col+1;
                    end
                end
            endcase
        end
    end

    // curr_row
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) curr_row <= 0;
        else begin
            case (state)
                S_IDLE: curr_row <= 0;
                S_INPUT: if (in_valid && counter == 0) curr_row <= init; // TODO: counter = ?
                S_FORWARD: begin
                    if (curr_col != `COL-1) begin
                        case (action)
                            1: curr_row <= curr_row+1; // right
                            2: curr_row <= curr_row-1; // left
                        endcase
                    end
                end
                S_BACKWARD: begin
                    // note that action in each col was chosen considering priority
                    case (action)
                        // undo previous action, add new action offset, then search forward
                        1: begin // right
                            // ans[curr_col] is 0
                            curr_row <= curr_row+1;
                        end
                        2: begin // left
                            case (ans[curr_col]) // previous action
                                0: curr_row <= curr_row-1;
                                1: curr_row <= curr_row-2;
                            endcase
                        end
                        3: begin // jump
                            case (ans[curr_col])
                                0: curr_row <= curr_row; // no change
                                1: curr_row <= curr_row-1; // move left
                                2: curr_row <= curr_row+1; // move right
                            endcase
                        end
                        // undo previous action, then keep backtracking
                        4: begin // backtrack
                            case (ans[curr_col])
                                0, 3: curr_row <= curr_row; // no change
                                1: curr_row <= curr_row-1; // move left
                                2: curr_row <= curr_row+1; // move right
                            endcase
                        end
                    endcase
                end
            endcase
        end
    end

    // action
    // 0: forward, 1: right, 2: left
    // 3: jump, 4: backtrack
    always @* begin
        case (state)
            S_FORWARD: begin
                if (curr_col == `COL-1) action = 0; // answer already found, set action to a dummy value
                else if (map[1][curr_row] == 0 || map[1][curr_row] == 2) action = 0; // forward, not allowed to run straight into lower obstacle or train
                else if (curr_row != `ROW && map[1][curr_row+1] == 0) action = 1; // right, not allowed to leave map and can only enter road
                else if (curr_row != 0 && map[1][curr_row-1] == 0) action = 2; // left, not allowed to leave map and can only enter road
                else if (map[0][curr_row] != 1 && map[1][curr_row] < 2) action = 3; // jump, cannot jump on lower obstacle and can't jump into higher obstacle or train
                else action = 4; // no legal action, backtrack
            end
            S_BACKWARD: begin
                // choose action with priority
                case (ans[curr_col]) // previous action
                    0: begin // forward
                        if (curr_row != `ROW && map[1][curr_row+1] == 0) action = 1; // right, not allowed to leave map and can only enter road
                        else if (curr_row != 0 && map[1][curr_row-1] == 0) action = 2; // left, not allowed to leave map and can only enter road
                        else if (map[0][curr_row] != 1 && map[1][curr_row] < 2) action = 3; // jump, cannot jump on lower obstacle and can't jump into higher obstacle or train
                        else action = 4; // no legal action, backtrack
                    end
                    1: begin // right
                        if (curr_row > 1 && map[1][curr_row-2] == 0) action = 2; // left, not allowed to leave map and can only enter road
                        else if (map[0][curr_row] != 1 && map[1][curr_row] < 2) action = 3; // jump, cannot jump on lower obstacle and can't jump into higher obstacle or train
                        else action = 4; // no legal action, backtrack
                    end
                    2: begin // left
                        if (map[0][curr_row] != 1 && map[1][curr_row] < 2) action = 3; // jump, cannot jump on lower obstacle and can't jump into higher obstacle or train
                        else action = 4; // no legal action, backtrack
                    end
                    3: begin // jump
                        action = 4;
                    end
                endcase
            end
            default: action = 0;
        endcase
    end

    // map
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < `COL; i=i+1) begin
                for (j = 0; j < `ROW; j=j+1) begin
                    map[i][j] <= 0;
                end
            end
        end else begin
            case (state)
                S_IDLE: begin
                    for (i = 0; i < `COL; i=i+1) begin
                        for (j = 0; j < `ROW; j=j+1) begin
                            map[i][j] <= 0;
                        end
                    end
                end
                S_INPUT: begin // read map
                    if (in_valid) begin
                        // shift left
                        for (i = 0; i < `COL-1; i=i+1) begin
                            for (j = 0; j < `ROW; j=j+1) begin
                                map[i][j] <= map[i+1][j];
                            end
                        end

                        map[`COL-1][0] <= in0;
                        map[`COL-1][1] <= in1;
                        map[`COL-1][2] <= in2;
                        map[`COL-1][3] <= in3;
                    end
                end
                S_FORWARD, S_BACKWARD: begin
                    if (action == 4) begin // backtrack
                        // rotate right
                        for (i = 0; i < `COL; i=i+1) begin
                            for (j = 0; j < `ROW; j=j+1) begin
                                map[(i+1)%(`COL)][j] <= map[i][j];
                            end
                        end
                    end else if (curr_col < `COL-1) begin // search forward
                        // rotate left
                        for (i = 0; i < `COL; i=i+1) begin
                            for (j = 0; j < `ROW; j=j+1) begin
                                map[i][j] <= map[(i+1)%(`COL)][j];
                            end
                        end
                    end
                end
            endcase
        end
    end
    
    // ans
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < `COL-1; i=i+1) begin
                ans[i] <= 0;
            end
        end else begin
            case (state)
                S_IDLE: begin
                    for (i = 0; i < `COL-1; i=i+1) begin
                        ans[i] <= 0;
                    end
                end
                S_FORWARD, S_BACKWARD: begin
                    if (curr_col < `COL-1 && action < 4) begin
                        ans[curr_col] <= action;
                    end
                end
            endcase
        end
    end

    // --------------- OUTPUT ---------------
    // out_valid
    assign out_valid = (state == S_OUTPUT);

    // out
    always @* begin
        case (state)
            S_OUTPUT: out = ans[counter];
            default: out = 0;
        endcase
    end
    // --------------- END OUTPUT ---------------
endmodule
