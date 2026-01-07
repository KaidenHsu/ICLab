`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2025 12:53:54 AM
// Design Name: 
// Module Name: tb_CC
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


`define TEST_CASES 4

module tb_cc();
	logic [4-1:0] in_s0, in_s1, in_s2, in_s3, in_s4, in_s5, in_s6;
	logic [3-1:0] opt;
	logic [2-1:0] a;
	logic [3-1:0] b;

	logic [3-1:0] out;
	logic [3-1:0] s_id0, s_id1, s_id2, s_id3, s_id4, s_id5, s_id6;

	CC uut (
		.in_s0(in_s0), .in_s1(in_s1), .in_s2(in_s2), .in_s3(in_s3), .in_s4(in_s4), .in_s5(in_s5), .in_s6(in_s6),
		.opt(opt),
		.a(a), .b(b),

		.out(out),
		.s_id0(s_id0), .s_id1(s_id1), .s_id2(s_id2), .s_id3(s_id3), .s_id4(s_id4), .s_id5(s_id5), .s_id6(s_id6)
	);

	logic [4-1 : 0] in_s0_arr [`TEST_CASES-1 : 0];
    logic [4-1 : 0] in_s1_arr [`TEST_CASES-1 : 0];
    logic [4-1 : 0] in_s2_arr [`TEST_CASES-1 : 0];
    logic [4-1 : 0] in_s3_arr [`TEST_CASES-1 : 0];
    logic [4-1 : 0] in_s4_arr [`TEST_CASES-1 : 0];
    logic [4-1 : 0] in_s5_arr [`TEST_CASES-1 : 0];
    logic [4-1 : 0] in_s6_arr [`TEST_CASES-1 : 0];

	logic [3-1 : 0] opt_arr [`TEST_CASES-1 : 0];

	logic [2-1 : 0] a_arr [`TEST_CASES-1 : 0];
	logic [3-1 : 0] b_arr [`TEST_CASES-1 : 0];

	logic [3-1 : 0] out_arr [`TEST_CASES-1 : 0];

	logic [3-1 : 0] s_id0_arr [`TEST_CASES-1 : 0];
    logic [3-1 : 0] s_id1_arr [`TEST_CASES-1 : 0];
    logic [3-1 : 0] s_id2_arr [`TEST_CASES-1 : 0];
    logic [3-1 : 0] s_id3_arr [`TEST_CASES-1 : 0];
    logic [3-1 : 0] s_id4_arr [`TEST_CASES-1 : 0];
    logic [3-1 : 0] s_id5_arr [`TEST_CASES-1 : 0];
    logic [3-1 : 0] s_id6_arr [`TEST_CASES-1 : 0];

    // initialize test cases
    initial begin
        in_s0_arr = '{2, 2, 2, 2};
        in_s1_arr = '{-1, -1, -1, -1};
        in_s2_arr = '{3, 3, 3, 3};
        in_s3_arr = '{5, 5, 5, 5};
        in_s4_arr = '{5, 5, 5, 5};
        in_s5_arr = '{4, 4, 4, 4};
        in_s6_arr = '{-3, -3, -3, -3};

        opt_arr = '{3'b001, 3'b011, 3'b101, 3'b111};

        a_arr = '{1, 1, 1, 1};
        b_arr = '{3, 3, 3, 3};

        out_arr = '{7, 7, 0, 0};

        s_id0_arr = '{6, 3, 6, 3};
        s_id1_arr = '{1, 4, 1, 4};
        s_id2_arr = '{0, 5, 0, 5};
        s_id3_arr = '{2, 2, 2, 2};
        s_id4_arr = '{5, 0, 5, 0};
        s_id5_arr = '{3, 1, 3, 1};
        s_id6_arr = '{4, 6, 4, 6};
    end

    int i;

    initial begin
        for (i = 0; i < `TEST_CASES; i++) begin
            // apply stimuli
            in_s0 = in_s0_arr[i];
            in_s1 = in_s1_arr[i];
            in_s2 = in_s2_arr[i];
            in_s3 = in_s3_arr[i];
            in_s4 = in_s4_arr[i];
            in_s5 = in_s5_arr[i];
            in_s6 = in_s6_arr[i];

            opt = opt_arr[i];

            a = a_arr[i];
            b = b_arr[i];

            #10 // check answer after a short delay

            if (out !== out_arr[i] || s_id0 !== s_id0_arr[i] || s_id1 !== s_id1_arr[i] || s_id2 !== s_id2_arr[i] || 
                s_id3 !== s_id3_arr[i] || s_id4 !== s_id4_arr[i] || s_id5 !== s_id5_arr[i] || s_id6 !== s_id6_arr[i]) begin

                $display("test case #%0d:", i);
                $display("Wrong answer!");

                $display("opt[0] = %b", opt_arr[i][0]);
                $display("opt[1] = %b", opt_arr[i][1]);

                if (out !== out[i]) $display("out = %d, golden = %d", out, out[i]);
                else $display("out = %d", out);

                if (s_id0 !== s_id0_arr[i]) $display("s_id0 = %d, golden = %d", s_id0, s_id0_arr[i]);
                else $display("s_id0 = %d", s_id0);

                if (s_id1 !== s_id1_arr[i]) $display("s_id1 = %d, golden = %d", s_id1, s_id1_arr[i]);
                else $display("s_id1 = %d", s_id1);

                if (s_id2 !== s_id2_arr[i]) $display("s_id2 = %d, golden = %d", s_id2, s_id2_arr[i]);
                else $display("s_id2 = %d", s_id2);

                if (s_id3 !== s_id3_arr[i]) $display("s_id3 = %d, golden = %d", s_id3, s_id3_arr[i]);
                else $display("s_id3 = %d", s_id3);

                if (s_id4 !== s_id4_arr[i]) $display("s_id4 = %d, golden = %d", s_id4, s_id4_arr[i]);
                else $display("s_id4 = %d", s_id4);

                if (s_id5 !== s_id5_arr[i]) $display("s_id5 = %d, golden = %d", s_id5, s_id5_arr[i]);
                else $display("s_id5 = %d", s_id5);

                if (s_id6 !== s_id6_arr[i]) $display("s_id6 = %d, golden = %d", s_id6, s_id6_arr[i]);
                else $display("s_id6 = %d", s_id6);

                #10 $finish;
            end
        end

        $display("All test cases passed!");
        #10 $finish;
    end
endmodule
