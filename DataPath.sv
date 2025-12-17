module Data_Path(
    input clk, reset,
    input PCSrc, ALUSrc, RegWrite,
    input [1:0] ResultSrc,
	input MemWrite,
    input [2:0] ALUControl,
    input [1:0] ImmSrc,
    input [31:0] instruction,
    output zero,
    output [31:0] PC,
    output [31:0] WriteData,
    output [31:0] ReadData,
    output [31:0] ALUResult,
    output [31:0] Result	
);
    wire [31:0] PCNext, PCPlus4, ImmExt, PCTarget, SrcA, SrcB;
    wire [31:0] PC_out;

    // PC Logic flow
    program_counter pc(clk, reset, PCNext, PC_out);
    Adder_for_PCPlus4 a1(PC_out, PCPlus4);
    Adder_for_PCTarget a2(PC_out, ImmExt, PCTarget);
    MUX_for_PCSrc m1(PCPlus4, PCTarget, PCSrc, PCNext);
    
    // Register File Logic Flow
    RegFile rf(RegWrite, clk, instruction[19:15], instruction[24:20], instruction[11:7], Result, SrcA, WriteData);
    Extend e(instruction[31:7], ImmSrc, ImmExt);
    
    // ALU Logic
    MUX_for_ALUSrc m2(WriteData, ImmExt, ALUSrc, SrcB);
    ALU alu(SrcA, SrcB, ALUControl, zero, ALUResult);
    
    // Data Memory Logic
    Data_Memory dm(clk, MemWrite, ALUResult, WriteData, ReadData);
    
    // MUX for ResultSrc
    MUX_for_ResultSrc m3(ALUResult, ReadData, PCPlus4, ResultSrc, Result);
    
    // Output Assignments
    assign PC = PC_out;
endmodule 
