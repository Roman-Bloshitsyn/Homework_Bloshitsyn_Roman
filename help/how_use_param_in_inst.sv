    shift_register # (.width(32), .depth(n_delay)) res_shift_reg
    (
        .clk              (clk),
        .in_data  (srcA * srcB),
        .out_data (result)
    );