import processing.serial.*;

Serial Zumo1, Zumo2, Zumo3;
int data = 0;
int data1_1 = 0;
int data1_2 = 0;
int data1_3 = 0;
int data2_1 = 0;
int data2_2 = 0;
int data2_3 = 0;
int data3_1 = 0;
int data3_2 = 0;
int data3_3 = 0;
String mode1 = "Waiting";
String mode2 = "Waiting";
String mode3 = "Waiting";
int Dist1 = 0;
int Dist2 = 0;
int Dist3 = 0;
int direction1 = 0;
int direction2 = 0;
int direction3 = 0;

void setup() {
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
  text("mode:", 350, 30);
  text("mode:", 350, 430);
  text("mode:", 950, 30);
  text("TIME       :", 630, 500);
  text("GET CUP:", 630, 600);
}

void draw() {
  background(255);

  // 更新されたデータを描画
  fill(0);
  text(mode1, 450, 30);
  text(mode2, 450, 430);
  text(mode3, 1040, 30);

  // 各ロボットの距離メーターを描画
  drawMeter(650, 100, Dist1, "Zumo1 Distance");
  drawMeter(650, 300, Dist2, "Zumo2 Distance");
  drawMeter(650, 500, Dist3, "Zumo3 Distance");
}

void drawMeter(int x, int y, int value, String label) {
  fill(0);
  text(label, x, y - 20);

  int maxBarWidth = 400; // メーターの最大幅
  int barHeight = 30;   // メーターの高さ

  // メーター背景
  fill(200);
  rect(x, y, maxBarWidth, barHeight);

  // 距離に基づいたメーターの進捗
  int barWidth = (int) map(value, 0, 80, 0, maxBarWidth);
  fill(0, 255, 0);
  rect(x, y, barWidth, barHeight);

  // 距離のテキストを表示
  fill(0);
  text(value + " cm", x + maxBarWidth + 10, y + barHeight / 2 + 5);
}

void serialEvent(Serial p) {
  if (p.available() >= 4) {
    if (p.read() == 'H') {
      if (p == Zumo1) {
        data1_1 = p.read();
        data1_2 = p.read();
        data1_3 = p.read();
        if (data1_1 < 10) {
          mode1 = updateMode(data1_1);
        }
        if (data1_2 < 80) {
          Dist1 = data1_2;
        }
        if (data1_3 < 10) {
          direction1 = data1_3;
        }
      } else if (p == Zumo2) {
        data2_1 = p.read();
        data2_2 = p.read();
        data2_3 = p.read();
        if (data2_1 < 10) {
          mode2 = updateMode(data2_1);
        }
        if (data2_2 < 80) {
          Dist2 = data2_2;
        }
        if (data2_3 < 10) {
          direction2 = data2_3;
        }
      } else if (p == Zumo3) {
        data3_1 = p.read();
        data3_2 = p.read();
        data3_3 = p.read();
        if (data3_1 < 10) {
          mode3 = updateMode(data3_1);
        }
        if (data3_2 < 80) {
          Dist3 = data3_2;
        }
        if (data3_3 < 10) {
          direction3 = data3_3;
        }
      }
      p.clear();
    }
  }
}

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
