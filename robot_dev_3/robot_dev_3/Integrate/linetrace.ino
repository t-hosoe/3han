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
  // この変数は1秒停止の開始時間を覚えておくために使用
  switch (mode_G) 
  {
    case 0:
      startTime = timeNow_G;
      mode_G = 1;
      break;  // break文を忘れない（忘れるとその下も実行される）

    case 1:
      motors.setSpeeds(100, 100);
      if(maintainState(2000))
        mode_G = 2;
      break;
      
   case 2:
      motors.setSpeeds(150, -150);
      if(0 < dist && dist < 15){
        mode_G = 3; 
      }
      if(maintainState(2000))
        mode_G = 0;
    break;
   case 3:
    if(dist >= 5){//アームの中に入れるまで前進
      motors.setSpeeds( 100, 100);   
    }  else if(0 < dist && dist < 5){
      motors.setSpeeds(0, 0);         
      delay(1000);
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
