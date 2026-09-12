module put_in_order
# (
    parameter width    = 16,
              n_inputs = 4
)
(
    input                       clk,
    input                       rst,

    input  [ n_inputs - 1 : 0 ] up_vlds,
    input  [ n_inputs - 1 : 0 ]
           [ width    - 1 : 0 ] up_data,

    output                      down_vld,
    output [ width   - 1 : 0 ]  down_data
);

//---------------------------------------------------------------------
//Fixed: the ternary operator has been removed in down_data

//---------------------------------------------------------------------
//Буфер, который хранит в себе значения, пришедших данных

    logic [width - 1:0] bufer [0:n_inputs - 1];
    logic [n_inputs - 1:0] bufer_vld;  
    
    always_ff @(posedge clk)
    begin
        for (int i = 0; i < n_inputs; i++)
            if (up_vlds [i]) 
            begin
                bufer [i] <= up_data [i];
                bufer_vld [i] <= up_vlds [i];
            end
    end

//---------------------------------------------------------------------
//Концепция конечного автомата

    logic [$clog2(n_inputs) - 1:0] state;
    logic [width - 1:0] down_data_1 [0:n_inputs - 1];
    logic down_vld_1;

    always_comb
    begin
        down_vld_1 = 1'b0;
        
        if (bufer_vld [state]) 
        begin
            down_data_1 [state] = bufer [state];
            down_vld_1 = 1'b1;
        end
    end

    assign down_vld = down_vld_1;   
    assign down_data = down_data_1 [state];

    always_ff @(posedge clk)
    begin
        if (rst)
            state <= '0;
        else if (bufer_vld [state]) 
        begin
            state <= state + 1'd1;
            bufer_vld [state] <= '0;
        end
    end

//---------------------------------------------------------------------



    // Task:    
    //
    // Implement a module that accepts many outputs of the computational blocks
    // and outputs them one by one in order. Input signals "up_vlds" and "up_data"
    // are coming from an array of non-pipelined computational blocks.
    // These external computational blocks have a variable latency.
    //
    // The order of incoming "up_vlds" is not determent, and the task is to
    // output "down_vld" and corresponding data in a round-robin manner,
    // one after another, in order.
    //
    // Comment:
    // The idea of the block is kinda similar to the "parallel_to_serial" block
    // from Homework 2, but here block should also preserve the output order.


endmodule
