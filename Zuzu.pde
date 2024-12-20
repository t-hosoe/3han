import processing.serial.*;

Serial Zumo1, Zumo2, Zumo3;
int Dist1 = 0, Dist2 = 0, Dist3 = 0;
String mode1 = "Waiting", mode2 = "Waiting", mode3 = "Waiting";
int direction1 = 0, direction2 = 0, direction3 = 0;
int color1 = 0, color2 = 0, color3 = 0; // New variables for color

void setup() {
  size(1200, 800);
  Zumo1 = new Serial(this, "COM6", 9600);
  //Zumo2 = new Serial(this, "COM7", 9600);
  //Zumo3 = new Serial(this, "/dev/ttyUSB2", 9600);
  textAlign(CENTER, CENTER);
  textSize(20);
  frameRate(60); // Set a higher frame rate to reduce lag
}

void draw() {
  background(30);
  drawHeader();

  // Zumo1
  drawMeter(200, 400, Dist1, "Zumo1", mode1, direction1, color1);

  // Zumo2
  drawMeter(600, 400, Dist2, "Zumo2", mode2, direction2, color2);

  // Zumo3
  drawMeter(1000, 400, Dist3, "Zumo3", mode3, direction3, color3);
}

void drawHeader() {
  fill(255);
  textSize(32);
  text("Zumo Robot Display", width / 2, 50);
  textSize(20);
  text("Real-time monitoring of Zumo robots", width / 2, 90);
}

void drawMeter(int x, int y, int distance, String label, String mode, int direction, int colored) {
  fill(50, 50, 80);
  stroke(200);
  rect(x - 150, y - 200, 300, 400, 20);

  // Robot Label
  fill(255);
  textSize(28);
  text(label, x, y - 180);

  // Mode Display
  textSize(32); // Increased font size for mode display
  text("Mode: " + mode, x, y - 130);

  // Direction Arrow
  drawArrow(x, y - 60, direction);

  // Distance Bar
  drawDistanceBar(x, y, distance);

  // Color Indicator
  drawColor(x, y + 150, colored);
}

void drawArrow(int x, int y, int direction) {
  if (direction < 1 || direction > 8) return;

  float angle = radians((direction - 1) * 45 - 90);
  int len = 60; // Increased arrow length
  int arrowSize = 15; // Increased arrowhead size
  float endX = x + cos(angle) * len;
  float endY = y + sin(angle) * len;

  stroke(255, 200, 0);
  strokeWeight(4);
  line(x, y, endX, endY);
  fill(255, 200, 0);
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

  fill(100);
  noStroke();
  rect(x - barWidth / 2, y, barWidth, barHeight, 10);

  fill(0, 255, 0);
  rect(x - barWidth / 2, y, fillWidth, barHeight, 10);

  stroke(255);
  noFill();
  rect(x - barWidth / 2, y, barWidth, barHeight, 10);

  fill(255);
  textSize(20); // Slightly increased text size
  text(distance + " cm", x, y + 50); // Adjusted position for better visibility
}

void drawColor(int x, int y, int colored) {
  noStroke();
  switch (colored) {
    case 0: fill(255); break; // White
    case 1: fill(0); break; // Black
    case 2: fill(0, 0, 255); break; // Blue
    case 3: fill(255, 0, 0); break; // Red
    default: fill(200); // Default grey
  }
  ellipse(x, y, 60, 60); // Increased size of the color indicator
}

void serialEvent(Serial p) {
  while (p.available() >= 5) {
    if (p.read() == 'H') {
      int data1 = p.read();
      int data2 = p.read();
      int data3 = p.read();
      int data4 = p.read();

      if (validateData(data1, data2, data3, data4)) {
        if (p == Zumo1) {
          if (data1 >= 0 && data1 <= 9) mode1 = updateMode(data1);
          if (data2 >= 0 && data2 <= 80) Dist1 = data2; else Dist1 = 99;
          if (data3 >= 1 && data3 <= 8) direction1 = data3;
          if (data4 >= 0 && data4 <= 3) color1 = data4;
        } else if (p == Zumo2) {
          if (data1 >= 0 && data1 <= 9) mode2 = updateMode(data1);
          if (data2 >= 0 && data2 <= 80) Dist2 = data2; else Dist2 = 99;
          if (data3 >= 1 && data3 <= 8) direction2 = data3;
          if (data4 >= 0 && data4 <= 3) color2 = data4;
        } else if (p == Zumo3) {
          if (data1 >= 0 && data1 <= 9) mode3 = updateMode(data1);
          if (data2 >= 0 && data2 <= 80) Dist3 = data2; else Dist3 = 99;
          if (data3 >= 1 && data3 <= 8) direction3 = data3;
          if (data4 >= 0 && data4 <= 3) color3 = data4;
        }
      }
      p.clear();
    }
  }
}

boolean validateData(int mode, int distance, int direction, int color_I) {
  if (mode < 0 || mode > 9) return false;
  if (distance < 0 || distance > 80) return false;
  if (direction < 1 || direction > 8) return false;
  if (color_I < 0 || color_I > 3) return false;
  return true;
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
