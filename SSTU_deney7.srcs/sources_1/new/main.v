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

module MULTS_signed (input [7:0] a, input [7:0] x, output [15:0] result);

wire [7:0] PP [7:0];
wire [7:0] ppbw [7:0];
wire [15:0] PP_shifted [7:0];


genvar i;
generate
    for(i = 0; i < 8; i = i + 1) begin
    assign PP[i][7:0] = (a[i] * x);
    end
endgenerate
     
    
genvar j, k;
generate
        for(j = 0; j < 8; j = j + 1) begin
            for(k = 0; k < 8; k = k + 1) begin
                if(j != 7) begin
                    if(k != 7)
                        assign ppbw[j][k] = PP[j][k];
                    else
                        assign ppbw[j][k] = ~PP[j][k];
                    end

                    else begin
                    if(k == 7)
                        assign ppbw[j][k] = PP[j][k];
                    else
                        assign ppbw[j][k] = ~PP[j][k];
                    end
            end
         end
endgenerate
    
    
    
genvar l;
generate
    for(l = 0; l < 8; l = l + 1) begin
        assign PP_shifted[l][15:0] = ppbw[l] << l;
    end
endgenerate    
    

    wire [15:0] sum1, sum2, sum3, sum4, sum5, sum6, sum7;

    //first stage

    carry_look_ahead_16bit cla1(PP_shifted[0], PP_shifted[1], 1'b0, sum1);
    carry_look_ahead_16bit cla2(PP_shifted[2], PP_shifted[3], 1'b0, sum2);
    carry_look_ahead_16bit cla3(PP_shifted[4], PP_shifted[5], 1'b0, sum3);
    carry_look_ahead_16bit cla4(PP_shifted[6], PP_shifted[7], 1'b0, sum4);

    //second stage

    carry_look_ahead_16bit cla5(sum1, sum2, 1'b0, sum5);
    carry_look_ahead_16bit cla6(sum3, sum4, 1'b0, sum6);

    //third stage

    carry_look_ahead_16bit cla7(sum5, sum6, 1'b0, sum7);
    
    //fourth stage
    
    carry_look_ahead_16bit cla8(sum7, 16'h8100, 1'b0, result);

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
    reg [1:0] count;

    MULTB m0(data[7:0], weight[7:0], product0);
    MULTB m1(data[15:8], weight[15:8], product1);
    MULTB m2(data[23:16], weight[23:16], product2);

    ADDRB #(.c_size(20)) a0(product0, product1, sum0);
    ADDRB #(.b_size(20), .c_size(20)) a1(product2, sum0, sum1);

    always @(posedge clk or posedge reset)begin
        if(reset == 1) begin
            result <= 0;
            count <= 0;
        end
        else begin
            result <= result + sum1;
            count <= count + 1;
        end
        
    end


endmodule