`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2025 12:36:41 AM
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


`define CLK_PRD 10

`define INPUT_DLY (`CLK_PRD/2)
`define OUTPUT_DLY (`CLK_PRD/2)

// number of patterns cannot be more than 300
`define PAT_CNT 300

`define COL 64

module PATTERN(
    input out_valid,
    input [2-1 : 0] out,

    output reg clk, rst_n,
    output reg in_valid,
    output reg [2-1 : 0] init,
    output reg [2-1 : 0] in0, in1, in2, in3
);
    // 4 x 64 map
    reg [2-1 : 0] map [0 : `COL-1][0 : 4-1];
    
    // 63 moves
    reg [2-1 : 0] ans [0 : `COL-2];

    // cost for forward, left, right, jump
    reg [3-1 : 0] cost [0 : 4-1];

    // specs 3 ~ 7, 8-1 ~ 8-5
    // 1: pass
    // 0: fail
    reg [0 : 10-1] specs;
    integer latency, out_cycle;
    integer total_cost = 0;

    reg [4-1 : 0] train_gen [0 : 8-1];
    reg [2-1 : 0] init_pos_candidate_arr [0 : 4-1];
    reg [2-1 : 0] lots;
    reg [2-1 : 0] init_position;

    reg [2-1 : 0] row;
    reg in_bounds;

    integer i, j, k;



    // initialize cost array
    initial begin
        cost[0] = 1;
        cost[1] = 2;
        cost[2] = 2;
        cost[3] = 4;
    end

    // spec 4 (3%)
    // the out should be reset
    // when your out_valid is low
    always @(negedge out_valid) begin
        specs[1] = ((out === 0) && specs[1]);
    end

    // spec 5 (3%)
    // the out_valid should not be high
    // when in_valid is high
    initial begin
        @(out_valid === 1 & in_valid === 1);
        $display("%0t, s5 fail!", $time);
        specs[2] = 0;
    end

    // clock
    initial begin
        clk = 0;
        forever #(`CLK_PRD/2) clk = ~clk;
    end



    initial begin
        // specs 3 ~ 5
        specs[0] = 0; // spec 3
        specs[1] = 1; // spec 4
        specs[2] = 1; // spec 5

        // initialize input signals
        init = 0;
        in0 = 0;
        in1 = 0;
        in2 = 0;
        in3 = 0;

        // asynchronous reset once at the beginning
        rst_n = 1;
        #(2*`CLK_PRD)
        force clk = 0;
        #(2*`CLK_PRD)
        rst_n = 0;
        #(2*`CLK_PRD)

        // spec 3 (3%)
        // all output signals should be reset
        // after the reset signal is asserted
        specs[0] = ((out == 0) && (out_valid == 0));

        #(2*`CLK_PRD)
        rst_n = 1;
        #(2*`CLK_PRD)
        release clk;

        @(posedge clk);
        @(posedge clk);

        // loop through patterns
        for (i = 0; i < `PAT_CNT; i=i+1) begin
            // specs
            specs[3] = 1;
            specs[4] = 0;
            specs[5] = 1;
            specs[6] = 1;
            specs[7] = 1;
            specs[8] = 1;
            specs[9] = 1;

            $display("Pattern #%0d: ", i);

            // header rows
            for (j = 0; j < `COL; j=j+1) begin
                if (!(j%10)) begin
                    $write("%0d ", j/10);
                end else begin
                    $write("  ");
                end
            end
            $write("\n");

            for (j = 0; j < `COL; j=j+1) begin
                $write("%0d ", j % 10);
            end
            $write("\n");

            $display("--------------------------------------------------------------------------------------------------------------------------------");

            gen_map_and_init_pos;
            $display("ans: (init = %d)", init_position);

            latency = -1;
            out_cycle = 0;

            // ------- INPUT -------
            for (j = 0; j < `COL; j=j+1) begin
                @(posedge clk);
                #(`INPUT_DLY)

                if (j == 0) begin
                    in_valid = 1;
                    init = init_position;
                end else if (j == 1) begin
                    init = 0;
                end

                in0 = map[j][0];
                in1 = map[j][1];
                in2 = map[j][2];
                in3 = map[j][3];
            end

            // the 64 column map input
            @(posedge clk);
            #(`INPUT_DLY)
            in_valid = 0;

            // spec 6 (3%)
            // the execution latency is
            // limited in 3000 cycles
            while (!out_valid) begin
                latency = latency + 1;

                if (latency == 3001) begin
                    specs[3] = 0;
                end

                ans[0] = out;

                @(posedge clk);
            end
            // ------- END INPUT -------

            // ------- OUTPUT -------
            for (j = 1; out_valid; j=j+1) begin
                #(`OUTPUT_DLY)

                $write("%d ", out);
                ans[j] = out;

                // spec 7 (3%)
                // out_valid and out must asserted
                // successively in 63 cycles
                out_cycle = out_cycle + 1;

                if (out_cycle == 63) specs[4] = 1;
                if (out_cycle > 63) specs[4] = 0;

                @(posedge clk);
            end

            $write("\n");
            // ------- END OUTPUT -------

            row = init_position;
            in_bounds = 1;

            for (j = 0; (j < `COL-1) && in_bounds; j=j+1) begin
                // $display("j=%2d, ans[j]=%0d, row=%0d", j, ans[j], row);

                // spec 8-5 (5%): if you are on a lower obstacle, you cannot use jump
                if ((map[j][row] == 1) && // on a lower obstacle
                    (ans[j] == 3) // jump
                ) specs[9] = 0;

                // spec 8-1 (5%): the character cannot run outside the map
                if ((row == 0 && ans[j] == 2) || // out of left bounds
                    (row == 3 && ans[j] == 1) // out of right bounds
                ) begin
                    specs[5] = 0;
                    in_bounds = 0;
                end else begin
                    case (ans[j])
                        1: row = row + 1; // right
                        2: row = row - 1; // left
                    endcase

                    // spec 8-2 (5%): the character must avoid hitting lower obstacles
                    if ((map[j+1][row] == 1) && // destination is a lower obstacle
                        (ans[j] < 3) // forward, left, right
                    ) begin
                        specs[6] = 0;
                    end

                    // spec 8-3 (5%): the character must avoid hitting higher obstacles
                    if ((map[j+1][row] == 2) && // destination is a higher obstacle
                        (ans[j] > 0) // left, right, jump
                    ) specs[7] = 0;

                    // spec 8-4 (5%): the character must avoid hitting trains
                    if ((map[j+1][row] == 3)) begin // destination is a train
                        specs[8] = 0;
                    end

                    // accumulate total cost
                    total_cost = total_cost + cost[ans[j]];
                end
            end

            repeat ($urandom_range(2, 5)) begin
                @(posedge clk);
            end

            // check specs and print error message according to priority
            check_specs;

            // display total_cost
            $write("total cost = %0d ", total_cost);
            if (total_cost < 28000) begin
                $display("(< 28000: You get yourself 5 bonus points!)");
            end

            $display("");
            $display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
            $display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
            $display("");
        end


        #(`CLK_PRD) $finish;
    end



    task gen_map_and_init_pos;
        begin
            // clear map and place obstacles
            for (j = 0; j < `COL; j=j+1) begin
                for (k = 0; k < 4; k=k+1) begin
                    if (!(j % 2) && // even columns
                        (j % 8) // excluding columns divisible by 8
                    ) begin
                        // could be lower, higher obstacles or road
                        map[j][k] = $urandom_range(0, 2);
                    end else begin
                        map[j][k] = 0;
                    end
                end
            end

            // generate train_gen
            // 0 ~ 3: train at position i
            // 4 ~ 9: trains at (0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)
            // 10 ~ 13: trains at (1, 2, 3), (0, 2, 3), (0, 1, 3), (0, 1, 2)
            for (j = 0; j < 8; j=j+1) begin
                for (k = 0; k < 4; k=k+1) begin
                    train_gen[j][k] = $urandom_range(0, 13);
                end
            end

            // place trains using train_gen, not blocking the map
            for (j = 0; j < `COL; j=j+1) begin
                if (j % 8 < 4) begin
                    case (train_gen[j/8])
                    // 0 ~ 3: train at position i
                        0: begin
                            map[j][0] = 3;
                        end
                        1: begin
                            map[j][1] = 3;
                        end
                        2: begin
                            map[j][2] = 3;
                        end
                        3: begin
                            map[j][3] = 3;
                        end
                        // 4 ~ 9: trains at (0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)
                        4: begin
                            map[j][0] = 3;
                            map[j][1] = 3;
                        end
                        5: begin
                            map[j][0] = 3;
                            map[j][2] = 3;
                        end
                        6: begin
                            map[j][0] = 3;
                            map[j][3] = 3;
                        end
                        7: begin
                            map[j][1] = 3;
                            map[j][2] = 3;
                        end
                        8: begin
                            map[j][1] = 3;
                            map[j][3] = 3;
                        end
                        9: begin
                            map[j][2] = 3;
                            map[j][3] = 3;
                        end
                        // 10 ~ 13: trains at (1, 2, 3), (0, 2, 3), (0, 1, 3), (0, 1, 2)
                        10: begin
                            map[j][1] = 3;
                            map[j][2] = 3;
                            map[j][3] = 3;
                        end
                        11: begin
                            map[j][0] = 3;
                            map[j][2] = 3;
                            map[j][3] = 3;
                        end
                        12: begin
                            map[j][0] = 3;
                            map[j][1] = 3;
                            map[j][3] = 3;
                        end
                        13: begin
                            map[j][0] = 3;
                            map[j][1] = 3;
                            map[j][2] = 3;
                        end
                    endcase
                end
            end

            // decide init_position
            case (train_gen[0])
                // 0 ~ 3: train at position i
                0: begin
                    init_pos_candidate_arr[0] = 1;
                    init_pos_candidate_arr[1] = 2;
                    init_pos_candidate_arr[2] = 3;
                    init_pos_candidate_arr[3] = 0;

                    lots = $urandom_range(0, 2);
                    init_position = init_pos_candidate_arr[lots];
                end
                1: begin
                    init_pos_candidate_arr[0] = 0;
                    init_pos_candidate_arr[1] = 2;
                    init_pos_candidate_arr[2] = 3;
                    init_pos_candidate_arr[3] = 0;

                    lots = $urandom_range(0, 2);
                    init_position = init_pos_candidate_arr[lots];
                end
                2: begin
                    init_pos_candidate_arr[0] = 0;
                    init_pos_candidate_arr[1] = 1;
                    init_pos_candidate_arr[2] = 3;
                    init_pos_candidate_arr[3] = 0;

                    lots = $urandom_range(0, 2);
                    init_position = init_pos_candidate_arr[lots];
                end
                3: begin
                    init_pos_candidate_arr[0] = 0;
                    init_pos_candidate_arr[1] = 1;
                    init_pos_candidate_arr[2] = 2;
                    init_pos_candidate_arr[3] = 0;

                    lots = $urandom_range(0, 2);
                    init_position = init_pos_candidate_arr[lots];
                end
                // 4 ~ 9: trains at (0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)
                4: begin
                    init_pos_candidate_arr[0] = 2;
                    init_pos_candidate_arr[1] = 3;
                    init_pos_candidate_arr[2] = 0;
                    init_pos_candidate_arr[3] = 0;

                    lots = $urandom_range(0, 1);
                    init_position = init_pos_candidate_arr[lots];
                end
                5: begin
                    init_pos_candidate_arr[0] = 1;
                    init_pos_candidate_arr[1] = 3;
                    init_pos_candidate_arr[2] = 0;
                    init_pos_candidate_arr[3] = 0;

                    lots = $urandom_range(0, 1);
                    init_position = init_pos_candidate_arr[lots];
                end
                6: begin
                    init_pos_candidate_arr[0] = 1;
                    init_pos_candidate_arr[1] = 2;
                    init_pos_candidate_arr[2] = 0;
                    init_pos_candidate_arr[3] = 0;

                    lots = $urandom_range(0, 1);
                    init_position = init_pos_candidate_arr[lots];
                end
                7: begin
                    init_pos_candidate_arr[0] = 0;
                    init_pos_candidate_arr[1] = 3;
                    init_pos_candidate_arr[2] = 0;
                    init_pos_candidate_arr[3] = 0;

                    lots = $urandom_range(0, 1);
                    init_position = init_pos_candidate_arr[lots];
                end
                8: begin
                    init_pos_candidate_arr[0] = 0;
                    init_pos_candidate_arr[1] = 2;
                    init_pos_candidate_arr[2] = 0;
                    init_pos_candidate_arr[3] = 0;

                    lots = $urandom_range(0, 1);
                    init_position = init_pos_candidate_arr[lots];
                end
                9: begin
                    init_pos_candidate_arr[0] = 0;
                    init_pos_candidate_arr[1] = 1;
                    init_pos_candidate_arr[2] = 0;
                    init_pos_candidate_arr[3] = 0;

                    lots = $urandom_range(0, 1);
                    init_position = init_pos_candidate_arr[lots];
                end
                // 10 ~ 13: trains at (1, 2, 3), (0, 2, 3), (0, 1, 3), (0, 1, 2)
                10: init_position = 0;
                11: init_position = 1;
                12: init_position = 2;
                13: init_position = 3;
            endcase

            // init position should be on road
            map[0][init_position] = 0;

            // print the generated map to console
            for (j = 0; j < 4; j=j+1) begin
                for (k = 0; k < `COL; k=k+1) begin
                    $write("%d ", map[k][j]);
                end
                $write("\n");
            end
        end
    endtask

    // check specs with priority
    task check_specs;
        begin
            if (!specs[0]) begin
                $display("SPEC 3 IS FAIL!");
                $finish;
            end else if (!specs[1]) begin
                $display("SPEC 4 IS FAIL!");
                $finish;
            end else if (!specs[2]) begin
                $display("SPEC 5 IS FAIL!");
                $finish;
            end else if (!specs[3]) begin
                $display("SPEC 6 IS FAIL!");
                $finish;
            end else if (!specs[4]) begin
                $display("SPEC 7 IS FAIL!");
                $finish;
            end else if (!specs[5]) begin
                $display("SPEC 8-1 IS FAIL!");
                $finish;
            end else if (!specs[6]) begin
                $display("SPEC 8-2 IS FAIL!");
                $finish;
            end else if (!specs[7]) begin
                $display("SPEC 8-3 IS FAIL!");
                $finish;
            end else if (!specs[8]) begin
                $display("SPEC 8-4 IS FAIL!");
                $finish;
            end else if (!specs[9]) begin
                $display("SPEC 8-5 IS FAIL!");
                $finish;
            end else begin
                $display ("--------------------------------------------------------------------");
                $display ("                         Congratulations!                           ");
                $display ("                  You have passed all patterns!                     ");
                $display ("--------------------------------------------------------------------");        
            end
        end
    endtask
endmodule
