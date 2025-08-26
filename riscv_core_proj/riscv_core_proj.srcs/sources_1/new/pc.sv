

module pc#(parameter WIDTH = 32 //risc v uses 32 bit addresses 
)(
input logic clk,
input logic rst,
input logic[WIDTH-1:0] pc_next,
 output logic [WIDTH-1:0] pc_current  //current instruction address
);


always_ff@(posedge clk)begin
   if(rst) begin
   pc_current <= '0; //reset all the bits to 0
   end 
    else 
    begin
        pc_current <= pc_next; // uptdate with the next address
    end
          
    end


endmodule
