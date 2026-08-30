//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module gearbox_1_to_2_fc
# (
    parameter width = 8
)
(
    input                   clk,
    input                   rst,
    input                   up_valid,
    output                  up_ready,
    input  [   width - 1:0] up_data,
    output                  down_valid,
    output [ 2*width - 1:0] down_data,
    input                   down_ready
);

    logic [width - 1:0] save_first;
    logic [width - 1:0] save_second;
    logic               have_first;
    logic               have_second;

    wire handshake_up   = up_valid & up_ready;
    wire handshake_down = down_valid & down_ready;


    assign down_valid = have_first & have_second;
    assign down_data  = {save_first, save_second};
    assign up_ready   = !have_second | down_ready;

    always_ff @(posedge clk) begin
        if (rst) 
        begin
            save_first   <= '0;
            save_second  <= '0;
            have_first   <= 1'b0;
            have_second  <= 1'b0;
        end 
        else 
        begin
            
            if (handshake_down & handshake_up) 
            begin
                save_first  <= up_data;
                have_first   <= 1'b1;
                have_second  <= 1'b0;
            end
            
            else if (handshake_up) 
            begin
                if (!have_first) 
                begin
                    save_first  <= up_data;
                    have_first   <= 1'b1;
                end 
                else 
                begin
                    save_second <= up_data;
                    have_second  <= 1'b1;
                end
            end
            
            else if (handshake_down) 
            begin
                have_first  <= 1'b0;
                have_second <= 1'b0;
            end
            
        end
    end

    // Task:
    // Implement a module that generates one token from of two tokens.
    // Example:
    // "01", "10" => "0110"
    //
    // The module must use signals valid-ready for transfer tokens.


endmodule
