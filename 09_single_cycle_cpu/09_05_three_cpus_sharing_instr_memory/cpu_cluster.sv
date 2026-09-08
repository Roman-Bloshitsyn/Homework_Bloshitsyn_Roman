//
//  schoolRISCV - small RISC-V CPU
//
//  Originally based on Sarah L. Harris MIPS CPU
//  & schoolMIPS project.
//
//  Copyright (c) 2017-2020 Stanislav Zhelnio & Aleksandr Romanov.
//
//  Modified in 2024 by Yuri Panchul & Mike Kuskov
//  for systemverilog-homework project.
//

module cpu_cluster
#(
    parameter nCPUs = 3
)
(
    input                        clk,      // clock
    input                        rst,      // reset

    input   [nCPUs - 1:0][31:0]  rstPC,    // program counter set on reset
    input   [nCPUs - 1:0][ 4:0]  regAddr,  // debug access reg address
    output  [nCPUs - 1:0][31:0]  regData   // debug access reg data
);
    logic [nCPUs - 1:0] gnt;
    logic [nCPUs - 1:0][31:0] imAddr;
    logic [31:0] imData;
    
    genvar i;

    generate
        for (i = 0; i < nCPUs; i ++)
        begin : gen_cpu
            sr_cpu cpu
            (
                .clk (clk),
                .rst (rst),
                .rstPC (rstPC [i]),
                .regAddr (regAddr [i]),
                .regData (regData [i]),
                .imDataVld ( gnt [i] ),
                .imAddr ( imAddr [i] ),
                .imData ( imData )
            );
        end
    endgenerate

    round_robin_arbiter_8 arbiter
    (
        .clk      ( clk      ),
        .rst      ( rst      ),
        .req      ( { nCPUs { 1'b1 } } ),
        .gnt      ( gnt      )
    );

    logic [31:0] immAddrwin;

    always_comb
    begin
        immAddrwin = 1'b0;

        for (int j = 0; j < nCPUs; j ++)
            if (gnt [j])
                immAddrwin = imAddr [j];
    end
    
    instruction_rom rom
    (
        .a   ( immAddrwin ),
        .rd  ( imData     )
    );
endmodule
