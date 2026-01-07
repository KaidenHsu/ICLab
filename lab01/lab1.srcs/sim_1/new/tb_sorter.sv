`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2025 12:10:07 AM
// Design Name: 
// Module Name: tb_sorter
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

`define STUDENT_NUMBER 7

module tb_sorter();
    typedef struct {
        logic [3-1 : 0] idx;
        logic [4-1 : 0] val;
    } pair_t;

    logic [4-1 : 0] in_s0, in_s1, in_s2, in_s3, in_s4, in_s5, in_s6;
    logic [3-1 : 0] s_id0, s_id1, s_id2, s_id3, s_id4, s_id5, s_id6;

    logic [3-1 : 0] opt;

    logic [4-1 : 0] golden [`STUDENT_NUMBER-1 : 0];
    logic [4-1 : 0] answer [`STUDENT_NUMBER-1 : 0];

    pair_t sortArr [`STUDENT_NUMBER-1 : 0];

    // sorter uut (
    //     .in_s0  (in_s0),
    //     .in_s1  (in_s1),
    //     .in_s2  (in_s2),
    //     .in_s3  (in_s3),
    //     .in_s4  (in_s4),
    //     .in_s5  (in_s5),
    //     .in_s6  (in_s6),

    //     .opt (opt),

    //     .s_id0  (s_id0),
    //     .s_id1  (s_id1),
    //     .s_id2  (s_id2),
    //     .s_id3  (s_id3),
    //     .s_id4  (s_id4),
    //     .s_id5  (s_id5),
    //     .s_id6  (s_id6)
    // );

    min_size_sorting_network uut (
        .in_s0  (in_s0),
        .in_s1  (in_s1),
        .in_s2  (in_s2),
        .in_s3  (in_s3),
        .in_s4  (in_s4),
        .in_s5  (in_s5),
        .in_s6  (in_s6),

        .opt (opt),

        .s_id0  (s_id0),
        .s_id1  (s_id1),
        .s_id2  (s_id2),
        .s_id3  (s_id3),
        .s_id4  (s_id4),
        .s_id5  (s_id5),
        .s_id6  (s_id6)
    );

    int seed;

    int i, j;
    bit swapped; // true or false

    pair_t tmp; // temp variable for swapping

    initial begin
        opt = 3'b000;
        seed = 29;

        // 10 sets of test cases
        repeat (10) begin
            // signedness
            opt[0] = $random(seed) % 2;
            // sort order
            opt[1] = $random(seed) % 2;

            in_s0 = $random(seed) % 15;
            in_s1 = $random(seed) % 15;
            in_s2 = $random(seed) % 15;
            in_s3 = $random(seed) % 15;
            in_s4 = $random(seed) % 15;
            in_s5 = $random(seed) % 15;
            in_s6 = $random(seed) % 15;

            // initialize golden array of pairs
            for (i = 0; i < `STUDENT_NUMBER; i++) begin
                sortArr[i].idx = i;
            end

            sortArr[0].val = in_s0;
            sortArr[1].val = in_s1;
            sortArr[2].val = in_s2;
            sortArr[3].val = in_s3;
            sortArr[4].val = in_s4;
            sortArr[5].val = in_s5;
            sortArr[6].val = in_s6;

            // bubble sort
            for (i = 0; i < `STUDENT_NUMBER - 1; i++) begin
                swapped = 0; // false

                for (j = 0; j < `STUDENT_NUMBER - i - 1; j++) begin

                    if (opt[1]) begin // descending order
                        if (opt[0]) begin // signed
                            if ($signed(sortArr[j].val) < $signed(sortArr[j+1].val)) begin
                                // swap
                                tmp = sortArr[j];
                                sortArr[j] = sortArr[j+1];
                                sortArr[j+1] = tmp;

                                swapped = 1; // true
                            end
                        end else begin // unsigned
                            if (sortArr[j].val < sortArr[j+1].val) begin
                                // swap
                                tmp = sortArr[j];
                                sortArr[j] = sortArr[j+1];
                                sortArr[j+1] = tmp;

                                swapped = 1; // true
                            end
                        end
                    end else begin // ascending order
                        if (opt[0]) begin // signed
                            if ($signed(sortArr[j].val) > $signed(sortArr[j+1].val)) begin
                                // swap
                                tmp = sortArr[j];
                                sortArr[j] = sortArr[j+1];
                                sortArr[j+1] = tmp;

                                swapped = 1; // true
                            end
                        end else begin // unsigned
                            if (sortArr[j].val > sortArr[j+1].val) begin
                                // swap
                                tmp = sortArr[j];
                                sortArr[j] = sortArr[j+1];
                                sortArr[j+1] = tmp;

                                swapped = 1; // true
                            end
                        end
                    end
                end
            
                // If no two elements were swapped, then break
                if (!swapped) break;
            end

            /*------- check answer after a short delay ------*/
            #10

            // concatenate uut outputs
            answer[0] = s_id0;
            answer[1] = s_id1;
            answer[2] = s_id2;
            answer[3] = s_id3;
            answer[4] = s_id4;
            answer[5] = s_id5;
            answer[6] = s_id6;

            // construct golden from sortArr
            for (i = 0; i < `STUDENT_NUMBER; i++) begin
                golden[i] = sortArr[i].idx;
            end

            // if wrong
            if (answer !== golden) begin
                $display("Wrong Answer!");
                $display("opt[0] = %d", opt[0]);
                $display("opt[1] = %d", opt[1]);

                $display("golden: ");
                for (i = 0; i < `STUDENT_NUMBER; i++) begin
                    $display("golden[%0d] = %d", i, golden[i]);
                end

                $display("Your answer: ");
                for (i = 0; i < `STUDENT_NUMBER; i++) begin
                    $display("answer[%0d] = %d", i, answer[i]);
                end

                #10 $finish;
            end

            $display("All test cases passed!");
            #10 $finish;
        end
    end
endmodule
