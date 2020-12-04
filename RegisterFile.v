`timescale 1ns / 1ps

module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk); 

    //64 bit register file inputs and outputs
    output [63:0] BusA;
    output [63:0] BusB;
    input [63:0] BusW;
    input [4:0] RA;
    input [4:0] RB;
    input [4:0] RW;
    input RegWr;
    input Clk;
    reg [63:0] registers [31:0];
    

    //behavioral model of register file
    always @ (negedge Clk) begin
        if(RegWr) //When RegWr is set to 1, then the data on Bus W is stored in the register specified by Rw with dealy of 3
            registers[RW] <= #3 BusW;
    end

    //Data from registers Ra and Rb is sent on Bus A and Bus B respectively, after a delay of 2 tics.  Also sets Register 31 equal to zero
    assign #2 BusA = (RA == 31) ? 0 : registers[RA];
    assign #2 BusB = (RB == 31  ) ? 0: registers[RB];

    
endmodule
