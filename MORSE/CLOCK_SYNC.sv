`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Gus Flusser
// 
// Create Date: 06/08/2023 01:24:55 PM
// Design Name: 
// Module Name: CLOCK_SYNC
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


module CLOCK_SYNC(
    input FAST,
    input SLOW,
    output PULSE
    );

    logic slowprev = 0;
    logic signal = 0; 
    assign PULSE = signal;

    always_ff @(posedge FAST) begin

        slowprev <= SLOW;
        signal <= 0;                        
        if(!slowprev && SLOW) begin         //this line checks if the previous state is low, and the current state is high, therefore meaning a rising edge has occured
            signal <= 1;                    //sends a 1 fast clk signal
        end
    end


endmodule
