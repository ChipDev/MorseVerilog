`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Blake Stewart
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
    output logic [7:0] DB_LEDS,
    output invalid
    );
 
    logic WRITE_LED; 
    logic WAIT_LED;   //Can be assigned to some outputs, but only for debugging purposes.

    logic parserSend;
    logic [1:0] parserDataOut;
    logic validChar;
    logic charSend;
    logic [7:0] charBits;
    logic [1:0] LED_LENGTH;
    logic [7:0] morseLen;
    logic [3:0] state;
    assign invalid = ~validChar && EN;  //If not valid and enabled. Displays on the board after a character is sent.

    assign DB_LEDS = charBits; //Allows for multiple things to be

    always_comb begin
        if(LED_LENGTH == 2'b00) begin
            holdLights = 4'b0000;                 //If LED LENGTH is 0, 4 progress leds are 0000
        end
        else if(LED_LENGTH == 2'b10) begin        //If LED LENGTH is 2, 4 progress leds are 1100
            holdLights = 4'b1100;
        end
        else begin
            holdLights = 4'b1111;                  //If LED LENGTH is 4+, 4 progress leds are 1111
        end
    end

    morse_parser MorseParser(.BTN_IN(BTN), .CLK(CLK), .EN(EN), .SEND(parserSend), .BLINK_LED(BLINK_LED), .DATA_OUT(parserDataOut), .SEND_LENGTH_LED(LED_LENGTH));
    MorseToChar MorseToChar(.clk(CLK), .recieve(parserSend), .datain(parserDataOut), .valid(validChar), .send(charSend), .bits(charBits), .lengthAnytime(morseLen));

    lcd_driver_fsm driver(.CLK(CLK), .EN(EN), .CHAR(charBits), .WRITE(charSend), .RS(RS), .E(E), .D(DB), .WAITING(WAIT_LED), .WRITING(WRITE_LED), .SWITCH(SW));
    //Module logic links




endmodule