# 32_32_LED_MATRIX_INVADER2


32×32LEDマトリックスを用いた **FPGA(Cmod A7-35T)** のプロジェクト




・LEDマトリックスを用いたインベーダーのようなシューティングゲーム


・ボタン４つで操作し、障害物を破壊する


・タイミングに応じたブザー音、メロディが出る


[マイコン(STM32/NUCLEO-F103RB)の作品はこちら](https://github.com/itakatoshi/32_32_LED_MATRIX_INVADER)



## 完成品の掲載（ハードウェア）


〇主な部品


・FPGA(Cmod A7-35T)


・32×32LEDマトリックス


・タクトスイッチ×4


・圧電ブザー




![image](https://github.com/itakatoshi/32_32_LED_MATRIX_INVADER2/assets/141484485/28e6da35-66cf-4730-99fc-92e40b2cd7a3)



## 動作検証


マイコンとFPGAの差分検証

**FPGA(Cmod A7-35T)**
iPhoneのカメラで画像を撮影　カメラ撮影でも問題なし


![IMG_1377](https://github.com/itakatoshi/32_32_LED_MATRIX_INVADER2/assets/141484485/835f70ef-6954-43b4-b1f2-91b99fa788af)


**マイコン(STM32/NUCLEO-F103RB)**
iPhoneのカメラ撮影の場合チラつきはあり（フレームレート）　肉眼で見るととくにチラつきは感じない　


![IMG_1355](https://github.com/itakatoshi/32_32_LED_MATRIX_INVADER2/assets/141484485/528c8824-c75e-4b3f-a42b-45ac56bce994)




**FPGA(Cmod A7-35T)**
iPhoneのカメラで動画を撮影　　


※GitHub上は10MBの容量制限の為、一部掲載


https://github.com/itakatoshi/32_32_LED_MATRIX_INVADER2/assets/141484485/310bea91-0dd3-4e10-9655-903a93e4567a

**マイコン(STM32/NUCLEO-F103RB)**
iPhoneのカメラ撮影の場合チラつきはあり（フレームレート）　


※GitHub上は10MBの容量制限の為、一部掲載



https://github.com/itakatoshi/32_32_LED_MATRIX_INVADER2/assets/141484485/33e9bb10-f633-44ae-a4e8-a988d9cbf9d6


## 回路図


![image](https://github.com/itakatoshi/32_32_LED_MATRIX_INVADER2/assets/141484485/140d90d2-0028-4731-8a54-e33079924ac9)


![image](https://github.com/itakatoshi/32_32_LED_MATRIX_INVADER2/assets/141484485/8aa07623-2d5d-4dc8-8a46-24b28b93062a)


## 状態遷移図

![image](https://github.com/itakatoshi/32_32_LED_MATRIX_INVADER2/assets/141484485/2c7b2398-abab-4373-8830-4cae350c3180)

