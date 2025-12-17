module MainDecoder(
    input [6:0] op,
    output reg RegWrite,
    output reg MemWrite,
    output reg Branch,
    output reg ALUSrc,
	output reg [1:0] ResultSrc,
	output reg jump,
    output reg [1:0] ALUop,
    output reg [1:0] ImmSrc
); 
    always @(*) begin
        casex(op)
            7'd3: begin // Load Word Instruction
                RegWrite = 1'b1;
				ImmSrc = 2'b00;
				ALUSrc = 1'b1;
                MemWrite = 1'b0;
				ResultSrc = 2'b01;
                Branch = 1'b0;
                ALUop = 2'b00;
				jump = 1'b0;
            end
            7'd35: begin // Store Word Instruction
                RegWrite = 1'b0;
				ImmSrc = 2'b01;
				ALUSrc = 1'b1;
                MemWrite = 1'b1;
				ResultSrc = 2'bxx;
                Branch = 1'b0;
                ALUop = 2'b00;
				jump = 1'b0;
            end
			7'd51: begin // R Type Instruction
                RegWrite = 1'b1;
				ImmSrc = 2'bxx;
				ALUSrc = 1'b0;
                MemWrite = 1'b0;
				ResultSrc = 2'b00;
                Branch = 1'b0;
                ALUop = 2'b10;
				jump = 1'b0;
            end
            7'd99: begin // Branch Instruction
                RegWrite = 1'b0;
				ImmSrc = 2'b10;
				ALUSrc = 1'b0;
                MemWrite = 1'b0;
				ResultSrc = 2'bxx;
                Branch = 1'b1;
                ALUop = 2'b01;
				jump = 1'b0;
            end
            7'd19: begin // I-type Instruction
                RegWrite = 1'b1;
				ImmSrc = 2'b00;
				ALUSrc = 1'b1;
                MemWrite = 1'b0;
				ResultSrc = 2'b00;
                Branch = 1'b0;
                ALUop = 2'b10;
				jump = 1'b0;
            end
			7'd111: begin // JAL-type Instruction
                RegWrite = 1'b1;
				ImmSrc = 2'b11;
				ALUSrc = 1'bx;
                MemWrite = 1'b0;
				ResultSrc = 2'b10;
                Branch = 1'b0;
                ALUop = 2'bxx;
				jump = 1'b1;
            end

            default: begin
                RegWrite = 1'bx;
				ImmSrc = 2'bxx;
				ALUSrc = 1'bx;
                MemWrite = 1'bx;
				ResultSrc = 2'bxx;
                Branch = 1'bx;
                ALUop = 2'bxx;
				jump = 1'bx;
            end
        endcase
    end
endmodule
