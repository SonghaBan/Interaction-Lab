PImage clock; 
PImage mask;
PImage timesup;
PFont font;
int score = 0;
float seconds;  
float startTime = 45;
float ready;
float startMillis = 0;
int timerWidth = 200;
int level = 1;
int needs = 4;

void scoring_setup(){
  clock = loadImage("clock.png");
  mask = loadImage("mask.gif");
  clock.resize(40,40);
  mask.resize(40,40);
  timesup = loadImage("timesup.png");
  timesup.resize(450,220);
  
}

void score(){
  score++;
}

void printScore(){
  image(mask, 120-cameraX, 5-cameraY);
  font = loadFont("YuppyTC-Regular-25.vlw");
  textFont(font,32);
  textAlign(CENTER);
  fill(255);
  textSize(25);
  text(score, 185 - cameraX, 35 - cameraY);
  text("Level : "+level, 580 - cameraX, 35 - cameraY);
}

void timer(){
  seconds = startTime + startMillis - millis()/1000;
  
  if (seconds<0){
    smog_attack();
  }
}

void smogAttack(){
  screen = 10;
}

void drawTimer() {
  image(clock, 260-cameraX, 5-cameraY);
  noStroke();
  fill(189, 195, 199);
  rectMode(CORNER);
  rect(305-cameraX, 25 - cameraY, timerWidth, 10);
  if (seconds > 15 && seconds < startTime + startMillis -5) {
    fill(46, 204, 113);
  } else if (seconds > 5) {
    fill(230, 126, 34);
  } else if (seconds >0){
    fill(231, 76, 60);
  }
  if (seconds < startTime + startMillis -10){
    rectMode(CORNER);
    rect(305-cameraX, 25 - cameraY, timerWidth*(seconds/startTime), 10);
  }
  if (ready < seconds) {
    textAlign(CENTER);
    fill(255);
    textSize(50);
    text("Please save people in Shanghai from smog!\nCollect the masks by shooting balloons", width/2-cameraX, height/2-cameraY);
  }
}

void levelup(){
  level++;
  scene = level % 3;
  needs += 2;
  bSpeed += 0.3;
  score = 0;
  seconds = 45;
  lastAddTime = 0;
  balloons.clear();
  screen = 1;
}