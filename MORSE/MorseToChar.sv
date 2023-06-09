`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Gus Flusser
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
    logic[4:0] morse = 5'b0;    //The morse code has at max 5 dots/dashes
    logic sendData = 0;         //Sends data to FSM driver

    assign lengthAnytime = length; //Debugging issues, kept this line to have multiple ways of displaying

    CLOCK_SYNC sendOnlyOne(.FAST(clk), .SLOW(sendData), .PULSE(send));   //'send' will go high for one cycle of clk, on the rising edge of sendData

    always_ff @(posedge recieve) begin
        valid <= 1;                         //If not invalid, it is valid.
        bits <= {3'b000, morse};            //If invalid character is entered, bits is 00000000 
        if(length == 8'b00000001) begin     //1 dot/dash
            case(morse)
                0: begin
                    bits <= 8'b01000101; // E
                end
                1: begin
                    bits <= 8'b01010100; // T
                end
                default: begin
                    bits <= 8'b0;
                    valid <= 0;
                end
            endcase
        end
        else if(length == 8'b00000010) begin //2 dot/dash
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
                    valid <= 0;
                end
            endcase
        end
        else if(length == 8'b00000011) begin //3 dot/dash
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
                    valid <= 0;
                end
            endcase
        end
        else if(length == 8'b00000100) begin  //4 dot/dash
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
                    valid <= 0;
                end
            endcase
        end
        else begin
            valid <= 0;
            bits <= 8'b0;
        end

        if(datain == 0) begin                   //recieved tend of char
            sendData <= ~(length == 0);         //only send data if length != 0 to prevent lcd from filling with error characters
            morse <= 0;                         //resets
            length <= 0;
            valid <= 0;
        end
        else begin
            sendData <= 0;
            length <= length + 1;              //not a space; increase morse length
            morse <= (morse << 1) + (datain - 1);  //shift register that pushes the new dot/dash in, (datain - 1) represents dot = 0, dash. Originally, morse would be all dots, but length is added because morse code has different lengths, leading zeros do not give the same value (dot dot dash dash =/= dash dash)
            valid <= 1;
        end
    end





endmodule