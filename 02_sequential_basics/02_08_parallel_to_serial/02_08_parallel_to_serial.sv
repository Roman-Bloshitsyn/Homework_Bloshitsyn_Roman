//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module parallel_to_serial
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      parallel_valid,
    input        [width - 1:0] parallel_data,

    output                     busy,
    output logic               serial_valid,
    output logic               serial_data
);

    localparam cnt_width = $clog2(width);
    logic [cnt_width - 1:0] cnt;
    logic [width - 1:0] shift_reg;
    
    always_comb
      if (parallel_valid)
        serial_valid = parallel_valid;
    
    always_ff @ (posedge clk) 
      if (rst) begin
        serial_valid <= 0;
        cnt <= 0; 
      end
      else if (parallel_valid) begin
             shift_reg <= { 1'b0, parallel_data[width - 1:1] };
             cnt <= width - 1;
             serial_valid <= '1;
            end
           else if ( cnt != '0) begin
               shift_reg <= { 1'b0, shift_reg[width - 1:1] }; 
               cnt <= cnt - 1'd1;
               serial_valid <= ( cnt != 1'd1);
                end
    always_comb 
        if (parallel_valid)
            serial_data = parallel_data[0];         
        else
            serial_data = shift_reg[0];     

     assign busy = (cnt != 0);

         



    // Task:
    // Implement a module that converts multi-bit parallel value to the single-bit serial data.
    //
    // The module should accept 'width' bit input parallel data when 'parallel_valid' input is asserted.
    // At the same clock cycle as 'parallel_valid' is asserted, the module should output
    // the least significant bit of the input data. In the following clock cycles the module
    // should output all the remaining bits of the parallel_data.
    // Together with providing correct 'serial_data' value, module should also assert the 'serial_valid' output.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.


endmodule
