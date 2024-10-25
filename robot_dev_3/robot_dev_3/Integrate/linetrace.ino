int distance() {
  unsigned long interval;        //Echoのパルス幅(μs)
  int dist;                      //距離(cm)
  
  digitalWrite(trig, HIGH);      //10μsのパルスを超音波センサのTrigピンに出力
  delayMicroseconds(10);
  digitalWrite(trig, LOW);

  interval = pulseIn(echo, HIGH, 23071);               //Echo信号がHIGHである時間(μs)を計測
  dist = (0.61 * 25 + 331.5) * interval / 10000 / 2;   //距離(cm)に変換

  delay(60);                     //trigがHIGHになる間隔を60ms以上空ける（超音波センサの仕様）

  return dist;
}

void movement()
{
  int dist;
  dist = distance(); 
  static unsigned long startTime; // static変数，時間計測ははunsigned long
  Serial.println(dist); //距離をシリアルモニタに出力
  Serial.println(mode_G);//モードをシリアルモニタに出力
  // この変数は1秒停止の開始時間を覚えておくために使用
  switch (mode_G) 
  {
    case 0:
      startTime = timeNow_G;//start時間を保存
      mode_G = 1;//モードを1に変更する
      break;  // break文を忘れない（忘れるとその下も実行される）

    case 1:
      motors.setSpeeds(100, 100);//100の速度でロボットを動かす
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
      motors.setSpeeds(100,100);   
    }  else if(0 < dist && dist < 5){//物体との距離が5cm以下なら静止
      motors.setSpeeds(0, 0);         
      delay(1000);
      if(dist > 5){//物体との距離が5cm以上になるとモードを1にする
        mode_G = 1;
      }
    }
    break;
  }
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
