// ボタンを生成するモジュール
import controlP5.*;

ControlP5 controlP5;

/* プログラム起動時にボタンが押されたときのイベントが勝手に発動するので、
   それを防ぐための配列を用意する。 */
boolean[] isCalledOnce = {false, false, false, false};

final int N_CLASS = 5;
// 各インデックスに対応するラベル名
final String[] index2name = {"Chino", "Cocoa", "Rise", "Shallo", "Chiyo"};
boolean[] selectClassArray = new boolean[N_CLASS];  // ラジオボタンにて選択されているラベルを格納

RadioButton radio;
Button imgBtn, delBtn, saveBtn, xmlBtn;

PImage img = null;
String getFile = null, nowFile=null;

boolean isReDraw = false;  // 再描画を要求するフラグ

int start_x, start_y, end_x, end_y;
boolean isDrawRect = false;  // 描画中かを識別するフラグ

DataXML xml = null;

void setup() {
  size(700,600);
  background(255);
  stroke(255,0,0);
  strokeWeight(3);
  noFill();
  controlP5 = new ControlP5(this);
  
  imgBtn = controlP5.addButton("LOAD IMAGE");
  imgBtn.setValue(0).setPosition(600,40).setSize(70,30);
  
  delBtn = controlP5.addButton("DELETE RECT");
  delBtn.setValue(1).setPosition(600,450).setSize(70,30);
  
  saveBtn = controlP5.addButton("SAVE RECT");
  saveBtn.setValue(2).setPosition(600,300).setSize(70,30);
  
  xmlBtn = controlP5.addButton("OUTPUT XML");
  xmlBtn.setValue(3).setPosition(600,350).setSize(70,30);
  
  radio = controlP5.addRadioButton("radioButton", 600, 80);  // Position
  radio.setSize(30, 30).setColorLabel(color(0));
  radio.addItem(index2name[0], 1);
  radio.addItem(index2name[1], 2);
  radio.addItem(index2name[2], 3);
  radio.addItem(index2name[3], 4);
  radio.addItem(index2name[4], 5);
  
  // 初期化
  for(int i = 0; i < N_CLASS; i++){
    selectClassArray[i] = false;
  }
}

void draw() {
  //background(255);
  
  // 読み込む画像があるとき、その画像を読み込み、表示する
  if (getFile != null){
    nowFile = getFile;
    getFile = null;
    println(nowFile);
    
    // 選択ファイルの拡張子を取得
    String ext = nowFile.substring(nowFile.lastIndexOf('.') + 1);
    // その文字列を小文字にする
    ext.toLowerCase();
    // jpg, jpeg, pngのみ受け付ける
    if (ext.equals("jpg") || ext.equals("jpeg") || ext.equals("png")){
      img = loadImage(nowFile);
      background(255);  // 画像を貼り付ける前に一旦真っ白にする
      image(img, 0, 0, img.width, img.height);  // 描画
      println("successful to load!");
      
      xml = new DataXML(nowFile.substring(nowFile.lastIndexOf('/') + 1), img.width, img.height);
    }else{
      println("Your selected file path is worng.");
    }
    isReDraw = false;
  }else if (isReDraw && img != null){
    background(255);  // 画像を貼り付ける前に一旦真っ白にする
    image(img, 0, 0, img.width, img.height);  // 描画
    isReDraw = false;
  }
  
  if (isDrawRect && img != null){
    // 画像を再描画してから、その上に矩形を描画する
    background(255);  // 画像を貼り付ける前に一旦真っ白にする
    image(img, 0, 0, img.width, img.height);  // 描画
    rect(start_x, start_y, end_x - start_x, end_y - start_y);
  }
}

void mousePressed(){
  if (mouseX > 600){
    return;
  }
  
  if (!isDrawRect){
    start_x = mouseX;
    start_y = mouseY;
    end_x = mouseX + 1;
    end_y = mouseY + 1;
    isDrawRect = true;
  }else{
    end_x = mouseX;
    end_y = mouseY;
  }
}

void deleteRect(){
  isDrawRect = false;
  isReDraw = true;
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.getName() == "LOAD IMAGE"){
    if (throwOnce(0)) return;
    getFile = getFileName();
  }else if(theEvent.getName() == "DELETE RECT"){
    if (throwOnce(1)) return;
    deleteRect(); // 矩形の削除
  }else if(theEvent.getName() == "SAVE RECT"){ 
    if (throwOnce(2)) return;
    if (!isDrawRect){
      println("Please draw a rect before save!");
    }
    // 選択されているラベルの取得
    int obj_cls = -1;
    for (int i = 0; i < N_CLASS; i++){
      if (selectClassArray[i]){
        obj_cls = i;
        break;
      }
    }
    if (obj_cls == -1){
      println("Please check a class!");
      return;
    }
    // XMLへの追加
    if (xml != null){
      int xmin = min(start_x, end_x);
      int xmax = max(start_x, end_x);
      int ymin = min(start_y, end_y);
      int ymax = max(start_y, end_y);
      xml.addData(index2name[obj_cls], xmin, ymin, xmax, ymax);
    }else {
      println("xml is null. Please review your code...");
    }
    deleteRect();  // 矩形の削除
  }else if(theEvent.getName() == "OUTPUT XML"){
    if (throwOnce(3)) return;
    // XMLをファイルとして保存する
    if(xml != null){
      String imgFileName = nowFile.substring(nowFile.lastIndexOf('/') + 1);
      String imgName = imgFileName.substring(0, imgFileName.lastIndexOf('.'));
      xml.saveNewXML(imgName + ".xml");
      println("successful to save");
    }
  }else if(theEvent.isFrom(radio)) {
    for (int i = 0; i < theEvent.getGroup().getArrayValue().length; i++){
      if (theEvent.getGroup().getArrayValue()[i] == 1.0){ 
        selectClassArray[i] = true;
      }else{
        selectClassArray[i] = false;
      }
    }
    println(selectClassArray);
  }
}

boolean throwOnce(int i){
  if (isCalledOnce[i]){
    return false;
  }
  else{
    isCalledOnce[i] = true;
    return true;
  }  
}