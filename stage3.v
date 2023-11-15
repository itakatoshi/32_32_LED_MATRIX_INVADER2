
module stage3 (
    input clk,
    input reset,
    input wire [4:0] col,
    input wire [3:0] row,
    input wire sw0_value,
    input wire sw1_value,
    input wire sw2_value,
    input wire sw3_value,
    input wire sw0_raise,
    input wire sw1_raise,
    input wire sw2_raise,
    input wire sw3_raise,
    input wire [2:0]cur_stage,
    output wire sound_en,
    output wire [3:0] note_sel,
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

// 敵の状態を示す定数を定義
parameter MOVE_UP = 2'b00;
parameter OUTPUT_UP  = 2'b01;
parameter MOVE_DOWN  = 2'b10;
parameter OUTPUT_DOWN  = 2'b11;

// 音程の定義
parameter C = 4'b0000;
parameter D = 4'b0001;
parameter E = 4'b0010;
parameter F = 4'b0011;
parameter G = 4'b0100;
parameter A = 4'b0101;
parameter B = 4'b0110;
parameter C_H = 4'b0111;


//圧電ブザーの制御
//reg sound_en;
reg [2:0] next_stage;
reg [1:0] stage_select_flag; 

// 2次元の reg 配列
reg [31:0] R_UP [15:0], R_DOWN [15:0], G_UP [15:0], G_DOWN [15:0], B_UP [15:0], B_DOWN [15:0];
reg [31:0] B_UP_TEN [15:0],B_UP_MOVE_TEN [15:0],B_MOVE_TEN [15:0];
reg [31:0] B_UP_MOVE [15:0],B_MOVE [15:0];
reg [23:0] count;
reg [23:0] MAX;

// ボムの制御
parameter BOM_SPEED =  100_000; //12MHz  
reg shift_done; // シフト完了フラグ
reg [18:0] bom_count; //ボムのスピードカウント
reg [4:0] shift_state; //弾のシフト回数
reg shift_enable; //ボムの発射判定
reg laser_shift_enable;

//飛行機の制御
parameter FLY_SPEED = 1_200_000; //1.2MHz  
reg [22:0]fly_count;
reg long_press_en; 
parameter LONG_PRESS_TIME = 12_000_000; //12MHz  
reg [23:0] press_count; //長押し判定　12MHz
reg press_detected; 

//音の制御
reg [16:0]sound_count;
parameter BOM_SOUND = 81_250; //12MHz  

//敵の移動
parameter ENEMY_MOVE = 2_000_000; //12MHz  
reg [22:0] enemy_count;
reg [1:0]enemy_status;


assign RED_UP_WIRE = R_UP[row][col];
assign RED_DOWN_WIRE = R_DOWN[row][col];
assign GREEN_UP_WIRE = G_UP[row][col];
assign GREEN_DOWN_WIRE = G_DOWN[row][col];
assign BLUE_UP_WIRE = B_UP[row][col];
assign BLUE_DOWN_WIRE = B_DOWN[row][col];



assign stage_select = stage_select_flag;
assign next_stage_flag = next_stage;


// 敵の制御
always @(posedge clk or posedge reset) begin
	if(reset==1'b1) begin
            
        B_UP[0]<=32'b00000000000000000000000000000000;
        B_UP[1]<=32'b00000000000000000000000000000000;
        B_UP[2]<=32'b00000000000000000000000000000000;
        B_UP[3]<=32'b00010000000000010000000000010000;
        B_UP[4]<=32'b00111000000000111000000000111000;
        B_UP[5]<=32'b01010100000001010100000001010100;
        B_UP[6]<=32'b01111100000001111100000001111100;
        B_UP[7]<=32'b00101000000000101000000000101000;
        B_UP[8]<=32'b01010100010001010100010001010100;
        B_UP[9]<=32'b00000000111000000000111000000000;
        B_UP[10]<=32'b00000001010100000001010100000000;
        B_UP[11]<=32'b00000001111100000001111100000000;
        B_UP[12]<=32'b00000000111000000000111000000000;
        B_UP[13]<=32'b00000000101000000000101000000000;
        B_UP[14]<=32'b00000000000000000000000000000000;
        B_UP[15]<=32'b00000000000000000000000000000000;
        
               
        B_UP_MOVE[0]<=32'b00000000000000000000000000000000;
        B_UP_MOVE[1]<=32'b00000000000000000000000000000000;
        B_UP_MOVE[2]<=32'b00000000000000000000000000000000;
        B_UP_MOVE[3]<=32'b00010000000000010000000000010000;
        B_UP_MOVE[4]<=32'b00111000000000111000000000111000;
        B_UP_MOVE[5]<=32'b01010100000001010100000001010100;
        B_UP_MOVE[6]<=32'b01111100000001111100000001111100;
        B_UP_MOVE[7]<=32'b00111000000000111000000000111000;
        B_UP_MOVE[8]<=32'b00101000010000101000010000101000;
        B_UP_MOVE[9]<=32'b00000000111000000000111000000000;
        B_UP_MOVE[10]<=32'b00000001010100000001010100000000;
        B_UP_MOVE[11]<=32'b00000001111100000001111100000000;
        B_UP_MOVE[12]<=32'b00000000101000000000101000000000;
        B_UP_MOVE[13]<=32'b00000001010100000001010100000000;
        B_UP_MOVE[14]<=32'b00000000000000000000000000000000;
        B_UP_MOVE[15]<=32'b00000000000000000000000000000000;
        
        
        B_MOVE[0]<=32'b00000000000000000000000000000000;
        B_MOVE[1]<=32'b00000000000000000000000000000000;
        B_MOVE[2]<=32'b00000000000000000000000000000000;
        B_MOVE[3]<=32'b00010000000000010000000000010000;
        B_MOVE[4]<=32'b00111000000000111000000000111000;
        B_MOVE[5]<=32'b01010100000001010100000001010100;
        B_MOVE[6]<=32'b01111100000001111100000001111100;
        B_MOVE[7]<=32'b00101000000000101000000000101000;
        B_MOVE[8]<=32'b01010100010001010100010001010100;
        B_MOVE[9]<=32'b00000000111000000000111000000000;
        B_MOVE[10]<=32'b00000001010100000001010100000000;
        B_MOVE[11]<=32'b00000001111100000001111100000000;
        B_MOVE[12]<=32'b00000000111000000000111000000000;
        B_MOVE[13]<=32'b00000000101000000000101000000000;
        B_MOVE[14]<=32'b00000000000000000000000000000000;
        B_MOVE[15]<=32'b00000000000000000000000000000000;
        

        enemy_status <= MOVE_UP;
        
	end else begin 
	if(enemy_count == ENEMY_MOVE) begin
	case (enemy_status)
	       MOVE_UP : begin
                B_UP_MOVE[0]<= (B_UP_MOVE[0] << 1) | (B_UP_MOVE[0] >> 31);
                B_UP_MOVE[1]<= (B_UP_MOVE[1] << 1) | (B_UP_MOVE[1] >> 31);
                B_UP_MOVE[2]<= (B_UP_MOVE[2] << 1) | (B_UP_MOVE[2] >> 31);
                B_UP_MOVE[3]<= (B_UP_MOVE[3] << 1) | (B_UP_MOVE[3] >> 31);
                B_UP_MOVE[4]<= (B_UP_MOVE[4] << 1) | (B_UP_MOVE[4] >> 31);
                B_UP_MOVE[5]<= (B_UP_MOVE[5] << 1) | (B_UP_MOVE[5] >> 31);
                B_UP_MOVE[6]<= (B_UP_MOVE[6] << 1) | (B_UP_MOVE[6] >> 31);
                B_UP_MOVE[7]<= (B_UP_MOVE[7] << 1) | (B_UP_MOVE[7] >> 31);
                B_UP_MOVE[8]<= (B_UP_MOVE[8] << 1) | (B_UP_MOVE[8] >> 31);
                B_UP_MOVE[9]<= (B_UP_MOVE[9] << 1) | (B_UP_MOVE[9] >> 31);
                B_UP_MOVE[10]<= (B_UP_MOVE[10] << 1) | (B_UP_MOVE[10] >> 31);
                B_UP_MOVE[11]<= (B_UP_MOVE[11] << 1) | (B_UP_MOVE[11] >> 31);
                B_UP_MOVE[12]<= (B_UP_MOVE[12] << 1) | (B_UP_MOVE[12] >> 31);
                B_UP_MOVE[13]<= (B_UP_MOVE[13] << 1) | (B_UP_MOVE[13] >> 31);
                B_UP_MOVE[14]<= (B_UP_MOVE[14] << 1) | (B_UP_MOVE[14] >> 31);
                B_UP_MOVE[15]<= (B_UP_MOVE[15] << 1) | (B_UP_MOVE[15] >> 31);
                enemy_status <= OUTPUT_UP;
	       end
	       OUTPUT_UP : begin
	            B_UP[0]<= B_UP_MOVE[0];
                B_UP[1]<= B_UP_MOVE[1];
                B_UP[2]<= B_UP_MOVE[2];
                B_UP[3]<= B_UP_MOVE[3];
                B_UP[4]<= B_UP_MOVE[4];
                B_UP[5]<= B_UP_MOVE[5];
                B_UP[6]<= B_UP_MOVE[6];
                B_UP[7]<= B_UP_MOVE[7];
                B_UP[8]<= B_UP_MOVE[8];
                B_UP[9]<= B_UP_MOVE[9];
                B_UP[10]<= B_UP_MOVE[10];
                B_UP[11]<= B_UP_MOVE[11];
                B_UP[12]<= B_UP_MOVE[12];
                B_UP[13]<= B_UP_MOVE[13];
                B_UP[14]<= B_UP_MOVE[14];
                B_UP[15]<= B_UP_MOVE[15];
                enemy_status <= MOVE_DOWN;
	       end
	       MOVE_DOWN : begin
                B_MOVE[0]<= (B_MOVE[0] << 1) | (B_MOVE[0] >> 31);
                B_MOVE[1]<= (B_MOVE[1] << 1) | (B_MOVE[1] >> 31);
                B_MOVE[2]<= (B_MOVE[2] << 1) | (B_MOVE[2] >> 31);
                B_MOVE[3]<= (B_MOVE[3] << 1) | (B_MOVE[3] >> 31);
                B_MOVE[4]<= (B_MOVE[4] << 1) | (B_MOVE[4] >> 31);
                B_MOVE[5]<= (B_MOVE[5] << 1) | (B_MOVE[5] >> 31);
                B_MOVE[6]<= (B_MOVE[6] << 1) | (B_MOVE[6] >> 31);
                B_MOVE[7]<= (B_MOVE[7] << 1) | (B_MOVE[7] >> 31);
                B_MOVE[8]<= (B_MOVE[8] << 1) | (B_MOVE[8] >> 31);
                B_MOVE[9]<= (B_MOVE[9] << 1) | (B_MOVE[9] >> 31);
                B_MOVE[10]<= (B_MOVE[10] << 1) | (B_MOVE[10] >> 31);
                B_MOVE[11]<= (B_MOVE[11] << 1) | (B_MOVE[11] >> 31);
                B_MOVE[12]<= (B_MOVE[12] << 1) | (B_MOVE[12] >> 31);
                B_MOVE[13]<= (B_MOVE[13] << 1) | (B_MOVE[13] >> 31);
                B_MOVE[14]<= (B_MOVE[14] << 1) | (B_MOVE[14] >> 31);
                B_MOVE[15]<= (B_MOVE[15] << 1) | (B_MOVE[15] >> 31); 
                enemy_status <= OUTPUT_DOWN; 
	       end
	       OUTPUT_DOWN :begin
	            B_UP[0]<= B_MOVE[0];
                B_UP[1]<= B_MOVE[1];
                B_UP[2]<= B_MOVE[2];
                B_UP[3]<= B_MOVE[3];
                B_UP[4]<= B_MOVE[4];
                B_UP[5]<= B_MOVE[5];
                B_UP[6]<= B_MOVE[6];
                B_UP[7]<= B_MOVE[7];
                B_UP[8]<= B_MOVE[8];
                B_UP[9]<= B_MOVE[9];
                B_UP[10]<= B_MOVE[10];
                B_UP[11]<= B_MOVE[11];
                B_UP[12]<= B_MOVE[12];
                B_UP[13]<= B_MOVE[13];
                B_UP[14]<= B_MOVE[14];
                B_UP[15]<= B_MOVE[15];
                enemy_status <= MOVE_UP; 
	       end
	   endcase
	   end 
	   

       if(B_UP[5] <=32'b00000000000000000000000000000000 &&
            B_UP[6]  <=32'b00000000000000000000000000000000 &&
            B_UP[7]  <=32'b00000000000000000000000000000000 &&
            B_UP[8]  <=32'b00000000000000000000000000000000 &&
            B_UP[9]  <=32'b00000000000000000000000000000000 &&
            B_UP[10] <=32'b00000000000000000000000000000000 &&
            B_UP[11] <=32'b00000000000000000000000000000000 &&
            B_UP[12] <=32'b00000000000000000000000000000000 &&
            B_MOVE[5] <=32'b00000000000000000000000000000000 &&
            B_MOVE[6]  <=32'b00000000000000000000000000000000 &&
            B_MOVE[7]  <=32'b00000000000000000000000000000000 &&
            B_MOVE[8]  <=32'b00000000000000000000000000000000 &&
            B_MOVE[9]  <=32'b00000000000000000000000000000000 &&
            B_MOVE[10] <=32'b00000000000000000000000000000000 &&
            B_MOVE[11] <=32'b00000000000000000000000000000000 &&
            B_MOVE[12] <=32'b00000000000000000000000000000000 &&
            B_UP_MOVE[5] <=32'b00000000000000000000000000000000 &&
            B_UP_MOVE[6]  <=32'b00000000000000000000000000000000 &&
            B_UP_MOVE[7]  <=32'b00000000000000000000000000000000 &&
            B_UP_MOVE[8]  <=32'b00000000000000000000000000000000 &&
            B_UP_MOVE[9]  <=32'b00000000000000000000000000000000 &&
            B_UP_MOVE[10] <=32'b00000000000000000000000000000000 &&
            B_UP_MOVE[11] <=32'b00000000000000000000000000000000 &&
            B_UP_MOVE[12] <=32'b00000000000000000000000000000000)begin
            
            next_stage <= 3'b110;           
	   end else if (shift_state ==5'b01100) begin   //あたった状態を保存 
	        B_UP[3]<= B_UP[3]& ~R_UP[13];
	        B_UP[4]<= B_UP[4]& ~R_UP[13];
            B_UP[5]<= B_UP[5]& ~R_UP[13];
            B_UP[6]<= B_UP[6]& ~R_UP[13];
            B_UP[7]<= B_UP[7]& ~R_UP[13];
            B_UP[8]<= B_UP[8]& ~R_UP[13];
            B_UP[9]<= B_UP[9]& ~R_UP[13];
            B_UP[10]<= B_UP[10]& ~R_UP[13];
            B_UP[11]<= B_UP[11]& ~R_UP[13];
            B_UP[12]<= B_UP[12]& ~R_UP[13];
            B_UP[13]<= B_UP[13]& ~R_UP[13];
            
            B_UP_MOVE[3]<= B_UP_MOVE[3]& ~R_UP[13];
            B_UP_MOVE[4]<= B_UP_MOVE[4]& ~R_UP[13];
            B_UP_MOVE[5]<= B_UP_MOVE[5]& ~R_UP[13];
            B_UP_MOVE[6]<= B_UP_MOVE[6]& ~R_UP[13];
            B_UP_MOVE[7]<= B_UP_MOVE[7]& ~R_UP[13];
            B_UP_MOVE[8]<= B_UP_MOVE[8]& ~R_UP[13];
            B_UP_MOVE[9]<= B_UP_MOVE[9]& ~R_UP[13];
            B_UP_MOVE[10]<= B_UP_MOVE[10]& ~R_UP[13];
            B_UP_MOVE[11]<= B_UP_MOVE[11]& ~R_UP[13];
            B_UP_MOVE[12]<= B_UP_MOVE[12]& ~R_UP[13];
            B_UP_MOVE[13]<= B_UP_MOVE[13]& ~R_UP[13];
            
            B_MOVE[3]<= B_MOVE[3]& ~R_UP[13];
            B_MOVE[4]<= B_MOVE[4]& ~R_UP[13];
            B_MOVE[5]<= B_MOVE[5]& ~R_UP[13];
            B_MOVE[6]<= B_MOVE[6]& ~R_UP[13];
            B_MOVE[7]<= B_MOVE[7]& ~R_UP[13];
            B_MOVE[8]<= B_MOVE[8]& ~R_UP[13];
            B_MOVE[9]<= B_MOVE[9]& ~R_UP[13];
            B_MOVE[10]<= B_MOVE[10]& ~R_UP[13];
            B_MOVE[11]<= B_MOVE[11]& ~R_UP[13];
            B_MOVE[12]<= B_MOVE[12]& ~R_UP[13];
            B_MOVE[13]<= B_MOVE[13]& ~R_UP[13];
       end else begin 
            next_stage <= 3'b000;
       end    
        
       if(cur_stage != STAGE3)begin //別のステージの場合に敵ありの状態にする
            B_UP[0]<=32'b00000000000000000000000000000000;
            B_UP[1]<=32'b00000000000000000000000000000000;
            B_UP[2]<=32'b00000000000000000000000000000000;
            B_UP[3]<=32'b00010000000000010000000000010000;
            B_UP[4]<=32'b00111000000000111000000000111000;
            B_UP[5]<=32'b01010100000001010100000001010100;
            B_UP[6]<=32'b01111100000001111100000001111100;
            B_UP[7]<=32'b00101000000000101000000000101000;
            B_UP[8]<=32'b01010100010001010100010001010100;
            B_UP[9]<=32'b00000000111000000000111000000000;
            B_UP[10]<=32'b00000001010100000001010100000000;
            B_UP[11]<=32'b00000001111100000001111100000000;
            B_UP[12]<=32'b00000000111000000000111000000000;
            B_UP[13]<=32'b00000000101000000000101000000000;
            B_UP[14]<=32'b00000000000000000000000000000000;
            B_UP[15]<=32'b00000000000000000000000000000000;
            
                   
            B_UP_MOVE[0]<=32'b00000000000000000000000000000000;
            B_UP_MOVE[1]<=32'b00000000000000000000000000000000;
            B_UP_MOVE[2]<=32'b00000000000000000000000000000000;
            B_UP_MOVE[3]<=32'b00010000000000010000000000010000;
            B_UP_MOVE[4]<=32'b00111000000000111000000000111000;
            B_UP_MOVE[5]<=32'b01010100000001010100000001010100;
            B_UP_MOVE[6]<=32'b01111100000001111100000001111100;
            B_UP_MOVE[7]<=32'b00111000000000111000000000111000;
            B_UP_MOVE[8]<=32'b00101000010000101000010000101000;
            B_UP_MOVE[9]<=32'b00000000111000000000111000000000;
            B_UP_MOVE[10]<=32'b00000001010100000001010100000000;
            B_UP_MOVE[11]<=32'b00000001111100000001111100000000;
            B_UP_MOVE[12]<=32'b00000000101000000000101000000000;
            B_UP_MOVE[13]<=32'b00000001010100000001010100000000;
            B_UP_MOVE[14]<=32'b00000000000000000000000000000000;
            B_UP_MOVE[15]<=32'b00000000000000000000000000000000;
            
            
            B_MOVE[0]<=32'b00000000000000000000000000000000;
            B_MOVE[1]<=32'b00000000000000000000000000000000;
            B_MOVE[2]<=32'b00000000000000000000000000000000;
            B_MOVE[3]<=32'b00010000000000010000000000010000;
            B_MOVE[4]<=32'b00111000000000111000000000111000;
            B_MOVE[5]<=32'b01010100000001010100000001010100;
            B_MOVE[6]<=32'b01111100000001111100000001111100;
            B_MOVE[7]<=32'b00101000000000101000000000101000;
            B_MOVE[8]<=32'b01010100010001010100010001010100;
            B_MOVE[9]<=32'b00000000111000000000111000000000;
            B_MOVE[10]<=32'b00000001010100000001010100000000;
            B_MOVE[11]<=32'b00000001111100000001111100000000;
            B_MOVE[12]<=32'b00000000111000000000111000000000;
            B_MOVE[13]<=32'b00000000101000000000101000000000;
            B_MOVE[14]<=32'b00000000000000000000000000000000;
            B_MOVE[15]<=32'b00000000000000000000000000000000;
            
       end
        
    end
 
end

//敵の移動カウンタ
always @(posedge clk or posedge reset) begin
    if(reset==1'b1) 
        enemy_count <= 22'b0;
    else if (enemy_count == ENEMY_MOVE)
        enemy_count <= 22'b0;
    else 
        enemy_count <= enemy_count + 22'b1;
end




always @(posedge clk or posedge reset) begin
    
    if(reset == 1'b1) begin
            R_DOWN[9] <=32'b00000000000000010000000000000000;
            R_DOWN[10]<=32'b00000000000000010000000000000000;
            R_DOWN[11]<=32'b00000000000000111000000000000000;
            R_DOWN[12]<=32'b00000000000001111100000000000000;
            R_DOWN[13]<=32'b00000000000011111110000000000000;
            R_DOWN[14]<=32'b00000000000011111110000000000000;
            R_DOWN[15]<=32'b00000000000011111110000000000000;
    end else if(cur_stage == STAGE3)begin
        
        if(long_press_en == 1'b1) begin
            if(sw2_value == 1'b1)begin
                R_DOWN[9] <= (R_DOWN[9] << 1) | (R_DOWN[9] >> 31);
                R_DOWN[10] <= (R_DOWN[10] << 1) | (R_DOWN[10] >> 31);
                R_DOWN[11] <= (R_DOWN[11] << 1) | (R_DOWN[11] >> 31);
                R_DOWN[12] <= (R_DOWN[12] << 1) | (R_DOWN[12] >> 31);
                R_DOWN[13] <= (R_DOWN[13] << 1) | (R_DOWN[13] >> 31);
                R_DOWN[14] <= (R_DOWN[14] << 1) | (R_DOWN[14] >> 31);
                R_DOWN[15] <= (R_DOWN[15] << 1) | (R_DOWN[15] >> 31);
                
            end else if(sw0_value ==1'b1 ) begin
                R_DOWN[9] <= (R_DOWN[9] >> 1) | (R_DOWN[9] << 31);
                R_DOWN[10] <= (R_DOWN[10] >> 1) | (R_DOWN[10] << 31);
                R_DOWN[11] <= (R_DOWN[11] >> 1) | (R_DOWN[11] << 31);
                R_DOWN[12] <= (R_DOWN[12] >> 1) | (R_DOWN[12] << 31);
                R_DOWN[13] <= (R_DOWN[13] >> 1) | (R_DOWN[13] << 31);
                R_DOWN[14] <= (R_DOWN[14] >> 1) | (R_DOWN[14] << 31);
                R_DOWN[15] <= (R_DOWN[15] >> 1) | (R_DOWN[15] << 31);
                
            end
        
        end else if(sw2_raise == 1'b1) begin 
            
            R_DOWN[9] <= (R_DOWN[9] << 1) | (R_DOWN[9] >> 31);
            R_DOWN[10] <= (R_DOWN[10] << 1) | (R_DOWN[10] >> 31);
            R_DOWN[11] <= (R_DOWN[11] << 1) | (R_DOWN[11] >> 31);
            R_DOWN[12] <= (R_DOWN[12] << 1) | (R_DOWN[12] >> 31);
            R_DOWN[13] <= (R_DOWN[13] << 1) | (R_DOWN[13] >> 31);
            R_DOWN[14] <= (R_DOWN[14] << 1) | (R_DOWN[14] >> 31);
            R_DOWN[15] <= (R_DOWN[15] << 1) | (R_DOWN[15] >> 31);
                              
       end else if(sw0_raise == 1'b1) begin
            R_DOWN[9] <= (R_DOWN[9] >> 1) | (R_DOWN[9] << 31);
            R_DOWN[10] <= (R_DOWN[10] >> 1) | (R_DOWN[10] << 31);
            R_DOWN[11] <= (R_DOWN[11] >> 1) | (R_DOWN[11] << 31);
            R_DOWN[12] <= (R_DOWN[12] >> 1) | (R_DOWN[12] << 31);
            R_DOWN[13] <= (R_DOWN[13] >> 1) | (R_DOWN[13] << 31);
            R_DOWN[14] <= (R_DOWN[14] >> 1) | (R_DOWN[14] << 31);
            R_DOWN[15] <= (R_DOWN[15] >> 1) | (R_DOWN[15] << 31);
       end
    end
 end

// ボタンの状態に基づいた長押し検出とfly_countの管理
always @(posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
        press_count <= 0;
        fly_count <= 0;
        long_press_en <= 1'b0;
        press_detected <= 1'b0;
    end else begin
        // ボタンが押されている場合
        if (sw0_value == 1'b1 || sw1_value == 1'b1 || sw2_value == 1'b1) begin
            // 長押し検出までカウントアップ
            if (press_count < LONG_PRESS_TIME) begin
                press_count <= press_count + 1'b1;
            end else begin
                press_detected <= 1'b1; // 長押し検出
            end

            // 長押しが検出された後の処理
            if (press_detected == 1'b1) begin
                if (fly_count < FLY_SPEED) begin
                    fly_count <= fly_count + 1'b1;
                    long_press_en <= 1'b0 ;
                end else begin
                    fly_count <= 0;
                    long_press_en <= 1'b1; // 高速シフト有効化
                end
            end
        end else begin
            // ボタンが放されたら、カウンタをリセット
            press_count <= 0;
            fly_count <= 0;
            long_press_en <= 1'b0;
            press_detected <= 1'b0;
        end
    end
end


//ボタンが押された際のボムの発射判定
always @(posedge clk or posedge reset) begin
    if(reset == 1'b1) begin
        shift_enable <= 1'b0;
    end else
        if(cur_stage == STAGE3) begin
            if (sw1_raise == 1'b1 && shift_done == 1'b0) begin // shift_doneが1の場合は発射を許可しない
                shift_enable <= 1'b1;
            end else if (shift_done == 1'b1) begin
                shift_enable <= 1'b0;
            end
        end
end



//ボムのシフト終了判定
always @(posedge clk or posedge reset)
begin
    if (reset == 1'b1) begin
        shift_done <= 1'b0;
    end else if (shift_enable == 1'b1 && bom_count == BOM_SPEED && shift_state == 5'b11010 && long_press_en == 1'b0  && sw1_value == 1'b0 ) begin
        shift_done <= 1'b1;
    end else begin
        shift_done <= 1'b0;
    end
end
   

//ボムのシフト描写
always @(posedge clk or posedge reset)
begin
    if (reset == 1'b1) begin
        R_UP[0]<=32'b00000000000000000000000000000000;
        R_UP[1]<=32'b00000000000000000000000000000000;
        R_UP[2]<=32'b00000000000000000000000000000000;
        R_UP[3]<=32'b00000000000000000000000000000000;
        R_UP[4]<=32'b00000000000000000000000000000000;
        R_UP[5]<=32'b00000000000000000000000000000000;
        R_UP[6]<=32'b00000000000000000000000000000000;
        R_UP[7]<=32'b00000000000000000000000000000000;
        R_UP[8]<=32'b00000000000000000000000000000000;
        R_UP[9]<=32'b00000000000000000000000000000000;
        R_UP[10]<=32'b00000000000000000000000000000000;
        R_UP[11]<=32'b00000000000000000000000000000000;
        R_UP[12]<=32'b00000000000000000000000000000000;
        R_UP[13]<=32'b00000000000000000000000000000000;
        R_UP[14]<=32'b00000000000000000000000000000000;
        R_UP[15]<=32'b00000000000000000000000000000000;

        R_DOWN[0]<=32'b00000000000000000000000000000000;
        R_DOWN[1]<=32'b00000000000000000000000000000000;
        R_DOWN[2]<=32'b00000000000000000000000000000000;
        R_DOWN[3]<=32'b00000000000000000000000000000000;
        R_DOWN[4]<=32'b00000000000000000000000000000000;
        R_DOWN[5]<=32'b00000000000000000000000000000000;
        R_DOWN[6]<=32'b00000000000000000000000000000000;
        R_DOWN[7]<=32'b00000000000000000000000000000000;
        R_DOWN[8]<=32'b00000000000000000000000000000000;
    
        shift_state <= 5'b00000;
        bom_count <= 0;
    end else begin
        if (shift_enable == 1'b1) begin
            if (bom_count == BOM_SPEED) begin  
                bom_count <= 0;
                case (shift_state)
                    5'b00000: R_DOWN[8] <= R_DOWN[9];
                    5'b00001: R_DOWN[7] <= R_DOWN[8];
                    5'b00010: begin
                        R_DOWN[8] <= 32'b00000000000000000000000000000000;
                        R_DOWN[6] <= R_DOWN[7];
                    end
                    5'b00011: begin
                        R_DOWN[7] <= 32'b00000000000000000000000000000000;
                        R_DOWN[5] <= R_DOWN[6];
                    end
                    5'b00100: begin
                        R_DOWN[6] <= 32'b00000000000000000000000000000000;
                        R_DOWN[4] <= R_DOWN[5];
                    end
                    5'b00101: begin
                        R_DOWN[5] <= 32'b00000000000000000000000000000000;
                        R_DOWN[3] <= R_DOWN[4];
                    end
                    5'b00110: begin
                        R_DOWN[4] <= 32'b00000000000000000000000000000000;
                        R_DOWN[2] <= R_DOWN[3];
                    end
                    5'b00111: begin
                        R_DOWN[3] <= 32'b00000000000000000000000000000000;
                        R_DOWN[1] <= R_DOWN[2];
                    end
                    5'b01000: begin
                        R_DOWN[2] <= 32'b00000000000000000000000000000000;
                        R_DOWN[0] <= R_DOWN[1];
                    end
                    5'b01001: begin
                        R_DOWN[1] <= 32'b00000000000000000000000000000000;
                        R_UP[15] <= R_DOWN[0];
                    end
                    5'b01010: begin
                        R_DOWN[0] <= 32'b00000000000000000000000000000000;
                        R_UP[14] <= R_UP[15];
                    end
                    5'b01011: begin
                        R_UP[15] <= 32'b00000000000000000000000000000000;
                        R_UP[13] <= R_UP[14];
                    end
                    5'b01100: begin
                        R_UP[14] <= 32'b00000000000000000000000000000000;
                        R_UP[12] <= R_UP[13];
                    end
                    5'b01101: begin
                        R_UP[13] <= 32'b00000000000000000000000000000000;
                        R_UP[11] <= R_UP[12];
                    end
                    5'b01110: begin
                        R_UP[12] <= 32'b00000000000000000000000000000000;
                        R_UP[10] <= R_UP[11];
                    end
                    5'b01111: begin
                        R_UP[11] <= 32'b00000000000000000000000000000000;
                        R_UP[9]  <= R_UP[10];
                    end
                    5'b10000: begin
                        R_UP[10] <= 32'b00000000000000000000000000000000;
                        R_UP[8]  <= R_UP[9];
                    end
                    5'b10001: begin
                        R_UP[9]  <= 32'b00000000000000000000000000000000;
                        R_UP[7]  <= R_UP[8];
                    end
                    5'b10010: begin
                        R_UP[8]  <= 32'b00000000000000000000000000000000;
                        R_UP[6]  <= R_UP[7];
                    end
                    5'b10011: begin
                        R_UP[7]  <= 32'b00000000000000000000000000000000;
                        R_UP[5]  <= R_UP[6];
                    end
                    5'b10100: begin
                        R_UP[6]  <= 32'b00000000000000000000000000000000;
                        R_UP[4]  <= R_UP[5];
                    end
                    5'b10101: begin
                        R_UP[5]  <= 32'b00000000000000000000000000000000;
                        R_UP[3]  <= R_UP[4];
                    end
                    5'b10110: begin
                        R_UP[4]  <= 32'b00000000000000000000000000000000;
                        R_UP[2]  <= R_UP[3];
                    end
                    5'b10111: begin
                        R_UP[3]  <= 32'b00000000000000000000000000000000;
                        R_UP[1]  <= R_UP[2];
                    end
                    5'b11000: begin
                        R_UP[2]  <= 32'b00000000000000000000000000000000;
                        R_UP[0]  <= R_UP[1];
                    end
                    5'b11001: begin
                        R_UP[1]  <= 32'b00000000000000000000000000000000;
                        R_UP[0]  <= 32'b00000000000000000000000000000000;
                    end
                    5'b11010: begin
                    end

                endcase      

                if (shift_state == 5'b11111) begin
                    shift_state <= 5'b00000;
                end else begin
                    shift_state <= shift_state + 5'b00001;
                end            
            end else if (bom_count < BOM_SPEED) begin
                bom_count <= bom_count + 19'b1;
            end
        end
    end
end

stage3_music stage3_music(
    .clk(clk),
    .reset(reset),
    .cur_stage(cur_stage),
    .sound_en(sound_en),
    .note_sel(note_sel)
);



endmodule
