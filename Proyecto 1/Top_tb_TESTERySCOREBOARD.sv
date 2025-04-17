//////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Top_tb_TESTERySCOREBOARD.sv
// 
// Este modulo sirve como testbench con teste y scoreboard del modulo top
//
//////////////////////////////////////////////////////////////////////////////////////////////////////


`timescale 1ns/1ns
`include "Top.v"

module Top_tb_TESTERySCOREBOARD ();

//Declaración de señales del testbench
bit CLK;
bit RST;
bit RD;
bit WR;
bit [3:0] SEL;

reg [15:0] dato_leido;

//Variables para el scoreboard
reg scoreboard_en;
reg [3:0] reg_leido;
reg [3:0] scoreboard_SEL;
reg [15:0] scoreboard_drive;
reg [15:0] scoreboard_dato_leido;
reg [15:0] expected [0:15];



integer i;
bit lectura = 0; //senal para determinar si scoreboard de lectura o escritura
bit escritura = 0;

// Contadores
integer ok_count_escritura = 0;
integer err_count_escritura = 0;
integer ok_count_lectura = 0;
integer err_count_lectura = 0;
integer repeticion = 0;


// Señales para controlar el bus inout
bit [15:0] DATA_drive;
bit DATA_en;
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



////////////////////////////////////////////////////////////////////////
//TESTER


//creacion del reloj
initial begin
    CLK = 0;
    forever #10 CLK =~ CLK;
end


//funcion para definir si leer o escribir 

function bit obtener_operacion_RD_WR();
    bit aleatorio;
    aleatorio = $urandom;    
    return aleatorio; //si retorna 1 es lectura, si no si retorna 0 es escritura
 
endfunction : obtener_operacion_RD_WR


