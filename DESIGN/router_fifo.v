module router_fifo(clock, resetn, write_enb, soft_reset, read_enb, data_in, lfd_state, empty, data_out, full);
    input clock, resetn, write_enb, soft_reset, read_enb, lfd_state;
    input [7:0] data_in;
    output empty, full;
    output reg [7:0] data_out;
    
    integer i;
    
    reg [4:0] wr_ptr, rd_ptr;
    reg [8:0] mem [15:0];
    reg [6:0] counter;
    reg temp;
    
    always @(posedge clock) begin
        if(!resetn) begin
            temp <= 1'b0;
        end
        else begin
            temp <= lfd_state;
        end
    end
    
    //Read Operation - dout - z(!reset,soft,!counter)  
    always @(posedge clock) begin
        if (!resetn) begin
            data_out <= 8'b0;
            rd_ptr <= 5'b0;
        end
        else if(soft_reset) begin
            data_out <= 8'bz;
        end
        else if(counter == 7'b0) begin
            data_out <= 8'bz;
        end
        else if(read_enb && !empty) begin
            data_out <= mem[rd_ptr[3:0]][7:0];
            rd_ptr <= rd_ptr + 1'b1;
        end
        else begin
            data_out <= 8'bz;
        end
    end
    
    always @(posedge clock) begin
        if(!resetn) begin
            counter <= 7'b0;
        end
        else if(soft_reset) begin
            counter <= 7'b0;
        end
        // 8 bit == 1 [payload length] -- counter = payload_len + parity
        else if(mem[rd_ptr[3:0]][8] == 1'b1) begin
             counter <= mem[rd_ptr[3:0]][7:2] + 1'b1;            
        end
        else if(read_enb && !empty) begin
            counter <= counter - 1'b1;
        end
        else begin
            counter <= counter;
        end
    end
    
    //Write Operation
    always @(posedge clock) begin
        if(!resetn) begin
            for(i=0; i<16; i=i+1) begin
                mem[i] <= 9'b0;
                wr_ptr <= 5'b0;
            end
        end  
        else if(soft_reset) begin
            for(i=0; i<16; i=i+1) begin
                mem[i] <= 9'b0;
                wr_ptr <= 5'b0;
            end
        end
        else if(write_enb && !full) begin
            mem[wr_ptr[3:0]] <= {temp,data_in}; 
            wr_ptr <= wr_ptr+ 1'b1;
        end            
    end
    
    assign full  = ((wr_ptr[4]!= rd_ptr[4]) && (wr_ptr[3:0] == rd_ptr[3:0])) ? 1'b1 : 1'b0;
    assign empty = (wr_ptr == rd_ptr) ? 1'b1 : 1'b0;
    
endmodule
