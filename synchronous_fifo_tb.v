module tb;
   parameter WIDTH = 8;
   parameter DEPTH = 8;
   reg clk,rst,wr_en,rd_en;
   wire [WIDTH - 1 : 0] rd_data;
   reg [WIDTH - 1 : 0] wr_data;
   wire full,empty;


fifo 
#(.WIDTH(WIDTH),
  .DEPTH(DEPTH)
  )
  dut 
  (.clk(clk),
   .rst(rst),
   .wr_en(wr_en),
   .rd_en(rd_en),
   .rd_data(rd_data),
   .wr_data(wr_data),
   .full(full),
   .empty(empty)
   );

   reg [WIDTH - 1 : 0] mem[DEPTH - 1 : 0];
   reg [$clog2(DEPTH) - 1 : 0] rd_ptr,wr_ptr;

   event finish_e;

   always #5 clk = ~clk;

   initial begin
       clk = 'd0;
       rst = 'd0;
       wr_en = 'd0;
       rd_en = 'd0;
       wr_data = 'd0;
       rd_ptr = 'd0;
       wr_ptr = 'd0;
   end

   initial begin
       @(posedge clk);
       rst = 1'b1;
       $display("[TB] : -------------------------------------");
       $display("[TB] : RESET ASSERTED");
       repeat(5) @(posedge clk)
       rst = 1'b0;
       $display("[TB] : -------------------------------------");
   end

   ///---------------------------------------------------------
   //------------------------WRITE_OPERATION-------------------
   //----------------------------------------------------------

   task write_operation_check();
   begin
       @(posedge clk);
       wr_en = 1'b1;
       wr_data = $urandom();
       mem[wr_ptr + 1] = wr_data;
       wr_ptr = wr_ptr + 1;
       @(posedge clk);
       wr_en = 1'b0;
       if(wr_data == mem[wr_ptr]) $display("[TB] : time : %0t , Write Operation Successful with wr_data : %0d",$time(),wr_data);
       else $error("[TB] : time : %0t, Write Operation Unsuccessful, wr_en : %0d, wr_data : %0d, wr_ptr : %0d",$time,wr_en,wr_data,wr_ptr);
    end
   endtask

   //----------------------------------------------------------
   //------------------------READ_OPERATION--------------------
   //----------------------------------------------------------

   task read_operation_check();
     begin
       @(posedge clk);
       rd_en = 1'b1;
       rd_ptr = rd_ptr + 1;
       @(posedge clk);
       rd_en = 1'b0;
       if(rd_data == mem[rd_ptr]) $display("[TB] : time : %0t , Read Operation Successful with rd_data : %0d, rd_en : %od, rd_ptr : %0d",$time(),rd_data,rd_en,rd_ptr);
       else $error("[TB] : time : %0t, Read Operation Unsuccessful, rd_en : %0d, rd_data : %0d, rd_ptr : %0d",$time,rd_en,rd_data,rd_ptr);
     end
   endtask

   initial begin
      repeat(10) begin
           write_operation_check();
           $display("[TB] : WRITE OPERATION EXECUTED");
           @(posedge clk);
           read_operation_check();
           $display("[TB] : WRITE OPERATION EXECUTED");
           @(posedge clk);
       end
   end

   initial begin
       #500;
       $finish();
   end
endmodule
