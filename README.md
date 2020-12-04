# ARM-Processor-Implementation
Created a ARMv8 Single-cycle Processor using Verilog 


## How to compile and run :
- compile code to a executable by typing `iverilog -o singlecycle ALU.v DataMemory.v InstructionMemory-1.v nextpc.v RegisterFile.v SignExtender.v Control.v Processor.v ProcessorTest.v`
- run executable by typing `./singlecycle`
- view wavefrom by typing `gtkwave singlecycle.vcd`

## ARMv8 Instructions currently supported: 
- ADD 
- SUB
- AND
- ORR
- ADD immediate
- SUB immediate
- AND immediate
- ORR immediate
- LDUR
- STUR
- MOVZ
