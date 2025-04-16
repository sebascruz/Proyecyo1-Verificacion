//////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Top_tb.v
// 
// Este modulo sirve como testbench del modulo top
//
//////////////////////////////////////////////////////////////////////////////////////////////////////


`timescale 1ns/1ns
`include "Top.v"

module BancoDeRegistros8088_tb ();

//Declaración de señales del testbench
reg CLK;
reg RST;
reg RD;
reg WR;
reg [3:0] SEL;


// Señales para controlar el bus inout
reg [15:0] DATA_drive;
reg DATA_en;
wire [15:0] DATA;

// Simulación del comportamiento triestado del bus
assign DATA = DATA_en ? DATA_drive : 16'bz;

//Instanciación del modulo BancoDeRegistros8088
BancoDeRegistros8088 DUT(
    .CLK(CLK),
    .RST(RST),
    .RD(RD),
    .WR(WR),
    .SEL(SEL),
    .DATA(DATA)
);


//creacion del reloj
initial begin
    CLK = 0;
    forever #10 CLK =~ CLK;
end



initial begin

    $dumpfile("Top_tb.vcd");
    $dumpvars(0, BancoDeRegistros8088_tb);


    // Reset inicial
    RST = 1; WR = 0; RD = 0; SEL = 0;
    DATA_drive = 16'h0000;
    DATA_en = 0;
    #20 RST = 0;



//inicio de pruebas
    #50

///////////////////////////////////////////////////////////////////
 //Escritura y lectura en AL

    //escritura en registro AL (SEL = 4'b0000)
    SEL = 4'b0000;
    DATA_drive = 16'h00A1; //Dato a escribir
    DATA_en = 1;          //Conducir al bus
    WR = 1;


    #20;


    WR = 0;
    DATA_en = 0;          //Soltar el bus


    //Lectura desde AL
    #20;
    SEL = 4'b0000;
    RD = 1;
    #20;
    $display("Lectura desde AL: %h", DATA);
    RD = 0;
///////////////////////////////////////////////////////////////////




///////////////////////////////////////////////////////////////////
 //Escritura y lectura en AH

    #20;
    //escritura en registro AH (SEL = 4'b0100)
    SEL = 4'b0100; //AH
    DATA_drive = 16'hA200; //Solo byte alto
    DATA_en = 1;           //Conducir al bus
    WR = 1;


    #20;


    WR = 0;
    DATA_en = 0;        //Soltar el bus


    // Lectura desde AH
    #20;
    SEL = 4'b0100;
    RD = 1;
    #20;
    $display("Lectura desde AH: %h", DATA);
    RD = 0;
///////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////
// Escritura y lectura en CL

    #20;

    //escritura en registro CL (SEL = 4'b0001)     
    SEL = 4'b0001; // CL
    DATA_drive = 16'h00C1; //Solo byte bajo
    DATA_en = 1; //Conducir al bus
    WR = 1;


    #20;


    WR = 0;
    DATA_en = 0; //Soltar el bus

   // Lectura desde CL
    #20;
    SEL = 4'b0001;
    RD = 1;
    #20;
    $display("Lectura desde CL: %h", DATA);
    RD = 0;
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
// Escritura y lectura en CH

    #20;

    //escritura en registro CH (SEL = 4'b0101)
    SEL = 4'b0101; // CH
    DATA_drive = 16'hC200; //Solo byte alto
    DATA_en = 1; //Conducir al bus
    WR = 1;

    
    #20;
    
    
    WR = 0;
    DATA_en = 0; //Soltar el bus

  // Lectura desde CH
    #20;
    SEL = 4'b0101;
    RD = 1;
    #20;
    $display("Lectura desde CH: %h", DATA);
    RD = 0;
///////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////
// Escritura y lectura en DL

    #20;

    //escritura en registro DL (SEL = 4'b0010)    
    SEL = 4'b0010; // DL
    DATA_drive = 16'h00D1; //Solo byte bajo
    DATA_en = 1; //Conducir al bus
    WR = 1;


    #20;
    
    
    WR = 0;
    DATA_en = 0; //Soltar el bus

   // Lectura desde DL
    #20;
    SEL = 4'b0010;
    RD = 1;
    #20;
    $display("Lectura desde DL: %h", DATA);
    RD = 0;
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
// Escritura y lectura en DH

    #20;

    //escritura en registro DH (SEL = 4'b0110)
    SEL = 4'b0110; // DH
    DATA_drive = 16'hD200; //Solo byte alto
    DATA_en = 1; //Conducir al bus
    WR = 1;


    #20;
    
    
    WR = 0;
    DATA_en = 0; //Soltar el bus

   // Lectura desde DH
    #20;
    SEL = 4'b0110;
    RD = 1;
    #20;
    $display("Lectura desde DH: %h", DATA);
    RD = 0;
