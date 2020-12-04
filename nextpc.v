`timescale 1ns / 1ps

module NextPCLogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);

	//inputs outputs
	output reg [63:0] NextPC;
	input [63:0] CurrentPC;
	input [63:0] SignExtImm64;
	input Branch, ALUZero,Uncondbranch;

	//behavioral model of PC logic
	always @(*)
	begin
		if (Uncondbranch || (Branch && ALUZero)) // pc takes branch or unconditional branch
			#3 NextPC = (SignExtImm64 << 2 ) + CurrentPC;
		else // else pc goes to next pc counter
			#2 NextPC = CurrentPC + 4;
			
	end
	
	 

endmodule

