`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2025 01:36:37 AM
// Design Name: 
// Module Name: min_size_sorting_network
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: sorting network of N = 7 from https://bertdobbelaere.github.io/sorting_networks.html
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module min_size_sorting_network(
    input [4-1 : 0] in_s0, in_s1, in_s2, in_s3, in_s4, in_s5, in_s6,
    input [3-1 : 0] opt,

    output reg [3-1 : 0] s_id0, s_id1, s_id2, s_id3, s_id4, s_id5, s_id6
);
    // preprocess all inputs by adding an extra MSB to preserve signedness
    reg [5-1 : 0] in_s [7-1 : 0];

    // initial indices (constant IDs for each input)
    wire [3-1:0] id0 = 3'd0;
    wire [3-1:0] id1 = 3'd1;
    wire [3-1:0] id2 = 3'd2;
    wire [3-1:0] id3 = 3'd3;
    wire [3-1:0] id4 = 3'd4;
    wire [3-1:0] id5 = 3'd5;
    wire [3-1:0] id6 = 3'd6;

    // layer wires: each layer has 7 channels (0..6), data width 5 and index width 3
    // We'll name them layerN_D_i and layerN_I_i for data and idx respectively.
    // Layer 0 is the preprocessed inputs.
    wire [5-1:0] layer1_D_0, layer1_D_1, layer1_D_2, layer1_D_3, layer1_D_4, layer1_D_5, layer1_D_6;
    wire [3-1:0] layer1_I_0, layer1_I_1, layer1_I_2, layer1_I_3, layer1_I_4, layer1_I_5, layer1_I_6;

    wire [5-1:0] layer2_D_0, layer2_D_1, layer2_D_2, layer2_D_3, layer2_D_4, layer2_D_5, layer2_D_6;
    wire [3-1:0] layer2_I_0, layer2_I_1, layer2_I_2, layer2_I_3, layer2_I_4, layer2_I_5, layer2_I_6;

    wire [5-1:0] layer3_D_0, layer3_D_1, layer3_D_2, layer3_D_3, layer3_D_4, layer3_D_5, layer3_D_6;
    wire [3-1:0] layer3_I_0, layer3_I_1, layer3_I_2, layer3_I_3, layer3_I_4, layer3_I_5, layer3_I_6;

    wire [5-1:0] layer4_D_0, layer4_D_1, layer4_D_2, layer4_D_3, layer4_D_4, layer4_D_5, layer4_D_6;
    wire [3-1:0] layer4_I_0, layer4_I_1, layer4_I_2, layer4_I_3, layer4_I_4, layer4_I_5, layer4_I_6;

    wire [5-1:0] layer5_D_0, layer5_D_1, layer5_D_2, layer5_D_3, layer5_D_4, layer5_D_5, layer5_D_6;
    wire [3-1:0] layer5_I_0, layer5_I_1, layer5_I_2, layer5_I_3, layer5_I_4, layer5_I_5, layer5_I_6;

    wire [5-1:0] layer6_D_0, layer6_D_1, layer6_D_2, layer6_D_3, layer6_D_4, layer6_D_5, layer6_D_6;
    wire [3-1:0] layer6_I_0, layer6_I_1, layer6_I_2, layer6_I_3, layer6_I_4, layer6_I_5, layer6_I_6;

    // Layer 0 assignment (preprocessed inputs)
    always @* begin
        if (opt[0]) begin // signed
            in_s[0] = {in_s0[3], in_s0};
            in_s[1] = {in_s1[3], in_s1};
            in_s[2] = {in_s2[3], in_s2};
            in_s[3] = {in_s3[3], in_s3};
            in_s[4] = {in_s4[3], in_s4};
            in_s[5] = {in_s5[3], in_s5};
            in_s[6] = {in_s6[3], in_s6};
        end else begin // unsigned
            in_s[0] = {1'b0, in_s0};
            in_s[1] = {1'b0, in_s1};
            in_s[2] = {1'b0, in_s2};
            in_s[3] = {1'b0, in_s3};
            in_s[4] = {1'b0, in_s4};
            in_s[5] = {1'b0, in_s5};
            in_s[6] = {1'b0, in_s6};
        end
    end

    // ------------------ Layer 1: [(0,6),(2,3),(4,5)] ------------------
    compare_and_swap cs10(.a(in_s[0]), .b(in_s[6]), .idx_a(id0), .idx_b(id6), .opt1(opt[1]),
                          .A(layer1_D_0), .idx_A(layer1_I_0), .B(layer1_D_6), .idx_B(layer1_I_6));
    compare_and_swap cs11(.a(in_s[2]), .b(in_s[3]), .idx_a(id2), .idx_b(id3), .opt1(opt[1]),
                          .A(layer1_D_2), .idx_A(layer1_I_2), .B(layer1_D_3), .idx_B(layer1_I_3));
    compare_and_swap cs12(.a(in_s[4]), .b(in_s[5]), .idx_a(id4), .idx_b(id5), .opt1(opt[1]),
                          .A(layer1_D_4), .idx_A(layer1_I_4), .B(layer1_D_5), .idx_B(layer1_I_5));
    // pass-through channels that are not part of a comparator on this layer
    assign layer1_D_1 = in_s[1]; assign layer1_I_1 = id1;

    // ------------------ Layer 2: [(0,2),(1,4),(3,6)] ------------------
    compare_and_swap cs20(.a(layer1_D_0), .b(layer1_D_2), .idx_a(layer1_I_0), .idx_b(layer1_I_2), .opt1(opt[1]),
                          .A(layer2_D_0), .idx_A(layer2_I_0), .B(layer2_D_2), .idx_B(layer2_I_2));
    compare_and_swap cs21(.a(layer1_D_1), .b(layer1_D_4), .idx_a(layer1_I_1), .idx_b(layer1_I_4), .opt1(opt[1]),
                          .A(layer2_D_1), .idx_A(layer2_I_1), .B(layer2_D_4), .idx_B(layer2_I_4));
    compare_and_swap cs22(.a(layer1_D_3), .b(layer1_D_6), .idx_a(layer1_I_3), .idx_b(layer1_I_6), .opt1(opt[1]),
                          .A(layer2_D_3), .idx_A(layer2_I_3), .B(layer2_D_6), .idx_B(layer2_I_6));
    // pass-through
    assign layer2_D_5 = layer1_D_5; assign layer2_I_5 = layer1_I_5;

    // ------------------ Layer 3: [(0,1),(2,5),(3,4)] ------------------
    compare_and_swap cs30(.a(layer2_D_0), .b(layer2_D_1), .idx_a(layer2_I_0), .idx_b(layer2_I_1), .opt1(opt[1]),
                          .A(layer3_D_0), .idx_A(layer3_I_0), .B(layer3_D_1), .idx_B(layer3_I_1));
    compare_and_swap cs31(.a(layer2_D_2), .b(layer2_D_5), .idx_a(layer2_I_2), .idx_b(layer2_I_5), .opt1(opt[1]),
                          .A(layer3_D_2), .idx_A(layer3_I_2), .B(layer3_D_5), .idx_B(layer3_I_5));
    compare_and_swap cs32(.a(layer2_D_3), .b(layer2_D_4), .idx_a(layer2_I_3), .idx_b(layer2_I_4), .opt1(opt[1]),
                          .A(layer3_D_3), .idx_A(layer3_I_3), .B(layer3_D_4), .idx_B(layer3_I_4));
    // pass-through
    assign layer3_D_6 = layer2_D_6; assign layer3_I_6 = layer2_I_6;

    // ------------------ Layer 4: [(1,2),(4,6)] ------------------
    compare_and_swap cs40(.a(layer3_D_1), .b(layer3_D_2), .idx_a(layer3_I_1), .idx_b(layer3_I_2), .opt1(opt[1]),
                          .A(layer4_D_1), .idx_A(layer4_I_1), .B(layer4_D_2), .idx_B(layer4_I_2));
    compare_and_swap cs41(.a(layer3_D_4), .b(layer3_D_6), .idx_a(layer3_I_4), .idx_b(layer3_I_6), .opt1(opt[1]),
                          .A(layer4_D_4), .idx_A(layer4_I_4), .B(layer4_D_6), .idx_B(layer4_I_6));
    // pass-through
    assign layer4_D_0 = layer3_D_0; assign layer4_I_0 = layer3_I_0;
    assign layer4_D_3 = layer3_D_3; assign layer4_I_3 = layer3_I_3;
    assign layer4_D_5 = layer3_D_5; assign layer4_I_5 = layer3_I_5;

    // ------------------ Layer 5: [(2,3),(4,5)] ------------------
    compare_and_swap cs50(.a(layer4_D_2), .b(layer4_D_3), .idx_a(layer4_I_2), .idx_b(layer4_I_3), .opt1(opt[1]),
                          .A(layer5_D_2), .idx_A(layer5_I_2), .B(layer5_D_3), .idx_B(layer5_I_3));
    compare_and_swap cs51(.a(layer4_D_4), .b(layer4_D_5), .idx_a(layer4_I_4), .idx_b(layer4_I_5), .opt1(opt[1]),
                          .A(layer5_D_4), .idx_A(layer5_I_4), .B(layer5_D_5), .idx_B(layer5_I_5));
    // pass-through
    assign layer5_D_0 = layer4_D_0; assign layer5_I_0 = layer4_I_0;
    assign layer5_D_1 = layer4_D_1; assign layer5_I_1 = layer4_I_1;
    assign layer5_D_6 = layer4_D_6; assign layer5_I_6 = layer4_I_6;

    // ------------------ Layer 6: [(1,2),(3,4),(5,6)] ------------------
    compare_and_swap cs60(.a(layer5_D_1), .b(layer5_D_2), .idx_a(layer5_I_1), .idx_b(layer5_I_2), .opt1(opt[1]),
                          .A(layer6_D_1), .idx_A(layer6_I_1), .B(layer6_D_2), .idx_B(layer6_I_2));
    compare_and_swap cs61(.a(layer5_D_3), .b(layer5_D_4), .idx_a(layer5_I_3), .idx_b(layer5_I_4), .opt1(opt[1]),
                          .A(layer6_D_3), .idx_A(layer6_I_3), .B(layer6_D_4), .idx_B(layer6_I_4));
    compare_and_swap cs62(.a(layer5_D_5), .b(layer5_D_6), .idx_a(layer5_I_5), .idx_b(layer5_I_6), .opt1(opt[1]),
                          .A(layer6_D_5), .idx_A(layer6_I_5), .B(layer6_D_6), .idx_B(layer6_I_6));
    // pass-through
    assign layer6_D_0 = layer5_D_0; assign layer6_I_0 = layer5_I_0;

    // Final outputs (IDs of sorted channels)
    always @* begin
        s_id0 = layer6_I_0;
        s_id1 = layer6_I_1;
        s_id2 = layer6_I_2;
        s_id3 = layer6_I_3;
        s_id4 = layer6_I_4;
        s_id5 = layer6_I_5;
        s_id6 = layer6_I_6;
    end
endmodule
