//Eliel Nolasco de Souza
//ES92564

module ff ( input data, input c, input r, output q);
reg q;
always @(posedge c or negedge r) 
begin
 if(r==1'b0)
  q <= 1'b0; 
 else 
  q <= data; 
end 
endmodule //End 
/*
+--------+                 +--------+
|   Qo   <-------+         |        |
|        |       |  +------>    Q2  <-----+
+----+---+       |  |      +----+---+     |
     |     0     |  |           |         |
  0\1|  +-----------+        0\1|         |
     |  |        |              |         |
+----v--++       |   0     +----v---+     |
|    Q3  |       +---------+   Q4   |     |
|        <-----------------+        |     |
+------+-+       1         +--------+    0|1
       |                                  |
       |1                                 |
       |                                  |
       |     +--------+                   |
       +----->        +-------------------+
             |   Q5   |
             +--------+

*/

// ----   FSM alto nível com Case
module statem(clk, reset, a, saida);

input clk, reset, a;
output [2:0] saida;
reg [2:0] state;
parameter zero=3'd2, tres=3'd4, dois=3'd6, quatro=3'd7, cinco =3'd3;

assign saida = (state == zero)? 3'd2:
           (state == dois)? 3'd6:
	   (state == tres)? 3'd4:
	   (state == quatro)? 3'd7:3'd3;

always @(posedge clk or negedge reset)
     begin
          if (reset==0)
               state = zero;
          else
               case (state)
                    zero: state = tres;
                    tres: if ( a == 1 ) state = cinco;
			  else state = dois;
                    quatro: if ( a == 1 ) state = tres;
			  else state = zero;
                    dois: state = quatro;
                    cinco: state = dois;
               endcase
     end
endmodule
// FSM com portas logicas
// programar ainda....
module statePorta(input clk, input res, input a, output [2:0] s);
wire [2:0] e;
wire [2:0] p;
wire b,c,d;
assign b = e[2];
assign c = e[1];
assign d = e[0];
assign s = e;  // saida = estado atual
assign p[0] = b&a&~d | b&c&~d; //7 operações
assign p[1] = ~d&b | c&b&~a | ~b&d&c; //13 operações
assign p[2] = ~d&~a | c&~b | a&c; //10 operações
//Total de 30 operações
ff  e0(p[0],clk,res,e[0]);
ff  e1(p[1],clk,res,e[1]);
ff  e2(p[2],clk,res,e[2]);

endmodule 




module stateMem(input clk,input res, input a, output [2:0] saida);
reg [5:0] StateMachine [0:15]; // 16 linhas e 6 bits de largura
initial
begin  // programar ainda....
StateMachine[0] = 6'b100010;
StateMachine[1] = 6'b100010;
StateMachine[2] = 6'b100010;
StateMachine[3] = 6'b110011;
StateMachine[4] = 6'b110100;
StateMachine[5] = 6'b100010;
StateMachine[6] = 6'b111110;
StateMachine[7] = 6'b010111;
StateMachine[8] = 6'b100010;
StateMachine[9] = 6'b100001;
StateMachine[10] = 6'b100010;
StateMachine[11] = 6'b110011;
StateMachine[12] = 6'b011100;
StateMachine[13] = 6'b100010;
StateMachine[14] = 6'b111110;
StateMachine[15] = 6'b100111;

end
wire [3:0] address;  // 16 linhas = 4 bits de endereco
wire [5:0] dout; // 6 bits de largura 3+3 = proximo estado + saida
assign address[3] = a;
assign dout = StateMachine[address];
assign saida = dout[2:0];
ff st0(dout[3],clk,res,address[0]);
ff st1(dout[4],clk,res,address[1]);
ff st2(dout[5],clk,res,address[2]);
endmodule

module main;
reg c,res,a;
wire [2:0] saida;
wire [2:0] saida1;
wire [2:0] saida2;

statem FSM(c,res,a,saida);
statePorta FSM1(c,res,a, saida1);
stateMem FSM2(c,res,a,saida2);


initial
    c = 1'b0;
  always
    c= #(1) ~c;

// visualizar formas de onda usar gtkwave out.vcd
initial  begin
     $dumpfile ("out.vcd"); 
     $dumpvars; 
   end 

  initial 
    begin
     $monitor($time," c %b res %b a %b Case: %d PortaL: %d StateMachine: %d",c,res,a,saida,saida1, saida2);
      #1 res=0; a=0;
      #1 res=1;
      #8 a=1;
      #16 a=0;
      #12 a=1;
      #4;
      $finish ;
    end
endmodule

