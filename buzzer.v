
module buzzer(
    input clk,
    input reset,
    input [3:0] note_sel, // 4 bits to select one of 16 notes
    input sound_en,
    output sound_out
);

parameter DIV_C = 12_000_000 / (2 * 261.63) - 1;
parameter DIV_D = 12_000_000 / (2 * 293.66) - 1;
parameter DIV_E = 12_000_000 / (2 * 329.63) - 1;
parameter DIV_F = 12_000_000 / (2 * 349.23) - 1;
parameter DIV_G = 12_000_000 / (2 * 392.00) - 1;
parameter DIV_A = 12_000_000 / (2 * 440.00) - 1;
parameter DIV_B = 12_000_000 / (2 * 493.88) - 1;
parameter DIV_HIGH_C = 12_000_000 / (2 * 523.25) - 1;
parameter DIV_HIGH_D = 12_000_000 / (2 * 587.33) - 1;
parameter DIV_HIGH_E = 12_000_000 / (2 * 659.25) - 1;
parameter DIV_HIGH_F = 12_000_000 / (2 * 698.46) - 1;
parameter DIV_HIGH_G = 12_000_000 / (2 * 783.99) - 1;
parameter DIV_HIGH_A = 12_000_000 / (2 * 880.00) - 1;
parameter DIV_HIGH_B = 12_000_000 / (2 * 987.77) - 1;
parameter DIV_HIGHER_C = 12_000_000 / (2 * 1046.50) - 1;

reg [23:0] clk_divider = 0;
reg [23:0] current_div;
reg pwm_state = 0;

always @(posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
        clk_divider <= 0;
        pwm_state <= 0;
    end else begin
        if (sound_en == 1'b1) begin
            case(note_sel)
                4'b0000: current_div = DIV_C;
                4'b0001: current_div = DIV_D;
                4'b0010: current_div = DIV_E;
                4'b0011: current_div = DIV_F;
                4'b0100: current_div = DIV_G;
                4'b0101: current_div = DIV_A;
                4'b0110: current_div = DIV_B;
                4'b0111: current_div = DIV_HIGH_C;
                4'b1000: current_div = DIV_HIGH_D;
                4'b1001: current_div = DIV_HIGH_E;
                4'b1010: current_div = DIV_HIGH_F;
                4'b1011: current_div = DIV_HIGH_G;
                4'b1100: current_div = DIV_HIGH_A;
                4'b1101: current_div = DIV_HIGH_B;
                4'b1110: current_div = DIV_HIGHER_C;
                default : current_div = DIV_C;
            endcase

            if (clk_divider == current_div) begin
                clk_divider <= 0;
                pwm_state <= ~pwm_state;
            end else begin
                clk_divider <= clk_divider + 24'b1;
            end
        end else begin
            clk_divider <= 0;
            pwm_state <= 0;
        end
    end
end

assign sound_out = (clk_divider < current_div/2) ? pwm_state : ~pwm_state;

endmodule




//module buzzer(
//    input clk,
//    input reset,
//    input [2:0] note_sel, // 3 bits to select one of 8 notes
//    input sound_en,
//    output sound_out
//);

//parameter DIV_C = 12_000_000 / (2 * 261.63) - 1;  // PWMが上昇エッジと下降エッジの両方で動作する
//parameter DIV_D = 12_000_000 / (2 * 293.66) - 1;
//parameter DIV_E = 12_000_000 / (2 * 329.63) - 1;
//parameter DIV_F = 12_000_000 / (2 * 349.23) - 1;
//parameter DIV_G = 12_000_000 / (2 * 392.00) - 1;
//parameter DIV_A = 12_000_000 / (2 * 440.00) - 1;
//parameter DIV_B = 12_000_000 / (2 * 493.88) - 1;
//parameter DIV_HIGH_C = 12_000_000 / (2 * 523.25) - 1;

//reg [23:0] clk_divider = 0;
//reg [23:0] current_div;
//reg pwm_state = 0;

//always @(posedge clk or posedge reset) begin
//    if (reset == 1'b1) begin
//        clk_divider <= 0;
//        pwm_state <= 0;
//    end else begin
//        if (sound_en == 1'b1) begin
//            case(note_sel)
//                3'b000: current_div = DIV_C;
//                3'b001: current_div = DIV_D;
//                3'b010: current_div = DIV_E;
//                3'b011: current_div = DIV_F;
//                3'b100: current_div = DIV_G;
//                3'b101: current_div = DIV_A;
//                3'b110: current_div = DIV_B;
//                3'b111: current_div = DIV_HIGH_C;
//                default : current_div = DIV_C;
//            endcase

//            if (clk_divider == current_div) begin
//                clk_divider <= 0;
//                pwm_state <= ~pwm_state;
//            end else begin
//                clk_divider <= clk_divider + 24'b1;
//            end
//        end else begin
//            clk_divider <= 0;
//            pwm_state <= 0;
//        end
//    end
//end

//assign sound_out = (clk_divider < current_div/2) ? pwm_state : ~pwm_state;

//endmodule


//module buzzer(
//    input clk,
//    input reset,
//    input sound_en,
//    output sound_out
//);

//parameter DIV_1000Hz = 12_000_000 / 1000 - 1;

//reg [16:0] clk_divider = 0;
//reg pwm_state = 0;

//always @(posedge clk or posedge reset) begin
//    if (reset == 1'b1) begin
//        clk_divider <= 0;
//        pwm_state <= 0;
//    end else if (sound_en == 1'b1) begin
//        if (clk_divider == DIV_1000Hz) begin
//            clk_divider <= 0;
//            pwm_state <= ~pwm_state;
//        end else begin
//            clk_divider <= clk_divider + 17'b1;
//        end
//    end
//end

//assign sound_out = (clk_divider < DIV_1000Hz/2) ? pwm_state : ~pwm_state;

//endmodule
