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
  text(label, x, y - 160); // ラベルを少し上に
  text("Mode: " + mode, x, y - 120); // モード表示位置を調整

  // 矢印で方向表示
  drawArrow(x, y - 40, direction); // 矢印を少し上に

  // 距離を横棒のメーターで表示
  drawDistanceBar(x, y + 40, distance); // バーをやや下に

  // 色を表示
  drawColor(x, y + 100, colored); // 色表示をさらに下に
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
      fill(255, 0, 0); // Red
      break;
    case 3:
      fill(0, 0, 255); // Blue
      break;
    default:
      fill(200); // Default grey if unknown value
  }
  ellipse(x, y, 30, 30); // Display color as a circle
}

void serialEvent(Serial p) {
  while (p.available() >= 5) { // バッファに5バイト以上のデータがある場合に処理
    if (p.read() == 'H') { // ヘッダ確認
      int data1 = p.read();
      int data2 = p.read();
      int data3 = p.read();
      int data4 = p.read(); // 色データ

      // データのバリデーションと割り当て
      if (p == Zumo1) {
        if (data1 >= 0 && data1 <= 9) mode1 = updateMode(data1);
        if (data2 >= 0 && data2 <= 80) Dist1 = data2; // 距離は0～80の範囲内
        if (data3 >= 1 && data3 <= 8) direction1 = data3; // 方向は1～8
        if (data4 >= 0 && data4 <= 3) color1 = data4; // 色は0～3
      } else if (p == Zumo2) {
        if (data1 >= 0 && data1 <= 9) mode2 = updateMode(data1);
        if (data2 >= 0 && data2 <= 80) Dist2 = data2;
        if (data3 >= 1 && data3 <= 8) direction2 = data3;
        if (data4 >= 0 && data4 <= 3) color2 = data4;
      } else if (p == Zumo3) {
        if (data1 >= 0 && data1 <= 9) mode3 = updateMode(data1);
        if (data2 >= 0 && data2 <= 80) Dist3 = data2;
        if (data3 >= 1 && data3 <= 8) direction3 = data3;
        if (data4 >= 0 && data4 <= 3) color3 = data4;
      }
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
