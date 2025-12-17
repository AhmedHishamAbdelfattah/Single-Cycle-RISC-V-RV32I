module program_counter(
input clk, reset, 
input [31:0] pc_in, // Input Port
output reg [31:0] pc_out // Output Port
    );

    always@(posedge clk)
    if (reset)
        pc_out <= 32'h0; // so next becomes 0 // In initial Stage, output of PC will be the initial address
    else
        pc_out <= pc_in;  // In the next cycle, output will be incremented to four of previous stage. Example: 1000 + 4= 1004, in next cycle it is 1008
endmodule
