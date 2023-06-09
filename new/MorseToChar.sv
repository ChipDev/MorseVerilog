`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/08/2023 12:50:36 PM
// Design Name: 
// Module Name: MorseToChar
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


module MorseToChar(
    input clk,
    input recieve,
    input [1:0] datain,
    output logic valid,
    output send,
    output logic [7:0] bits,
    output [7:0] lengthAnytime
    );

    logic[7:0] length = 8'b0;
    logic[4:0] morse = 5'b0; 
    logic sendData = 0;

    assign lengthAnytime = length;

    CLOCK_SYNC sendOnlyOne(.FAST(clk), .SLOW(sendData), .PULSE(send));

    always_ff @(posedge recieve) begin

        bits <= {3'b111, morse};
        if(length == 8'b00000001) begin
            case(morse)
                0: begin
                    bits <= 8'b01000101; // E
                end
                1: begin
                    bits <= 8'b01010100; // T
                end
                default: begin
                    bits <= 8'b0;
                end
            endcase
        end
        else if(length == 8'b00000010) begin
            case(morse)
                2'b00: begin
                    bits <= 8'b01001001; // I
                end
                2'b01: begin
                    bits <= 8'b01000001; // A
                end
                2'b10: begin
                    bits <= 8'b01001110; // N
                end
                2'b11: begin
                    bits <= 8'b01001101; // M
                end
                default: begin
                    bits <= 8'b0;
                end
            endcase
        end
        else if(length == 8'b00000011) begin
            case(morse)
                3'b000: begin
                    bits <= 8'b01010011; // S
                end
                3'b001: begin
                    bits <= 8'b01010101; // U
                end
                3'b010: begin
                    bits <= 8'b01010010; // R
                end
                3'b011: begin
                    bits <= 8'b01010111; // W
                end
                3'b100: begin
                    bits <= 8'b01000100; // D
                end
                3'b101: begin
                    bits <= 8'b01001011; // K
                end
                3'b110: begin
                    bits <= 8'b01000111; // G
                end
                3'b111: begin
                    bits <= 8'b01001111; // O
                end

                default: begin
                    bits <= 8'b0;
                end
            endcase
        end
        else if(length == 8'b00000100) begin
            case(morse)
                4'b0000: begin
                    bits <= 8'b01001000; // H
                end
                4'b0001: begin
                    bits <= 8'b01010110; // V
                end
                4'b0010: begin
                    bits <= 8'b01000110; // F
                end
               
                4'b0100: begin
                    bits <= 8'b01001100; // L
                end

                4'b0110: begin
                    bits <= 8'b01010000; // P
                end
                4'b0111: begin
                    bits <= 8'b01001010; // J
                end
                4'b1000: begin
                    bits <= 8'b01000010; // B
                end
                4'b1001: begin
                    bits <= 8'b01011000; // X
                end
                4'b1010: begin
                    bits <= 8'b01000011; // C
                end
                4'b1011: begin
                    bits <= 8'b01011001; // Y
                end
                4'b1100: begin
                    bits <= 8'b01011010; // Z 
                end
                4'b1101: begin
                    bits <= 8'b01010001; // Q
                end

                default: begin
                    bits <= 8'b0;
                end
            endcase
        end

        if(datain == 0) begin
            sendData <= 1;
            morse <= 0;
            length <= 0;
            valid <= 0;
        end
        else begin
            sendData <= 0;
            length <= length + 1;
            morse <= (morse << 1) + (datain - 1);
            valid <= 1;
        end
    end





endmodule
