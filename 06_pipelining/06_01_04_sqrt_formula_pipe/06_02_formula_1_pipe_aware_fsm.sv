//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_pipe_aware_fsm
(
    input               clk,
    input               rst,

    input               arg_vld,
    input        [31:0] a,
    input        [31:0] b,
    input        [31:0] c,

    output logic        res_vld,
    output logic [31:0] res,

    // isqrt interface

    output logic        isqrt_x_vld,
    output logic [31:0] isqrt_x,

    input               isqrt_y_vld,
    input        [15:0] isqrt_y
);

//----------------------------------------------------------------------------
//Fixed: the data registers have been pulled out from under the reset
    
    logic [31:0] reg_b, reg_c_1, reg_c_2;

    enum logic[2:0]
    {
        st_idle = 3'd0,
        st_take_b = 3'd1,
        st_take_c = 3'd2,
        st_wait_a = 3'd3,
        st_wait_b = 3'd4,
        st_wait_c = 3'd5
    }
    state, next_state;

    always_comb
    begin
        
        next_state = state;

        isqrt_x_vld = '0;
        isqrt_x     =  a;  //<-- removed 'x

        case (state)
        st_idle:
        begin
            isqrt_x = a;

            if (arg_vld) begin
                isqrt_x_vld = 1'b1;
                next_state = st_take_b;
            end
        end

        st_take_b:
        begin
            isqrt_x = reg_b;
            isqrt_x_vld = 1'b1;
            next_state = st_take_c;
        end

        st_take_c:
        begin
            isqrt_x = reg_c_2;
            isqrt_x_vld = 1'b1;
            next_state = st_wait_a;
        end

        st_wait_a:
        begin
            if (isqrt_y_vld)
                next_state = st_wait_b;
        end

        st_wait_b:
        begin
            if (isqrt_y_vld)
                next_state = st_wait_c;
        end

        st_wait_c:
        begin
            if (isqrt_y_vld)
                next_state = st_idle;
        end
        endcase
    end

//----------------------------------------------------------------------------
//Запись результата

    always_ff @(posedge clk)
        if (state == st_idle)
            res <= '0;
        else if (isqrt_y_vld)
            res <= res + 32' (isqrt_y);
    
    always_ff @(posedge clk)
        if (rst)
            res_vld <= '0;
        else
            res_vld <= (state == st_wait_c & isqrt_y_vld);

//----------------------------------------------------------------------------
//Переход к следующему состоянию

    always_ff @ (posedge clk)
        if (rst)
            state <= st_idle;
        else
            state <= next_state;

//----------------------------------------------------------------------------
//Регистры

    always_ff @ (posedge clk)
    begin
        reg_b <= b;
        reg_c_1 <= c;
        reg_c_2 <= reg_c_1;
    end
            

    // Task:
    //
    // Implement a module formula_1_pipe_aware_fsm
    // with a Finite State Machine (FSM)
    // that drives the inputs and consumes the outputs
    // of a single pipelined module isqrt.
    //
    // The formula_1_pipe_aware_fsm module is supposed to be instantiated
    // inside the module formula_1_pipe_aware_fsm_top,
    // together with a single instance of isqrt.
    //
    // The resulting structure has to compute the formula
    // defined in the file formula_1_fn.svh.
    //
    // The formula_1_pipe_aware_fsm module
    // should NOT create any instances of isqrt module,
    // it should only use the input and output ports connecting
    // to the instance of isqrt at higher level of the instance hierarchy.
    //
    // All the datapath computations except the square root calculation,
    // should be implemented inside formula_1_pipe_aware_fsm module.
    // So this module is not a state machine only, it is a combination
    // of an FSM with a datapath for additions and the intermediate data
    // registers.
    //
    // Note that the module formula_1_pipe_aware_fsm is NOT pipelined itself.
    // It should be able to accept new arguments a, b and c
    // arriving at every N+3 clock cycles.
    //
    // In order to achieve this latency the FSM is supposed to use the fact
    // that isqrt is a pipelined module.
    //
    // For more details, see the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.org/fsm#state_0


endmodule
