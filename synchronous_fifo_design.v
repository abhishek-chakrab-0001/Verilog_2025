//FIFO works as a synchronizer between design blocks 
//First In First Out (FIFO) is a very popular and useful design block for purpose of synchronization and a handshaking mechanism between the modules.

//Depth of FIFO: The number of slots or rows in FIFO is called the depth of the FIFO.
//
//Width of FIFO: The number of bits that can be stored in each slot or row is called the width of the FIFO.
//
//There are two types of FIFOs
//
//Synchronous FIFO
//Asynchronous FIFO
//
//Synchronous FIFO
//
//In Synchronous FIFO, data read and write operations use the same clock frequency. Usually, they are used with high clock frequency to support high-speed systems.

//Synchronous FIFO Operation
//Signals:
//
//wr_en: write enable
//
//wr_data: write data
//
//full: FIFO is full
//
//empty: FIFO is empty
//
//rd_en: read enable
//
//rd_data: read data
//
//w_ptr: write pointer
//
//r_ptr: read pointer
//
//FIFO write operation
//FIFO can store/write the wr_data at every posedge of the clock based on wr_en signal till it is full. The write pointer gets incremented on every data write in FIFO memory.
//
//FIFO read operation
//The data can be taken out or read from FIFO at every posedge of the clock based on the rd_en signal till it is empty. The read pointer gets incremented on every data read from FIFO memory.
//
module fifo
#(parameter DEPTH = 32, 
  parameter WIDTH = 8)
  (input clk,
   input rst,
   input wr_en,
   input [WIDTH - 1 : 0] wr_data,
   input rd_en,
   output full,
   output empty,
   output reg [WIDTH - 1 : 0] rd_data
   );

   reg [$clog2(DEPTH) - 1 : 0] rd_ptr,wr_ptr;
   reg [WIDTH - 1 : 0] mem[DEPTH - 1 : 0];

    //----------------------------------------------
    //-----------------RESET_LOGIC------------------
    //----------------------------------------------
    always @(posedge clk) begin
        if(rst) begin
            rd_ptr <= 'd0;
            wr_ptr <= 'd0;
            rd_data <= 'd0;
        end
    end

    //----------------------------------------------
    //-----------------WRITE_OPERATION--------------
    //----------------------------------------------

    always @(posedge clk) begin
        if(wr_en && !full) begin
            mem[wr_ptr + 1] <= wr_data;
            wr_ptr <= wr_ptr + 1;
        end
    end

    //-----------------------------------------------
    //-----------------READ_OPERATION----------------
    //-----------------------------------------------

    always@(posedge clk) begin
        if(rd_en && !empty) begin
            rd_data <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

    //-----------------------------------------------
    //-----------------FULL/EMPTY--------------------
    //-----------------------------------------------

    assign empty = (wr_ptr == rd_ptr) ? 1'b1 : 1'b0;
    assign full = ((wr_ptr == rd_ptr) && (wr_ptr == DEPTH)) ? 1'b1 : 1'b0;


endmodule
