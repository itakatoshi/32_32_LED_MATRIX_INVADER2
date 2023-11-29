# 32_32_LED_MATRIX_INVADER2
32×32LEDマトリックスを用いたプロジェクト

マイコン(STM32/NUCLEO-F103RB)の作品はこちら。

## 完成品の掲載（ハードウェア）


FPGA(Cmod A7-35T)を使用。

![image](https://github.com/itakatoshi/32_32_LED_MATRIX_INVADER2/assets/141484485/28e6da35-66cf-4730-99fc-92e40b2cd7a3)



## 動作検証


マイコンとFPGAの性能を比較してみる。

**FPGA(Cmod A7-35T)**
iPhoneのカメラで画像を撮影。カメラ撮影でも問題なし。


![IMG_1377](https://github.com/itakatoshi/32_32_LED_MATRIX_INVADER2/assets/141484485/835f70ef-6954-43b4-b1f2-91b99fa788af)


**マイコン(STM32/NUCLEO-F103RB)**
iPhoneのカメラ撮影の場合チラつきはあり（フレームレート）。肉眼で見るととくにチラつきは感じない。


![IMG_1355](https://github.com/itakatoshi/32_32_LED_MATRIX_INVADER2/assets/141484485/528c8824-c75e-4b3f-a42b-45ac56bce994)




**FPGA(Cmod A7-35T)**
iPhoneのカメラで動画を撮影。チラつきはなし。きれいに映る。


https://github.com/itakatoshi/32_32_LED_MATRIX_INVADER2/assets/141484485/310bea91-0dd3-4e10-9655-903a93e4567a

**マイコン(STM32/NUCLEO-F103RB)**
iPhoneのカメラで動画を撮影。肉眼では問題はないが、カメラで撮るとチラつきあり。



https://github.com/itakatoshi/32_32_LED_MATRIX_INVADER2/assets/141484485/e2c47f3c-6300-4d96-a191-4fbbac3c9470




## 回路図


![image](https://github.com/itakatoshi/32_32_LED_MATRIX_INVADER2/assets/141484485/140d90d2-0028-4731-8a54-e33079924ac9)




## 状態遷移図

