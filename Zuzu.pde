import processing.serial.*;

Serial Zumo1;
int data = 0;
String mode = "Waiting";  // モードの文字列を初期化

void setup() {
  // 利用可能なポート一覧を取得して確認する
  println(Serial.list());

  // シリアルポートの初期化
  Zumo1 = new Serial(this, "/dev/ttyUSB0", 9600);
  
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
  text("mode:", 400, 30);
  text("mode:", 400, 430);
  text("mode:", 1000, 30);
  text("TIME       :", 630, 500);
  text("GET CUP:", 630, 600);
}

void draw() {
  fill(255);
  rect(440, 0, 150, 40);  // モード表示エリアを白で上書き
  fill(0);
  text(mode, 450, 30);  // 最新のモードを表示

  // シリアルデータがあるかをチェックし、読み取る
  if (Zumo1.available() > 0) {
    data = Zumo1.read();
    updateMode(data);  // モードの更新
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
void updateMode(int data) {
  switch (data) {
    case 1:
      mode = "Straight";
      break;
    case 2:
      mode = "Roll";
      break;
    case 3:
      mode = "Stop";
      break;
    default:
      mode = "Unknown";
  }
}
