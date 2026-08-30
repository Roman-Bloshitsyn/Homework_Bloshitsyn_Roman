module sqrt_formula_distributor
# (
    parameter formula = 1,
              impl    = 1
)
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

    localparam N = 50;

//---------------------------------------------------------------------
//Счетчик индекса и присваение ИСТИНА текущему индексу

    logic [$clog2(N) - 1:0] index_cnt;   // Счетчик индекса
    logic index_v;                       // Значение текущего индекса (value)

    always_ff @ (posedge clk)
        if (rst)
            index_cnt <= '0;
        else if (arg_vld)
                index_cnt <= (index_cnt == N - 1) ? '0 : index_cnt + 'd1;
             
    always_comb 
    begin
        index_v = 1'b0;

        if (arg_vld)
            index_v = 1'b1;
    end

//---------------------------------------------------------------------
//Регистр для запоминания a, b, c 

    logic [31:0] reg_a [0:N - 1];
    logic [31:0] reg_b [0:N - 1];
    logic [31:0] reg_c [0:N - 1];

    always_ff @ (posedge clk)
         if (arg_vld & index_v)
        begin
            reg_a [index_cnt] <= a;
            reg_b [index_cnt] <= b;
            reg_c [index_cnt] <= c;
        end


//---------------------------------------------------------------------
//Регистр для запоминания arg_vld

    logic [N - 1:0] reg_arg_vld;

    always_ff @ (posedge clk)
        if (rst)
            reg_arg_vld <= '0;
        else 
        begin
            reg_arg_vld <= '0;
            
            if (index_v)
                reg_arg_vld [index_cnt] <= arg_vld;
        end

//---------------------------------------------------------------------
//Вызов инстансов для вычисления формул

logic [N - 1:0] instance_res_vld;
logic [31:0] instance_res [0:N - 1];

genvar i;

//Формула 1, isqrt 1

generate
    if ((formula == 1) & (impl == 1))
    begin: gen_formula_1_impl_1

        for (i = 0; i < N; i++)
        begin : gen_instances

            formula_1_impl_1_top new_instance_1
            (
                .clk (clk),
                .rst (rst),
                .arg_vld (reg_arg_vld [i]),
                .a (reg_a [i]),
                .b (reg_b [i]),
                .c (reg_c [i]),
                .res_vld (instance_res_vld [i]),
                .res (instance_res [i])
            );
        end
    end

//Формула 1, isqrt 2

    if ((formula == 1) & (impl == 2))
    begin: gen_formula_1_impl_2

        for (i = 0; i < N; i++)
        begin : gen_instances

            formula_1_impl_2_top new_instance_2
            (
                .clk (clk),
                .rst (rst),
                .arg_vld (reg_arg_vld [i]),
                .a (reg_a [i]),
                .b (reg_b [i]),
                .c (reg_c [i]),
                .res_vld (instance_res_vld [i]),
                .res (instance_res [i])
            );
        end
    end

//Формула 2

    if (formula == 2)
    begin: gen_formula_2

        for (i = 0; i < N; i++)
        begin : gen_instances

            formula_2_top new_instance_3
            (
                .clk (clk),
                .rst (rst),
                .arg_vld (reg_arg_vld [i]),
                .a (reg_a [i]),
                .b (reg_b [i]),
                .c (reg_c [i]),
                .res_vld (instance_res_vld [i]),
                .res (instance_res [i])
            );
        end
    end

endgenerate

//---------------------------------------------------------------------
//res_vld ИСТИНА если готово хотя бы одно значение

    assign res_vld = |instance_res_vld;

//---------------------------------------------------------------------
//Вывод результата соответствующего инстанса
    
    logic [31:0] res_1;

    always_comb
    begin
        res_1 = '0;

        for (int i = 0; i < N; i++)
        begin
            if (instance_res_vld [i])
                res_1 = instance_res [i];
        end
    end

    assign res = res_1;

    // Task:
    //
    // Implement a module that will calculate formula 1 or formula 2
    // based on the parameter values. The module must be pipelined.
    // It should be able to accept new triple of arguments a, b, c arriving
    // at every clock cycle.
    //
    // The idea of the task is to implement hardware task distributor,
    // that will accept triplet of the arguments and assign the task
    // of the calculation formula 1 or formula 2 with these arguments
    // to the free FSM-based internal module.
    //
    // The first step to solve the task is to fill 03_04 and 03_05 files.
    //
    // Note 1:
    // Latency of the module "formula_1_isqrt" should be clarified from the corresponding waveform
    // or simply assumed to be equal 50 clock cycles.
    //
    // Note 2:
    // The task assumes idealized distributor (with 50 internal computational blocks),
    // because in practice engineers rarely use more than 10 modules at ones.
    // Usually people use 3-5 blocks and utilize stall in case of high load.
    //
    // Hint:
    // Instantiate sufficient number of "formula_1_impl_1_top", "formula_1_impl_2_top",
    // or "formula_2_top" modules to achieve desired performance.


endmodule
