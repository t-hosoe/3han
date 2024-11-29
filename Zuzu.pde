import processing.serial.*;

Serial Zumo1, Zumo2, Zumo3;
int Dist1 = 0, Dist2 = 0, Dist3 = 0;
String mode1 = "Waiting", mode2 = "Waiting", mode3 = "Waiting";
int direction1 = 0, direction2 = 0, direction3 = 0;

void setup() {
  size(1200, 800);
  Zumo1 = new Serial(this, "/dev/ttyUSB0", 9600);
  background(255);
  textAlign(CENTER, CENTER);
  textSize(20);
}

void draw() {
  background(255);

  // Zumo1の表示
  drawMeter(200, 200, Dist1, "Zumo1", mode1, direction1);
  
  // Zumo2の表示
  drawMeter(600, 200, Dist2, "Zumo2", mode2, direction2);
  
  // Zumo3の表示
  drawMeter(1000, 200, Dist3, "Zumo3", mode3, direction3);
}

void drawMeter(int x, int y, int distance, String label, String mode, int direction) {
  // 距離メーター
  fill(200);
  ellipse(x, y, 150, 150);
  float angle = map(distance, 0, 100, 0, TWO_PI);
  stroke(255, 0, 0);
  line(x, y, x + cos(-HALF_PI + angle) * 70, y + sin(-HALF_PI + angle) * 70);

  // 距離のテキスト
  fill(0);
  text(distance + " cm", x, y + 100);

  // ラベルとモード
  text(label, x, y - 120);
  text("Mode: " + mode, x, y + 140);

  // 矢印で方向表示
  drawArrow(x, y, direction);
}

void drawArrow(int x, int y, int direction) {
  if (direction < 1 || direction > 8) return;

  float angle = radians((direction - 1) * 45);
  int len = 50;
  int arrowSize = 10;
  float endX = x + cos(angle) * len;
  float endY = y - sin(angle) * len;

  stroke(0);
  line(x, y, endX, endY);
  fill(0);
  float arrowAngle1 = angle + radians(135);
  float arrowAngle2 = angle - radians(135);
  triangle(endX, endY,
           endX + cos(arrowAngle1) * arrowSize, endY - sin(arrowAngle1) * arrowSize,
           endX + cos(arrowAngle2) * arrowSize, endY - sin(arrowAngle2) * arrowSize);
}

void serialEvent(Serial p) {
  if (p.available() >= 4) {
    if (p.read() == 'H') {
      if (p == Zumo1) {
        int data1_1 = p.read();
        int data1_2 = p.read();
        int data1_3 = p.read();
        if (data1_1 < 10) mode1 = updateMode(data1_1);
        if (data1_2 < 80) Dist1 = data1_2;
        if (data1_3 < 10) direction1 = data1_3;
      } else if (p == Zumo2) {
        int data2_1 = p.read();
        int data2_2 = p.read();
        int data2_3 = p.read();
        if (data2_1 < 10) mode2 = updateMode(data2_1);
        if (data2_2 < 80) Dist2 = data2_2;
        if (data2_3 < 10) direction2 = data2_3;
      } else if (p == Zumo3) {
        int data3_1 = p.read();
        int data3_2 = p.read();
        int data3_3 = p.read();
        if (data3_1 < 10) mode3 = updateMode(data3_1);
        if (data3_2 < 80) Dist3 = data3_2;
        if (data3_3 < 10) direction3 = data3_3;
      }
      p.clear();
    }
  }
}

String updateMode(int data) {
  switch (data) {
    case 1: return "Straight";
    case 2: return "Roll";
    case 3: return "Stop";
    default: return "Unknown";
  }
}