function bit [15:0] obtener_valor();
    bit [2:0] ceros_y_unos;
    ceros_y_unos = $urandom;

    if (ceros_y_unos == 3'b000)
        return 16'h0000;
    
    else if (ceros_y_unos == 3'b111)
        return 16'hFFFF;
    else
        return $urandom;
    
endfunction : obtener_valor


function bit [3:0] obtener_registro();
    return $urandom;
endfunction





//inicio de tester

    initial begin : tester


        $dumpfile("Top_tb_TESTERySCOREBOARD.vcd");
        $dumpvars(0, Top_tb_TESTERySCOREBOARD);
      
        // Reset inicial
        @(posedge CLK); RST = 1; WR = 0; RD = 0; SEL = 0;
                    DATA_drive = 16'h0000;
                    DATA_en = 0;
        #20 

        @(posedge CLK); 
        @(posedge CLK);
        RST = 0;
 
        for (i = 0; i < 16; i++) begin
            expected[i] = 16'h0000;
        end

//testing//////////////////////////////////////////////////////////////////////////////
        repeat (20) begin

            @(posedge CLK);
            
            repeticion++;

            //obtener operacion: lectura = 1 | escritura = 0
            RD = obtener_operacion_RD_WR();

            $display("Repeticion: %0d", repeticion);
            //$display(""); // Línea en blanco


            if (RD == 1) begin     //Lectura de registro
                lectura = 1;

                $display("Valor de RD: %b (LECTURA DE REGISTROS)", RD);
                SEL = obtener_registro();
                DATA_en = 0;
                WR = 0;


                #20;
                
                
                DATA_en = 1;
                dato_leido = DATA;
                
                $display("Leyendo registro %0d, dato_leido = %h", SEL, dato_leido);
                $display("Leyendo registro %0d, expected[SEL] = %h", SEL, expected[SEL]);
                $display(" ");

                RD = 0;
                DATA_en = 0;
                scoreboard_SEL = SEL;
                scoreboard_drive = DATA_drive;
                scoreboard_dato_leido = dato_leido;
                reg_leido = SEL;
                scoreboard_en = 1;
            end 



            else begin             //Escritura en registro
                #20;
                escritura = 1;
                $display("Valor de RD: %b (ESCRITURA DE REGISTROS)", RD);

                SEL = obtener_registro();
                DATA_drive = obtener_valor();
                DATA_en = 1;
                WR = 1;
                
                
                
                #30;
                
                
                WR = 0;
                DATA_en = 0;

                
                $display("Escribiendo %h en registro %0d", DATA_drive, SEL);


                
                
                RD = 1;


                #20;


                DATA_en = 1;
                dato_leido = DATA;
                
                
                $display("Lectura desde reg %0d: %h", SEL, dato_leido);
                $display(""); // Línea en blanco

                scoreboard_SEL = SEL;
                scoreboard_drive = DATA_drive;
                scoreboard_dato_leido = dato_leido;
                reg_leido = SEL;
                expected[SEL] = scoreboard_dato_leido;


                RD = 0;
                #20
                scoreboard_en = 1;
                

            end

        end



        $display("Tester terminado.");
        $display("Resumen final:");

        $display("Escrituras Totales Correctas: %0d", ok_count_escritura);
        $display("Escrituras Totales Erroneas: %0d", err_count_escritura);

        $display("Lecturas Totales Correctos: %0d", ok_count_lectura);
        $display("Lecturas Totales Erroneas: %0d", err_count_lectura);
        $finish; 
    end : tester



//SCOREBOARD
    always @(scoreboard_en) begin : scoreboard
        if (scoreboard_en) begin
            scoreboard_en = 0; // desactiva para siguiente ciclo

            if (escritura == 1) begin
                $display("Valor de SEL: %b:", scoreboard_SEL);
                $display("Valor de DATA_drive: %h:", scoreboard_drive);
                $display("Valor de dato_leido: %h:", scoreboard_dato_leido);
                escritura = 0; 
            
                if (scoreboard_SEL[3:2] == 2'b00) begin      //registros de 8 bits lows
                    
                    if (scoreboard_drive [7:0] == scoreboard_dato_leido[7:0]) begin
                        $display("SCOREBOARD escritura OK: REG = %0d | Dato de entrada = %h | Leido = %h", reg_leido, scoreboard_drive, scoreboard_dato_leido);
                        $display(""); // Línea en blanco
                        ok_count_escritura++;
                    end 

                    else begin
                        $display("SCOREBOARD escritura ERROR: REG = %0d | Esperado = %h | Leido = %h", reg_leido, scoreboard_drive, scoreboard_dato_leido);
                        $display(""); // Línea en blanco
                        err_count_escritura++;
                    end 
                end 

                else if (SEL[3:2] == 2'b01) begin

                        if (scoreboard_drive [15:8] == scoreboard_dato_leido[7:0]) begin
                            $display("SCOREBOARD escritura OK: REG = %0d | Dato de entrada = %h | Leido = %h", reg_leido, scoreboard_drive, scoreboard_dato_leido);
                            $display(""); // Línea en blanco
                            ok_count_escritura++;
                        end 

                        else begin
                            $display("SCOREBOARD escritura ERROR: REG = %0d | Esperado = %h | Leido = %h", reg_leido, scoreboard_drive, scoreboard_dato_leido);
                            $display(""); // Línea en blanco
                            err_count_escritura++;
                        end 
                    end

                else begin
                    if (scoreboard_drive == scoreboard_dato_leido) begin
                            $display("SCOREBOARD escritura OK: REG = %0d | Dato de entrada = %h | Leido = %h", reg_leido, scoreboard_drive, scoreboard_dato_leido);
                            $display(""); // Línea en blanco
                            ok_count_escritura++;
                    end
                    else begin
                            $display("SCOREBOARD escritura ERROR: REG = %0d | Esperado = %h | Leido = %h", reg_leido, scoreboard_drive, scoreboard_dato_leido);
                            $display(""); // Línea en blanco
                            err_count_escritura++;
                    end
                end
            end


            else if (lectura == 1) begin
                    lectura = 0;
                    if (expected[SEL] == dato_leido) begin
                        $display("SCOREBOARD lectura OK: REG = %0d | Dato Leido = %h | Dato esperado = %h", reg_leido, dato_leido, expected[SEL]);
                        $display(""); // Línea en blanco
                        ok_count_lectura++;
                    end
                    else begin
                        $display("SCOREBOARD lectura ERROR: REG = %0d | Dato Leido = %h | Dato esperado = %h", reg_leido, dato_leido, expected[SEL]);
                        $display(""); // Línea en blanco
                        err_count_lectura++;
                    end
                end
            end
 
    end : scoreboard




endmodule