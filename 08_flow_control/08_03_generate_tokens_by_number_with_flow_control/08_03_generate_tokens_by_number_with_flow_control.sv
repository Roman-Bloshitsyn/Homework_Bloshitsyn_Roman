//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module generate_tokens_by_number_with_flow_control
#(
    WIDTH = 4
)
(
    input                 clk,
    input                 rst,

    input                 up_valid,
    output                up_ready,
    input  [WIDTH-1 : 0]  n_tokens,

    output                down_valid,
    input                 down_ready,
    output                down_token
);

    localparam CNT_W   = WIDTH + 1;        
    localparam MAX = (1 << WIDTH);     

    logic [CNT_W-1:0] cnt;

    logic up_handshake, down_handshake;

    assign up_handshake   = up_valid   & up_ready;
    assign down_handshake = down_valid & down_ready;

    assign down_token = 1'b1;
    assign down_valid = (cnt != '0);
    assign up_ready = (cnt <= MAX);

    always_ff @(posedge clk)
        if (rst)
            cnt <= '0;
        else
            cnt <= cnt
                 + (up_handshake   ? n_tokens : '0)   
                 - (down_handshake ? 1'b1     : 1'b0); //Cnt + принятие - отдатие


    // Task:
    // Implement a module that recive an integer N_tokens and generate N_tokens pulses. The module must use signals valid-ready for
    // transfer tokens.


endmodule
