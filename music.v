module stage3_music(
    input clk,  // クロック入力
    input reset,
    input wire [2:0]cur_stage,
    output reg sound_en,
    output reg [3:0] note_sel
);

// 状態を示す定数を定義
parameter OPENING = 3'b000;
parameter STAGE1  = 3'b001;
parameter STAGE2  = 3'b010;
parameter STAGE3  = 3'b011;
parameter FINISH  = 3'b100;

reg [7:0] music;
reg [22:0] counter;
parameter MAX = 3_000_000;

// 音程の定義
parameter C = 4'b0000;
parameter D = 4'b0001;
parameter E = 4'b0010;
parameter F = 4'b0011;
parameter G = 4'b0100;
parameter A = 4'b0101;
parameter B = 4'b0110;
parameter C_H = 4'b0111;
parameter D_H = 4'b1000;
parameter E_H = 4'b1001;
parameter F_H = 4'b1010;
parameter G_H = 4'b1011;
parameter A_H = 4'b1100;
parameter B_H = 4'b1101;
parameter C_HIGHER = 4'b1110;

// 音符の再生を行う関数
function [7:0] play_note;
    input [3:0] note;
    input [7:0] current_state;
    input [7:0] next_state;
begin
    if(counter == MAX) begin
        sound_en = 1;
        note_sel = note;
        play_note = next_state;
    end else begin
        play_note = current_state;
    end
end
endfunction

// 休止の再生を行う関数
function [7:0] play_rest;
    input [7:0] current_state;
    input [7:0] next_state;
begin
    if(counter == MAX) begin
        sound_en = 0;  // 休止のため音をオフにする
        play_rest = next_state;
    end else begin
        play_rest = current_state;
    end
end
endfunction

always @(posedge clk or posedge reset) begin
    if(reset == 1'b1) begin
        music <= 8'b00000000;
        counter <= 0;
        sound_en <= 0;
    end else begin
case(music)
    8'b00000000:begin 
                    if(cur_stage == STAGE3) music <= 8'b00000001;
                    else music <= 8'b00000000;
                end
    8'b00000001: music <= play_note(A, 8'b00000001, 8'b00000010);
    8'b00000010: music <= play_rest(8'b00000010, 8'b00000011);
    8'b00000011: music <= play_note(A, 8'b00000011, 8'b00000100);
    8'b00000100: music <= play_rest(8'b00000100, 8'b00000101);
    8'b00000101: music <= play_note(B, 8'b00000101, 8'b00000110);
    8'b00000110: music <= play_note(B, 8'b00000110, 8'b00000111);
    8'b00000111: music <= play_note(A, 8'b00000111, 8'b00001000);
    8'b00001000: music <= play_rest(8'b00001000, 8'b00001001);
    8'b00001001: music <= play_note(A, 8'b00001001, 8'b00001010);
    8'b00001010: music <= play_rest(8'b00001010, 8'b00001011);
    8'b00001011: music <= play_note(B, 8'b00001011, 8'b00001100);
    8'b00001100: music <= play_note(B, 8'b00001100, 8'b00001101);
    8'b00001101: music <= play_note(A, 8'b00001101, 8'b00001110);
    8'b00001110: music <= play_rest(8'b00001110, 8'b00001111);
    8'b00001111: music <= play_note(B, 8'b00001111, 8'b00010000);
    8'b00010000: music <= play_rest(8'b00010000, 8'b00010001);
    8'b00010001: music <= play_note(C_H, 8'b00010001, 8'b00010010);
    8'b00010010: music <= play_rest(8'b00010010, 8'b00010011);
    8'b00010011: music <= play_note(B, 8'b00010011, 8'b00010100);
    8'b00010100: music <= play_note(A, 8'b00010100, 8'b00010101);
    8'b00010101: music <= play_note(A, 8'b00010101, 8'b00010110);
    8'b00010110: music <= play_note(B, 8'b00010110, 8'b00010111);
    8'b00010111: music <= play_note(F, 8'b00010111, 8'b00011000);
    8'b00011000: music <= play_rest(8'b00011000, 8'b00011001);
    8'b00011001: music <= play_note(E, 8'b00011001, 8'b00011010);
    8'b00011010: music <= play_rest(8'b00011010, 8'b00011011);
    8'b00011011: music <= play_note(C, 8'b00011011, 8'b00011100);
    8'b00011100: music <= play_rest(8'b00011100, 8'b00011101);
    8'b00011101: music <= play_note(E, 8'b00011101, 8'b00011110);
    8'b00011110: music <= play_note(F, 8'b00011110, 8'b00011111);
    8'b00011111: music <= play_note(E, 8'b00011111, 8'b00100000);
    8'b00100000: music <= play_note(E, 8'b00100000, 8'b00100001);
    8'b00100001: music <= play_rest(8'b00100001, 8'b00100010);
    8'b00100010: music <= play_note(C_H, 8'b00100010, 8'b00100011);  // 2回目のC_H
    8'b00100011: music <= play_rest(8'b00100011, 8'b00100100);
    8'b00100100: music <= play_note(B, 8'b00100100, 8'b00100101);           
    8'b00100101: music <= play_note(A, 8'b00100101, 8'b00100110);
    8'b00100110: music <= play_rest(8'b00100110, 8'b00100111);
    8'b00100111: music <= play_note(A, 8'b00100111, 8'b00101000);
    8'b00101000: music <= play_rest(8'b00101000, 8'b00101001);
    8'b00101001: music <= play_note(B, 8'b00101001, 8'b00101010);
    8'b00101010: music <= play_rest(8'b00101010, 8'b00101011);
    8'b00101011: music <= play_note(E, 8'b00101011, 8'b00101100);
    8'b00101100: music <= play_note(F, 8'b00101100, 8'b00101101);
    8'b00101101: music <= play_note(B, 8'b00101101, 8'b00101110);
    8'b00101110: music <= play_rest(8'b00101110, 8'b00101111);
    8'b00101111: music <= play_note(A, 8'b00101111, 8'b00110000);
    8'b00110000: music <= play_note(F, 8'b00110000, 8'b00110001);
    8'b00110001: music <= play_rest(8'b00110001, 8'b00110010);
    8'b00110010: music <= play_note(E, 8'b00110010, 8'b00110011);
    8'b00110011: music <= 8'b00000000;
endcase                
        if(counter != MAX) begin
            counter <= counter + 23'b1;
        end else begin
            counter <= 0;
        end
    end
end

endmodule
