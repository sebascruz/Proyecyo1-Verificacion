//////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Registros.v
// 
// Este modulo sirve como modulo para "crear" los registros
//
//////////////////////////////////////////////////////////////////////////////////////////////////////


module Registros (
    input CLK, 
    input RST, 
    input SEL,  
    input SEL_H_L,            
    input [15:0] DATA, 
    input [11:0] WE,

    output wire [7:0] AL, 
    output wire [7:0] CL, 
    output wire [7:0] DL, 
    output wire [7:0] BL, 
    output wire [7:0] AH, 
    output wire [7:0] CH, 
    output wire [7:0] DH, 
    output wire [7:0] BH,

    output wire [15:0] SP,  
    output wire [15:0] BP,
    output wire [15:0] SI,
    output wire [15:0] DI 
);

    
//Llamada al mux para selecionar High o Low en los registros de 8 bits
wire [7:0] Temp;
Mux2x8 mux2x8 (DATA[7:0], DATA [15:8], SEL_H_L, Temp);

//Llamada a Reg8bits para "crear" los registros de 8 bits
Reg8bits RegAL (CLK, RST, WE[11], DATA[7:0], AL); 
Reg8bits RegCL (CLK, RST, WE[10], DATA[7:0], CL); 
Reg8bits RegDL (CLK, RST, WE[9], DATA[7:0], DL); 
Reg8bits RegBL (CLK, RST, WE[8], DATA[7:0], BL); 
Reg8bits RegAH (CLK, RST, WE[7], Temp, AH); 
Reg8bits RegCH (CLK, RST, WE[6], Temp, CH); 
Reg8bits RegDH (CLK, RST, WE[5], Temp, DH); 
Reg8bits RegBH (CLK, RST, WE[4], Temp, BH); 

//Llamada a Reg16bits para "crear" los registros de 16 bits

Reg16bits RegSP (CLK, RST, WE[3], DATA, SP); 
Reg16bits RegBP (CLK, RST, WE[2], DATA, BP); 
Reg16bits RegSI (CLK, RST, WE[1], DATA, SI); 
Reg16bits RegDI (CLK, RST, WE[0], DATA, DI); 

endmodule
