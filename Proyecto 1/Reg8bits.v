//////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Reg8bits.v
// 
// Este modulo sirve como registros de 8 bits
//
//////////////////////////////////////////////////////////////////////////////////////////////////////

module Reg8bits (
    input CLK, 
    input RST, 
    input WriteEnable,
    input [7:0] D,
    output reg [7:0] Q 
);
    

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q = 8'b0;
    else if (WriteEnable)
        Q = D;
    else 
        Q = Q;
end

endmodule