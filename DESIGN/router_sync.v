module router_sync(detect_add, data_in, write_enb_reg, clock, resetn, read_enb_0, read_enb_1, read_enb_2, empty_0, empty_1, empty_2, full_0, full_1, full_2, vld_out_0,vld_out_1,vld_out_2, soft_reset_0,soft_reset_1,soft_reset_2, write_enb, fifo_full);
    input clock, resetn, detect_add, write_enb_reg, read_enb_0, read_enb_1, read_enb_2, empty_0, empty_1, empty_2, full_0, full_1, full_2;
    input [1:0] data_in;
    output vld_out_0, vld_out_1, vld_out_2;
    output reg soft_reset_0, soft_reset_1, soft_reset_2, fifo_full;
    output reg [2:0] write_enb; 
    
    reg [1:0] temp;
    
    reg [4:0] count_0, count_1, count_2;
    
    //Valid out
    assign vld_out_0 = ~empty_0;
    assign vld_out_1 = ~empty_1;
    assign vld_out_2 = ~empty_2;
    
    //temp
    always @(posedge clock) begin
        if(!resetn) begin
            temp <= 2'b11;
        end
        else if(detect_add) begin
                temp <= data_in;
            end
    end
    
    //fifo_full
    always @(*) begin
        case (temp)
            2'b00: fifo_full = full_0;
            2'b01: fifo_full = full_1;
            2'b10: fifo_full = full_2;
            default: fifo_full = 1'b0;
        endcase
    end
    
    //write_enb
    always @(*) begin
        if(write_enb_reg) begin
            case(temp)
                2'b00: write_enb = 3'b001;
                2'b01: write_enb = 3'b010;
                2'b10: write_enb = 3'b100;
                default: write_enb = 3'b000;
            endcase
        end  
        else begin
            write_enb = 3'b000;
        end      
    end
    
    //soft_reset_0
    always @(posedge clock) begin
        if(!resetn) begin
            count_0 <= 5'b0;
            soft_reset_0 <= 1'b0;
        end    
        else if (vld_out_0) begin
            if(!read_enb_0) begin
                if(count_0 == 29) begin
                    soft_reset_0 <= 1'b1;
                    count_0 <= 5'b0;
                end
                else begin
                    count_0 <= count_0 + 1;
                end
            end
            else begin 
                count_0 <= 5'b0;
                soft_reset_0 <= 1'b0;
            end
        end
        else begin
            count_0 <= 5'b0;
            soft_reset_0 <= 1'b0;
        end
    end
    
    //soft_reset_1
    always @(posedge clock) begin
        if(!resetn) begin
            count_1 <= 5'b0;
            soft_reset_1 <= 1'b0;
        end    
        else if (vld_out_1) begin
            if(!read_enb_1)begin
                if(count_1 == 29) begin
                    soft_reset_1 <= 1'b1;
                    count_1 <= 5'b0;
                end
                else begin
                    count_1 <= count_1 + 1;
                end
            end
            else begin 
                count_1 <= 5'b0;
                soft_reset_1 <= 1'b0;
            end
        end
        else begin
            count_1 <= 5'b0;
            soft_reset_1 <= 1'b0;
        end
    end
    
    //soft_reset_2
    always @(posedge clock) begin
        if(!resetn) begin
            count_2 <= 5'b0;
            soft_reset_2 <= 1'b0;
        end    
        else if (vld_out_2) begin
            if(!read_enb_2) begin
                if(count_2 == 29) begin
                    soft_reset_2 <= 1'b1;
                    count_2 <= 5'b0;
                end
                else begin
                    count_2 <= count_2 + 1;
                end
            end
            else begin 
                count_2 <= 5'b0;
                soft_reset_2 <= 1'b0;
            end
        end
        else begin
            count_2 <= 5'b0;
            soft_reset_2 <= 1'b0;
        end
    end

endmodule
