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
    logic [width - 1:0] save;
    logic save_vld;
    logic [1:0] valid;

    always_ff @(posedge clk)
        if (rst)
            save_vld <= '0;
        else 
            save_vld <= up_vld ? (~ save_vld) : (save_vld);

    assign down_vld = save_vld & up_vld;
    assign valid = {up_vld, down_vld};

    always_ff @(posedge clk)
        if (rst)
            save <= '0;
        else 
            case (valid)
            2'b00: save <= save;
            2'b01: save <= 1'b0;
            2'b10: save <= up_data;
            2'b11: save <= 1'b0;
            endcase
    
    assign down_data = (up_vld & down_vld) ? {save, up_data} : '0;
         
              
        
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
