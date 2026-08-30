//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module convert_first_to_last_with_flow_control
# (
    parameter width = 8
)
(
    input                clock,
    input                reset,

    input                up_valid,
    output               up_ready,
    input                up_first,
    input  [width - 1:0] up_data,

    output               down_valid,
    input                down_ready,
    output               down_last,
    output [width - 1:0] down_data
);

    logic [width - 1:0] saved_data;
    logic               has_data;

    logic up_handshake;
    logic down_handshake;

    assign up_handshake   = up_valid   & up_ready;
    assign down_handshake = down_valid & down_ready;
    assign up_ready   = !has_data | down_ready;
    assign down_valid = has_data & up_valid;
    assign down_data  = saved_data;
    assign down_last  = up_first;

    always_ff @(posedge clock) begin
        if (reset) begin
            has_data   <= 1'b0;
            saved_data <= '0;
        end else begin
            if (up_handshake) begin
                saved_data <= up_data;
                has_data   <= 1'b1;
            end 
            else if (down_handshake) begin
                has_data   <= 1'b0;
            end
        end
    end


    // Task:
    // Implement a module that converts 'first' input status signal
    // to the 'last' output status signal.
    //
    // The module should respect and set correct valid and ready signals
    // to control flow from the upstream and to the downstream.


endmodule
