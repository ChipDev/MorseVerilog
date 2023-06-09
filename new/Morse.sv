`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2023 02:44:49 AM
// Design Name: 
// Module Name: Morse
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


module Morse(
    input CLK,
    input EN,
    input SW,
    input BTN,
    output RS,
    output E,
    output [7:0] DB,
    output logic BLINK_LED,
    output logic [3:0] holdLights,
    output invalid,
    output WRITE_LED,
    output WAIT_LED,
    output logic [7:0] DB_LEDS
    );


    logic parserSend;
    logic [1:0] parserDataOut;
    logic validChar;
    logic charSend;
    logic [7:0] charBits;
    logic [1:0] LED_LENGTH;
    logic [7:0] morseLen;
    logic [3:0] state;
    assign invalid = ~validChar && EN;

    assign DB_LEDS = charBits;

    always_comb begin
        if(LED_LENGTH == 2'b00) begin
            holdLights = 4'b0000;
        end
        else if(LED_LENGTH == 2'b10) begin
            holdLights = 4'b1100;
        end
        else begin
            holdLights = 4'b1111;
        end
    end

    morse_parser MorseParser(.BTN_IN(BTN), .CLK(CLK), .EN(EN), .SEND(parserSend), .BLINK_LED(BLINK_LED), .DATA_OUT(parserDataOut), .SEND_LENGTH_LED(LED_LENGTH));
    MorseToChar MorseToChar(.clk(CLK), .recieve(parserSend), .datain(parserDataOut), .valid(validChar), .send(charSend), .bits(charBits), .lengthAnytime(morseLen));

    lcd_driver_fsm driver(.CLK(CLK), .EN(EN), .CHAR(charBits), .WRITE(charSend), .RS(RS), .E(E), .D(DB), .WAITING(WAIT_LED), .WRITING(WRITE_LED), .SWITCH(SW));




endmodule
