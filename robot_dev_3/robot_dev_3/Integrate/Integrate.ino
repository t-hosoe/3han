#include <Wire.h>
#include <ZumoMotors.h>
#include <Pushbutton.h>
#include <LSM303.h>

ZumoMotors motors;
Pushbutton button(ZUMO_BUTTON);
LSM303 compass;

const int trig = 2;              //TrigピンをArduinoの2番ピンに
const int echo = 4;              //EchoピンをArduinoの4番ピンに
const int buzzerPin = 3;              //超音波センサのglobal関数
float red_G, green_G, blue_G; // カラーセンサで読み取ったRGB値（0-255）
bool isRed_G, isBlue_G;
int mode_G; // タスクのモードを表す状態変数
unsigned long timeInit_G, timeNow_G, timePrev_G; //  スタート時間，経過時間, 1回前
int motorR_G, motorL_G; // 左右のZumoのモータに与える回転力
int dist;
float mx=0, my=0, mz=0;
float ax=0, ay=0, az=0;
float  heading_G= 0;
float heading_p = 0;
bool color_b;
bool change_black;
bool mp;
bool cm;
int move_color;
int Head=0;
int moveRobot;
int checkDist;
int checkStart= 0;
int straight_time = 0;

void setup()
{
  button.waitForButton(); //ユーザボタンが押されるまで待機
  Serial.begin(9600);
  pinMode(trig, OUTPUT); //trig を出力ポートに設定
  pinMode(echo, INPUT); //echo を入力ポートに設定
  Wire.begin();
  setupCompass();
  button.waitForButton(); 
  CalibrationColorSensor();
  calibrationCompass();
  button.waitForButton();
  timeInit_G = millis();
  timePrev_G=0;
  mode_G = 0;
  motorR_G = 0;
  motorL_G = 0;
  color_b = true;
  change_black = false;
  mp = false;
  cm = true;
  move_color = 0;
}

void loop()
{
  getRGB(red_G, green_G, blue_G); // カラーセンサでRGB値を取得(0-255)
  timeNow_G = millis() - timeInit_G; // 経過時間
  //motors.setSpeeds(motorL_G, motorR_G); // 左右モーターへの回転力入力
  if (timeNow_G-timePrev_G<100) {
    return;
  }
  compass.read();
  compass.m_min.x = min(compass.m.x,compass.m_min.x);  compass.m_max.x = max(compass.m.x,compass.m_max.x);
  compass.m_min.y = min(compass.m.y,compass.m_min.y);  compass.m_max.y = max(compass.m.y,compass.m_max.y);
  compass.m_min.z = min(compass.m.z,compass.m_min.z);  compass.m_max.z = max(compass.m.z,compass.m_max.z);
  ax = compass.a.x/256; //map(compass.a.x,-32768,32767,-128,127);
  ay = compass.a.y/256; //map(compass.a.y,-32768,32767,-128,127);
  az = compass.a.z/256; //map(compass.a.z,-32768,32767,-128,127);
  mx = map(compass.m.x,compass.m_min.x,compass.m_max.x,-128,127);
  my = map(compass.m.y,compass.m_min.y,compass.m_max.y,-128,127);
  mz = map(compass.m.z,compass.m_min.z,compass.m_max.z,-128,127); 
  
  heading_p = atan2(my,mx) * 180 / M_PI;
  Head=checkHead(heading_p);
  
  sendData(); // データ送信

  movement_North();
  //movement_South();

  info_write();
}

int checkHead(float G){
  int hougaku;
  
  if(G<0){
    G+=360;
  }
  if(337.5<G&&G<=360||0<=G && G<=22.5){
    hougaku=1;//北
  }
  else if(22.5<G&&G<=67.5)
  {
    hougaku=2;//北東
  }
  else if(67.5<G&&G<=112.5)
  {
    hougaku=3;//東
  }
   else if(112.5<G&&G<=157.5)
  {
    hougaku=4;//南東
  }
   else if(157.5<G&&G<=202.5)
  {
    hougaku=5;//南
  }
  else if(202.5<G&&G<=247.5)
  {
    hougaku=6;//南西
  }
   else if(247.5<G&&G<=292.5)
  {
    hougaku=7;//西
  }
   else if(292.5<G&&G<=337.5)
  {
    hougaku=8;//北西
  }
  return hougaku;
}

// 通信方式2
void sendData()
{
  static unsigned long timePrev = 0;
  static boolean flag_start = true; // 最初の通信かどうか
  int inByte; 

  // if文の条件： 最初の通信である || 
  // 最後のデータ送信から500ms経過 || 
  // (データ送信要求が来ている && 最後のデータ送信から50ms経過)
  if (flag_start == true || 
      timeNow_G - timePrev > 500 || 
      (Serial.available() > 0 && timeNow_G - timePrev > 50)) 
 {
    flag_start = false;
    while(Serial.available() > 0)
    { 
      // 送信要求が複数来ていた場合は全て読み込む
      inByte = Serial.read();
    }
    
    Serial.write('H');
    Serial.write(mode_G);
    Serial.write(dist);
    Serial.write(Head);
    Serial.write(move_color);
    
    //Serial.write((int)red_G);
    //Serial.write((int)green_G );
    //Serial.write((int)blue_G);

    timePrev = timeNow_G;
  }
}
