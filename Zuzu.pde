import processing.serial.*;

Serial Zumo1, Zumo2, Zumo3;
int Dist1 = 0, Dist2 = 0, Dist3 = 0;
String mode1 = "Waiting", mode2 = "Waiting", mode3 = "Waiting";
int direction1 = 0, direction2 = 0, direction3 = 0;
int color1 = 0, color2 = 0, color3 = 0; // New variables for color

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
  drawMeter(200, 200, Dist1, "Zumo1", mode1, direction1, color1);

  // Zumo2の表示
  drawMeter(600, 200, Dist2, "Zumo2", mode2, direction2, color2);

  // Zumo3の表示
  drawMeter(1000, 200, Dist3, "Zumo3", mode3, direction3, color3);
}

void drawMeter(int x, int y, int distance, String label, String mode, int direction, int colored) {
  // ラベルとモード
  fill(0);
  text(label, x, y - 140);
  text("Mode: " + mode, x, y - 100);

  // 矢印で方向表示
  drawArrow(x, y, direction);

  // 距離を横棒のメーターで表示
  drawDistanceBar(x, y + 80, distance);

  // 色を表示
  drawColor(x, y + 120, colored);
}

void drawArrow(int x, int y, int direction) {
  if (direction < 1 || direction > 8) return;

  float angle = radians((direction - 1) * 45 - 90); // 修正: 北を基準に時計回り
  int len = 50;
  int arrowSize = 10;
  float endX = x + cos(angle) * len;
  float endY = y + sin(angle) * len;

  stroke(0);
  line(x, y, endX, endY);
  fill(0);
  float arrowAngle1 = angle + radians(135);
  float arrowAngle2 = angle - radians(135);
  triangle(endX, endY,
           endX + cos(arrowAngle1) * arrowSize, endY + sin(arrowAngle1) * arrowSize,
           endX + cos(arrowAngle2) * arrowSize, endY + sin(arrowAngle2) * arrowSize);
}

void drawDistanceBar(int x, int y, int distance) {
  int barWidth = 200;
  int barHeight = 20;
  float fillWidth = map(distance, 0, 100, 0, barWidth);

  // 背景バー
  fill(200);
  rect(x - barWidth / 2, y, barWidth, barHeight);

  // 距離に応じたフィル
  fill(0, 255, 0);
  rect(x - barWidth / 2, y, fillWidth, barHeight);

  // 枠線
  noFill();
  stroke(0);
  rect(x - barWidth / 2, y, barWidth, barHeight);

  // 距離の数値
  fill(0);
  text(distance + " cm", x, y + 40);
}

void drawColor(int x, int y, int colored) {
  // 色に基づいて背景色を変更
  switch (colored) {
    case 0:
      fill(255); // White
      break;
    case 1:
      fill(0);   // Black
      break;
    case 2:
      fill(0, 0, 255); // Blue
      break;
    case 3:
      fill(255, 0, 0); // Red
      break;
    default:
      fill(200); // Default grey if unknown value
  }
  ellipse(x, y, 30, 30); // Display color as a circle
}

void serialEvent(Serial p) {
  if (p.available() >= 5) { // Change the check to 5 for color data
    if (p.read() == 'H') {
      if (p == Zumo1) {
        int data1_1 = p.read();
        int data1_2 = p.read();
        int data1_3 = p.read();
        int data1_4 = p.read(); // Read color data
        if (data1_1 < 10) mode1 = updateMode(data1_1);
        if (data1_2 < 80) Dist1 = data1_2;
        if (data1_3 < 10) direction1 = data1_3;
        if (data1_4 >= 0 && data1_4 <= 3) color1 = data1_4; // Set color1 based on received value
      } else if (p == Zumo2) {
        int data2_1 = p.read();
        int data2_2 = p.read();
        int data2_3 = p.read();
        int data2_4 = p.read(); // Read color data
        if (data2_1 < 10) mode2 = updateMode(data2_1);
        if (data2_2 < 80) Dist2 = data2_2;
        if (data2_3 < 10) direction2 = data2_3;
        if (data2_4 >= 0 && data2_4 <= 3) color2 = data2_4; // Set color2 based on received value
      } else if (p == Zumo3) {
        int data3_1 = p.read();
        int data3_2 = p.read();
        int data3_3 = p.read();
        int data3_4 = p.read(); // Read color data
        if (data3_1 < 10) mode3 = updateMode(data3_1);
        if (data3_2 < 80) Dist3 = data3_2;
        if (data3_3 < 10) direction3 = data3_3;
        if (data3_4 >= 0 && data3_4 <= 3) color3 = data3_4; // Set color3 based on received value
      }
      p.clear();
    }
  }
}

String updateMode(int data) {
  switch (data) {
    case 0: return "Initialize";
    case 1: return "Straight";
    case 2: return "Search";
    case 3: return "Catch";
    case 4: return "Direction";
    case 5: return "Transport";
    case 6: return "Linetrace";
    default: return "Unknown";
  }
}
