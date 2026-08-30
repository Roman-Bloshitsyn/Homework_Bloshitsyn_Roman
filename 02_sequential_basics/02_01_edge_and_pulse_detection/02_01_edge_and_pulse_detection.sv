//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module posedge_detector (input clk, rst, a, output detected);

  logic a_r;

  // Note:
  // The a_r flip-flop input value d propogates to the output q
  // only on the next clock cycle.

  always_ff @ (posedge clk)
    if (rst)
      a_r <= '0;
    else
      a_r <= a;

  assign detected = ~ a_r & a;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module one_cycle_pulse_detector (input clk, rst, a, output detected);

logic a_r_1;
logic a_r_2;
logic save;
logic detected_1;
logic detected_2;
logic detected_sv;

always_ff @ (posedge clk)
  if (rst)
    a_r_1 <= '0;
  else 
    a_r_1 <= a;

assign detected_1 = ~ a_r_1 & a;

always_ff @ (posedge clk)
  if (rst)
    save <= '0;
  else 
    save <= detected_1;

assign detected_sv = save;

always_ff @ (posedge clk)
  if (rst)
    a_r_2 <= '0;
  else
    a_r_2 <= a;

assign detected_2 = a_r_2 & ~ a;

assign detected = detected_sv & detected_2;

  
  // Task:
  // Create an one cycle pulse (010) detector.
  //
  // Note:
  // See the testbench for the output format ($display task).


endmodule
