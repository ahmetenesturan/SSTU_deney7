`timescale 1ns / 1ps


module MULTS (input [7:0] A, input [7:0] X, output [15:0] result);

    wire [15:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7;

    pp_gen pp(A, X, pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7);
    

    //stages

    wire [15:0] sum1, sum2, sum3, sum4, sum5, sum6;

    //first stage

    carry_look_ahead_16bit cla1(pp0, pp1, 1'b0, sum1);
    carry_look_ahead_16bit cla2(pp2, pp3, 1'b0, sum2);
    carry_look_ahead_16bit cla3(pp4, pp5, 1'b0, sum3);
    carry_look_ahead_16bit cla4(pp6, pp7, 1'b0, sum4);

    //second stage

    carry_look_ahead_16bit cla5(sum1, sum2, 1'b0, sum5);
    carry_look_ahead_16bit cla6(sum3, sum4, 1'b0, sum6);

    //third stage

    carry_look_ahead_16bit cla7(sum5, sum6, 1'b0, result);

endmodule

module MULTS_signed (input [7:0] A, input [7:0] X, output [15:0] result);

    wire [7:0] PP [7:0];
    wire [7:0] PP_BW [7:0];

    genvar i;
    generate
        for(i = 0; i <= 7; i = i + 1) begin: PP_LOOP
            assign PP[i][7:0] = (X[i] * A);
        end
    endgenerate
    genvar z, t;
    generate
    for(z = 0; z <= 7; z = z + 1) begin: PP_BW_LOOP
        for(t = 0; t <= 7; t = t + 1) begin
            if(z != 7) begin
                if(t != 7)
                    assign PP_BW[z][t] = PP[z][t];
                else
                    assign PP_BW[z][t] = ~PP[z][t];
                end
            else begin
                if(t == 7)
                    assign PP_BW[z][t] = PP[z][t];
                else
                    assign PP_BW[z][t] = ~PP[z][t];
            end
        end
    end
    endgenerate


    wire [15:0] PP_shifted [7:0];

    genvar u;

    generate
        for(u = 0; u <= 7; u = u + 1) begin
            assign PP_shifted[u][15:0] = PP_BW[u] << u;
        end
    endgenerate

    //stages

    wire [15:0] sum1, sum2, sum3, sum4, sum5, sum6;

    //first stage

    carry_look_ahead_16bit cla1(PP_shifted[0], PP_shifted[1], 1'b0, sum1);
    carry_look_ahead_16bit cla2(PP_shifted[2], PP_shifted[3], 1'b0, sum2);
    carry_look_ahead_16bit cla3(PP_shifted[4], PP_shifted[5], 1'b0, sum3);
    carry_look_ahead_16bit cla4(PP_shifted[6], PP_shifted[7], 1'b0, sum4);

    //second stage

    carry_look_ahead_16bit cla5(sum1, sum2, 1'b0, sum5);
    carry_look_ahead_16bit cla6(sum3, sum4, 1'b0, sum6);

    //third stage

    carry_look_ahead_16bit cla7(sum5, sum6, 1'b0, result);



endmodule

module MULTB (input signed [7:0] A, input signed [7:0] X, output reg signed [15:0] result);

    always @(A or X) begin
        result <= A * X;
    end

endmodule

module ADDRB #(parameter a_size = 16, parameter  b_size = 16, parameter c_size = 16) (input  signed [(a_size-1):0] A, input signed [(b_size-1):0] B, output reg signed [(c_size-1):0] result);

    always @(A or B) begin
        result <= A + B;
    end

endmodule

module MAC (input clk, reset, input [23:0] data, input [23:0] weight, output reg [19:0] result);

    wire signed [15:0] product0, product1, product2;
    wire signed [19:0] sum0, sum1;

    MULTB m0(data[7:0], weight[7:0], product0);
    MULTB m1(data[15:8], weight[15:8], product1);
    MULTB m2(data[23:16], weight[23:16], product2);

    ADDRB #(.c_size(20)) a0(product0, product1, sum0);
    ADDRB #(.b_size(20), .c_size(20)) a1(product2, sum0, sum1);

    always @(posedge clk)begin
        result <= result + sum1;
    end


endmodule