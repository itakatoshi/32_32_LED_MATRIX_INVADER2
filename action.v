
module action (
    input clk,
    input reset,
    input wire sw0_value,
    input wire sw1_value,
    input wire sw2_value,
    input wire sw3_value,
    input wire [2:0]cur_stage,
    input wire [3:0] row,
    input wire [4:0] col,
    output wire sound_out,
    output wire [2:0]next_stage_flag,
    output wire [1:0] stage_select,
    output wire RED_UP_WIRE,
    output wire RED_DOWN_WIRE,
    output wire GREEN_UP_WIRE,
    output wire GREEN_DOWN_WIRE,
    output wire BLUE_UP_WIRE,
    output wire BLUE_DOWN_WIRE
);

// 状態を示す定数を定義
parameter OPENING = 3'b000;
parameter STAGE1  = 3'b001;
parameter STAGE2  = 3'b010;
parameter STAGE3  = 3'b011;
parameter FINISH  = 3'b100;

reg sw0_d1, sw0_d2, sw1_d1, sw1_d2, sw2_d1, sw2_d2, sw3_d1, sw3_d2;
wire sw0_raise, sw1_raise, sw2_raise; //エッジ検出

// 選ばれた状態を一時的に保存
reg [511:0] RED_UP;
reg [511:0] RED_DOWN;
reg [511:0] GREEN_UP;
reg [511:0] GREEN_DOWN;
reg [511:0] BLUE_UP;
reg [511:0] BLUE_DOWN;
reg sound_en;
reg [3:0] note_sel;
reg [2:0] next_stage_en;
reg [1:0] stage_select_en;

//OPENING
wire RED_UP_0;
wire RED_DOWN_0;
wire GREEN_UP_0;
wire GREEN_DOWN_0;
//wire BLUE_UP_0;
//wire BLUE_DOWN_0;
wire sound_out0;
//wire [3:0] note_sel0;
wire [2:0]next_stage_flag0;
wire [1:0] stage_select0;

//STAGE1
wire RED_UP_1;
wire RED_DOWN_1;
wire GREEN_UP_1;
wire GREEN_DOWN_1;
wire BLUE_UP_1;
wire BLUE_DOWN_1;
wire sound_out1;
wire [3:0] note_sel1;
wire [2:0]next_stage_flag1;
wire [1:0] stage_select1;

//STAGE2
wire RED_UP_2;
wire RED_DOWN_2;
wire GREEN_UP_2;
wire GREEN_DOWN_2;
wire BLUE_UP_2;
wire BLUE_DOWN_2;
wire sound_out2;
wire [3:0] note_sel2;
wire [2:0]next_stage_flag2;
wire [1:0] stage_select2;

//STAGE3
wire RED_UP_3;
wire RED_DOWN_3;
wire GREEN_UP_3;
wire GREEN_DOWN_3;
wire BLUE_UP_3;
wire BLUE_DOWN_3;
wire sound_out3;
wire [3:0] note_sel3;
wire [2:0]next_stage_flag3;
wire [1:0] stage_select3;

//FINISH
wire RED_UP_F;
wire RED_DOWN_F;
wire GREEN_UP_F;
wire GREEN_DOWN_F;
wire BLUE_UP_F;
wire BLUE_DOWN_F;
wire sound_outF;
wire [3:0] note_selF;
wire [2:0]next_stage_flagF;
wire [1:0] stage_selectF;

//buzzer



assign RED_UP_WIRE = RED_UP;
assign RED_DOWN_WIRE = RED_DOWN;
assign GREEN_UP_WIRE = GREEN_UP;
assign GREEN_DOWN_WIRE = GREEN_DOWN;
assign BLUE_UP_WIRE = BLUE_UP;
assign BLUE_DOWN_WIRE = BLUE_DOWN;
assign next_stage_flag = next_stage_en;
assign stage_select = stage_select_en;



//スイッチの立ち上がりエッジの検出
always @(posedge clk)begin
    sw0_d1 <= sw0_value;
    sw0_d2 <= sw0_d1;
    sw1_d1 <= sw1_value;
    sw1_d2 <= sw1_d1;
    sw2_d1 <= sw2_value;
    sw2_d2 <= sw2_d1;
    sw3_d1 <= sw3_value;
    sw3_d2 <= sw3_d1;
end

