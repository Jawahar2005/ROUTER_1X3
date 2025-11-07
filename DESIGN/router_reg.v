module router_reg(clock, resetn, pkt_valid, data_in, fifo_full, rst_int_reg, detect_add, ld_state, laf_state, full_state, lfd_state, parity_done, low_pkt_valid, err, dout);
    input clock, resetn, pkt_valid, fifo_full, rst_int_reg, detect_add, ld_state, laf_state, full_state, lfd_state;
    input [7:0] data_in;
    output reg parity_done, low_pkt_valid, err;
    output reg [7:0] dout;
    
    reg [7:0] header_byte, FIFO_full_state_byte, internal_parity, packet_parity_byte;
    
    //dout --> lfd -> header | ld and fifo not full -> data_in | laf -> fifo full state
    always @(posedge clock) begin
        if (!resetn) begin
            dout <= 8'b0;
        end
        else begin
            if(lfd_state) begin
                dout <= header_byte;
            end
            // not pkt valid because of parity
            else if (ld_state &&!fifo_full) begin
                dout <= data_in;
            end
            else if (laf_state) begin
                dout <= FIFO_full_state_byte;
            end
            else begin
                dout <= dout;
            end
        end
    end
    
    //detect add pktvalid (1) -> header | ld fifo full(3->4) -> fifo full state
    always @(posedge clock) begin
        if(!resetn) begin
            {header_byte, FIFO_full_state_byte} = 'b0;
        end
        else begin
            if(detect_add && pkt_valid && data_in != 2'b11) begin
                header_byte <= data_in;
            end
            else if(ld_state && fifo_full) begin
                FIFO_full_state_byte <= data_in;
            end
        end
    end
    
    //ld !full !valid | laf lowpktvalid !parity_done
    always @(posedge clock) begin
        if(!resetn) begin
            parity_done <= 1'b0;
        end
        else if(detect_add) begin
            parity_done <= 1'b0;
        end
        else begin
            if(ld_state && !fifo_full && !pkt_valid) begin
                parity_done <= 1'b1;
            end
            else if(laf_state && low_pkt_valid && !parity_done) begin
                parity_done <= 1'b1;
            end
        end
    end
    
    //low packet valid - (load state and pkt valid 0) laf -> lp
    always @(posedge clock) begin
        if (!resetn) begin
            low_pkt_valid <= 1'b0;
        end
        if(rst_int_reg) begin
            low_pkt_valid <= 1'b0;
        end
        else if(ld_state && !pkt_valid) begin
            low_pkt_valid <= 1'b1;
        end
    end
    
    // ld_state !pkt_valid !full
    always @(posedge clock) begin
        if (!resetn) begin
            packet_parity_byte <= 8'b0;
        end         
        else if ((ld_state && !pkt_valid && !fifo_full)||(laf_state && low_pkt_valid && parity_done)) begin
            packet_parity_byte <= data_in;
        end
        else if(!pkt_valid && rst_int_reg) begin
            packet_parity_byte <= 8'b0;
        end
        else if (detect_add) begin
            packet_parity_byte <= 8'b0;
        end
    end
    
    always @(posedge clock) begin
        if (!resetn) begin
            internal_parity <= 8'b0;
        end
        else if (detect_add) begin
            internal_parity <= 8'b0;
        end
        else if (lfd_state) begin
            internal_parity <= header_byte;
        end
        else if (ld_state && pkt_valid && !full_state) begin
            internal_parity <= internal_parity ^ data_in;
        end
        else if (!pkt_valid && rst_int_reg) begin
            internal_parity <= 8'b0;
        end
    end
    
    always@(posedge clock) begin
        if(!resetn)
            err <= 1'b0;
        else if(parity_done == 1 && internal_parity != packet_parity_byte)
            err <= 1'b1;
        else
            err <= 1'b0;
    end

endmodule
