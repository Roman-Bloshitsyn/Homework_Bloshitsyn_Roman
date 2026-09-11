//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module gearbox_1_to_2
# (
    parameter width = 0
)
(
    input                    clk,
    input                    rst,

    input                    up_vld,    // upstream
    input  [    width - 1:0] up_data,

    output                   down_vld,  // downstream
    output [2 * width - 1:0] down_data
);

//----------------------------------------------------------------------------
//Fixed: the case was replaced with if else; 
//The code was simplified by removing unnecessary assign statements and variables.

    logic [width - 1:0] save;
    logic save_vld;

    always_ff @(posedge clk)
        if (rst)
            save_vld <= '0;
        else 
            save_vld <= up_vld ? (~ save_vld) : (save_vld);

    assign down_vld = save_vld & up_vld;

    always_ff @(posedge clk)
        if (rst)
            save <= '0;
        else if (up_vld)
            save <= up_data;

    assign down_data = {save, up_data};
         
    // Task:
    // Implement a module that transforms a stream of data
    // from 'width' to the 2*'width' data width.
    //
    // The module should be capable to accept new data at each
    // clock cycle and produce concatenated 'down_data'
    // at each second clock cycle.
    //
    // The module should work properly with reset 'rst'
    // and valid 'vld' signals


endmodule
