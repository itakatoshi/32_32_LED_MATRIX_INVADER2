
module led_matrix(
    input clk,             // �N���b�N����
    input reset,
    input wire RED_UP_WIRE,
    input wire RED_DOWN_WIRE,
    input wire GREEN_UP_WIRE,
    input wire GREEN_DOWN_WIRE,
    input wire BLUE_UP_WIRE,
    input wire BLUE_DOWN_WIRE,
    output reg [3:0] row,
    output reg [4:0] col,
    output reg R0, G0, B0, R1, G1, B1, // �f�[�^�o��
    output reg LED_CLK, STB, OE,     // ����M��
    output reg [3:0] sel_ABCD    // �s�I��M��
);

//�_�C�i�~�b�N�_���̎d�l�Ɋ�Â���ԃ}�V���̏��
localparam WAIT = 0,
		   BLANK = 1,
		   LATCH = 2,
		   UNBLANK = 3,
		   READ = 4,
		   SHIFT1 = 5,
		   SHIFT2 = 6;

//WAIT: �ҋ@���
//BLANK: �f�B�X�v���C���u�����N�ɂ�����A�ȑO�ɃV�t�g���ꂽ�f�[�^�����b�`
//LATCH: ���b�`���ꂽ�f�[�^���f�B�X�v���C�ɕ\��
//UNBLANK: ���ɍs�ֈړ�
//READ: RAM����̓ǂݎ��
//SHIFT1: ��f�[�^���o��
//SHIFT2: �f�[�^��RAM�ɃN���b�N���A���̗�Ɉړ�


// ���W�X�^�ƃ��C��
reg [2:0] state; //��ԕϐ�

reg [1:0] bit;
reg [23:0] count;
reg [3:0] delay;

// 2������ reg �z��
wire [31:0] RED_UP [15:0], RED_DOWN [15:0], GREEN_UP [15:0], GREEN_DOWN [15:0], BLUE_UP [15:0], BLUE_DOWN [15:0];

// �N���b�N���W�b�N
always @ (posedge clk or posedge reset)
begin
	if (reset)begin
		R0 <= 0;
		G0 <= 0;
		B0 <= 0;
		R1 <= 0;
		G1 <= 0;
		B1 <= 0;
		sel_ABCD <= 0;
		OE <= 1;
		LED_CLK <= 0;
		STB <= 0;
		state <= READ;
		row <= 0;
		bit <= 0;
		col <= 0;
		delay <= 0;
	end else begin

		// ��ԃ}�V��
		case (state)
			WAIT: begin
				LED_CLK <= 0;
				OE <= 1;
				delay <= 8;
				state <= BLANK;
			end

			BLANK: begin
			     if(delay ==0)begin
				    STB <= 1;
				    state <= LATCH;
				    delay <= 8;
				    sel_ABCD <= row;
			     end else begin
			         delay <= delay - 1;
			     end
			end

			LATCH: begin
			     if (delay == 0)begin
				    OE <= 0;
				    STB <= 0;
				    state <= UNBLANK;
			     end else begin
			         delay <= delay - 1;
			     end
			end

			UNBLANK: begin
				if (row == 15) begin
					row <= 0;
				end else begin
					row <= row + 1;
				end
				col <= 0;
				state <= READ;
			end

			READ: begin
				state <= SHIFT1;
				LED_CLK <= 0;
			end

			SHIFT1: begin
				R0 <= RED_UP_WIRE;
				G0 <= GREEN_UP_WIRE;
				B0 <= BLUE_UP_WIRE;
				R1 <= RED_DOWN_WIRE;
				G1 <= GREEN_DOWN_WIRE;
				B1 <= BLUE_DOWN_WIRE;
				state <= SHIFT2;
			end

			SHIFT2: begin
				LED_CLK  <= 1;
				if (col == 31) begin
					col <= 0;
					state <= WAIT;
				end else begin
					col <= col + 1;
					state <= READ;
				end
			end
		endcase
	end
end


endmodule




