`timescale 1ns / 1ps
/*
 * Module: InstructionMemory
 *
 * Implements read-only instruction memory
 *
 */
module InstructionMemory(Data, Address);
    output [31:0] Data;
    input [63:0]  Address;
    reg [31:0] 	 Data;

    always @ (Address) begin
        case(Address)
        /* Test Program 1:
         * Program loads constants from the data memory. Uses these constants to test
         * the following instructions: LDUR, ORR, AND, CBZ, ADD, SUB, STUR and B.
         *
         * Assembly code for test:
         *
         * 0x00: ORR  X20, XZR, XZR     //Create a base memory address
         * 0x04: LDUR X9,  [X20, 0x0]   //Load 1 into x9
         * 0x08: LDUR X10, [X20, 0x8]   //Load a into x10
         * 0x0c: LDUR X11, [X20, 0x10]  //Load 5 into x11
         * 0x10: LDUR X12, [X20, 0x18]  //Load big constant into x12
         * 0x14: LDUR X13, [X20, 0x20]  //load a 0 into X13
         *
         * 0x18: ORR X10, X10, X11  //Create mask of 0xf
         * 0x1c: AND X12, X12, X10  //Mask off low order bits of big constant/
         *
         * loop:
         * 0x20: CBZ X12, end  //while X12 is not 0
         * 0x24: ADD X13, X13, X9  //Increment counter in X13
         * 0x28: SUB X12, X12, X9  //Decrement remainder of big constant in X12
         * 0x2c: B loop  //Repeat till X12 is 0
         * 0x30: STUR X13, [X20, 0x20]  //store back the counter value into the memory location 0x20
         * 0x34: LDUR X13, [X20, 0x20]  //One last load to place stored value on memdbus for test checking.
         */

        64'h000: Data = 32'hAA1F03F4;
        64'h004: Data = 32'hF8400289;
        64'h008: Data = 32'hF840828A;
        64'h00c: Data = 32'hF841028B;
        64'h010: Data = 32'hF841828C;
        64'h014: Data = 32'hF842028D;
        64'h018: Data = 32'hAA0B014A;
        64'h01c: Data = 32'h8A0A018C;
        64'h020: Data = 32'hB400008C;
        64'h024: Data = 32'h8B0901AD;
        64'h028: Data = 32'hCB09018C;
        64'h02c: Data = 32'h17FFFFFD;
        64'h030: Data = 32'hF802028D;
        64'h034: Data = 32'hF842028D;


        /* Add code for your tests here */
		/* Test Program 2:
         * Assembly code for test:
         *
         * 0x38: MOVZ X14, 0x1234, 0x48  //wirte 1234 LSL 48 into x14
         * 0x3c: MOVZ X15, 0x5678, 0x32  //wirte 5678 LSL 32 into x15
         * 0x40: MOVZ X16, 0x9abc, 0x16  //wirte 1234 LSL 16 into x16
         * 0x44: MOVZ X17, 0xdef0        //wirte def0 LSL0  into x17 
         * 0x48: ORR X9, X15, X14        //puts 0x1234567800000000 into x9 
         * 0x4c: ORR X9, X9, X16         //puts 0x123456789abc0000 into x9 
         * 0x50: ORR X9, X9, X17         //puts 0x123456789abcdef0 into x9 
         * 0x54: STUR X9, [X20, 0x28]    //store x9 into memory location 0x28
         * 0x58: LDUR X10, [X20, 0x28]   //load 0x123456789abcdef0 into X10
         */ 
         
         64'h038: Data = {9'b110100101,2'b11,16'h1234,5'd14};
         64'h03c: Data = {9'b110100101,2'b10,16'h5678,5'd15};
         64'h040: Data = {9'b110100101,2'b01,16'h9abc,5'd16};
         64'h044: Data = {9'b110100101,2'b00,16'hdef0,5'd17};
         64'h048: Data = {11'b10101010000,5'd14,6'd0,5'd15,5'd9};
         64'h04c: Data = {11'b10101010000,5'd16,6'd0,5'd9,5'd9};
         64'h050: Data = {11'b10101010000,5'd17,6'd0,5'd9,5'd9}; 
         64'h054: Data = {11'b11111000000,9'h28,2'b00,5'd20,5'd9};
         64'h058: Data = {11'b11111000010,9'h28,2'b00,5'd20,5'd10};
          
          
        default: Data = 32'hXXXXXXXX;
        endcase
    end
endmodule


