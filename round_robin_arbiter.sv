module arbiter(clk,rst,req,grant);
   input clk;
   input rst;
   input [1:0] req;
   input [1:0] grant;

   parameter idle = 0;
   parameter s_01 = 1;
   parameter s_10 = 2;
   parameter s_00 = 3;

   reg [1:0] state , nstate;

   //--------------------------------------------------------
   //----------------------RESET_LOGIC-----------------------
   //--------------------------------------------------------
   //--------------------------------------------------------
   //----------------------SEQ_CKT---------------------------
   always @(posedge clk) begin
       if(rst) state <= idle;
       else state <= nstate;
   end

   //---------------------------------------------------------
   //-----------------------OUTPUT_LOGIC----------------------
   //---------------------------------------------------------
   //-----------------------COMBO_LOGIC-----------------------
   always @(state) begin
       case(state) 
           idle : grant = 2'b00;
           s_01 : begin
               if(req == 2'b00) grant = 2'b01;
               else if (req == 2'b10) grant = 2'b10;
               else if((req == 2'b11) || (req == 2'b11)) grant = 2'b00;
           end
           s_10 : begin
               if(req == 2'b00) grant = 2'b10;
               else if (req == 2'b01) grant = 2'b01;
               else if((req == 2'b11) || (req == 2'b11)) grant = 2'b00;
           end
           s_00 : begin
               if((req == 2'b00) || (req == 2'b11)) grant = 2'b00;
               else if (req == 2'b01) grant = 2'b01;
               else if (req == 2'b10) grant = 2'b10;
           end
           default : grant = 2'b00;
       endcase
   end

   //------------------------------------------------------------------
   //------------------NEXT_STATE_DECODER------------------------------
   //------------------------------------------------------------------
   //-----------------COMBO_LOGIC--------------------------------------

   always @(state,req) begin
       case(state)
           idle : nstate = s_01;
           s_01 : begin
               if(req == 2'b10) nstate = s_10;
               else if (req == 2'b00) nstate = s_01;
               else nstate = s_00;
           end
           s_10 : begin
               if(req == 2'b01) nstate = s_01;
               else if (req == 2'b00) nstate = s_10;
               else nstate = s_00;
           end
           s_00 : begin
               if(req == 2'b01) nstate = s_01;
               else if (req == 2'b10) nstate = s_10;
               else nstate = s_00;
           end
       endcase
   end
endmodule
