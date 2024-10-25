import processing.serial.*;

Serial Zumo1,Zumo2;
int data=0;
int data1 = 0;
int data2 = 0;
int data3 = 0;
String mode1 = "Waiting";  // モードの文字列を初期化
String mode2 = "Waiting";  // モードの文字列を初期化
String mode3 = "Waiting";  // モードの文字列を初期化

void setup() {
 

  // シリアルポートの初期化
  Zumo1 = new Serial(this, "/dev/ttyUSB0", 9600);
  Zumo2 = new Serial(this, "/dev/ttyUSB1", 9600);
  Zumo3 = new Serial(this, "/dev/ttyUSB2", 9600);
  
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
  // シリアルデータがあるかをチェックし、読み取る
}

void serialEvent(Serial p)
{
   if (p.available() >= 2) {
    if(p.read()=='H')
    {
      if(p==Zumo1)
      {
        data1=p.read();
        mode1=updateMode(data1);
      }
      else if(p==Zumo2)
      {
        data2 = p.read();
        mode2 = updateMode(data2);
      }
      else if(p==Zumo3)
      {
        data3 = p.read();
        mode3 = updateMode(data3);
      }
      p.clear();
    }
   
  }
}
  

// キーが押されたときの動作
void keyPressed() {
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
