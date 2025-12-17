module RISC_V_RV32I_Top_Module (
    clk, rst
);
    input clk, rst;
    wire [31:0] WriteData;
    wire PCSrc, ALUSrc, RegWrite;
    wire [1:0] ResultSrc;
	wire MemWrite;
    wire [2:0] ALUControl;
    wire [1:0] ImmSrc;
    wire [31:0] instruction;
    wire zero;
    wire [31:0] PC;
    wire [31:0] ReadData;
    wire [31:0] ALUResult; 
    wire branch;
	wire [31:0] Result;

 Data_Path DP(
              .clk(clk),
			  .reset(rst),
              .PCSrc(PCSrc),
			  .ALUSrc(ALUSrc),
			  .RegWrite(RegWrite),
              .MemWrite(MemWrite),
			  .ResultSrc(ResultSrc),
              .ALUControl(ALUControl),
              .ImmSrc(ImmSrc),
              .instruction(instruction),
              .zero(zero),
              .PC(PC),
              .WriteData(WriteData),
              .ReadData(ReadData),
              .ALUResult(ALUResult),
              .Result(Result)			  
);

 Control_top Control_Top_Module(
                               .op(instruction[6:0]),
                               .funct3(instruction[14:12]),
                               .funct7(instruction[30]),
                               .zero(zero),
                               .PCSrc(PCSrc),
                               .ALUSrc(ALUSrc),
							   .ResultSrc(ResultSrc),
                               .RegWrite(RegWrite),
                               .MemWrite(MemWrite),
                               .ImmSrc(ImmSrc),
                               .ALUControl(ALUControl)
);


 Instruction_Memory Intruction_mem(
								   .A(PC), 
								   .RD(instruction)
    );

endmodule
