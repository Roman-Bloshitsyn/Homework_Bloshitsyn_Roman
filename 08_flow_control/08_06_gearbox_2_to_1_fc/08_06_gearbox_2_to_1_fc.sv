//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module gearbox_2_to_1_fc
# (
    parameter width = 8
)
(
    input                    clk,
    input                    rst,

    input                    up_valid,
    output                   up_ready,
    input   [ 2*width - 1:0] up_data,

    output                   down_valid,
    input                    down_ready,
    output  [   width - 1:0] down_data
);

logic [2*width - 1:0] saved_data;
logic second, full;

wire handshake_up = up_ready & up_valid;
wire handshake_down = down_ready & down_valid;

assign down_valid = full | second;
assign up_ready = !full | down_ready;
assign down_data = second ? saved_data [width - 1:0] : saved_data [2*width - 1: width];

always @ (posedge clk)
    if (rst)
    begin
        saved_data <= '0;
        second <= '0;
    end
    else
    begin

        if (handshake_up & handshake_down)
        begin
            if (!second)
            begin
                saved_data <= up_data;
                second <= '0;
            end
            else
            begin
                saved_data <= saved_data;
                second <= 1'b1;
            end              
        end
        
        else if (handshake_up)
        begin
            saved_data <= up_data;
            second <= '0;
        end

        else if (handshake_down)    
        begin    
            second <= 1'b1; 
        end
    end
    // Task:
    // Implement a module that generates tokens from of one token.
    // Example:
    // "0110" => "01", "10"
    //
    // The module must use signals valid-ready for transfer tokens.


endmodule
