//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module conv_first_to_last_no_ready
# (
    parameter width = 8
)
(
    input                clock,
    input                reset,

    input                up_valid,
    input                up_first,
    input  [width - 1:0] up_data,

    output               down_valid,
    output               down_last,
    output [width - 1:0] down_data
);
//----------------------------------------------------------------------------
//Fixed: ternary operators have been replaced with if-else, 
//And the assign statements have been corrected.

    logic [width - 1:0] up_data_delay;
    logic delay_1;
    logic delay_2;   
    
    always_ff @ (posedge clock)
        if (reset) 
        begin
            delay_1 <= '0;
            delay_2 <= '0;
        end 
        else if (up_valid)
        begin
            delay_1 <= 1'b1;
            delay_2 <= 1'b1;
        end

    assign down_valid = (up_valid & delay_1);

    always @(posedge clock)
        if (reset)
            up_data_delay <= '0;
        else if (up_valid)
            up_data_delay <= up_data;
    
    assign down_data = up_data_delay;
    assign down_last = up_first & delay_2;

    // Task:
    // Implement a module that converts 'first' input status signal
    // to the 'last' output status signal.
    //
    // See README for full description of the task with timing diagram.


endmodule