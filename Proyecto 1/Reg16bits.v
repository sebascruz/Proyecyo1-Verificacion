//////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Reg16bits.v
// 
// Este modulo sirve como para crear los registros de 16 bits
//
//////////////////////////////////////////////////////////////////////////////////////////////////////

module Reg16bits (
    input CLK, 
    input RST, 
    input WriteEnable,
    input [15:0] D,
    output reg [15:0] Q 
);
 

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 16'b0;
    else if (WriteEnable)
        Q <= D; 
end
 


endmodule