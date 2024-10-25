import processing.serial.*;
Serial Zumo1;
int data;

void setup() {
 Zumo1= new Serial(this,"/dev/ttyUSB0",9600);
 //Zumo2= new Serial(this,Serial.list()[0],9600);
 //Zumo3= new Serial(this,Serial.list()[0],9600);
 size(1200,800);
 background(255);
   stroke(0);
   quad(0,0,0,400,600,400,600,0);
   quad(0,400,0,800,600,800,600,400);
   quad(600,0,600,400,1200,400,1200,0);
   
   quad(600,400,600,800,1200,800,1200,400);
    textSize(30);
 fill(0);
 text("Zumo1", 30, 30 );
 text("Zumo2", 30, 430 );
 text("Zumo3", 630, 30 );
 text("mode:",400,30);
 text("mode:",400,430);
 text("mode:",1000,30);
 text("TIME       :", 630,500 );
 text("GET CUP:",630,600 );
}

void draw() {
   
   if(data==0)
   {
   }
   else if(data ==1)
   {
     text("Straight", 680, 30 );
   }
    else if(data ==2)
   {
     text("roll", 680, 30 );
   }
    else if(data ==3)
   {
     text("roll", 680, 30 );
   }
  
   
   
}

void keyPressed() { // keyが押されると呼ばれる関数
  if (key == 's') {
    noLoop(); // draw()の繰返し処理を停止
  } else if (key == 'c') {
    background(255); // draw()の繰返し処理を再開
    loop();
  }
}

void serialEvent(Serial Zumo1)
{
  if(Zumo1.available()>=1)
  {
    data = Zumo1.read();
  }
  
}

/*
// 通信方式2
void serialEvent(Serial p) {

  int l = p.available(); // 受信バッファ内のデータ数
  boolean bod_f = false; // 1組のデータ(block of data)が得られたか？

  while (l>0) { // 受信バッファ内にデータがある場合
    if (sof_f == false) { // SoFを発見していない場合
      if (p.read() == 'H') { // SoF(Start of Frame)の検査
        sof_f = true; // SoFの発見
      }
      l--; // 受信バッファのデータ数の修正
    }
    if (sof_f == true) { // SoFを発見している場合
      if (l >= 4) { // 受信バッファのデータ数が4以上

        mode =  p.read();
        red =  p.read();
        green = p.read();
        blue =  p.read();

        print(" RGB = ");
        println(red, green, blue);

        bod_f = true; // 1組のデータを読み込んだ
        sof_f = false; // 1組のデータを読み取ったのでSoFの発見をクリア
        l -= 4; // 受信バッファのデータ数の修正
      } else { // 受信バッファのデータ数不足の場合
        break; // whileループを中断
      }
    }
  }
  if (bod_f == true) // 1組のデータを読み込んだので
    p.write("A"); // 次のデータ送信要求を送信
}
// このプログラムではHに続くデータが4つ（1バイトのデータが4つ）で一組を想定している．
// プログラム中の4の部分は適宜変更が必要
*/
