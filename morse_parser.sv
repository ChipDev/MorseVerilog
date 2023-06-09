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

    logic SCLK;
    assign CHECK = SCLK && EN;
    logic CLEAR = 0;
    logic [7:0] numberOfOnes;
    logic [7:0] numberOfZeroes;
    logic [7:0] length;
    assign BLINK_LED = CHECK;

    clk_div2 slowed_clock(.clk(CLK), .sclk(SCLK));

    Accumulator zeroes(.clk(CHECK), .LD(EN), .CLR(CLEAR), .D({7'b0, ~BTN_IN}), .Q(numberOfZeroes));
    Accumulator ones(.clk(CHECK), .LD(EN), .CLR(CLEAR), .D({7'b0, BTN_IN}), .Q(numberOfOnes));
    

    always_comb begin
        
        length = numberOfOnes + numberOfZeroes;

        if(numberOfOnes == 2'b00) begin
            SEND_LENGTH_LED = 2'b00;
        end
        else if(numberOfOnes == 2'b01) begin
            SEND_LENGTH_LED = 2'b10;
        end
        else begin
            SEND_LENGTH_LED = 2'b11;
        end

        if(numberOfOnes == 0) begin
            DATA_OUT = 2'b00;
        end
        else if(numberOfOnes == 1) begin
            DATA_OUT = 2'b01;
        end
        else begin
            DATA_OUT = 2'b10;
        end
    end

    always_ff @(posedge SCLK) begin
        SEND <= 0;
        CLEAR <= 0;

        if(numberOfOnes > 0 && !BTN_IN && SEND == 0) begin
            SEND <= 1;
            CLEAR <= 1;
        end
        else if(numberOfZeroes > 2 && SEND == 0) begin
            SEND <= 1;
            CLEAR <= 1;
        end

    end

    


endmodule