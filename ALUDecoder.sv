module ALUDecoder(
    input  op_5,         // Opcode_bit_5
    input  [2:0] funct3,     // funct3 field
    input        funct7_5,     // 1-bit funct7 (your design choice)
    input  [1:0] ALUop,      // From main decoder
    output reg [2:0] ALUControl
);

    always @(*) begin
        case (ALUop)

            // ----------------------------------------
            // ALUop = 00 → always ADD (for load/store)
            // ----------------------------------------
            2'b00: ALUControl = 3'b000; // ADD
            // ----------------------------------------
            // ----------------------------------------

            // ----------------------------------------
            // ALUop = 01 → always SUB (for branch) beq
            // ----------------------------------------
            2'b01: ALUControl = 3'b001; // SUB
            // ----------------------------------------
            // ----------------------------------------

            // ----------------------------------------
            // ALUop = 10 → Use funct7, funct3, op5
            // ----------------------------------------
            2'b10: begin
                casex({funct7_5, op_5, funct3})
                    // ADD
                    5'b00_000: ALUControl = 3'b000;
                    5'b01_000: ALUControl = 3'b000;
                    5'b10_000: ALUControl = 3'b000;

                    // SUB
                    5'b11_000: ALUControl = 3'b001;

                    // SLT
                    5'bxx_010: ALUControl = 3'b101;

                    // OR
                    5'bxx_110: ALUControl = 3'b011;

                    // AND
                    5'bxx_111: ALUControl = 3'b010;

                    default: ALUControl = 3'bxxx;
                endcase
            end

            default: ALUControl = 3'bxxx;
        endcase
    end

endmodule 
