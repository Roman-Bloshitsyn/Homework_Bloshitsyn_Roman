//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module add
(
  input  [3:0] a, b,
  output [3:0] sum
);

  assign sum = a + b;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module signed_add_with_saturation
(
  input  [3:0] a, b,
  output [3:0] sum
);
  wire overflow;
  logic [3:0] max;
  logic [3:0] min;
  logic [3:0] out;
  logic [3:0] out_1;
 
  assign out = a + b;
  assign max = 4'b0111;
  assign min = 4'b1000;
  assign overflow = ((a[3] == b[3]) & (out[3] != a[3])); 

  assign sum = (~overflow) ? (a + b) : (a[3] == 1'b1) ? min : max;	

  


  // Task:
  //
  // Implement a module that adds two signed numbers with saturation.
  //
  // "Adding with saturation" means:
  //
  // When the result does not fit into 4 bits,
  // and the arguments are positive,
  // the sum should be set to the maximum positive number.
  //
  // When the result does not fit into 4 bits,
  // and the arguments are negative,
  // the sum should be set to the minimum negative number.


endmodule
