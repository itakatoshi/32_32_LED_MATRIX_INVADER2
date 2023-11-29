
module stage1 (
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
    input wire [3:0]cur_stage,
    output reg sound_en,
    output reg [3:0] note_sel,
    output wire [2:0]next_stage_flag,
    output wire [1:0] stage_select,
    output wire RED_UP_WIRE,
    output wire RED_DOWN_WIRE,
    output wire GREEN_UP_WIRE,
    output wire GREEN_DOWN_WIRE,
    output wire BLUE_UP_WIRE,
    output wire BLUE_DOWN_WIRE
);

// ��Ԃ������萔���`
parameter OPENING = 3'b000;
parameter STAGE1  = 3'b001;
parameter STAGE2  = 3'b010;
parameter STAGE3  = 3'b011;
parameter FINISH  = 3'b100;

//���d�u�U�[�̐���
reg [2:0] next_stage;
reg [1:0] stage_select_flag; 

// 2������ reg �z��
reg [31:0] R_UP [15:0], R_DOWN [15:0], G_UP [15:0], G_DOWN [15:0], B_UP [15:0], B_DOWN [15:0];
reg [31:0] G_UP_TEN [15:0];
reg [23:0] MAX;

// �{���̐���
parameter BOM_SPEED = 100_000; //12MHz  
reg shift_done; // �V�t�g�����t���O
reg [18:0] bom_count; //�{���̃X�s�[�h�J�E���g
reg [4:0] shift_state; //�e�̃V�t�g��
reg shift_enable; //�{���̔��˔���
reg laser_shift_enable;

//��s�@�̐���
parameter FLY_SPEED = 1_200_000; //1.2MHz  
reg [22:0]fly_count;
reg long_press_en; 
parameter LONG_PRESS_TIME = 12_000_000; //12MHz  
reg [23:0] press_count; //����������@12MHz
reg press_detected; 

//���̐���
reg [16:0] sound_count;
parameter BOM_SOUND = 81_250; //12MHz  


assign RED_UP_WIRE = R_UP[row][col];
assign RED_DOWN_WIRE = R_DOWN[row][col];
assign GREEN_UP_WIRE = G_UP[row][col];
assign GREEN_DOWN_WIRE = G_DOWN[row][col];
assign BLUE_UP_WIRE = B_UP[row][col];
assign BLUE_DOWN_WIRE = B_DOWN[row][col];


assign stage_select = stage_select_flag;
assign next_stage_flag = next_stage;


