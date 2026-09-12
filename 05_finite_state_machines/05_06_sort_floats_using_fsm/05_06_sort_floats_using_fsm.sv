//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module sort_floats_using_fsm (
    input                          clk,
    input                          rst,

    input                          valid_in,
    input        [0:2][FLEN - 1:0] unsorted,

    output logic                   valid_out,
    output logic [0:2][FLEN - 1:0] sorted,
    output logic                   err,
    output                         busy,

    // f_less_or_equal interface
    output logic      [FLEN - 1:0] f_le_a,
    output logic      [FLEN - 1:0] f_le_b,
    input                          f_le_res,
    input                          f_le_err
);
//------------------------------------------------------------
// Fixed: the busy signal output has been reworked

    enum logic[1:0]
    {
        u0_and_u1 = 2'b00,
        s1_and_u2 = 2'b01,
        s0_and_s1 = 2'b10
    }
    state, next_state;

    logic [0:2][FLEN - 1:0] stage_1;
    logic [0:2][FLEN - 1:0] stage_2;

    always_comb
    begin
        next_state = state;
        valid_out = 1'b0;
        f_le_a = '0;
        f_le_b = '0;
        err = '0;   

        case (state)
        u0_and_u1:
        begin
            if (valid_in)
            begin 
                f_le_a = unsorted [0];
                f_le_b = unsorted [1];
                next_state = s1_and_u2;
                    if (f_le_err) begin
                        valid_out = '1;
                        err = '1;
                        next_state = u0_and_u1;
                    end else if (f_le_res)
                        stage_1 = unsorted;
                    else begin
                        {stage_1 [0], stage_1 [1]} =
                        {unsorted [1], unsorted [0]};
                        stage_1 [2] = unsorted [2];
                    end
            
            end
        
        end
        s1_and_u2:
            begin
            f_le_a = stage_1 [1];
            f_le_b = unsorted [2];
            stage_2 = stage_1;
            next_state = s0_and_s1;
                    if (f_le_err) begin
                        valid_out = '1;
                        err = '1;
                        next_state = u0_and_u1;
                    end else if (f_le_res)
                        stage_2 = stage_1;
                    else begin
                        {stage_2 [2], stage_2[1]} = 
                        {stage_1 [1], stage_1 [2] };
                    end
           
            end
    

        s0_and_s1:
            begin
            f_le_a = stage_2 [0];
            f_le_b = stage_2 [1];
            sorted = stage_2;        
                    if (f_le_err) begin
                        err = '1;
                    end else if (f_le_res)
                        sorted = stage_2;
                    else
                        {sorted [0], sorted[1]} = 
                        {stage_2 [1], stage_2 [0] };
            
            valid_out = 1'b1;
            next_state = u0_and_u1;
            
            end
        
        endcase
    
    end

    assign busy = (state != u0_and_u1);

//------------------------------------------------------------
//Присваиваем следующее состояние                  
  
    always_ff @ (posedge clk)
        if (rst)
            state <= u0_and_u1;
        else
            state <= next_state;
                    
    // Task:
    // Implement a module that accepts three Floating-Point numbers and outputs them in the increasing order using FSM.
    //
    // Requirements:
    // The solution must have latency equal to the three clock cycles.
    // The solution should use the inputs and outputs to the single "f_less_or_equal" module.
    // The solution should NOT create instances of any modules.
    //
    // Notes:
    // res0 must be less or equal to the res1
    // res1 must be less or equal to the res1
    //
    // The FLEN parameter is defined in the "import/preprocessed/cvw/config-shared.vh" file
    // and usually equal to the bit width of the double-precision floating-point number, FP64, 64 bits.



endmodule
