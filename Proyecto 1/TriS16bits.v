//////////////////////////////////////////////////////////////////////////////////////////////////////
//
// TriS16bits.v
// 
// Este modulo sirve como triestado de 16 bits
//
//////////////////////////////////////////////////////////////////////////////////////////////////////


module TriS16bits (
    input [15:0] IN,
    input SEL, 
    output wire [15:0] OUT
);

assign OUT = SEL ? IN : 16'bz;
    
endmodule


//varios dispositivos pueden compartir una línea o bus, pero solo uno debe conducir 
//en un momento dado. Usar Z (alta impedancia) permite que un módulo "se desconecte" del bus cuando no le toca transmitir.







