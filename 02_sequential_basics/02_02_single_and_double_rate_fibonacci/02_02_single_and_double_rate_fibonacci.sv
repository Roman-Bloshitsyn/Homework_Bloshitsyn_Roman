//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module fibonacci
(
  input               clk,
  input               rst,
  output logic [15:0] num
);

  logic [15:0] num2;

  always_ff @ (posedge clk)
    if (rst)
      { num, num2 } <= { 16'd1, 16'd1 };
    else
      { num, num2 } <= { num2, num + num2 };

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module fibonacci_2
(
  input               clk,
  input               rst,
  output logic [15:0] num,
  output logic [15:0] num2
);


logic [15:0] num3;
logic [15:0] num4;

always_ff @ (posedge clk) begin
    if (rst) begin
      num <= 'd1;
      num2 <= 'd1;
      num3 <= 'd2;
      num4 <= 'd3;
    end
    else begin
      num <= num3;
      num2 <= num4;
      num3 <= num3 + num4;
      num4 <= num4 + num4 + num3;

    end
end
            


  // Task:
  // Implement a module that generates two fibonacci numbers per cycle


endmodule
