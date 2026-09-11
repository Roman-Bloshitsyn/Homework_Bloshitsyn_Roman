module conv_last_to_first
# (
    parameter width = 8
)
(
    input                clock,
    input                reset,

    input                up_valid,
    input                up_last,
    input  [width - 1:0] up_data,

    output               down_valid,
    output               down_first,
    output [width - 1:0] down_data
);

//----------------------------------------------------------------------------
//Fixed: the case was replaced with if else; 
//The code was simplified by removing unnecessary assign statements and variables.

    logic save_up_last;

    assign down_valid = up_valid;

    always_ff @ (posedge clock)
        if (reset)
            save_up_last <= '1;
        else if (up_last)
            save_up_last <= '1;
        else if (up_valid)
            save_up_last <= '0;


    assign down_first = save_up_last;
    assign down_data = up_data;

    // Task:
    // Implement a module that converts 'last' input status signal
    // to the 'first' output status signal.
    //
    // See README for full description of the task with timing diagram.


endmodule