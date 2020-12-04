`timescale 1ns / 1ps

module SignExtender(Imm64, Imm26, Ctrl); 
 
  /*input and output ports*/
  output [63:0] Imm64; 
  input [25:0] Imm26; 
  input [2:0] Ctrl; 

  reg [63:0] Imm64Reg;

  always@ (*) begin

    if(Ctrl == 3'b000)begin //I-type sign extender for add and sub
      Imm64Reg = {{52{Imm26[1'b0]}} , Imm26[21:10]};
    end
    else if(Ctrl == 3'b001)begin //D-type sign extender for load and store
      Imm64Reg = {{55{Imm26[20]}} , Imm26[20:12]};
    end
    else if(Ctrl == 3'b010)begin //B-type sign extender for branch
      Imm64Reg = {{38{Imm26[25]}} , Imm26};
    end   
    else if(Ctrl == 3'b011) begin //CB-type sign extender for conditional branch
      Imm64Reg = {{45{Imm26[23]}} , Imm26[23:5]};
    end
    else begin //IM-type sign extender for MOVZ
      Imm64Reg = { 48'b0, {Imm26[20:5]} };
      if(Imm26[22:21] != 2'b00) begin
      	Imm64Reg =  Imm64Reg << ((Imm26[22:21]) *16);
      end
    end
                  
  end

  assign Imm64 = Imm64Reg;

endmodule
