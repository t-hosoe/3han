import processing.serial.*;

Serial Zumo1,Zumo2,Zumo3;
int data=0;
int data1_1 = 0;
int data1_2= 0;
int data1_3 = 0;
int data1_4 = 0;
int data2_1 = 0;
int data2_2 = 0;
int data2_3 = 0;
int data2_4 = 0;
int data3_1 = 0;
int data3_2 = 0;
int data3_3 = 0;
int data3_4 = 0;
String mode1 = "Waiting";  // モードの文字列を初期化
String mode2 = "Waiting";  // モードの文字列を初期化
String mode3 = "Waiting";  // モードの文字列を初期化
int Dist1 = 0;
int Dist2 = 0;
int Dist3 = 0;
int direction1 = 0; // Zumo1の方向
int direction2 = 0; // Zumo2の方向
int direction3 = 0; // Zumo3の方向


void setup() {
 

  // シリアルポートの初期化
  Zumo1 = new Serial(this, "/dev/ttyUSB0", 9600);
  //Zumo2 = new Serial(this, "/dev/ttyUSB1", 9600);
  //Zumo3 = new Serial(this, "/dev/ttyUSB2", 9600);
  
  size(1200, 800);
  background(255);
  stroke(0);
  
  // 各四角形エリアの描画
  quad(0, 0, 0, 400, 600, 400, 600, 0);
  quad(0, 400, 0, 800, 600, 800, 600, 400);
  quad(600, 0, 600, 400, 1200, 400, 1200, 0);
  quad(600, 400, 600, 800, 1200, 800, 1200, 400);

  textSize(30);
  fill(0);

  // ラベルを配置
  text("Zumo1", 30, 30);
  text("Zumo2", 30, 430);
  text("Zumo3", 630, 30);
  text("mode:", 350, 30);
  text("mode:", 350, 430);
  text("mode:", 950, 30);
  text("TIME       :", 630, 500);
  text("GET CUP:", 630, 600);
 text("Direction:", 30, 70);
  text("Direction:", 30, 470);
  text("Direction:", 630, 70);
}

void draw() {
  fill(255);
  rect(440, 0, 150, 40);  // モード表示エリアを白で上書き
  fill(0);
  text(mode1, 450, 30);  // 最新のモードを表示

   // Zumo2のモードを表示
  fill(255);
  rect(440, 400, 150, 40);  // Zumo2のモード表示エリアを白で上書き
  fill(0);
  text(mode2, 450, 430);  // Zumo2の最新モードを表示
 // Zumo3のモードを表示
  fill(255);
  rect(1030, 0, 150, 40);  // Zumo2のモード表示エリアを白で上書き
  fill(0);
  text(mode3, 1040, 30);  // Zumo2の最新モードを表示
  
  fill(255);
  rect(440, 200, 150, 40);  // Zumo2のモード表示エリアを白で上書き
  fill(0);
  text(Dist1, 450, 230);  // Zumo2の最新モードを表示
 fill(255);
  rect(440, 600, 150, 40);  // Zumo2のモード表示エリアを白で上書き
  fill(0);
  text(Dist2, 450, 630);  // Zumo2の最新モードを表示
fill(255);
  rect(1030, 200, 150, 40);  // Zumo2のモード表示エリアを白で上書き
  fill(0);
  text(Dist3, 1040, 230);  // Zumo2の最新モードを表示
 // 方向の表示
  fill(255);
  rect(150, 50, 100, 40);
  fill(0);
  text(direction1, 160, 70); // Zumo1の方向を表示

  fill(255);
  rect(150, 450, 100, 40);
  fill(0);
  text(direction2, 160, 470); // Zumo2の方向を表示

  fill(255);
  rect(750, 50, 100, 40);
  fill(0);
  text(direction3, 760, 70); // Zumo3の方向を表示
  // シリアルデータがあるかをチェックし、読み取る
}

void serialEvent(Serial p)
{
   if (p.available() >= 4) {
    if(p.read()=='H')
    {
      if(p==Zumo1)
      {
        data1_1=p.read();        
        data1_2=p.read();
        data1_3=p.read(); // Zumo1の方向を読み取り
        if(data1_1<10){
         mode1=updateMode(data1_1); 
        }
        if(data1_2<80){
        Dist1=data1_2;
        }
        if(data1_3<10){
        direction1=data1_3;
        }
      else if(p==Zumo2)
      {
        data2_1=p.read();        
        data2_2=p.read();
        data2_3=p.read(); // Zumo1の方向を読み取り
        if(data2_1<10){
         mode2=updateMode(data2_1); 
        }
        if(data2_2<80){
        Dist2=data2_2;
        }
        if(data2_3<10){
        direction2=data2_3;
        }
      }
      else if(p==Zumo3)
      {
        data3_1=p.read();        
        data3_2=p.read();
        data3_3=p.read(); // Zumo1の方向を読み取り
        if(data3_1<10){
         mode3=updateMode(data3_1); 
        }
        if(data3_2<80){
        Dist1=data3_2;
        }
        if(data3_3<10){
        direction3=data3_3;
        }
      }
      p.clear();
    }
   
  }
}
  
}
// キーが押されたときの動作
void keyPressed(){
  if (key == 's') {
    noLoop();  // draw()の繰返し処理を停止
  } else if (key == 'c') {
    background(255);  // 背景を再描画
    loop();  // draw()の繰返し処理を再開
  }
}

// シリアルからのデータを受信してモードを更新
String updateMode(int data) {
  switch (data) {
    case 1:
      return "Straight";
    case 2:
      return "Roll";
     
    case 3:
      return "Stop";
    default:
      return "Unknown";
  }
}
