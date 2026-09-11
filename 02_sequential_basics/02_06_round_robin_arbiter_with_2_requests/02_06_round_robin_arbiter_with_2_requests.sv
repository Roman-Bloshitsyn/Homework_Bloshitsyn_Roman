//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module round_robin_arbiter_with_2_requests
(
    input        clk,
    input        rst,
    input  [1:0] requests,
    output [1:0] grants
);

//----------------------------------------------------------------------------
//Fixed: now, after “rst” if there are two requests, priority is given to the first requester

    logic [1:0] out;
    logic second;

    always_comb begin
        case (requests)
            2'b00: out = 2'b00;
            2'b01: out = 2'b01;
            2'b10: out = 2'b10;
            2'b11: out = second ? 2'b10 : 2'b01;
        endcase
     end

    assign grants = out;

    always_ff @(posedge clk) 
        if (rst)
          second <= '0;
        else 
          second <= (out == 2'b01) ? '1 : (out == 2'b10) ? '0 : second;

    
    // Task:
    // Implement a "arbiter" module that accepts up to two requests
    // and grants one of them to operate in a round-robin manner.
    //
    // The module should maintain an internal register
    // to keep track of which requester is next in line for a grant.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // requests -> 01 00 10 11 11 00 11 00 11 11
    // grants   -> 01 00 10 01 10 00 01 00 10 01


endmodule
