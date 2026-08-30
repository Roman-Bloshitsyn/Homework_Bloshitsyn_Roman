module float_discriminant_distributor (
    input                           clk,
    input                           rst,

    input                           arg_vld,
    input        [FLEN - 1:0]       a,
    input        [FLEN - 1:0]       b,
    input        [FLEN - 1:0]       c,

    output logic                    res_vld,
    output logic [FLEN - 1:0]       res,
    output logic                    res_negative,
    output logic                    err,

    output logic                    busy
);

    localparam N = 10;

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

    logic [FLEN - 1:0] reg_a [0:N - 1];
    logic [FLEN - 1:0] reg_b [0:N - 1];
    logic [FLEN - 1:0] reg_c [0:N - 1];

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
//Вызов инстансов для вычисления формулы

logic [N - 1:0] instance_res_vld;
logic [N - 1:0] instance_res_negative;
logic [N - 1:0] instance_busy;
logic [N - 1:0] instance_err;
logic [FLEN - 1:0] instance_res [0:N - 1];

genvar i;

generate
        for (i = 0; i < N; i++)
        begin : gen_instances

            float_discriminant new_instance_1
            (
                .clk (clk),
                .rst (rst),
                .arg_vld (reg_arg_vld [i]),
                .busy (instance_busy [i]),
                .a (reg_a [i]),
                .b (reg_b [i]),
                .c (reg_c [i]),
                .err (instance_err [i]),
                .res_vld (instance_res_vld [i]),
                .res_negative (instance_res_negative [i]),
                .res (instance_res [i])
            );
        end
endgenerate

//---------------------------------------------------------------------
//res_vld и busy ИСТИНА если готово хотя бы одно значение

    assign res_vld = |instance_res_vld;
    assign busy = |instance_busy;
    assign err = |instance_err;

//---------------------------------------------------------------------
//Вывод результата соответствующего инстанса

    always_comb
    begin
        res = '0;
        res_negative = '0;

        for (int i = 0; i < N; i++)
        begin
            if (instance_res_vld [i])
            begin
                res = instance_res [i];
                res_negative = instance_res_negative [i];
            end
        end
    end


    // Task:
    //
    // Implement a module that will calculate the discriminant based
    // on the triplet of input number a, b, c. The module must be pipelined.
    // It should be able to accept a new triple of arguments on each clock cycle
    // and also, after some time, provide the result on each clock cycle.
    // The idea of the task is similar to the task 04_11. The main difference is
    // in the underlying module 03_08 instead of formula modules.
    //
    // Note 1:
    // Reuse your file "03_08_float_discriminant.sv" from the Homework 03.
    //
    // Note 2:
    // Latency of the module "float_discriminant" should be clarified from the waveform.


endmodule
