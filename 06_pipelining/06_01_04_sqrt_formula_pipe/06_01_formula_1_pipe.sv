//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_pipe
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

    logic [31:0] res_a, res_b, res_c;
    logic [31:0] sum_reg, sum;
    logic y_vld, en, res_vld_reg;


    isqrt isqrt_a  
    (
        .clk (clk),
        .rst (rst),
        .x_vld(arg_vld),
        .x(a),
        .y_vld (y_vld),
        .y(res_a)
    );

    isqrt isqrt_b  
    (
        .clk (clk),
        .rst (rst),
        .x_vld(arg_vld),
        .x(b),
        .y(res_b)
    );

    isqrt isqrt_c 
    (
        .clk (clk),
        .rst (rst),
        .x_vld(arg_vld),
        .x(c),
        .y(res_c)
    );

    assign sum = res_a + res_b + res_c;

    always_ff @(posedge clk)
        if (rst) begin
            res_vld_reg <= '0;
            sum_reg <= '0;
        end
        else if (y_vld) begin
            res_vld_reg <= '1;
            sum_reg <= sum;
        end
            else
             res_vld_reg <= '0;

    assign res = sum_reg;
    assign res_vld = res_vld_reg;






    

    // Task:
    //
    // Implement a pipelined module formula_1_pipe that computes the result
    // of the formula defined in the file formula_1_fn.svh.
    //
    // The requirements:
    //
    // 1. The module formula_1_pipe has to be pipelined.
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