assign sw0_raise = ((sw0_d1 ==1'b1)&&(sw0_d2==1'b0))? 1'b1 : 1'b0;
assign sw1_raise = ((sw1_d1 ==1'b1)&&(sw1_d2==1'b0))? 1'b1 : 1'b0;
assign sw2_raise = ((sw2_d1 ==1'b1)&&(sw2_d2==1'b0))? 1'b1 : 1'b0;
assign sw3_raise = ((sw3_d1 ==1'b1)&&(sw3_d2==1'b0))? 1'b1 : 1'b0;




always@(posedge clk or posedge reset) begin
    if (reset ==1'b1)begin
            RED_UP <= RED_UP_0;
            RED_DOWN <= RED_DOWN_0;
            GREEN_UP <= GREEN_UP_0;
            GREEN_DOWN <= GREEN_DOWN_0;

            sound_en <= sound_out0;
            //note_sel <= note_sel0;
            next_stage_en <= next_stage_flag0;
            stage_select_en <= stage_select0;
    
    end else
    case(cur_stage)
        OPENING: begin
            RED_UP <= RED_UP_0;
            RED_DOWN <= RED_DOWN_0;
            GREEN_UP <= GREEN_UP_0;
            GREEN_DOWN <= GREEN_DOWN_0;

            sound_en <= sound_out0;
           // note_sel <= note_sel0;
            next_stage_en <= next_stage_flag0;
            stage_select_en <= stage_select0;
        end 
        
        STAGE1: begin
            RED_UP <= RED_UP_1;
            RED_DOWN <= RED_DOWN_1;
            GREEN_UP <= GREEN_UP_1;
            GREEN_DOWN <= GREEN_DOWN_1;
            BLUE_UP <= BLUE_UP_1;
            BLUE_DOWN <= BLUE_DOWN_1;       
            sound_en <= sound_out1;
            note_sel <= note_sel1;
            next_stage_en <= next_stage_flag1;
            stage_select_en <= stage_select1;
        end
        
        STAGE2: begin
            RED_UP <= RED_UP_2;
            RED_DOWN <= RED_DOWN_2;
            GREEN_UP <= GREEN_UP_2;
            GREEN_DOWN <= GREEN_DOWN_2;
            BLUE_UP <= BLUE_UP_2;
            BLUE_DOWN <= BLUE_DOWN_2;       
            sound_en <= sound_out2;
            note_sel <= note_sel2;
            next_stage_en <= next_stage_flag2;
            stage_select_en <= stage_select2;
        end
        
        STAGE3: begin
            RED_UP <= RED_UP_3;
            RED_DOWN <= RED_DOWN_3;
            GREEN_UP <= GREEN_UP_3;
            GREEN_DOWN <= GREEN_DOWN_3;
            BLUE_UP <= BLUE_UP_3;
            BLUE_DOWN <= BLUE_DOWN_3;       
            sound_en <= sound_out3;
            note_sel <= note_sel3;
            next_stage_en <= next_stage_flag3;
            stage_select_en <= stage_select3;
        end
        
        FINISH: begin
            RED_UP <= RED_UP_F;
            RED_DOWN <= RED_DOWN_F;
            GREEN_UP <= GREEN_UP_F;
            GREEN_DOWN <= GREEN_DOWN_F;
            BLUE_UP <= BLUE_UP_F;
            BLUE_DOWN <= BLUE_DOWN_F;       
            sound_en <= sound_outF;
            note_sel <= note_selF;
            next_stage_en <= next_stage_flagF;
            stage_select_en <= stage_selectF;
        end
        
        default: begin
            RED_UP <= RED_UP_0;
            RED_DOWN <= RED_DOWN_0;
            GREEN_UP <= GREEN_UP_0;
            GREEN_DOWN <= GREEN_DOWN_0;
            sound_en <= sound_out0;
            next_stage_en <= next_stage_flag0;
            stage_select_en <= stage_select0;
        end
    endcase
end



opening opening(
    .clk(clk),
    .reset(reset),
    .col(col),
    .row(row),
    .sw0_raise(sw0_raise),
    .sw1_raise(sw1_raise),
    .sw2_raise(sw2_raise),
    .sw3_raise(sw3_raise),
    .cur_stage(cur_stage),
    .sound_en(sound_out0),
    //.note_sel(note_sel0),
    .next_stage_flag(next_stage_flag0),
    .stage_select(stage_select0),
    .RED_UP_WIRE(RED_UP_0),  
    .RED_DOWN_WIRE(RED_DOWN_0),  
    .GREEN_UP_WIRE(GREEN_UP_0),  
    .GREEN_DOWN_WIRE(GREEN_DOWN_0)
//    .BLUE_UP_WIRE(BLUE_UP_0),  
//    .BLUE_DOWN_WIRE(BLUE_DOWN_0)  
);

stage1 stage1(
    .clk(clk),
    .reset(reset),
    .col(col),
    .row(row),
    .sw0_value(sw0_value),
    .sw1_value(sw1_value),
    .sw2_value(sw2_value),
    .sw3_value(sw3_value),
    .sw0_raise(sw0_raise),
    .sw1_raise(sw1_raise),
    .sw2_raise(sw2_raise),
    .sw3_raise(sw3_raise),
    .cur_stage(cur_stage),
    .sound_en(sound_out1),
    .note_sel(note_sel1),
    .next_stage_flag(next_stage_flag1),
    .stage_select(stage_select1),
    .RED_UP_WIRE(RED_UP_1),  
    .RED_DOWN_WIRE(RED_DOWN_1),  
    .GREEN_UP_WIRE(GREEN_UP_1),  
    .GREEN_DOWN_WIRE(GREEN_DOWN_1),  
    .BLUE_UP_WIRE(BLUE_UP_1),  
    .BLUE_DOWN_WIRE(BLUE_DOWN_1)  
);


stage2 stage2(
    .clk(clk),
    .reset(reset),
    .col(col),
    .row(row),
    .sw0_value(sw0_value),
    .sw1_value(sw1_value),
    .sw2_value(sw2_value),
    .sw3_value(sw3_value),
    .sw0_raise(sw0_raise),
    .sw1_raise(sw1_raise),
    .sw2_raise(sw2_raise),
    .sw3_raise(sw3_raise),
    .cur_stage(cur_stage),
    .sound_en(sound_out2),
    .note_sel(note_sel2),
    .next_stage_flag(next_stage_flag2),
    .stage_select(stage_select2),
    .RED_UP_WIRE(RED_UP_2),  
    .RED_DOWN_WIRE(RED_DOWN_2),  
    .GREEN_UP_WIRE(GREEN_UP_2),  
    .GREEN_DOWN_WIRE(GREEN_DOWN_2),  
    .BLUE_UP_WIRE(BLUE_UP_2),  
    .BLUE_DOWN_WIRE(BLUE_DOWN_2)  
);


stage3 stage3(
    .clk(clk),
    .reset(reset),
    .col(col),
    .row(row),
    .sw0_value(sw0_value),
    .sw1_value(sw1_value),
    .sw2_value(sw2_value),
    .sw3_value(sw3_value),
    .sw0_raise(sw0_raise),
    .sw1_raise(sw1_raise),
    .sw2_raise(sw2_raise),
    .sw3_raise(sw3_raise),
    .cur_stage(cur_stage),
    .sound_en(sound_out3),
    .note_sel(note_sel3),
    .next_stage_flag(next_stage_flag3),
    .stage_select(stage_select3),
    .RED_UP_WIRE(RED_UP_3),  
    .RED_DOWN_WIRE(RED_DOWN_3),  
    .GREEN_UP_WIRE(GREEN_UP_3),  
    .GREEN_DOWN_WIRE(GREEN_DOWN_3),  
    .BLUE_UP_WIRE(BLUE_UP_3),  
    .BLUE_DOWN_WIRE(BLUE_DOWN_3)  
);


finish finish(
    .clk(clk),
    .reset(reset),
    .col(col),
    .row(row),
    .cur_stage(cur_stage),
    .sound_en(sound_outF),
    .note_sel(note_selF),
    .next_stage_flag(next_stage_flagF),
    .stage_select(stage_selectF),
    .RED_UP_WIRE(RED_UP_F),  
    .RED_DOWN_WIRE(RED_DOWN_F),  
    .GREEN_UP_WIRE(GREEN_UP_F),  
    .GREEN_DOWN_WIRE(GREEN_DOWN_F),  
    .BLUE_UP_WIRE(BLUE_UP_F),  
    .BLUE_DOWN_WIRE(BLUE_DOWN_F)  
);

buzzer buzzer(
    .clk(clk),
    .reset(reset),
    .note_sel(note_sel),
    .sound_en(sound_en),
    .sound_out(sound_out)
);


endmodule
