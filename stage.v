
module stage(
    input clk,
    input reset,
    input wire [2:0]next_stage_flag,
    output reg [2:0]cur_stage
);


// ó‘Ô‚ğ¦‚·’è”‚ğ’è‹`
parameter OPENING = 3'b000;
parameter STAGE1  = 3'b001;
parameter STAGE2  = 3'b010;
parameter STAGE3  = 3'b011;
parameter FINISH  = 3'b100;


always @(posedge clk or posedge reset) begin
    if(reset == 1'b1) begin
        cur_stage <= OPENING;
    end else begin
        case (cur_stage)
            OPENING: begin
                if(next_stage_flag==3'b001) 
                    cur_stage <= STAGE1;
                else if(next_stage_flag ==3'b010)
                    cur_stage <= STAGE2;
                else if(next_stage_flag ==3'b011)
                    cur_stage <= STAGE3;
                else 
                    cur_stage <= cur_stage;
            end
            STAGE1: begin
                if(next_stage_flag==3'b100) 
                    cur_stage <= FINISH;
                else
                    cur_stage <= cur_stage;
            end                    
            STAGE2: begin
                if(next_stage_flag==3'b101) begin 
                    cur_stage <= FINISH;
                end
            end
            STAGE3: begin
                if(next_stage_flag==3'b110) begin 
                    cur_stage <= FINISH;
                end
            end        
            FINISH: begin
                if(next_stage_flag==3'b111)  
                    cur_stage <= OPENING;
                else
                    cur_stage <= cur_stage;                
            end      
        
            default: cur_stage <= OPENING;
        endcase
    end
end 







endmodule


