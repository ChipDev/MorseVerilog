`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Blake Stewart
// 
// Create Date: 06/08/2023 01:51:35 AM
// Design Name: 
// Module Name: morse_parser
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


module morse_parser(
    input BTN_IN,
    input CLK,
    input EN,
    output logic SEND,
    output BLINK_LED,
    output logic [1:0] SEND_LENGTH_LED,
    output logic [1:0] DATA_OUT
    );

    logic SCLK;                     //SlOW CLOCK
    assign CHECK = SCLK && EN;      //Only check when EN is high
    logic CLEAR = 0;
    logic [7:0] numberOfOnes;
    logic [7:0] numberOfZeroes;
    logic [7:0] length;             //Total length of dots and dashes
    assign BLINK_LED = CHECK;       //Blinks, Low-> high is when checked

    clk_div2 slowed_clock(.clk(CLK), .sclk(SCLK));      

    Accumulator zeroes(.clk(CHECK), .LD(EN), .CLR(CLEAR), .D({7'b0, ~BTN_IN}), .Q(numberOfZeroes)); //Accumulators, only one gets added to depending on BTN
    Accumulator ones(.clk(CHECK), .LD(EN), .CLR(CLEAR), .D({7'b0, BTN_IN}), .Q(numberOfOnes));
    
    // Takes in BTN, with multiple cycles, and then sends a SPACE (00), DOT (01), or DASH (10) to the MorseToChar module.

    always_comb begin
        
        length = numberOfOnes + numberOfZeroes;

        if(numberOfOnes == 2'b00) begin
            SEND_LENGTH_LED = 2'b00;
        end
        else if(numberOfOnes == 2'b01) begin
            SEND_LENGTH_LED = 2'b10;
        end
        else begin
            SEND_LENGTH_LED = 2'b11;            //Progress bar LEDS
        end

        if(numberOfOnes == 0) begin             //DATA_OUT IS A SPACE / END
            DATA_OUT = 2'b00;
        end
        else if(numberOfOnes == 1) begin        //DATA_OUT IS A DOT
            DATA_OUT = 2'b01;
        end
        else begin
            DATA_OUT = 2'b10;                   //DATA_OUT IS A DASH
        end
    end

    always_ff @(posedge SCLK) begin
        SEND <= 0;
        CLEAR <= 0;

        if(numberOfOnes > 0 && !BTN_IN && SEND == 0) begin  //If there has been entered 1 or more ONES, and now BTN is a zero, and it is not currently sending, SEND.
            SEND <= 1;
            CLEAR <= 1;
        end
        else if(numberOfZeroes > 2 && SEND == 0) begin      //If there has been 3 or more zeroes in a row, send. (Will send a SPACE)
            SEND <= 1;
            CLEAR <= 1;
        end

    end

    


endmodule