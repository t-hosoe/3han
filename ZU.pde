import processing.serial.*;

Serial[] zumos = new Serial[3];
int[] distances = {0, 0, 0};
String[] modes = {"Waiting", "Waiting", "Waiting"};
int[] directions = {0, 0, 0};
int[] colors = {0, 0, 0}; // New variables for color

void setup() {
  size(1200, 600); // Window size adjusted for better layout
  // Initialize serial ports
  zumos[0] = new Serial(this, "/dev/ttyUSB0", 9600);
  zumos[1] = new Serial(this, "/dev/ttyUSB1", 9600);
  zumos[2] = new Serial(this, "/dev/ttyUSB2", 9600);

  background(255);
  textAlign(CENTER, CENTER);
  textSize(20);
}

void draw() {
  background(255);

  // Display meters for all Zumos
  for (int i = 0; i < 3; i++) {
    int x = (i + 1) * width / 4; // Divide space evenly across width
    int y = height / 2;         // Center vertically
    drawMeter(x, y, distances[i], "Zumo" + (i + 1), modes[i], directions[i], colors[i]);
  }
}

void drawMeter(int x, int y, int distance, String label, String mode, int direction, int color) {
  // Label and mode
  fill(0);
  text(label, x, y - 120); // Move label up
  text("Mode: " + mode, x, y - 80); // Adjust mode text position

  // Direction as arrow
  drawArrow(x, y - 30, direction); // Position arrow slightly higher

  // Distance bar
  drawDistanceBar(x, y + 30, distance); // Adjust distance bar position

  // Display color
  drawColor(x, y + 80, color); // Adjust color display position
}

void drawArrow(int x, int y, int direction) {
  if (direction < 1 || direction > 8) return;

  float angle = radians((direction - 1) * 45 - 90); // Adjust to start from north
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

  // Background bar
  fill(200);
  rect(x - barWidth / 2, y, barWidth, barHeight);

  // Fill based on distance
  fill(0, 255, 0);
  rect(x - barWidth / 2, y, fillWidth, barHeight);

  // Outline
  noFill();
  stroke(0);
  rect(x - barWidth / 2, y, barWidth, barHeight);

  // Distance text
  fill(0);
  text(distance + " cm", x, y + 40);
}

void drawColor(int x, int y, int color) {
  switch (color) {
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
  for (int i = 0; i < zumos.length; i++) {
    if (p == zumos[i] && p.available() >= 5) {
      if (p.read() == 'H') {
        int data1 = p.read();
        int data2 = p.read();
        int data3 = p.read();
        int data4 = p.read(); // Read color data

        if (data1 < 10) modes[i] = updateMode(data1);
        if (data2 < 80) distances[i] = data2;
        if (data3 < 10) directions[i] = data3;
        if (data4 >= 0 && data4 <= 3) colors[i] = data4;

        p.clear();
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
