`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2025 10:27:44 PM
// Design Name: 
// Module Name: CC
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


module CC(
    input [4-1 : 0] in_s0, in_s1, in_s2, in_s3, in_s4, in_s5, in_s6,
    input [3-1 : 0] opt,
    input signed [2-1 : 0] a,
    input signed [3-1 : 0] b,

    output [3-1 : 0] out,
    output [3-1 : 0] s_id0, s_id1, s_id2, s_id3, s_id4, s_id5, s_id6
);
    // 2. sort

    sorter u1 (
        .in_s0(in_s0), .in_s1(in_s1), .in_s2(in_s2), .in_s3(in_s3), .in_s4(in_s4), .in_s5(in_s5), .in_s6(in_s6),
        .opt(opt),
        .s_id0(s_id0), .s_id1(s_id1), .s_id2(s_id2), .s_id3(s_id3), .s_id4(s_id4), .s_id5(s_id5), .s_id6(s_id6)
    );

    // min_size_sorting_network u1 (
    //     .in_s0(in_s0), .in_s1(in_s1), .in_s2(in_s2), .in_s3(in_s3), .in_s4(in_s4), .in_s5(in_s5), .in_s6(in_s6),
    //     .opt(opt),
    //     .s_id0(s_id0), .s_id1(s_id1), .s_id2(s_id2), .s_id3(s_id3), .s_id4(s_id4), .s_id5(s_id5), .s_id6(s_id6)
    // );



    // 3. calculate passing score

    // 3.1. UNSIGNED path

    // // 3.1.1. this would be alright as synthesis tool will most certainly optimize this out as
    // // the denominator is a plain constant
    // wire [8-1 : 0] unsigned_avg = (in_s0 + in_s1 + in_s2 + in_s3 + in_s4 + in_s5 + in_s6) / 7;

    // // 3.1.2. let me optimize this unsigned divison by hand using a pair of "magic numbers"
    wire [6:0] usum = in_s0 + in_s1 + in_s2 + in_s3 + in_s4 + in_s5 + in_s6;

    // x / 7 == (x * 147) >> 10 for x in 0..105
    wire [13:0] umul147 = (usum << 7) + (usum << 4) + (usum << 1) + usum;
    wire [7:0]  unsigned_avg = umul147 >> 10;

    // 3.2. SIGNED path
    wire signed [8-1 : 0] signed_avg = ($signed(in_s0) + $signed(in_s1) + $signed(in_s2) + $signed(in_s3) + $signed(in_s4) + $signed(in_s5) + $signed(in_s6)) / 7;

    // wire signed [6:0] s0 = in_s0;
    // wire signed [6:0] s1 = in_s1;
    // wire signed [6:0] s2 = in_s2;
    // wire signed [6:0] s3 = in_s3;
    // wire signed [6:0] s4 = in_s4;
    // wire signed [6:0] s5 = in_s5;
    // wire signed [6:0] s6 = in_s6;

    // wire signed [6:0] ssum = s0 + s1 + s2 + s3 + s4 + s5 + s6;
    // wire signed [7:0] signed_avg = ssum / 7'sd7;

    // 3.3. choose between SIGNED and UNSIGNED paths
    wire [8-1 : 0] avg = (opt[0])? signed_avg : unsigned_avg;

    wire signed_passing_score = $signed(avg) - a;
    wire unsigned_passing_score = avg - a;
    wire [4-1 : 0] passing_score = (opt[0])? signed_passing_score : unsigned_passing_score;



    // 4. linear transformation
    wire [4-1 : 0] lt_s0 = lt(in_s0, a, b, opt);
    wire [4-1 : 0] lt_s1 = lt(in_s1, a, b, opt);
    wire [4-1 : 0] lt_s2 = lt(in_s2, a, b, opt);
    wire [4-1 : 0] lt_s3 = lt(in_s3, a, b, opt);
    wire [4-1 : 0] lt_s4 = lt(in_s4, a, b, opt);
    wire [4-1 : 0] lt_s5 = lt(in_s5, a, b, opt);
    wire [4-1 : 0] lt_s6 = lt(in_s6, a, b, opt);



    // 5. count
    wire [3-1 : 0] passed_students = 
        (lt_s0 >= passing_score) +
        (lt_s1 >= passing_score) +
        (lt_s2 >= passing_score) +
        (lt_s3 >= passing_score) +
        (lt_s4 >= passing_score) +
        (lt_s5 >= passing_score) +
        (lt_s6 >= passing_score);

    assign out = (opt[2])?
        (7 - passed_students) : // failed students
        (passed_students); // passed students



    // linear transformation
    function automatic [4-1 : 0] lt (
        input [4-1 : 0] score,
        input [2-1 : 0] a,
        input [3-1 : 0] b,
        input [3-1 : 0] opt
    );
        begin
            if (opt[0] && score[3]) begin // score < 0
                lt = $signed(score) / ($signed(a)+1) + $signed(b);
            end else if (opt[0]) begin
                lt = $signed(score) * ($signed(a)+1) + $signed(b);
            end else begin
                lt = score * (a+1) + b;
            end
        end
    endfunction
endmodule
