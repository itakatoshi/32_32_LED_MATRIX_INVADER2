
module top(
    input clk,             // �N���b�N����
    input reset,
    input wire sw0,
    input wire sw1,
    input wire sw2,
    input wire sw3,
    output wire sound_out,
    output wire R0, G0, B0, R1, G1, B1, // �f�[�^�o��
    output wire LED_CLK, STB, OE,     // ����M��
    output wire [3:0] sel_ABCD    // �s�I��M��
);

wire [2:0]next_stage_flag;
wire [1:0] stage_select; 
wire [2:0]cur_stage;
wire sw0_value, sw1_value, sw2_value, sw3_value; //�`���^�����O�������sw0��sw1
wire [3:0] row;
wire [4:0] col;
wire RED_UP_WIRE;
wire RED_DOWN_WIRE;
wire GREEN_UP_WIRE;
wire GREEN_DOWN_WIRE;
wire BLUE_UP_WIRE;
wire BLUE_DOWN_WIRE;

//�`���^�����O����
sw_if sw(
    .clk(clk),
    .reset(reset),
    .sw0_in(sw0),
    .sw1_in(sw1),
    .sw2_in(sw2),
    .sw3_in(sw3),
    .sw0_out(sw0_value),
    .sw1_out(sw1_value),
    .sw2_out(sw2_value),
    .sw3_out(sw3_value)
);

//��Ԋm�F
stage stage(
    .clk(clk),
    .reset(reset),
    .next_stage_flag(next_stage_flag),
    .cur_stage(cur_stage)
);

//����
action action(
    .clk(clk),
    .reset(reset),
    .sw0_value(sw0_value),
    .sw1_value(sw1_value),
    .sw2_value(sw2_value),
    .sw3_value(sw3_value),
    .cur_stage(cur_stage),
    .row(row),
    .col(col),    
    .sound_out(sound_out),
    .next_stage_flag(next_stage_flag),
    .stage_select(stage_select),
    .RED_UP_WIRE(RED_UP_WIRE),  
    .RED_DOWN_WIRE(RED_DOWN_WIRE),  
    .GREEN_UP_WIRE(GREEN_UP_WIRE),  
    .GREEN_DOWN_WIRE(GREEN_DOWN_WIRE),  
    .BLUE_UP_WIRE(BLUE_UP_WIRE),  
    .BLUE_DOWN_WIRE(BLUE_DOWN_WIRE)  
);

//�o�́i�_�C�i�~�b�N�_���j
led_matrix(
    .clk(clk),
    .reset(reset),
    .RED_UP_WIRE(RED_UP_WIRE),  
    .RED_DOWN_WIRE(RED_DOWN_WIRE),  
    .GREEN_UP_WIRE(GREEN_UP_WIRE),  
    .GREEN_DOWN_WIRE(GREEN_DOWN_WIRE),  
    .BLUE_UP_WIRE(BLUE_UP_WIRE),  
    .BLUE_DOWN_WIRE(BLUE_DOWN_WIRE),  
    .row(row),
    .col(col),
    .R0(R0),
    .R1(R1),
    .G0(G0),
    .G1(G1),
    .B0(B0),
    .B1(B1),
    .LED_CLK(LED_CLK),
    .STB(STB),
    .OE(OE),
    .sel_ABCD(sel_ABCD)
);




endmodule
