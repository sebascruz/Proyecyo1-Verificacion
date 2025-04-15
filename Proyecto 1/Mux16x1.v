//////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Mux16x1.v
//
// Este modulo sirve como Mux16x1 de salida
//
//////////////////////////////////////////////////////////////////////////////////////////////////////

module Mux16x1 (
    input [15:0] A0, 
    input [15:0] A1, 
    input [15:0] A2, 
    input [15:0] A3,
    input [15:0] A4,
    input [15:0] A5,
    input [15:0] A6,
    input [15:0] A7,
    input [15:0] A8,
    input [15:0] A9,
    input [15:0] A10,
    input [15:0] A11,
    input [15:0] A12,
    input [15:0] A13,
    input [15:0] A14,
    input [15:0] A15,
    input [3:0] SEL,
    output reg [15:0] OUT
);

always @(*) begin
    case (SEL)
        4'b0000 : OUT = A0;  //AL 
        4'b0001 : OUT = A1;  //CL 
        4'b0010 : OUT = A2;  //DL 
        4'b0011 : OUT = A3;  //BL 
        4'b0100 : OUT = A4;  //AH 
        4'b0101 : OUT = A5;  //CH 
        4'b0110 : OUT = A6;  //DH 
        4'b0111 : OUT = A7;  //BH 
        4'b1000 : OUT = A8;  //AX 
        4'b1001 : OUT = A9;  //CX 
        4'b1010 : OUT = A10; //DX 
        4'b1011 : OUT = A11; //BX 
        4'b1100 : OUT = A12; //SP 
        4'b1101 : OUT = A13; //BP 
        4'b1110 : OUT = A14; //SI 
        4'b1111 : OUT = A15; //DI 
    endcase
end

endmodule