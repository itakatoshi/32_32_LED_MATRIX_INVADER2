
module led_matrix(
    input clk,             // クロック入力
    input reset,
    input wire RED_UP_WIRE,
    input wire RED_DOWN_WIRE,
    input wire GREEN_UP_WIRE,
    input wire GREEN_DOWN_WIRE,
    input wire BLUE_UP_WIRE,
    input wire BLUE_DOWN_WIRE,
    output reg [3:0] row,
    output reg [4:0] col,
    output reg R0, G0, B0, R1, G1, B1, // データ出力
    output reg LED_CLK, STB, OE,     // 制御信号
    output reg [3:0] sel_ABCD    // 行選択信号
);

//ダイナミック点灯の仕様に基づく状態マシンの状態
localparam WAIT = 0,
		   BLANK = 1,
		   LATCH = 2,
		   UNBLANK = 3,
		   READ = 4,
		   SHIFT1 = 5,
		   SHIFT2 = 6;

//WAIT: 待機状態
//BLANK: ディスプレイをブランクにした後、以前にシフトされたデータをラッチ
//LATCH: ラッチされたデータをディスプレイに表示
//UNBLANK: 次に行へ移動
//READ: RAMからの読み取り
//SHIFT1: 列データを出力
//SHIFT2: データをRAMにクロックし、次の列に移動


// レジスタとワイヤ
reg [2:0] state; //状態変数

reg [1:0] bit;
reg [23:0] count;
reg [3:0] delay;

// 2次元の reg 配列
wire [31:0] RED_UP [15:0], RED_DOWN [15:0], GREEN_UP [15:0], GREEN_DOWN [15:0], BLUE_UP [15:0], BLUE_DOWN [15:0];

// クロックロジック
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

		// 状態マシン
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