// �G�̐���
always @(posedge clk or posedge reset) begin
	if(reset) begin
        
        G_UP[0]<=32'b00000000000000000000000000000000;
        G_UP[1]<=32'b00000000000000000000000000000000;
        G_UP[2]<=32'b00000000000000000000000000000000;
        G_UP[3]<=32'b00000000000000000000000000000000;
        G_UP[4]<=32'b00000000000000000000000000000000;
        G_UP[5]<=32'b00111111110011111111001111111100;
        G_UP[6]<=32'b00111111110011111111001111111100;
        G_UP[7]<=32'b00111111110011111111001111111100;
        G_UP[8]<=32'b00111111110011111111001111111100;
        G_UP[9]<=32'b00111111110011111111001111111100;
        G_UP[10]<=32'b00111111110011111111001111111100;
        G_UP[11]<=32'b00111111110011111111001111111100;
        G_UP[12]<=32'b00111111110011111111001111111100;
        G_UP[13]<=32'b00000000000000000000000000000000;
        G_UP[14]<=32'b00000000000000000000000000000000;
        G_UP[15]<=32'b00000000000000000000000000000000;
        
        G_UP_TEN[5]<= 0;
        G_UP_TEN[6]<= 0;
        G_UP_TEN[7]<= 0;
        G_UP_TEN[8]<= 0;
        G_UP_TEN[9]<= 0;
        G_UP_TEN[10]<= 0;
        G_UP_TEN[11]<= 0;
        G_UP_TEN[12]<= 0;  
    

        	
	end else  begin 
	
        if ( G_UP[5] == 32'b00000000000000000000000000000000 ) begin
            next_stage <= 3'b100;                 
	    end else if (shift_state ==5'b01100) begin   //����������Ԃ�ۑ� 
            G_UP[5]<= G_UP[5]& ~R_UP[13];
            G_UP[6]<= G_UP[6]& ~R_UP[13];
            G_UP[7]<= G_UP[7]& ~R_UP[13];
            G_UP[8]<= G_UP[8]& ~R_UP[13];
            G_UP[9]<= G_UP[9]& ~R_UP[13];
            G_UP[10]<= G_UP[10]& ~R_UP[13];
            G_UP[11]<= G_UP[11]& ~R_UP[13];
            G_UP[12]<= G_UP[12]& ~R_UP[13];
        end else begin
            G_UP_TEN[5]<= G_UP[5];
            G_UP_TEN[6]<= G_UP[6];
            G_UP_TEN[7]<= G_UP[7];
            G_UP_TEN[8]<= G_UP[8];
            G_UP_TEN[9]<= G_UP[9];
            G_UP_TEN[10]<= G_UP[10];
            G_UP_TEN[11]<= G_UP[11];
            G_UP_TEN[12]<= G_UP[12];  
            next_stage <= 3'b000;    
        end
        
        if(cur_stage != STAGE1)begin //�ʂ̃X�e�[�W�̏ꍇ�ɓG����̏�Ԃɂ���
            G_UP[0]<=32'b00000000000000000000000000000000;
            G_UP[1]<=32'b00000000000000000000000000000000;
            G_UP[2]<=32'b00000000000000000000000000000000;
            G_UP[3]<=32'b00000000000000000000000000000000;
            G_UP[4]<=32'b00000000000000000000000000000000;
            G_UP[5]<=32'b00111111110011111111001111111100;
            G_UP[6]<=32'b00111111110011111111001111111100;
            G_UP[7]<=32'b00111111110011111111001111111100;
            G_UP[8]<=32'b00111111110011111111001111111100;
            G_UP[9]<=32'b00111111110011111111001111111100;
            G_UP[10]<=32'b00111111110011111111001111111100;
            G_UP[11]<=32'b00111111110011111111001111111100;
            G_UP[12]<=32'b00111111110011111111001111111100;
            G_UP[13]<=32'b00000000000000000000000000000000;
            G_UP[14]<=32'b00000000000000000000000000000000;
            G_UP[15]<=32'b00000000000000000000000000000000;
    
            
        end
        
    end
 end


always @(posedge clk or posedge reset) begin
    //if (cur_stage == STAGE1) begin //���݂̃X�e�[�W��STAGE1�Ȃ��
    if(reset == 1'b1) begin
            R_DOWN[9] <=32'b00000000000000010000000000000000;
            R_DOWN[10]<=32'b00000000000000010000000000000000;
            R_DOWN[11]<=32'b00000000000000111000000000000000;
            R_DOWN[12]<=32'b00000000000001111100000000000000;
            R_DOWN[13]<=32'b00000000000011111110000000000000;
            R_DOWN[14]<=32'b00000000000011111110000000000000;
            R_DOWN[15]<=32'b00000000000011111110000000000000;
    end else if(cur_stage == STAGE1)begin
        
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


// �{�^���̏�ԂɊ�Â������������o��fly_count�̊Ǘ�
always @(posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
        press_count <= 0;
        fly_count <= 0;
        long_press_en <= 1'b0;
        press_detected <= 1'b0;
    end else begin
        // �{�^����������Ă���ꍇ
        if (sw0_value == 1'b1 || sw1_value == 1'b1 || sw2_value == 1'b1) begin
            // ���������o�܂ŃJ�E���g�A�b�v
            if (press_count < LONG_PRESS_TIME) begin
                press_count <= press_count + 1'b1;
            end else begin
                press_detected <= 1'b1; // ���������o
            end

            // �����������o���ꂽ��̏���
            if (press_detected == 1'b1) begin
                if (fly_count < FLY_SPEED) begin
                    fly_count <= fly_count + 1'b1;
                    long_press_en <= 1'b0 ;
                end else begin
                    fly_count <= 0;
                    long_press_en <= 1'b1; // �����V�t�g�L����
                end
            end
        end else begin
            // �{�^���������ꂽ��A�J�E���^�����Z�b�g
            press_count <= 0;
            fly_count <= 0;
            long_press_en <= 1'b0;
            press_detected <= 1'b0;
        end
    end
end


//�u�U�[�̐���
always @(posedge clk or posedge reset)begin
    if(reset == 1'b1) 
        sound_en <= 1'b0;
    //else if(cur_stage == STAGE1) begin
    else if(sw1_raise == 1'b1) begin 
            sound_en <= 1'b1;  
    end else if(G_UP_TEN[5]!= G_UP[5]) begin   
            sound_en <= 1'b1;  
    end else if( sound_count == BOM_SOUND ) begin
            sound_en <= 1'b0;
    end 
end





//�u�U�[�Ȃ鎞�Ԃ̃J�E���g
always @(posedge clk or posedge reset)begin
    if(reset==1'b1)begin
        sound_count <=0;
    end else if(sound_en==1'b1) begin
        if (sound_count == BOM_SOUND) begin
            sound_count <= 0;
        end else if( sound_count < BOM_SOUND) begin    
            sound_count <= sound_count + 17'b1;
        end 
    end
end






//�{�^���������ꂽ�ۂ̃{���̔��˔���
always @(posedge clk or posedge reset) begin
    if(reset == 1'b1) begin
        shift_enable <= 1'b0;
    end else
        if(cur_stage == STAGE1) begin
            if (sw1_raise == 1'b1 && shift_done == 1'b0) begin // shift_done��1�̏ꍇ�͔��˂������Ȃ�
                shift_enable <= 1'b1;
            end else if (shift_done == 1'b1) begin
                shift_enable <= 1'b0;
            end
        end
end






//�{���̃V�t�g�I������
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
   

//�{���̃V�t�g�`��
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





endmodule
