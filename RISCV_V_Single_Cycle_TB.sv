`timescale 1ns/1ps

module TB_RISCV_single_cycle();

    reg clk;
    reg rst;

    wire [31:0] PC;
    wire [31:0] WriteData;
    wire [31:0] ReadData;
    wire [31:0] ALUResult;
    wire [31:0] instruction;
    integer k;
    integer m;

    // DUT
    RISC_V_RV32I_Top_Module dut (
        .clk(clk),
        .rst(rst)
    );


// ===================================================================================================================
// ===================================================================================================================
// Notes:
/* 
in my design reset is depending on clk as I made in the design @(posedge clk ) if (reset) 
==> so reset won't work else posedge clk comes 
but here in initial block I made rst = 1 then delay then rst = 0 ==> and it worked but how?
because initial and always block are running in parallel 
so the clk is running in the time of applying reset
those two blocks: 
    // Clock generation (period = 10ns)
    always begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end

    // Reset pulse
    initial begin
        rst = 1'b1;
        #20;
        rst = 1'b0;
    end
// ===========================================
// Notes on always and initial blocks:
- always blocks = infinite hardware processes
- initial blocks = one-time hardware events
- BOTH start at time 0
- BOTH run independently

- So the clock does NOT wait for reset.
- Reset does NOT wait for clock.
- They run simultaneously, just like real hardware.
*/ 
// ===================================================================================================================
// ===================================================================================================================

    // Clock generation (period = 10ns)
    always begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end

    // Reset pulse
    initial begin
        rst = 1'b1;
        #20;
        rst = 1'b0;
    end

// ===================================================================================================================
//  DEBUG MONITOR — prints everything every cycle
// ===================================================================================================================
always @(posedge clk) begin
    #1;  // small delay so signals settle

    $display("\n========================================================");
    $display(" Cycle @ %0t", $time);
    $display("========================================================");

    // -------------------------------------------------------
    // PC + Instruction
    // -------------------------------------------------------
    $display(" PC         = %h", dut.DP.PC);
    $display(" Instr      = %h", dut.Intruction_mem.RD);

    $display(" opcode=%b funct3=%b funct7=%b",
        dut.Intruction_mem.RD[6:0],
        dut.Intruction_mem.RD[14:12],
        dut.Intruction_mem.RD[30]
    );

    $display(" rs1=%0d rs2=%0d rd=%0d",
        dut.Intruction_mem.RD[19:15],
        dut.Intruction_mem.RD[24:20],
        dut.Intruction_mem.RD[11:7]
    );

    // -------------------------------------------------------
    // Control Signals
    // -------------------------------------------------------
    $display("--------------------------------------------------------");
    $display(" CONTROL:");
    $display("  RegWrite   = %b", dut.RegWrite);
    $display("  MemWrite   = %b", dut.MemWrite);
    $display("  ALUSrc     = %b", dut.ALUSrc);
    $display("  ResultSrc  = %b", dut.ResultSrc);
    $display("  ImmSrc     = %b", dut.ImmSrc);
    $display("  ALUop      = %b", dut.Control_Top_Module.ALUop);
    $display("  jump       = %b", dut.Control_Top_Module.jump);
    $display("  branch     = %b", dut.Control_Top_Module.branch);
    $display("  PCSrc      = %b", dut.PCSrc);
    $display("  ALUControl = %b", dut.ALUControl);

    // -------------------------------------------------------
    // Datapath Signals
    // -------------------------------------------------------
    $display("--------------------------------------------------------");
    $display(" DATAPATH:");
    $display("  SrcA       = %h", dut.DP.SrcA);
    $display("  SrcB       = %h", dut.DP.SrcB);
    $display("  ImmExt     = %h", dut.DP.ImmExt);

    $display("  ALUResult  = %h", dut.DP.ALUResult);
    $display("  zero       = %b", dut.DP.zero);

    $display("  WriteData  = %h", dut.DP.WriteData);
    $display("  ReadData   = %h", dut.DP.ReadData);
	$display("  Result     = %h", dut.DP.Result);


    $display("  PCPlus4    = %h", dut.DP.PCPlus4);
    $display("  PCTarget   = %h", dut.DP.PCTarget);

    // -------------------------------------------------------
    // REGISTER FILE DUMP
    // -------------------------------------------------------
    $display("--------------------------------------------------------");
    $display(" REGISTER FILE:");
    for (k = 0; k < 10; k = k + 1) begin
        $display("  x%0d  = %h", k, dut.DP.rf.register_file[k]);
    end

    // Show all 32 if needed
    /*
    for (k = 0; k < 32; k = k + 1)
        $display("  x%0d = %h", k, dut.DP.rf.register_file[k]);
    */

    // -------------------------------------------------------
    // DATA MEMORY DUMP (first few words)
    // -------------------------------------------------------
    $display("--------------------------------------------------------");
    $display(" DATA MEMORY [0..7]:");
    for (m = 0; m < 8; m = m + 1) begin
        $display("  mem[%0d] = %h", m, dut.DP.dm.mem[m]);
    end

    $display("========================================================\n");
end
// ===================================================================================================================
// ===================================================================================================================

/* 
    // Monitoring signals every cycle in a small scale
    always @(posedge clk) begin
        $display("PC = %d, Instr = %h, ALUResult = %d, WriteData = %d, ReadData = %d",
                  dut.DP.PC,
                  dut.Intruction_mem.RD,
                  dut.DP.ALUResult,
                  dut.DP.WriteData,
                  dut.DP.ReadData);
    end
*/ 
    // Simulation stop & correctness checking
    initial begin
        // Run long enough for program to finish
        #400;

        // --- EXPECTED RESULTS FROM YOUR PROGRAM ---
        // x3 = 15  (after add x3,x1,x2)
        // MEM[0] = 15 (after sw)
        // x7 = 15 (after lw)
        // x9 = 9  (last instruction)

        if (dut.DP.rf.register_file[3] == 15 &&
            dut.DP.rf.register_file[7] == 15 &&
            dut.DP.rf.register_file[9] == 9)
        begin
            $display("====================================================");
            $display("            SIMULATION SUCCESSFUL");
            $display("====================================================");
        end else begin
            $display("====================================================");
            $display("            SIMULATION FAILED");
            $display(" x3 = %d  x7 = %d  x9 = %d ",
                      dut.DP.rf.register_file[3],
                      dut.DP.rf.register_file[7],
                      dut.DP.rf.register_file[9] );
            $display("====================================================");
        end

        $stop;
    end

endmodule 
// ===================================================================================================================
// ===================================================================================================================
