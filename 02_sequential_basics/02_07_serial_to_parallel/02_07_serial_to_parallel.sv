//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_to_parallel
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      serial_valid,
    input                      serial_data,

    output logic               parallel_valid,
    output logic [width - 1:0] parallel_data
);
    localparam cnt_width = $clog2(width);
    logic [cnt_width - 1:0] cnt;

    always_ff @ (posedge clk)
        if (rst)
            cnt <= '0;
        else if (serial_valid)
             if (cnt == width - 1)
                cnt <= '0;
             else 
                cnt <= cnt + 1'd1;
     
    assign parallel_valid = (cnt == width - 1) & serial_valid;

    logic [width - 1:0] shift_reg;

    always_ff @ (posedge clk )
        if (rst)
            shift_reg <= '0;
        else if (serial_valid)                                  // <--removed & ~ parallel_valid
            shift_reg <= { serial_data, shift_reg [width - 1:1] };
    
    always_comb
      if (parallel_valid)                                       // <--removed & serial_valid
        parallel_data = {serial_data, shift_reg [width - 1:1]};

               

             

    // Task:
    // Implement a module that converts single-bit serial data to the multi-bit parallel value.
    //
    // The module should accept one-bit values with valid interface in a serial manner.
    // After accumulating 'width' bits and receiving last 'serial_valid' input,
    // the module should assert the 'parallel_valid' at the same clock cycle
    // and output 'parallel_data' value.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.


endmodule
