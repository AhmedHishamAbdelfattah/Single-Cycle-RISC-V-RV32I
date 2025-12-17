module Control_top(
    input [6:0] op,
    input [2:0] funct3,
    input funct7,
    input zero,
    output wire PCSrc,
    output wire ALUSrc,
	output wire [1:0] ResultSrc,
    output wire RegWrite,
    output wire MemWrite,
    output wire [1:0] ImmSrc,
    output wire [2:0] ALUControl
);
    wire [1:0] ALUop;
	wire jump;
    wire branch;

    MainDecoder md(op, RegWrite, MemWrite, branch, ALUSrc, ResultSrc, jump, ALUop, ImmSrc);
    ALUDecoder ad(op[5], funct3, funct7, ALUop, ALUControl);
    
    assign PCSrc = ( (branch & zero) | jump);
endmodule
