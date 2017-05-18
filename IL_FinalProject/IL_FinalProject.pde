import processing.serial.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

Serial myPort;
int val;

int cameraX, cameraY;
int screen = 0; //init 0, setting 1, game 2, counting 3, result 4, smog 10
int scene = 1; //night 1, day 2, twilight 3

PImage chSmog;

void setup() {
  size(1400, 800, P3D);
  setupSerial();
  color_setup();
  bg_setup();
  balloons_setup();
  scoring_setup();
  countingSetup();
  chSmog = loadImage("chsmog.png");
}

void draw() {
  //updateSerial();
  if (screen == 1 || screen == 2 ){
    colortrack();
  }
  if (screen == 0){
    initScreen();
  }else if (screen == 1){
    settingScreen();
  }else if (screen == 2){
    gameScreen(scene);
  }else if (screen == 3){
    countingScreen();
  }else if (screen == 4){
    resultScreen();
  }else if (screen == 10){
    smogScreen();
  }
}

void play(){
  screen = 2;
}

void smog_attack(){
  screen = 10;
}

void count_masks(){
  screen = 3;
}

void showResult(){
  screen = 4;
}

void restart(){
  level = 1;
  scene = 1;
  needs = 4;
  score = 0;
  seconds = 45;
  lastAddTime = 0;
  balloons.clear();
  screen = 1;
}

void mousePressed() {
  if (screen == 0){
    screen = 1;
  }else if (screen == 1){
    color c = get(mouseX, mouseY);
    println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));     
    int hue = int(map(hue(c), 0, 255, 0, 180));      
    colors[0] = c;
    hues[0] = hue;      
    println("color index " + (0) + ", value: " + hue);
    startMillis = millis()/1000;
    ready = startMillis + 19;
    sx = 0;
    play();
  }
}

void keyPressed() {
  if (screen == 0){
    if (key == 'r'){screen = 1;}
  }
  if (key == 's') {
    screen = 1; 
  }
}