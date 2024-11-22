import processing.serial.*;

Serial Zumo1, Zumo2, Zumo3;
int data = 0;
int data1 = 0;
int data2 = 0;
int data3 = 0;
String mode1 = "Waiting";
String mode2 = "Waiting";
String mode3 = "Waiting";
int Dist1 = 0;
int Dist2 = 0;
int Dist3 = 0;
int direction1 = -1;
int direction2 = -1;
int direction3 = -1;

void setup() {
  Zumo1 = new Serial(this, "/dev/ttyUSB0", 9600);
  Zumo2 = new Serial(this, "/dev/ttyUSB1", 9600);
  Zumo3 = new Serial(this, "/dev/ttyUSB2", 9600);
  
  size(1200, 800);
  background(255);
  stroke(0);

  quad(0, 0, 0, 400, 600, 400, 600, 0);
  quad(0, 400, 0, 800, 600, 800, 600, 400);
  quad(600, 0, 600, 400, 1200, 400, 1200, 0);
  quad(600, 400, 600, 800, 1200, 800, 1200, 400);

  textSize(30);
  fill(0);
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
  clearSection(440, 0, 150, 40);
  text(mode1, 450, 30);
  
  clearSection(440, 400, 150, 40);
  text(mode2, 450, 430);
  
  clearSection(1030, 0, 150, 40);
  text(mode3, 1040, 30);
  
  clearSection(440, 200, 150, 40);
  text(Dist1, 450, 230);

  clearSection(440, 600, 150, 40);
  text(Dist2, 450, 630);

  clearSection(1030, 200, 150, 40);
  text(Dist3, 1040, 230);

  clearSection(150, 50, 100, 40);
  text(direction1, 160, 70);

  clearSection(150, 450, 100, 40);
  text(direction2, 160, 470);

  clearSection(750, 50, 100, 40);
  text(direction3, 760, 70);
}

void serialEvent(Serial p) {
  if (p.available() >= 4) {
    char header = p.readChar();
    if (header == 'H') {
      int mode = p.read();
      int dist = p.read();
      int direction = p.read();
      
      if (p == Zumo1) {
        mode1 = updateMode(mode);
        Dist1 = dist;
        direction1 = direction;
      } else if (p == Zumo2) {
        mode2 = updateMode(mode);
        Dist2 = dist;
        direction2 = direction;
      } else if (p == Zumo3) {
        mode3 = updateMode(mode);
        Dist3 = dist;
        direction3 = direction;
      }
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

void clearSection(int x, int y, int w, int h) {
  fill(255);
  rect(x, y, w, h);
  fill(0);
}

void keyPressed() {
  if (key == 's') {
    noLoop();
  } else if (key == 'c') {
    background(255);
    loop();
  }
}
