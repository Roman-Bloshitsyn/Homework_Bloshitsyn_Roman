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
    logic save_up_last;
    logic [1:0] up_valid_last;

    assign up_valid_last = {up_valid, up_last};
    assign down_valid = up_valid;

    always_ff @ (posedge clock)
        if (reset)
            save_up_last <= '1;
        else
            case (up_valid_last)
                2'b00: save_up_last <= save_up_last;
                2'b01: save_up_last <= '0;
                2'b10: save_up_last <= '0;
                2'b11: save_up_last <= '1;
            endcase

    assign down_first = (save_up_last & up_valid);
    assign down_data = up_valid ? up_data : 'b0;


    // Task:
    // Implement a module that converts 'last' input status signal
    // to the 'first' output status signal.
    //
    // See README for full description of the task with timing diagram.


endmodule