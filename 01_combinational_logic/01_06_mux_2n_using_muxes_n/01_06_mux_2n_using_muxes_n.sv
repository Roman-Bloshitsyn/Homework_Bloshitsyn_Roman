//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module mux_2_1
(
  input  [3:0] d0, d1,
  input        sel,
  output [3:0] y
);

  assign y = sel ? d1 : d0;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//Fixed: a more elegant notation for the connected instances

module mux_4_1
(
  input  [3:0] d0, d1, d2, d3,
  input  [1:0] sel,
  output [3:0] y
);
wire [0:3] n1;
wire [0:3] n2;

mux_2_1 mux_1 (
          .d0  (d0), 
          .d1  (d1),
          .sel (sel[0]), 
          .y   (n1)
);
  
mux_2_1 mux_2 (
          .d0  (d2), 
          .d1  (d3),
          .sel (sel[0]), 
          .y   (n2)
);
 
mux_2_1 mux_3 (
          .d0  (n1), 
          .d1  (n2),
          .sel (sel[1]), 
          .y   (y)
);
             
  





  
  // Task:
  // Implement mux_4_1 using three instances of mux_2_1


endmodule
