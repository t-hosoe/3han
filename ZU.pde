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
  // シリアルデータがあるかをチェックし、読み取る
   // 各 Zumo の矢印を描画
  // 矢印を消去する（例：150, 100 の矢印を消す）
  clearArrow(150, 100, 100); // 中心 (150, 100)、半径 100 の円で消去
  drawArrow(150, 100, direction1);
  drawArrow(150, 500, direction2);
  drawArrow(750, 100, direction3);
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
        Dist3=data3_2;
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

void drawArrow(int x, int y, int direction) {
  // 方向が有効でない場合は表示しない
  if (direction < 1 || direction > 8) return;
  
  // 方角に応じた角度 (北=1で 0 度から時計回りに 45 度ずつ増加)
  float angle = radians((direction - 1) * 45);

  // 矢印の長さと計算
  int len = 50; // 矢印の長さ
  int arrowSize = 10; // 矢印の先端サイズ
  float endX = x + cos(angle) * len;
  float endY = y - sin(angle) * len;

  // 矢印を描画
  stroke(0);
  line(x, y, endX, endY);

  // 矢印先端の三角形を描画
  float arrowAngle1 = angle + radians(135);
  float arrowAngle2 = angle - radians(135);
  float tip1X = endX + cos(arrowAngle1) * arrowSize;
  float tip1Y = endY - sin(arrowAngle1) * arrowSize;
  float tip2X = endX + cos(arrowAngle2) * arrowSize;
  float tip2Y = endY - sin(arrowAngle2) * arrowSize;
  fill(0);
  triangle(endX, endY, tip1X, tip1Y, tip2X, tip2Y);
}
// 矢印を消す関数
void clearArrow(int x, int y, int radius) {
  fill(255); // 白色で塗りつぶす
  noStroke();
  ellipse(x, y, radius, radius); // 中心に円を描画
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
