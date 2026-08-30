//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module float_discriminant (
    input                     clk,
    input                     rst,

    input                     arg_vld,
    input        [FLEN - 1:0] a,
    input        [FLEN - 1:0] b,
    input        [FLEN - 1:0] c,

    output logic              res_vld,
    output logic [FLEN - 1:0] res,
    output logic              res_negative,
    output logic              err,

    output logic              busy
);
    localparam [FLEN - 1:0] four = 64'h4010_0000_0000_0000;
    logic [FLEN - 1:0] mult_a, mult_b, mult_res, sub_res, sub_a, sub_b;
    logic mult_up_valid, mult_down_valid, mult_busy, mult_err;
    logic sub_up_valid, sub_down_valid, sub_busy, sub_err;

    f_mult mult 
    (
        .clk       (clk),
        .rst       (rst),
        .a         (mult_a),
        .b         (mult_b),        
        .up_valid  (mult_up_valid), 
        .res       (mult_res),    
        .down_valid(mult_down_valid),
        .busy      (mult_busy),   
        .error     (mult_err)
    );
       
    f_sub sub
    (
        .clk       (clk),
        .rst       (rst),
        .a         (sub_a),
        .b         (sub_b),        
        .up_valid  (sub_up_valid), 
        .res       (sub_res),    
        .down_valid(sub_down_valid),
        .busy      (sub_busy),   
        .error     (sub_err)
    );

    enum logic [2:0]
    {
        multiply_bb = 3'b000,
        multiply_ac = 3'b001,
        multiply_4ac = 3'b010,
        sub_bb_4ac = 3'b011,
        wait_sub = 3'b100
    }
    state, next_state;


    always_comb
    begin
        next_state = state;
        
        mult_a = '0;
        mult_b = '0;
        mult_up_valid = 1'b0;

        sub_a = '0;
        sub_b = '0;
        sub_up_valid = 1'b0;

        err = 1'b0;


        case(state)
        multiply_bb:
        begin
            if (arg_vld) begin
                mult_a = b;
                mult_b = b;
                mult_up_valid = 1'b1; 
                next_state = multiply_ac;
                err = mult_err;
            end 
        end

        multiply_ac:
        begin
            if (mult_down_valid) begin
                mult_a = a;
                mult_b = c;
                mult_up_valid = 1'b1;
                next_state = multiply_4ac;
                err = mult_err;
            end
        end

        multiply_4ac:
        begin
            if (mult_down_valid) begin
                mult_a = four;
                mult_b = mult_res;
                mult_up_valid = 1'b1;  
                next_state = sub_bb_4ac;
                err = mult_err;
            end
        end

        sub_bb_4ac:
        begin
            if (mult_down_valid) begin
                sub_a = mult_res_1;
                sub_b = mult_res;
                sub_up_valid = 1'b1;  
                next_state = wait_sub;
                err = mult_err;
            end
        end
        wait_sub:
        begin
            if (sub_down_valid)
                next_state = multiply_bb;
                err = sub_err;
        end
        endcase
    end

    assign busy = (state == multiply_ac) | (state == multiply_4ac) | (state == sub_bb_4ac) | (state == multiply_bb) & ~ err;

    always_ff @ (posedge clk)
        if (rst)
            res_vld <= '0;
        else 
            res_vld <= sub_down_valid;

    always_ff @ (posedge clk)
        if (state == multiply_bb) begin
            res <= '0;
            res_negative <= '0;
        end
        else if (sub_down_valid) begin
                res_negative <= sub_res [FLEN - 1];
                res <= sub_res;
        end


  logic [FLEN - 1:0] mult_res_1;

    always_ff @ (posedge clk)
        if (rst)
            mult_res_1 <= '0;
        else if (mult_down_valid & (state == multiply_ac))
                 mult_res_1 <= mult_res;
             else 
                 mult_res_1 <= mult_res_1;
       
    always_ff @ (posedge clk)
        if (rst)
            state <= multiply_bb;
        else
            state <= next_state;
                                
                            

            
        

    // Task:
    // Implement a module that accepts three Floating-Point numbers and outputs their discriminant.
    // The resulting value res should be calculated as a discriminant of the quadratic polynomial.
    // That is, res = b^2 - 4ac == b*b - 4*a*c
    //
    // Note:
    // If any argument is not a valid number, that is NaN or Inf, the "err" flag should be set.
    //
    // The FLEN parameter is defined in the "import/preprocessed/cvw/config-shared.vh" file
    // and usually equal to the bit width of the double-precision floating-point number, FP64, 64 bits.


endmodule


