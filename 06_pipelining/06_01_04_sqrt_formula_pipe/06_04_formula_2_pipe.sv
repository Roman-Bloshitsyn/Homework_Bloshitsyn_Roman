//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_pipe
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
    logic [31:0] shift_reg_b [15:0];
    logic [31:0] shift_reg_a [32:0];
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
        .x_vld (shrek_vld_b [16]),
        .x (sum_bc),
        .y_vld (y_vld_bc),
        .y (isqrt_bc)
    );  

    isqrt isqrt_3 
    (
        .clk (clk),
        .rst (rst),
        .x_vld (shrek_vld_a [33]),
        .x (sum_bca),
        .y_vld (y_vld_bca),
        .y (isqrt_bca)
    );

//------------------------------------------------------------------------------------------
//Сдвиговые регистры входящих данных

    always_ff @(posedge clk)
    begin
        shift_reg_b [0] <= b;

        for(int i = 1; i < 16; i++)
        shift_reg_b [i] <= shift_reg_b [i - 1];
    end

    always_ff @(posedge clk)
    begin
        shift_reg_a [0] <= a;

        for(int i = 1; i < 33; i++)
        shift_reg_a [i] <= shift_reg_a [i - 1];
    end

//------------------------------------------------------------------------------------------
//Сдвиговые регистры валидных сигналов (shreg - shift reg, a далее как shrek XD)

    logic [16:0] shrek_vld_b;
    logic [33:0] shrek_vld_a;

    always_ff @ (posedge clk)
        if (rst) 
            shrek_vld_b <= '0;
        else
            shrek_vld_b <= { shrek_vld_b [15:0], arg_vld };

    always_ff @ (posedge clk)
        if (rst) 
            shrek_vld_a <= '0;
        else
            shrek_vld_a <= { shrek_vld_a [32:0], arg_vld };

//-------------------------------------------------------------------------------------------
//Регистры для записи результатов
   
    always_ff @ (posedge clk)
        if (rst) 
            sum_bc <= '0;
        else if (y_vld_c)
            sum_bc <= shift_reg_b [15] + 32' (isqrt_c);

    always_ff @ (posedge clk)
        if (rst)
            sum_bca <= '0;
        else if (y_vld_bc)
            sum_bca <= shift_reg_a [32] + 32' (isqrt_bc);

   assign res = y_vld_bca ? isqrt_bca : '0;
   assign res_vld = y_vld_bca;

//-------------------------------------------------------------------------------------------

    // Task:
    //
    // Implement a pipelined module formula_2_pipe that computes the result
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
    // 3. Your solution should save dynamic power by properly connecting
    // the valid bits.
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.org/fsm#state_0


endmodule
