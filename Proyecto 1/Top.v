//////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Top.v
// 
// Este modulo sirve como Top para el banco de registros del 8088
//
//////////////////////////////////////////////////////////////////////////////////////////////////////

`include "Registros.v"
`include "Deco.v"
`include "Mux2x8.v"
`include "Mux16x1.v"
`include "Reg8bits.v"
`include "Reg16bits.v"
`include "TriS16bits.v"


module BancoDeRegistros8088 (
    input CLK, 
    input RST, 
    input RD, 
    input WR, 
    input [3:0] SEL, 
    inout wire [15:0] DATA
);

//Llamada al deco de escritura 
wire [11:0] WE;
Deco DecoEscritura (WR, SEL, WE);

//Llamada a Registros
wire [7:0] AL, CL, DL, BL, AH, CH, DH, BH;
wire [15:0] SP, BP, SI, DI;
Registros Regs (CLK, RST, SEL[3], DATA, WE, AL, CL, DL, BL, AH, CH, DH, BH, SP, BP, SI, DI);

//Llamada a mux16x1
wire [15:0] SALIDA;
Mux16x1 MuxSalida (
    {8'b0, AL},
    {8'b0, CL},
    {8'b0, DL},
    {8'b0, BL},
    {8'b0, AH},
    {8'b0, CH},
    {8'b0, DH},
    {8'b0, BH},
    {AH, AL},
    {CH, CL},
    {DH, DL},
    {BH, BL},
    SP, 
    BP, 
    SI, 
    DI,
    SEL, 
    SALIDA);


//Llamada al tri estado
    TriS16bits TriEstado (SALIDA, RD, DATA); 
    
endmodule







