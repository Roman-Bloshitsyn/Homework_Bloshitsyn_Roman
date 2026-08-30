//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_pipe_using_circular
(
    input         clk,
    input         rst,

    input         arg_vld,
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,

    output        res_vld,
    output [31:0] res
);
    
//------------------------------------------------------------------------------------
//Вызов трех модулей isqrt

    isqrt isqrt_1 
    (
        .clk (clk),
        .rst (rst),
        .x_vld (arg_vld),
        .x (c),
        .y_vld (y_vld_c),
        .y (isqrt_c)

    );

    isqrt isqrt_2 
    (
        .clk (clk),
        .rst (rst),
        .x_vld (circ_vld_sumbc),
        .x (sum_bc),
        .y_vld (y_vld_bc),
        .y (isqrt_bc)
    );  

    isqrt isqrt_3 
    (
        .clk (clk),
        .rst (rst),
        .x_vld (circ_vld_sumbca),
        .x (sum_bca),
        .y_vld (y_vld_bca),
        .y (isqrt_bca)
    );  
 
//------------------------------------------------------------------------------------
//Вызов двух модулей circular_buffer для хранения входящих данных a и b
    
    logic [31:0] circ_a, circ_b;

    circular_buffer_with_valid #(.width (32), .depth (33)) circular_buffer_a
    (
        .clk (clk),
        .rst (rst),
        .in_data (a),
        .in_valid (arg_vld),
        .out_data (circ_a)
    );

    circular_buffer_with_valid #(.width (32), .depth (16)) circular_buffer_b
    (
        .clk (clk),
        .rst (rst),
        .in_data (b),
        .in_valid (arg_vld),
        .out_data (circ_b)
    );

//------------------------------------------------------------------------------------------
//Кольцевые буферы для валидных сигналов 

    logic circ_vld_sumbc, circ_vld_sumbca;

    one_bit_wide_circular_buffer #(.depth (17)) circular_buffer_vld_sumbc
    (
        .clk (clk),
        .rst (rst),
        .in_data (arg_vld),
        .out_data (circ_vld_sumbc)
    );

    one_bit_wide_circular_buffer #(.depth (34)) circular_buffer_vld_sumbca
    (
        .clk (clk),
        .rst (rst),
        .in_data (arg_vld),
        .out_data (circ_vld_sumbca)
    );

//-------------------------------------------------------------------------------------------
//Регистры для записи результатов
   
    always_ff @ (posedge clk)
        if (rst) 
            sum_bc <= '0;
        else if (y_vld_c)
            sum_bc <= circ_b + 32' (isqrt_c);

    always_ff @ (posedge clk)
        if (rst)
            sum_bca <= '0;
        else if (y_vld_bc)
            sum_bca <= circ_a + 32' (isqrt_bc);

   assign res = y_vld_bca ? isqrt_bca : '0;
   assign res_vld = y_vld_bca;

//-----------------------------------------------------------------------------------------
    // Task:
    //
    // Implement a pipelined module formula_2_pipe_using_circular
    // that computes the result of the formula defined in the file formula_2_fn.svh.
    //
    // The requirements:
    //
    // 1. The module formula_2_pipe has to be pipelined.
    //
    // It should be able to accept a new set of arguments a, b and c
    // arriving at every clock cycle.
    //
    // It also should be able to produce a new result every clock cycle
    // with a fixed latency after accepting the arguments.
    //
    // 2. Your solution should instantiate exactly 3 instances
    // of a pipelined isqrt module, which computes the integer square root.
    //
    // 3. Your solution should use circular buffers instead of shift registers
    // which were used in 06_04_formula_2_pipe.sv.
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.org/fsm#state_0


endmodule
