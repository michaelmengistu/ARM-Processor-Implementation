`timescale 1ns / 1ps
module singlecycle(
    input resetl,
    input [63:0] startpc,
    output reg [63:0] currentpc,
    output [63:0] dmemout,
    input CLK
);

    // Next PC connections
    wire [63:0] nextpc;       // The next PC, to be updated on clock cycle

    // Instruction Memory connections
    wire [31:0] instruction;  // The current instruction

    // Parts of instruction
  	wire [4:0] rd;            // The destination register
    wire [4:0] rm;            // Operand 1
  	wire [4:0] rn;    		  // Oprrderand 2
    wire [10:0] opcode;
  	wire [25:0] immediate;

    // Control wires
    wire reg2loc;
    wire alusrc;
    wire mem2reg;
    wire regwrite;
    wire memread;
    wire memwrite;
    wire branch;
    wire uncond_branch;
    wire [3:0] aluctrl;
  	wire [2:0] signop;

    // Register file connections
    wire [63:0] regoutA;     // Output A
    wire [63:0] regoutB;     // Output B

    // ALU connections
  	wire [63:0] muxW;
  	wire [63:0] muxB;
    wire [63:0] aluout;
    wire zero;

    // Immediate generator connections
    wire [63:0] extimm;

    // PC update logic
  	always @(negedge CLK)
    	begin
        	if (resetl)
           		currentpc <= nextpc;
        	else
           		currentpc <= startpc;	       
    	end

    InstructionMemory Instruction(
        .Data(instruction),
        .Address(currentpc)
    );
  

    control control(
        .reg2loc(reg2loc),
        .alusrc(alusrc),
        .mem2reg(mem2reg),
        .regwrite(regwrite),
        .memread(memread),
        .memwrite(memwrite),
        .branch(branch),
        .uncond_branch(uncond_branch),
        .aluop(aluctrl),
        .signop(signop),
        .opcode(opcode)
    );
    
    
    /*
    * Connect the remaining datapath elements below.
    * Do not forget any additional multiplexers that may be required.
    */
  
    // Parts of instruction
    assign rd = instruction[4:0];
    assign rm = instruction[9:5];
  	assign #2 rn = reg2loc ? instruction[4:0] : instruction[20:16];
    assign opcode = instruction[31:21];
  	assign immediate = instruction[25:0];  

  	RegisterFile REG(
      .BusA(regoutA),
		  .BusB(regoutB),
      .BusW(muxW),
		  .RA(rm),
		  .RB(rn),
		  .RW(rd),
      .RegWr(regwrite),
		  .Clk(CLK)
    );
  
    SignExtender ImmGen(
      .Imm64(extimm),
      .Imm26(immediate),
      .Ctrl(signop)
    );
 	
  	assign #2 muxB = alusrc ? extimm : regoutB;
  	ALU alu(
    	.BusA(regoutA),
      .BusB( muxB),
    	.BusW(aluout),
    	.Zero(zero),
    	.ALUCtrl(aluctrl)
    );

    DataMemory DM(
        .ReadData(dmemout),
      	.Address(aluout),
      	.WriteData(regoutB),
        .MemoryRead(memread),
        .MemoryWrite(memwrite),
        .Clock(CLK)
	);
    
  	assign #2 muxW = mem2reg ? dmemout : aluout;

  	NextPCLogic NextPCLogic(
        .NextPC(nextpc),
        .CurrentPC(currentpc),
        .SignExtImm64(extimm),
        .Branch(branch),
        .ALUZero(zero),
        .Uncondbranch(uncond_branch)
	);
  
  
endmodule

