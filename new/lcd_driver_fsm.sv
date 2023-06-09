`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2023 04:53:07 PM
// Design Name: 
// Module Name: lcd_driver_fsm
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


module lcd_driver_fsm(
    input CLK,
    input EN,
    input [7:0] CHAR,
    input WRITE,
    input SWITCH,
    output logic RS,
    output logic E,
    output logic [7:0] D,
    output logic WRITING,
    output logic WAITING
    );

    logic[13:0] counter = 0;
    logic counter_enable = 0;

    typedef enum { OFF, SETUP_0, WRITE_PULSE_WAIT, WRITE_P, DATA_WAIT, DATA_WRITE, SHUTDOWN} STATES;
    STATES PS, NS;
    STATES NEXT_COMMAND;

    always_ff @(posedge CLK) begin
        PS <= NS;
    end

    always_ff @(posedge CLK) begin
        if(!counter_enable) counter <= 0;
        else if(counter == 13'b1111111111111) counter <= 13'b0;
        else counter <= counter+1;
    end

    //assign STATE = {NEXT_COMMAND==DATA_WAIT, PS==WRITE_PULSE_WAIT, PS==DATA_WAIT};

    always_comb begin
        WRITING = 0;
        WAITING = 0;
        D = 8'b00000000;
        NEXT_COMMAND = DATA_WAIT;
        case(PS) 
            OFF: begin
                RS = 0;
                E = 0;
                D = 8'b00000000;
                counter_enable = 0;

                if(EN) begin 
                    NS = SETUP_0;
                end
                else begin
                    NS = OFF;
                end

            end

            WRITE_PULSE_WAIT: begin
                WAITING = 0;
                D = 8'b00000000;
                RS = 0;
                counter_enable = 1;
                E = 0;
                WAITING = 0;
                if(counter == 13'b1111111111111) begin
                    //NS = NEXT_COMMAND;
                    NS = DATA_WAIT;
                    E = 0;
                end
                else begin
                    NS = WRITE_PULSE_WAIT;
                    E = 0;
                end

            end

            SETUP_0: begin
                WRITING = 0;
                counter_enable = 1;
                NS = SETUP_0;
                RS = 0;
                D = 8'b00001101;
                NEXT_COMMAND = DATA_WAIT;
                if(counter == 13'b1111111111111) begin
                    NS = WRITE_PULSE_WAIT;
                    E = 0;
                end
                else if(counter > 2500) begin
                    E = 0;
                end
                else if(counter > 500) begin
                    E = 1;
                end
                else begin
                    E = 0;
                end
            end

            DATA_WAIT: begin
                E = 0;
                WAITING = 1;
                counter_enable = 0;
                NS = DATA_WAIT;
                RS = 0;
                D = 8'b00000000; 
                if(WRITE == 1) begin
                    NS = DATA_WRITE;
                end
                else begin
                    NS = DATA_WAIT;
                end
            end

            DATA_WRITE: begin
                WRITING = 1;
                counter_enable = 1;
                NS = DATA_WRITE;
                RS = 1;
                D = CHAR;
                NEXT_COMMAND = DATA_WAIT;
                if(counter == 13'b1111111111111) begin
                    NS = WRITE_PULSE_WAIT;
                    E = 0;
                end
                else if(counter > 2500) begin
                    E = 0;
                end
                else if(counter > 500) begin
                    E = 1;
                end
                else begin
                    E = 0;
                end
            end

            // WRITE_P: begin
            //     WRITING = 1;
            //     counter_enable = 1;
            //     NS = WRITE_P;
            //     RS = 1;
            //     D = 8'b01010000;
            //     NEXT_COMMAND = DATA_WAIT;
            //     if(counter == 13'b1111111111111) begin
            //         NS = WRITE_PULSE_WAIT;
            //         E = 0;
            //     end
            //     else if(counter > 2500) begin
            //         E = 0;
            //     end
            //     else if(counter > 500) begin
            //         E = 1;
            //     end
            //     else begin
            //         E = 0;
            //     end
            // end

            

            // SHUTDOWN: begin
            //     counter_enable = 1;
            //     NS = SHUTDOWN;
            //     RS = 0;
            //     D = 8'b00000000;
            //     NEXT_COMMAND = OFF;
            //     if(counter == 13'b1111111111111) begin
            //         NS = WRITE_PULSE_WAIT;
            //         E = 0;
            //     end
            //     else if(counter > 2500) begin
            //         E = 0;
            //     end
            //     else if(counter > 500) begin
            //         E = 1;
            //     end
            //     else begin
            //         E = 0;
            //     end
            // end


            default: begin
                WRITING = 0;
                counter_enable = 0;
                NS = SHUTDOWN;
                D = 8'b00000000;
                RS = 0;
                E = 0;
            end

        endcase
    end


endmodule
