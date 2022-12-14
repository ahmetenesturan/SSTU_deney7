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

reg [23:0] data;

initial begin
    data = 24'd40190086;
end

endmodule