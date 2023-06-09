`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Bridget Benson 
// Create Date: 10/26/2018 12:57:18 PM
// Description: 8 bit acculumator.  Adds new value to the
// current value when LD is 1.  
//////////////////////////////////////////////////////////////////////////////////


module Accumulator(
    input clk, LD, CLR,
    input [7:0] D,
    output logic [7:0] Q
    );
    
    logic [7:0] DOUT = 8'b0;

    assign Q = DOUT;

    always_ff @ (posedge clk)
    begin
        if (CLR)
            DOUT <= 0;
        else if (LD)
            DOUT = D + DOUT;
    end
endmodule
