int distance() {
  unsigned long interval;        //Echoのパルス幅(μs)
  int dist;                      //距離(cm)
  
  digitalWrite(trig, HIGH);      //10μsのパルスを超音波センサのTrigピンに出力
  delayMicroseconds(10);
  digitalWrite(trig, LOW);

  interval = pulseIn(echo, HIGH, 23071);               //Echo信号がHIGHである時間(μs)を計測
  dist = (0.61 * 25 + 331.5) * interval / 10000 / 2;   //距離(cm)に変換

  delay(60);                     //trigがHIGHになる間隔を60ms以上空ける（超音波センサの仕様）

  if(dist >=150)
    dist = 150;

  return dist;
}

float sum_e = 0;

float turnTo(float theta_r) {
  float u;
  float KP = 4.0;
  float TIinv = 2/1000.0;
  heading_G = atan2(my,mx) * 180 / M_PI;
  if (heading_G<0) heading_G += 360;
  float e = theta_r-heading_G;
  if (e<-180) e+=360;
  if (e>180)  e-=360;
  if (abs(e) > 45.0 ) { // |e|>45のときはP制御
    u = KP*e;           // P制御
  } else {              // |e|<=45 の時はPI制御
    sum_e += TIinv*e*(timeNow_G-timePrev_G);
    u = KP*(e+sum_e);   // PI 制御
  }
  if ( u> 180 ) u = 180;  // 飽和
  if ( u<-180 ) u = -180; // 飽和
  return u;
}

void movement()
{
  float diff;
  dist = distance(); 
  move_color = identifyColor(red_G, green_G, blue_G);
  static unsigned long startTime; // static変数，時間計測ははunsigned long
  // この変数は1秒停止の開始時間を覚えておくために使用
  if(color_b == true){
    switch (mode_G) 
  {
    case 0:
      startTime = timeNow_G;//start時間を保存
      mode_G = 1;//モードを1に変更する
      break;  // break文を忘れない（忘れるとその下も実行される）

    case 1:
      motors.setSpeeds(200, 200);//100の速度でロボットを動かす
      if(maintainState(2000))//nマイクロ秒経ったらモードを2にする
        mode_G = 2;
      break;
      
   case 2:
      motors.setSpeeds(150, -150);//150の速度で回転する
      if(0 < dist && dist < 15){//物体との距離が15cm以内になったらモードを3にする
        mode_G = 3; 
      }
      if(maintainState(2000))
        mode_G = 1;//nマイクロ秒経ったらモードを2にする
    break;
   case 3:
    if(dist >= 5){//物体との距離が5cm以内になるまで前進
      motors.setSpeeds(150,150);   
    }  else if(0 < dist && dist < 5){//物体との距離が5cm以下なら静止
      motors.setSpeeds(0, 0);
      mode_G =4;         
      delay(1000);
      if(dist > 5){//物体との距離が5cm以上になるとモードを1にする
        mode_G = 1;
      }
    }
    break;
    case 4: 
      diff = turnTo(0);
      motorL_G = diff;
      motorR_G = -diff;
      motors.setSpeeds(motorL_G, motorR_G);
      if(abs(0-heading_G)<= 5){
        mode_G = 5;
      }
    break;
    case 5:
      motors.setSpeeds(150, 150);
      if(move_color == 2 || move_color == 3){
        mode_G = 0;
      }
  } 
  }

  switch(move_color){
    case 0:
      break;
    case 1:
      color_b = false;
      motors.setSpeeds(-100, -100);
      delay(1000);
      motors.setSpeeds(150, -150);
      delay(1400);
      color_b = true;
      break;
    case 2:
      color_b = false;
      motors.setSpeeds(100, 100);
      delay(500);
      motors.setSpeeds(-150, -150);
      delay(1000);
      motors.setSpeeds(150, -150);
      delay(1400);
      color_b = true;
      break;
    case 3:
      color_b = false;
      motors.setSpeeds(100, 100);
      delay(500);
      motors.setSpeeds(-150, -150);
      delay(1000);
      motors.setSpeeds(150, -150);
      delay(1400);
      color_b = true;
      break;
    case 4:
      break;
  }
  
  
}

void info_write(){
  Serial.print("timeNow:");
  Serial.print(timeNow_G);
  Serial.print(",");
  Serial.print("mode:");
  Serial.print(mode_G);//モードをシリアルモニタに出力
  Serial.print(",");
  Serial.print("dist:");
  Serial.print(dist); //距離(cm)をシリアルモニタに出力
  Serial.print(",");
  Serial.print("red:");
  Serial.print(red_G);//RGBのred(0~255)の値をシリアルモニタに出力
  Serial.print(",");
  Serial.print("green:");
  Serial.print(green_G);//RGBのgreen(0~255)の値をシリアルモニタに出力
  Serial.print(",");
  Serial.print("move_color:");//0 白　1　黒　2　青　3　赤　4　不明
  Serial.print(move_color);//RGBのgreen(0~255)の値をシリアルモニタに出力
  Serial.print(",");
  Serial.print("heading_p:");//0 白　1　黒　2　青　3　赤　4　不明
  Serial.print(heading_p);//RGBのgreen(0~255)の値をシリアルモニタに出力
  Serial.print(",");
  Serial.print("Head:");//0 白　1　黒　2　青　3　赤　4　不明
  Serial.print(Head);//RGBのgreen(0~255)の値をシリアルモニタに出力
  Serial.print(",");
  Serial.print("blue:");
  Serial.println(blue_G);//RGBのblue(0~255)の値をシリアルモニタに出力
  
}

int maintainState( unsigned long period )
{
  static int flagStart = 0; // 0: 待ち状態，1: 現在計測中
  static unsigned long startTime = 0;
  if ( flagStart == 0 ) { // 待ち状態の場合は計測開始
    startTime = timeNow_G; // 計測を開始した timeNow_G の値を覚えておく
    flagStart = 1; // 現在計測中にしておく
  }
  if ( timeNow_G - startTime > period ) { // 経過時間が指定時間を越えた
    flagStart = 0; // 待ち状態に戻しておく
    startTime = 0; // なくても良いが，形式的に初期化
    return 1;
  }
  else
  return 0;
}

int identifyColor(int red, int green, int blue) {
  if (red > 250 && green > 250 && blue > 250) {
    return 0;//白
  } else if (red < 30 && green < 45 && blue < 45) {
    return 1; //黒
  } else if (red < 55&& green < 95  && blue > 110) {
    return 2; //青
  } else if (red > 130 && green < 65  && blue < 65 ) {
    return 3; //赤
  } else  {
    return 4;//不明
  } 
}
