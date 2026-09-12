//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_pipe_using_fifos
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

//----------------------------------------------------------------------------
//The res multiplexing has been removed and,
//The if-else was fixed for vld_sumbc and vld_sumbca

    logic y_vld_c, y_vld_bc, y_vld_bca;
    logic [31:0] sum_bc, sum_bca;
    logic [31:0] isqrt_c, isqrt_bc, isqrt_bca;

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
        .x_vld (vld_sumbc),
        .x (sum_bc),
        .y_vld (y_vld_bc),
        .y (isqrt_bc)
    );

    isqrt isqrt_3 
    (
        .clk (clk),
        .rst (rst),
        .x_vld (vld_sumbca),
        .x (sum_bca),
        .y_vld (y_vld_bca),
        .y (isqrt_bca)
    );

//------------------------------------------------------------------------------------
//Вызов двух модулей fifo для хранения входящих данных a и b

    logic [31:0] f_a, f_b;

    flip_flop_fifo_with_counter #(.width (32), .depth (33)) fifo_a
    (
        .clk (clk),
        .rst (rst),
        .push (arg_vld),
        .pop (y_vld_bc),
        .write_data (a),
        .read_data (f_a)
    );
    
    flip_flop_fifo_with_counter #(.width (32), .depth (16)) fifo_b
    (
        .clk (clk),
        .rst (rst),
        .push (arg_vld),
        .pop (y_vld_c),
        .write_data (b),
        .read_data (f_b)
    );
//-------------------------------------------------------------------------
// Регистры для хранения валидных сигналов

    logic vld_sumbc, vld_sumbca;

    always_ff @ (posedge clk)
        if (rst)
            vld_sumbc <= '0;
        else 
            vld_sumbc <= y_vld_c;

    always_ff @ (posedge clk)
        if (rst)
            vld_sumbca <= '0;
        else
            vld_sumbca <= y_vld_bc;

//-------------------------------------------------------------------------------------------
//Регистры для записи результатов
   
    always_ff @ (posedge clk)
        if (rst) 
            sum_bc <= '0;
        else if (y_vld_c)
            sum_bc <= f_b + 32' (isqrt_c);

    always_ff @ (posedge clk)
        if (rst)
            sum_bca <= '0;
        else if (y_vld_bc)
            sum_bca <= f_a + 32' (isqrt_bc);

   assign res = isqrt_bca;
   assign res_vld = y_vld_bca;

//-------------------------------------------------------------------------
    // Task:
    //
    // Implement a pipelined module formula_2_pipe_using_fifos that computes the result
    // of the formula defined in the file formula_2_fn.svh.
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
    // 3. Your solution should use FIFOs instead of shift registers
    // which were used in 06_04_formula_2_pipe.sv.
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.org/fsm#state_0


endmodule