///////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////
// Escritura y lectura en BL

    #20;

    //escritura en registro BL (SEL = 4'b0011)
    SEL = 4'b0011; // BL
    DATA_drive = 16'h00B1; //Solo byte bajo
    DATA_en = 1; //Conducir al bus
    WR = 1;
    
    
    #20;
    
    
    WR = 0;
    DATA_en = 0; //Soltar el bus

   // Lectura desde BL
    #20;
    SEL = 4'b0011;
    RD = 1;
    #20;
    $display("Lectura desde BL: %h", DATA);
    RD = 0;
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
// Escritura y lectura en BH

    #20;

    //escritura en registro BH (SEL = 4'b0111)
    SEL = 4'b0111; // BH
    DATA_drive = 16'hB200; //Solo byte alto
    DATA_en = 1; //Conducir al bus
    WR = 1;

    
    #20;
    
    
    WR = 0;
    DATA_en = 0; //Soltar el bus

   // Lectura desde BH
    #20;
    SEL = 4'b0111;
    RD = 1;
    #20;
    $display("Lectura desde BH: %h", DATA);
    RD = 0;
///////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////
// Escritura y lectura en AX

    #20;

    //escritura en registro BX (SEL = 4'b1000)
    SEL = 4'b1000;        // AX
    DATA_drive = 16'hA3A4; //Ambos, byte alto y bajo
    DATA_en = 1; //Conducir al bus
    WR = 1;
    
    
    #20;
    
    
    WR = 0;
    DATA_en = 0; //Soltar el bus

    // Lectura desde AX
    #20;
    SEL = 4'b1000;
    RD = 1;
    #20;
    $display("Lectura desde AX: %h", DATA);
    RD = 0;
///////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////
// Escritura y lectura en CX

    #20;

    //escritura en registro BX (SEL = 4'b1001)
    SEL = 4'b1001;        // CX
    DATA_drive = 16'hC3C4; //Ambos, byte alto y bajo
    DATA_en = 1; //Conducir al bus
    WR = 1;


    #20;


    WR = 0;
    DATA_en = 0; //Soltar el bus


    // Lectura desde CX
    #20;
    SEL = 4'b1001;
    RD = 1;
    #20;
    $display("Lectura desde CX: %h", DATA);
    RD = 0;
///////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////
// Escritura y lectura en DX

    #20;

    //escritura en registro DX (SEL = 4'b1010)
    SEL = 4'b1010;        // DX
    DATA_drive = 16'hD3D4; //Ambos, byte alto y bajo
    DATA_en = 1; //Conducir al bus
    WR = 1;


    #20;
    
    
    WR = 0;
    DATA_en = 0; //Soltar el bus


    // Lectura desde DX
    #20;
    SEL = 4'b1010;
    RD = 1;
    #20;
    $display("Lectura desde DX: %h", DATA);
    RD = 0;
///////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////
// Escritura y lectura en BX

    #20;
    
    //escritura en registro BX (SEL = 4'b1011)
    SEL = 4'b1011;        // BX
    DATA_drive = 16'hB3B4; //Ambos, byte alto y bajo
    DATA_en = 1; //Conducir al bus
    WR = 1;


    #20;


    WR = 0;
    DATA_en = 0; //Soltar el bus


    // Lectura desde BX
    #20;
    SEL = 4'b1011;
    RD = 1;
    #20;
    $display("Lectura desde BX: %h", DATA);
    RD = 0;
///////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////
// Escritura y lectura en SP

    #20;
    //escritura en registro SP (SEL = 4'b1100)
    SEL = 4'b1100;        // SP
    DATA_drive = 16'h1234;
    DATA_en = 1; //Conducir al bus
    WR = 1;


    #30;


    WR = 0;
    DATA_en = 0;//Soltar el bus


    // Lectura desde SP
    #20;
    SEL = 4'b1100;
    RD = 1;
    #20;
    $display("Lectura desde SP: %h", DATA);
    RD = 0;
    #50
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
// Escritura y lectura en BP

    #20;
    //escritura en registro BP (SEL = 4'b1101)
    SEL = 4'b1101;        // BP
    WR = 1;
    DATA_drive = 16'h2345;
    DATA_en = 1; //Conducir al bus



    #30;


    WR = 0;
    DATA_en = 0;//Soltar el bus


    // Lectura desde BP
    #20;
    SEL = 4'b1101;
    RD = 1;
    #20;
    $display("Lectura desde BP: %h", DATA);
    RD = 0;
    #50
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
// Escritura y lectura en SI

    #20;
    //escritura en registro SI (SEL = 4'b1110)
    SEL = 4'b1110;        // SI
    WR = 1;
    DATA_drive = 16'h3456;
    DATA_en = 1; //Conducir al bus



    #30;


    WR = 0;
    DATA_en = 0;//Soltar el bus


    // Lectura desde SI
    #20;
    SEL = 4'b1110;
    RD = 1;
    #20;
    $display("Lectura desde SI: %h", DATA);
    RD = 0;
    #50
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
// Escritura y lectura en DI

    #20;
    //escritura en registro DI (SEL = 4'b1111)
    SEL = 4'b1111;        // DI
    WR = 1;
    DATA_drive = 16'h4567;
    DATA_en = 1; //Conducir al bus



    #30;


    WR = 0;
    DATA_en = 0;//Soltar el bus


    // Lectura desde DI
    #20;
    SEL = 4'b1111;
    RD = 1;
    #20;
    $display("Lectura desde DI: %h", DATA);
    RD = 0;
    #50
///////////////////////////////////////////////////////////////////


    $display("Test completado");
    $finish;

end

endmodule