`timescale 1ns / 1ps

module pp_gen(input [7:0] a, b, output [15:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7);

    wire [15:0] pp0_i, pp1_i, pp2_i, pp3_i, pp4_i, pp5_i, pp6_i, pp7_i;

    genvar i;

    generate for(i = 0; i < 8; i = i + 1) begin
        assign pp0_i[i] = b[0] & a[i];
    end
    endgenerate

    generate for(i = 0; i < 8; i = i + 1) begin
        assign pp1_i[i] = b[1] & a[i];
    end
    endgenerate

    generate for(i = 0; i < 8; i = i + 1) begin
        assign pp2_i[i] = b[2] & a[i];
    end
    endgenerate

    generate for(i = 0; i < 8; i = i + 1) begin
        assign pp3_i[i] = b[3] & a[i];
    end
    endgenerate

    generate for(i = 0; i < 8; i = i + 1) begin
        assign pp4_i[i] = b[4] & a[i];
    end
    endgenerate

    generate for(i = 0; i < 8; i = i + 1) begin
        assign pp5_i[i] = b[5] & a[i];
    end
    endgenerate

    generate for(i = 0; i < 8; i = i + 1) begin
        assign pp6_i[i] = b[6] & a[i];
    end
    endgenerate

    generate for(i = 0; i < 8; i = i + 1) begin
        assign pp7_i[i] = b[7] & a[i];
    end
    endgenerate

    assign pp0_i[15:8] = 8'b0;
    assign pp1_i[15:8] = 8'b0;
    assign pp2_i[15:8] = 8'b0;
    assign pp3_i[15:8] = 8'b0;
    assign pp4_i[15:8] = 8'b0;
    assign pp5_i[15:8] = 8'b0;
    assign pp6_i[15:8] = 8'b0;
    assign pp7_i[15:8] = 8'b0;

    assign pp0 = pp0_i;
    assign pp1 = pp1_i << 1;
    assign pp2 = pp2_i << 2;
    assign pp3 = pp3_i << 3;
    assign pp4 = pp4_i << 4;
    assign pp5 = pp5_i << 5;
    assign pp6 = pp6_i << 6;
    assign pp7 = pp7_i << 7;

endmodule
/*

module baugh_wooley_gen(input [7:0] a, b, output [7:0] PP_BW [7:0]);

    wire [7:0] PP [7:0];
    genvar i;
    generate
        for(i = 0; i <= 7; i = i + 1) begin: PP_LOOP
            assign PP[i][7:0] = (x[i] * a);
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


endmodule
*/