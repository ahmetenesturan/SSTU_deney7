`timescale 1ns / 1ps
module MULTS_tb;

reg [7:0] a,b;
wire [15:0] c;

MULTS m0(a,b,c);

initial begin
    a = 8'd30;
    b = 8'd10;
    #10;
    a = 8'd40;
    b = 8'd15;
    #10;
    $finish;
end

endmodule

module MULTS_signed_tb;

    reg signed [7:0] a,b;
    wire signed [15:0] c;

    MULTS_signed m0(a,b,c);

    initial begin
        a = 8'b10001000; //-120
        b = 8'b00001010; //10
        #10;
        a = 8'b11011000; //-40
        b = 8'b11100010; //-30
        #10;
        $finish;
    end

endmodule


module MULTB_tb;

reg signed [7:0] a,b;
wire signed [15:0] c;

MULTB m0(a,b,c);

initial begin
    a = 8'b10001000; //-120
    b = 8'b00001010; //10
    #10;
    a = 8'b11011000; //-40
    b = 8'b11100010; //-30
    #10;
    $finish;
end


endmodule


module MAC_tb;

/*
dataset:

0 4 0
1 9 0
0 8 6

weight:

-1 -1 -1
-1  8 -1
-1 -1 -1

*/

    reg clk, reset;
    reg [23:0] data;
    reg [23:0] weight;
    wire [19:0] result;

    MAC mac_inst(clk, reset, data, weight, result);

    initial begin
        clk = 0;
        reset = 1;
        #5;
        data = 24'h00_04_00;
        weight = 24'b11111111_11111111_11111111;
        reset = 0;
        #5;
        clk = 1;
        #5;
        clk = 0;
        data = 24'h01_09_00;
        weight = 24'b11111111_00001000_11111111;
        #5;
        clk = 1;
        #5;
        clk = 0;
        data = 24'h00_08_06;
        weight = 24'b11111111_11111111_11111111;
        #5;
        clk = 1;
        #5;
        clk = 0;
        $finish;
    end

endmodule

module conv_tb;


    reg [7:0] image [4:0][4:0];
    reg [7:0] kernel [2:0][2:0];

    reg clk, reset;
    reg [23:0] data;
    reg [23:0] weight;
    wire [19:0] result;

    integer i, j, k;

    MAC mac_inst(clk, reset, data, weight, result);

    initial begin
        
        //init image and kernel
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                image[i][j] = 8'd128;
            end
        end

        for(i = 0; i < 3; i = i + 1) begin
            for(j = 0; j < 3; j = j + 1) begin
                kernel[i][j] = 8'b11111111;
            end
        end

        kernel[2][2] = 8'd8;

        //kernel sliding

        for(i = 0; i < 3; i = i + 1) begin
            for(j = 0; j < 3; j = j + 1) begin
                reset = 0;
                #5;
                reset = 1;
                #5;
                reset = 0;
                #5;
                for(k = 0; k < 3; k = k + 1) begin
                    data = {image[i][k+j], image[i+1][k+j], image[i+2][k+j]};
                    weight = {kernel[0][k], kernel[1][k], kernel[2][k]};
                    #10;
                    $write("%d\n", result);
                end
            end
        end



    end

    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end

endmodule