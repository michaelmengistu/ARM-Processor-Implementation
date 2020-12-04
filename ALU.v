`timescale 1ns / 1ps

`define AND   4'b0000
`define OR    4'b0001
`define ADD   4'b0010
`define SUB   4'b0110
`define PassB 4'b0111


module ALU(BusW, BusA, BusB, ALUCtrl, Zero);
    
    parameter n = 64;
	 
     //input and output ports
    output  [n-1:0] BusW;
    input   [n-1:0] BusA, BusB;
    input   [3:0] ALUCtrl;
    output  Zero;
    
    reg     [n-1:0] BusW;
    
    always @(ALUCtrl or BusA or BusB) begin
        case(ALUCtrl)
            `AND: BusW <= #20 (BusA & BusB);
            `OR: BusW <= #20 (BusA | BusB);
            `ADD: BusW <= #20 (BusA + BusB);
            `SUB: BusW <= #20 (BusA - BusB);
            `PassB: BusW <= #20 BusB;
        endcase
    end

    assign #1 Zero = (BusW) ? 1'b0 : 1'b1; // 1 when BusW is 0, and 0 otherwise.
endmodule
