//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module double_tokens
(
    input        clk,
    input        rst,
    input        a,
    output       b,
    output logic overflow
);
    logic [7:0] cnt;

    assign b = a | (cnt != '0);

    always_ff @ (posedge clk)
        if (rst)
            cnt <= 'b0;
        else if (a)
                cnt <= cnt + 1'd1;
            else
                cnt <= (cnt == '0) ? '0 : (cnt - 1'd1);
        
    always_ff @ (posedge clk)
        if (rst)
            overflow <= 1'b0;
        else if (cnt >= 'd199) 
            overflow <= 1'b1;


    // Task:
    // Implement a serial module that doubles each incoming token '1' two times.
    // The module should handle doubling for at least 200 tokens '1' arriving in a row.
    //
    // In case module detects more than 200 sequential tokens '1', it should assert
    // an overflow error. The overflow error should be sticky. Once the error is on,
    // the only way to clear it is by using the "rst" reset signal.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // a -> 10010011000110100001100100
    // b -> 11011011110111111001111110


endmodule
