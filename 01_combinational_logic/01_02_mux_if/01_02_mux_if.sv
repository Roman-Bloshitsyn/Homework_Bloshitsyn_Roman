//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module mux_2_1
(
  input        [3:0] d0, d1,
  input              sel,
  output logic [3:0] y
);

  always_comb
    if (sel)
      y = d1;
    else
      y = d0;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module mux_4_1
(
  input        [3:0] d0, d1, d2, d3,
  input        [1:0] sel,
  output logic [3:0] y
);

//-----------------------------------------------------
//First approach

  // logic [3:0] a; 
  // logic [3:0] b;
  
  // always_comb begin
  //   if (sel[0])
  //     a = d1;
  //   else
  //     a = d0;

  //   if (sel[0])
  //     b = d3;
  //   else
  //     b = d2;

  //   if (sel[1])
  //     y = b;
  //   else
  //     y = a;
  // end

//------------------------------------------------------
//Second approach

  always_comb
  if (sel == 2'd0)
    y = d0;
  else if (sel == 2'd1)
    y = d1;
  else if (sel == 2'd2)
    y = d2;
  else
    y = d3;

  // Task:
  // Using code for mux_2_1 as an example,
  // write code for 4:1 mux using the "if" statement


endmodule
