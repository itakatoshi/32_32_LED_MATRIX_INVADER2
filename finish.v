
module finish(
    input clk,  // �N���b�N����
    input reset,
    input wire [4:0] col,
    input wire [3:0] row,
    input wire [2:0]cur_stage,
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

// �����̒�`
parameter C = 4'b0000;
parameter D = 4'b0001;
parameter E = 4'b0010;
parameter F = 4'b0011;
parameter G = 4'b0100;
parameter A = 4'b0101;
parameter B = 4'b0110;
parameter C_H = 4'b0111;

//�X�e�[�W�̒�`
reg [2:0] next_stage;
reg [1:0] stage_select_flag; 

reg [23:0] counter = 0;  // 24�r�b�g�J�E���^
reg [7:0] pwm_counter = 0;  // 8�r�b�gPWM�J�E���^
reg [5:0] color;
reg [6:0] color_count;  // 7�r�b�g�J�E���^

// LED0��RGB�l
reg [7:0] r_val0, g_val0, b_val0;

// LED1��RGB�l
reg [7:0] r_val1, g_val1, b_val1;



assign stage_select = stage_select_flag;
assign next_stage_flag = next_stage;


// PWM����
// pwm_counter �̍X�V
always @(posedge clk) begin
    pwm_counter <= pwm_counter + 1'b1;
end


//�A�E�g�v�b�g�֐ڑ�
assign RED_UP_WIRE = (pwm_counter < r_val0);
assign RED_DOWN_WIRE = (pwm_counter < r_val1);
assign GREEN_UP_WIRE = (pwm_counter < g_val0);
assign GREEN_DOWN_WIRE = (pwm_counter < g_val1);
assign BLUE_UP_WIRE = (pwm_counter < b_val0);
assign BLUE_DOWN_WIRE = (pwm_counter < b_val1);


always @(posedge clk or posedge reset) begin
    if(reset == 1'b1) begin
        color <= 5'b00001; 
        color_count <= 7'b0;
        r_val0 <= 0;
        r_val1 <= 0;
        g_val0 <= 0;
        g_val1 <= 0;
        b_val0 <= 0;
        b_val1 <= 0;
        counter <= 0;
        sound_en <= 0;
        next_stage <= 3'b000; 
    end else begin
    if(cur_stage == FINISH) begin
        next_stage <= 3'b000; 
        case(color)
             5'b00000: begin
                color <= 5'b00001;
             end
             5'b00001: begin  // �ԐF�t�F�[�h�C��
                sound_en <= 1;
                note_sel <= C;
                if(color_count == 7'b1111111) begin
                    color <= 5'b00010;  
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    r_val0 <= r_val0 + 1;
                    r_val1 <= r_val1 + 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end

            5'b00010: begin  // �ԐF�t�F�[�h�A�E�g
                sound_en <= 0;
                if(color_count == 7'b1111111) begin
                    color <= 5'b00011;  
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    r_val0 <= r_val0 - 1;
                    r_val1 <= r_val1 - 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end

            5'b00011: begin  // �ΐF�t�F�[�h�C��
                sound_en <= 1;
                note_sel <= C;
                if(color_count == 7'b1111111) begin
                    color <= 5'b00100;  
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    g_val0 <= g_val0 + 1;
                    g_val1 <= g_val1 + 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end

            5'b00100: begin  // �ΐF�t�F�[�h�A�E�g
                sound_en <= 0;
                if(color_count == 7'b1111111) begin
                    color <= 5'b00101;  
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    g_val0 <= g_val0 - 1;
                    g_val1 <= g_val1 - 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end

            5'b00101: begin  // �F�t�F�[�h�C��
                sound_en <= 1;
                note_sel <= G;
                if(color_count == 7'b1111111) begin
                    color <= 5'b00110;  
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    b_val0 <= b_val0 + 1;
                    b_val1 <= b_val1 + 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end

            5'b00110: begin  // �F�t�F�[�h�A�E�g
                sound_en <= 0;
                if(color_count == 7'b1111111) begin
                    color <= 5'b00111;  
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    b_val0 <= b_val0 - 1;
                    b_val1 <= b_val1 - 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end

            5'b00111: begin  // �V�A���F�t�F�[�h�C��
                sound_en <= 1;
                note_sel <= G;
                if(color_count == 7'b1111111) begin
                    color <= 5'b01000;  
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    g_val0 <= g_val0 + 1;
                    g_val1 <= g_val1 + 1;
                    b_val0 <= b_val0 + 1;
                    b_val1 <= b_val1 + 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end

            5'b01000: begin  // �V�A���F�t�F�[�h�A�E�g
                sound_en <= 0;
                if(color_count == 7'b1111111) begin
                    color <= 5'b01001;  
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    g_val0 <= g_val0 - 1;
                    g_val1 <= g_val1 - 1;
                    b_val0 <= b_val0 - 1;
                    b_val1 <= b_val1 - 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end

            5'b01001: begin  // ���F�t�F�[�h�C��
                sound_en <= 1;
                note_sel <= A;
                if(color_count == 7'b1111111) begin
                    color <= 5'b01010;  
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    r_val0 <= r_val0 + 1;
                    r_val1 <= r_val1 + 1;
                    b_val0 <= b_val0 + 1;
                    b_val1 <= b_val1 + 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end

            5'b01010: begin  // ���F�t�F�[�h�A�E�g
                sound_en <= 0;
                if(color_count == 7'b1111111) begin
                    color <= 5'b01011;  
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    r_val0 <= r_val0 - 1;
                    r_val1 <= r_val1 - 1;
                    b_val0 <= b_val0 - 1;
                    b_val1 <= b_val1 - 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end

            5'b01011: begin  // ���F�t�F�[�h�C��
                sound_en <= 1;
                note_sel <= A;
                if(color_count == 7'b1111111) begin
                    color <= 5'b01100;  
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    r_val0 <= r_val0 + 1;
                    r_val1 <= r_val1 + 1;
                    g_val0 <= g_val0 + 1;
                    g_val1 <= g_val1 + 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end

            5'b01100: begin  // ���F�t�F�[�h�A�E�g
                sound_en <= 0;
                if(color_count == 7'b1111111) begin
                    color <= 5'b01101;  
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    r_val0 <= r_val0 - 1;
                    r_val1 <= r_val1 - 1;
                    g_val0 <= g_val0 - 1;
                    g_val1 <= g_val1 - 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end

            5'b01101: begin  //�ԐF�t�F�[�h�C��
                sound_en <= 1;
                note_sel <= G;
                if(color_count == 7'b1111111) begin
                    color <= 5'b01110;  
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    r_val0 <= r_val0 + 1;
                    r_val1 <= r_val1 + 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end

            5'b01110: begin  // �ԐF�t�F�[�h�A�E�g �� �ΐF�t�F�[�h�C��
                //sound_en <= 0;
                if(color_count == 7'b1111111) begin
                    color <= 5'b01111; 
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    r_val0 <= r_val0 - 1;
                    r_val1 <= r_val1 - 1;
                    g_val0 <= g_val0 + 1;
                    g_val1 <= g_val1 + 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            
            5'b01111: begin  // �ΐF�t�F�[�h�A�E�g
                sound_en <= 0;
                if(color_count == 7'b1111111) begin
                    color <= 5'b10000;  
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    g_val0 <= g_val0 - 1;
                    g_val1 <= g_val1 - 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
        
            5'b10000: begin  // �F�t�F�[�h�C�� �� �ΐF�t�F�[�h�C��
                sound_en <= 1;
                note_sel <= F;
                if(color_count == 7'b1111111) begin
                    color <= 5'b10001;  
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    b_val0 <= b_val0 + 1;
                    b_val1 <= b_val1 + 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
        
            5'b10001: begin  // �ΐF�t�F�[�h�A�E�g �� �F�t�F�[�h�C��
                sound_en <= 0;
                if(color_count == 7'b1111111) begin
                    color <= 5'b10010;  
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    g_val0 <= g_val0 + 1;
                    g_val1 <= g_val1 + 1;
                    b_val0 <= b_val0 - 1;
                    b_val1 <= b_val1 - 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
        
            5'b10010: begin  // �F�t�F�[�h�A�E�g �� �ԐF�t�F�[�h�C�� 
                sound_en <= 1;
                note_sel <= F;
                if(color_count == 7'b1111111) begin
                    color <= 5'b10011;
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    g_val0 <= g_val0 - 1;
                    g_val1 <= g_val1 - 1;
                    r_val0 <= r_val0 + 1;
                    r_val1 <= r_val1 + 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
        
            5'b10011: begin  // �V�A���t�F�[�h�A�E�g �� �ԐF�t�F�[�h�C��
                sound_en <= 0;
                if(color_count == 7'b1111111) begin
                    color <= 5'b10100;
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    b_val0 <= b_val0 + 1;
                    b_val1 <= b_val1 + 1;
                    r_val0 <= r_val0 - 1;
                    r_val1 <= r_val1 - 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
        
            5'b10100: begin  // ���F�t�F�[�h�A�E�g �� �t�F�[�h�C�� 
                sound_en <= 1;
                note_sel <= E;
                if(color_count == 7'b1111111) begin
                    color <= 5'b10101;
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    b_val0 <= b_val0 - 1;
                    b_val1 <= b_val1 - 1;
                    g_val0 <= g_val0 + 1;
                    g_val1 <= g_val1 + 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
        
            5'b10101: begin  // ���F�t�F�[�h�A�E�g �� ���F�t�F�[�h�C��
                sound_en <= 0;
                if(color_count == 7'b1111111) begin
                    color <= 5'b10110;
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    r_val0 <= r_val0 + 1;
                    r_val1 <= r_val1 + 1;
                    b_val0 <= b_val0 + 1;
                    b_val1 <= b_val1 + 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
        
            5'b10110: begin  // ���F�t�F�[�h�A�E�g
                    sound_en <= 1;
                    note_sel <= E;
                    if(color_count == 7'b1111111) begin
                        color <= 5'b10111; // �ԐF�t�F�[�h�C���֖߂�
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    r_val0 <= r_val0 - 1;
                    r_val1 <= r_val1 - 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            5'b10111: begin  // ���F�t�F�[�h�A�E�g
                    sound_en <= 0;
                    if(color_count == 7'b1111111) begin
                        color <= 5'b11000; // �ԐF�t�F�[�h�C���֖߂�
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    b_val0 <= b_val0 - 1;
                    b_val1 <= b_val1 - 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            5'b11000: begin  // ���F�t�F�[�h�A�E�g
                    sound_en <= 1;
                    note_sel <= D;
                    if(color_count == 7'b1111111) begin
                        color <= 5'b11001; // �ԐF�t�F�[�h�C���֖߂�
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    r_val0 <= r_val0 + 1;
                    r_val1 <= r_val1 + 1;
                    g_val0 <= g_val0 - 1;
                    g_val1 <= g_val1 - 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            5'b11001: begin  // ���F�t�F�[�h�A�E�g
                    sound_en <= 0;
                    if(color_count == 7'b1111111) begin
                        color <= 5'b11010; // �ԐF�t�F�[�h�C���֖߂�
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    r_val0 <= r_val0 - 1;
                    r_val1 <= r_val1 - 1;
                    b_val0 <= b_val0 + 1;
                    b_val1 <= b_val1 + 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            5'b11010: begin  // ���F�t�F�[�h�A�E�g
                    sound_en <= 1;
                    note_sel <= D;
                    if(color_count == 7'b1111111) begin
                        color <= 5'b11011; // �ԐF�t�F�[�h�C���֖߂�
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    r_val0 <= r_val0 + 1;
                    r_val1 <= r_val1 + 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            
            5'b11011: begin  // ���F�t�F�[�h�A�E�g
                    sound_en <= 0;
                    if(color_count == 7'b1111111) begin
                        color <= 5'b11100; // �ԐF�t�F�[�h�C���֖߂�
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    g_val0 <= g_val0 + 1;
                    g_val1 <= g_val1 + 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            
            5'b11100: begin  // ���F�t�F�[�h�A�E�g
                    sound_en <= 1;
                    note_sel <= C;
                    if(color_count == 7'b1111111) begin
                        color <= 5'b11101; // �ԐF�t�F�[�h�C���֖߂�
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    b_val0 <= b_val0 - 1;
                    b_val1 <= b_val1 - 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            5'b11101: begin  // ���F�t�F�[�h�A�E�g
                    //sound_en <= 0;
                    if(color_count == 7'b1111111) begin
                        color <= 5'b11110; // �ԐF�t�F�[�h�C���֖߂�
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    r_val0 <= r_val0 - 1;
                    r_val1 <= r_val1 - 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            5'b11110: begin  // ���F�t�F�[�h�A�E�g
                    sound_en <= 0;
                    if(color_count == 7'b1111111) begin
                        color <= 5'b11111; // �ԐF�t�F�[�h�C���֖߂�
                    color_count <= 7'b0;
                    counter <= 0;
                end else if(counter == 20_000) begin
                    g_val0 <= g_val0 - 1;
                    g_val1 <= g_val1 - 1;
                    counter <= 0;
                    color_count <= color_count + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            5'b11111: begin
                next_stage <= 3'b111; 
                color <= 5'b00000;
            end
    
    endcase
    end
    end
end

endmodule



