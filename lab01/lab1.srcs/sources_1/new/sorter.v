`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2025 11:57:24 PM
// Design Name: 
// Module Name: sorter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: bubble sorter, with 2 separate datapaths, one signed, another unsigned
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sorter(
    input [4-1 : 0] in_s0, in_s1, in_s2, in_s3, in_s4, in_s5, in_s6,
    input [3-1 : 0] opt,

    output reg [3-1 : 0] s_id0, s_id1, s_id2, s_id3, s_id4, s_id5, s_id6
);
    // pairwise comparison
    wire _0vs1 = (opt[0])?
        ((opt[1])? ($signed(in_s0) < $signed(in_s1)) : ($signed(in_s0) > $signed(in_s1))) :
        ((opt[1])? (in_s0 < in_s1) : (in_s0 > in_s1));
    wire _0vs2 = (opt[0])?
        ((opt[1])? ($signed(in_s0) < $signed(in_s2)) : ($signed(in_s0) > $signed(in_s2))) :
        ((opt[1])? (in_s0 < in_s2) : (in_s0 > in_s2));
    wire _0vs3 = (opt[0])?
        ((opt[1])? ($signed(in_s0) < $signed(in_s3)) : ($signed(in_s0) > $signed(in_s3))) :
        ((opt[1])? (in_s0 < in_s3) : (in_s0 > in_s3));
    wire _0vs4 = (opt[0])?
        ((opt[1])? ($signed(in_s0) < $signed(in_s4)) : ($signed(in_s0) > $signed(in_s4))) :
        ((opt[1])? (in_s0 < in_s4) : (in_s0 > in_s4));
    wire _0vs5 = (opt[0])?
        ((opt[1])? ($signed(in_s0) < $signed(in_s5)) : ($signed(in_s0) > $signed(in_s5))) :
        ((opt[1])? (in_s0 < in_s5) : (in_s0 > in_s5));
    wire _0vs6 = (opt[0])?
        ((opt[1])? ($signed(in_s0) < $signed(in_s6)) : ($signed(in_s0) > $signed(in_s6))) :
        ((opt[1])? (in_s0 < in_s6) : (in_s0 > in_s6));


    wire _1vs2 = (opt[0])?
        ((opt[1])? ($signed(in_s1) < $signed(in_s2)) : ($signed(in_s1) > $signed(in_s2))) :
        ((opt[1])? (in_s1 < in_s2) : (in_s1 > in_s2));
    wire _1vs3 = (opt[0])?
        ((opt[1])? ($signed(in_s1) < $signed(in_s3)) : ($signed(in_s1) > $signed(in_s3))) :
        ((opt[1])? (in_s1 < in_s3) : (in_s1 > in_s3));
    wire _1vs4 = (opt[0])?
        ((opt[1])? ($signed(in_s1) < $signed(in_s4)) : ($signed(in_s1) > $signed(in_s4))) :
        ((opt[1])? (in_s1 < in_s4) : (in_s1 > in_s4));
    wire _1vs5 = (opt[0])?
        ((opt[1])? ($signed(in_s1) < $signed(in_s5)) : ($signed(in_s1) > $signed(in_s5))) :
        ((opt[1])? (in_s1 < in_s5) : (in_s1 > in_s5));
    wire _1vs6 = (opt[0])?
        ((opt[1])? ($signed(in_s1) < $signed(in_s6)) : ($signed(in_s1) > $signed(in_s6))) :
        ((opt[1])? (in_s1 < in_s6) : (in_s1 > in_s6));


    wire _2vs3 = (opt[0])?
        ((opt[1])? ($signed(in_s2) < $signed(in_s3)) : ($signed(in_s2) > $signed(in_s3))) :
        ((opt[1])? (in_s2 < in_s3) : (in_s2 > in_s3));
    wire _2vs4 = (opt[0])?
        ((opt[1])? ($signed(in_s2) < $signed(in_s4)) : ($signed(in_s2) > $signed(in_s4))) :
        ((opt[1])? (in_s2 < in_s4) : (in_s2 > in_s4));
    wire _2vs5 = (opt[0])?
        ((opt[1])? ($signed(in_s2) < $signed(in_s5)) : ($signed(in_s2) > $signed(in_s5))) :
        ((opt[1])? (in_s2 < in_s5) : (in_s2 > in_s5));
    wire _2vs6 = (opt[0])?
        ((opt[1])? ($signed(in_s2) < $signed(in_s6)) : ($signed(in_s2) > $signed(in_s6))) :
        ((opt[1])? (in_s2 < in_s6) : (in_s2 > in_s6));


    wire _3vs4 = (opt[0])?
        ((opt[1])? ($signed(in_s3) < $signed(in_s4)) : ($signed(in_s3) > $signed(in_s4))) :
        ((opt[1])? (in_s3 < in_s4) : (in_s3 > in_s4));
    wire _3vs5 = (opt[0])?
        ((opt[1])? ($signed(in_s3) < $signed(in_s5)) : ($signed(in_s3) > $signed(in_s5))) :
        ((opt[1])? (in_s3 < in_s5) : (in_s3 > in_s5));
    wire _3vs6 = (opt[0])?
        ((opt[1])? ($signed(in_s3) < $signed(in_s6)) : ($signed(in_s3) > $signed(in_s6))) :
        ((opt[1])? (in_s3 < in_s6) : (in_s3 > in_s6));


    wire _4vs5 = (opt[0])?
        ((opt[1])? ($signed(in_s4) < $signed(in_s5)) : ($signed(in_s4) > $signed(in_s5))) :
        ((opt[1])? (in_s4 < in_s5) : (in_s4 > in_s5));
    wire _4vs6 = (opt[0])?
        ((opt[1])? ($signed(in_s4) < $signed(in_s6)) : ($signed(in_s4) > $signed(in_s6))) :
        ((opt[1])? (in_s4 < in_s6) : (in_s4 > in_s6));


    wire _5vs6 = (opt[0])?
        ((opt[1])? ($signed(in_s5) < $signed(in_s6)) : ($signed(in_s5) > $signed(in_s6))) :
        ((opt[1])? (in_s5 < in_s6) : (in_s5 > in_s6));

    // ranking of each student
    wire [3-1 : 0] r0 = _0vs1 + _0vs2 + _0vs3 + _0vs4 + _0vs5 + _0vs6;
    wire [3-1 : 0] r1 = !_0vs1 + _1vs2 + _1vs3 + _1vs4 + _1vs5 + _1vs6;
    wire [3-1 : 0] r2 = !_0vs2 + !_1vs2 + _2vs3 + _2vs4 + _2vs5 + _2vs6;
    wire [3-1 : 0] r3 = !_0vs3 + !_1vs3 + !_2vs3 + _3vs4 + _3vs5 + _3vs6;
    wire [3-1 : 0] r4 = !_0vs4 + !_1vs4 + !_2vs4 + !_3vs4 + _4vs5 + _4vs6;
    wire [3-1 : 0] r5 = !_0vs5 + !_1vs5 + !_2vs5 + !_3vs5 + !_4vs5 + _5vs6;
    wire [3-1 : 0] r6 = !_0vs6 + !_1vs6 + !_2vs6 + !_3vs6 + !_4vs6 + !_5vs6;

    // s_id0
    always @* begin
        s_id0 = 0;

        if (r0 == 0) s_id0 = 0;
        else if (r1 == 0) s_id0 = 1;
        else if (r2 == 0) s_id0 = 2;
        else if (r3 == 0) s_id0 = 3;
        else if (r4 == 0) s_id0 = 4;
        else if (r5 == 0) s_id0 = 5;
        else if (r6 == 0) s_id0 = 6;
    end

    // s_id1
    always @* begin
        s_id1 = 0;

        if (r0 == 1) s_id1 = 0;
        else if (r1 == 1) s_id1 = 1;
        else if (r2 == 1) s_id1 = 2;
        else if (r3 == 1) s_id1 = 3;
        else if (r4 == 1) s_id1 = 4;
        else if (r5 == 1) s_id1 = 5;
        else if (r6 == 1) s_id1 = 6;
    end

    // s_id2
    always @* begin
        s_id2 = 0;

        if (r0 == 2) s_id2 = 0;
        else if (r1 == 2) s_id2 = 1;
        else if (r2 == 2) s_id2 = 2;
        else if (r3 == 2) s_id2 = 3;
        else if (r4 == 2) s_id2 = 4;
        else if (r5 == 2) s_id2 = 5;
        else if (r6 == 2) s_id2 = 6;
    end

    // s_id3
    always @* begin
        s_id3 = 0;

        if (r0 == 3) s_id3 = 0;
        else if (r1 == 3) s_id3 = 1;
        else if (r2 == 3) s_id3 = 2;
        else if (r3 == 3) s_id3 = 3;
        else if (r4 == 3) s_id3 = 4;
        else if (r5 == 3) s_id3 = 5;
        else if (r6 == 3) s_id3 = 6;
    end

    // s_id4
    always @* begin
        s_id4 = 0;

        if (r0 == 4) s_id4 = 0;
        else if (r1 == 4) s_id4 = 1;
        else if (r2 == 4) s_id4 = 2;
        else if (r3 == 4) s_id4 = 3;
        else if (r4 == 4) s_id4 = 4;
        else if (r5 == 4) s_id4 = 5;
        else if (r6 == 4) s_id4 = 6;
    end

    // s_id5
    always @* begin
        s_id5 = 0;

        if (r0 == 5) s_id5 = 0;
        else if (r1 == 5) s_id5 = 1;
        else if (r2 == 5) s_id5 = 2;
        else if (r3 == 5) s_id5 = 3;
        else if (r4 == 5) s_id5 = 4;
        else if (r5 == 5) s_id5 = 5;
        else if (r6 == 5) s_id5 = 6;
    end

    // s_id6
    always @* begin
        s_id6 = 0;

        if (r0 == 6) s_id6 = 0;
        else if (r1 == 6) s_id6 = 1;
        else if (r2 == 6) s_id6 = 2;
        else if (r3 == 6) s_id6 = 3;
        else if (r4 == 6) s_id6 = 4;
        else if (r5 == 6) s_id6 = 5;
        else if (r6 == 6) s_id6 = 6;
    end
endmodule
