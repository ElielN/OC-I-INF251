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


module stateMem(input clk,input res,input [1:0]A, output [2:0] count);
reg [5:0] StateMachine [0:31]; // Exemplo com 32 linhas (2 bits de endereço) e largura 6 bits
initial begin
  StateMachine[0] = 6'b110010; // statemachine[linha] = conteúdo da linha
  StateMachine[1] = 6'b010011;
  StateMachine[2] = 6'b110000;
  StateMachine[3] = 6'b010100;
  StateMachine[4] = 6'b010010;
  StateMachine[6] = 6'b100001;
  StateMachine[8] = 6'b010010;
  StateMachine[9] = 6'b010011;
  StateMachine[10] = 6'b100000;
  StateMachine[11] = 6'b010100;
  StateMachine[12] = 6'b110010;
  StateMachine[14] = 6'b000001;
  StateMachine[16] = 6'b001010;
  StateMachine[17] = 6'b001011;
  StateMachine[18] = 6'b001000;
  StateMachine[19] = 6'b001100;
  StateMachine[20] = 6'b001010;
  StateMachine[22] = 6'b001001;
  StateMachine[24] = 6'b001010;
  StateMachine[25] = 6'b011011;
  StateMachine[26] = 6'b001000;
  StateMachine[27] = 6'b010100;
  StateMachine[28] = 6'b010010;
  StateMachine[30] = 6'b010001;
end
wire [4:0] address;  // exemplo 5 bits de endereço = 32 linhas
wire [5:0] dout;   // exemplo com largura 6 bits
assign dout = StateMachine[address]; // captura a saida da memoria (proximo,saidas)
// saidas nos bits 2, 1, 0 (exemplo)..
/*
assign P2 = dout[5];
assign P1 = dout[4];
assign P0 = dout[3];
assign C2 = dout[2];
assign C1 = dout[1];
assign C0 = dout[0];
*/
assign count = {dout[2], dout[1], dout[0]}; 
// flip flop de estados, Proximo estado nos bits 3 e 4 (exemplo).
ff st0(dout[3],clk,res,address[0]);
ff st1(dout[4],clk,res,address[1]);
ff st2(dout[5],clk,res,address[2]);
assign address[3] = A[0];
assign address[4] = A[1];
endmodule
