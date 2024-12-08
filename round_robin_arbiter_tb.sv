module tb;
   reg clk,rst;
   reg [1:0] req;
   wire [1:0] grant;

   arbiter dut(.clk(clk),.rst(rst),.req(req),.grant(grant));

   initial begin
       clk = 'd0;
       rst = 'd0;
       req = 'd0;
   end

   always #10 clk = ~clk;

   initial begin
       @(posedge clk);
       rst = 1'b1;
       $display("[TB] : -------------------------------------");
       $display("[TB] : RESET ASSERTED");
       @(posedge clk)
       rst = 1'b0;
       $display("[TB] : -------------------------------------");
       $display("[TB] : RESET DEASSERTED");
   end

   initial begin
       repeat(10) begin
           req = $urandom();
           @(posedge clk);
       end
   end

   initial begin
       #600 $finish();
   end
endmodule
