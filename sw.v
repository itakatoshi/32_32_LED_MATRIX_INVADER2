
module sw_if(
    input clk,
    input reset,
    input sw0_in,
    input sw1_in,
    input sw2_in,
    input sw3_in,
    output sw0_out,
    output sw1_out,
    output sw2_out,
    output sw3_out
 );
 
reg [17:0] timing_cnt;
wire check_sig;
wire sw0_value;
wire sw1_value;
wire sw2_value;
wire sw3_value;
 
 
 //チャタリング除去　タイミング生成 
 //10m秒ごとに設定
 //12MHz(83.33n秒)
always@(posedge clk, posedge reset)
    if(reset ==1'b1)
        timing_cnt <= 18'd0;
    else 
        timing_cnt <= timing_cnt + 18'd1;
        
assign check_sig = (timing_cnt ==18'd120000)? 1'b1:1'b0;

sw_check u0(
    .clk(clk),
    .reset(reset),
    .sw_in(sw0_in),
    .check_sig(check_sig),
    .sw_out(sw0_value)
);

sw_check u1(
    .clk(clk),
    .reset(reset),
    .sw_in(sw1_in),
    .check_sig(check_sig),
    .sw_out(sw1_value)
);

sw_check u2(
    .clk(clk),
    .reset(reset),
    .sw_in(sw2_in),
    .check_sig(check_sig),
    .sw_out(sw2_value)
);

sw_check u3(
    .clk(clk),
    .reset(reset),
    .sw_in(sw3_in),
    .check_sig(check_sig),
    .sw_out(sw3_value)
);

assign sw0_out = sw0_value;
assign sw1_out = sw1_value;
assign sw2_out = sw2_value;    
assign sw3_out = sw3_value;    
    
endmodule


    

module sw_check(
    input clk,
    input reset,
    input sw_in,
    input check_sig,
    output sw_out
);

reg sw_dff1,sw_dff2;
reg sw_t1,sw_t2,sw_t3;
reg sw_value;

//メタステーブル対策
always@(posedge clk)begin
    sw_dff1 <=sw_in;
    sw_dff2 <=sw_dff1;
end

//チャタリング防止 値の保存
always@(posedge clk or posedge reset) begin
    if(reset ==1'b1)begin
        sw_t1 <= 1'b1;
        sw_t2 <= 1'b1;
    end
    else
        if(check_sig ==1'b1)begin
            sw_t1 <=sw_dff2;
            sw_t2 <=sw_t1;
        end
        else begin
            sw_t1 <=sw_t1;
            sw_t2 <=sw_t2;
      
        end
end

//2回確定値が来たらONにする
always @(posedge clk, posedge reset)
if(reset ==1'b1)
    sw_value <= 1'b1;
else
    if(check_sig==1'b1)
        if((sw_t1==1'b0)&&(sw_t2==1'b0))
            sw_value <= 1'b1; 
        else if((sw_t1==1'b1)&&(sw_t2==1'b1))
            sw_value <= 1'b0;
        else
            sw_value <= sw_value;
    else
        sw_value <= sw_value;
       
assign sw_out =sw_value;

endmodule
         
         
         
         
    