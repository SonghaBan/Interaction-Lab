import processing.serial.*;
String myString = null;
Serial myPort;

int NUM_OF_VALUES = 2;
int[] sensorValues;  

int gameScreen = 0;

PImage init;
PImage player;
PImage fire;
PImage cave;
PImage st1;
PImage st2;
PImage st3;
PImage[] newcave;
int playerY; 
int poten;
int bx = 200;
int s;

int wallSpeed = 5;
int wallInterval = round(random(800,1500));
float lastAddTime = 0;
int minGapHeight = 200;
int maxGapHeight = 300;
int wallWidth = 80;
ArrayList<int[]> walls = new ArrayList<int[]>(); //only st1
ArrayList<int[]> walls3 = new ArrayList<int[]>(); //save st3

//scoring
int score = 0;
int maxHealth = 300;
float health = 300;
float healthDecrease = 1.5;
int healthBarWidth = 180;

void setup(){
  size(1300,500);
  setupSerial();
  set_bg();
  set_player();
  set_stalactites();
}

void draw(){
  if (gameScreen == 0){
    initScreen();
  }
  else if (gameScreen == 1){
    gameScreen();
  }else if(gameScreen == 2){
    gameOverScreen();
  }
  
}

void set_bg(){
  cave = loadImage("Cave_Background_Brigade.png"); 
  cave.resize(1300,500);
  newcave = new PImage[1300];  
  for (int i = 0; i<1300; i++) {
    newcave[i] = cave.get(i, 0, 1, cave.height);
  }
  frameRate(40);
}

void set_player(){
  player = loadImage("soldier.png");
  player.resize(250,250);
  fire = loadImage("fire.png");
  fire.resize(40,40);
}

void set_stalactites(){
  st1 = loadImage("st1.png");
  st2 = loadImage("st2.png");
  st3 = loadImage("st3.png");
}

int indexOfTheFirstImageColumn=0; 

void bg(){
  int k=0; 
  for (int i = indexOfTheFirstImageColumn; i<1300; i++) {
    image ( newcave[i], k, 0 );
    k++;
  }
 
  for (int i = 0; i<indexOfTheFirstImageColumn; i++) {
    image ( newcave[i], k, 0 );
    k++;
  }

  indexOfTheFirstImageColumn++;
  if (indexOfTheFirstImageColumn==1300)
    indexOfTheFirstImageColumn=0;
}

void player(int playerY){
  image(player,0,height/2 - playerY);
  if (playerY > 10){
  image(fire,100,height/2 - playerY + 215);
  }
}

void stalactites(){
  wallAdder();
  wallHandler();
}

void wallAdder() {
  if (millis()-lastAddTime > wallInterval) {
    int randHeight = round(random(minGapHeight, maxGapHeight));
    int randY = round(random(0, height-randHeight));
    // {gapWallX, gapWallY, gapWallWidth, gapWallHeight}
    int[] randWall = {width, randY, wallWidth, randHeight, 0}; 
    walls.add(randWall);
    lastAddTime = millis();
  }
}


void wallHandler() {
  for (int i = 0; i < walls.size(); i++) {
    wallRemover(i);
    wallMover(i);
    st1Drawer(i);
    watchWallCollision(i);  
  }
}


void st1Drawer(int index) {
  int[] wall = walls.get(index);
  // get gap wall settings 
  int gapWallX = wall[0];
  int gapWallY = wall[1];
  int gapWallWidth = wall[2];
  int gapWallHeight = wall[3];
  // draw actual walls
  st1.resize(gapWallWidth,gapWallHeight);
  image(st1, gapWallX, gapWallY + gapWallHeight);
}


void wallMover(int index) {
  int[] wall = walls.get(index);
  wall[0] -= wallSpeed;
}

void wallRemover(int index) {
  int[] wall = walls.get(index);
  int wallBottomX = wall[0];
  if (wall[0]+wall[2] <= 0) {
    walls.remove(index);
  }
  else if (bx-200 > wallBottomX){
    walls.remove(index);
    bx = -1300;
  }
}

void watchWallCollision(int index) {
  int[] wall = walls.get(index);
  // get gap wall settings 
  int gapWallX = wall[0];
  int gapWallY = wall[1];
  int gapWallWidth = wall[2];
  int gapWallHeight = wall[3];
  int wallScored = wall[4];
  int wallBottomX = gapWallX/4;
  int wallBottomY = (gapWallY+gapWallHeight)/4;
  int wallBottomWidth = gapWallWidth/4;
  int wallBottomHeight = height-(gapWallY+gapWallHeight)/4;

  if (
    (160>wallBottomX+100) && //175
    (150<wallBottomX+wallBottomWidth+100) && //100
    (175-playerY>wallBottomY) &&
    (400-playerY<wallBottomY+wallBottomHeight)
    ) {
    decreaseHealth();
  }

  if (125 > gapWallX+(gapWallWidth/2) && wallScored==0) {
    wallScored=1;
    wall[4]=1;
    score();
  }
}

void drawHealthBar() {
  noStroke();
  fill(189, 195, 199);
  rectMode(CORNER);
  rect(125-(healthBarWidth/2), 250-playerY, healthBarWidth, 5);
  if (health > 60) {
    fill(46, 204, 113);
  } else if (health > 30) {
    fill(230, 126, 34);
  } else {
    fill(231, 76, 60);
  }
  rectMode(CORNER);
  rect(125-(healthBarWidth/2), 250 - playerY, healthBarWidth*(health/maxHealth), 5);
}
void decreaseHealth() {
  health -= healthDecrease;
  if (health <= 0) {
    gameOver();
  }
}

void score() {
  score++;
}
void printScore() {
  textAlign(CENTER);
  fill(255);
  textSize(30); 
  text(score, height/2, 50);
}

void bullet(int py, int s){
  if ((s == 1) && (py <20) && (bx >= 200)){
    fill(0);
    ellipse(bx,height/2 + 150 - py,20,9);
  }
  if ((s == 1) && (py <20)){  
    bx+=40;
  }
  if (bx > 1300){
  bx = -1000;
  }
}

void setupSerial() {
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 9600);
  myPort.clear();
  myString = myPort.readStringUntil( 10 );  // 10 = '\n'  Linefeed in ASCII
  sensorValues = new int[NUM_OF_VALUES];
}

void updateSerial() {
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil( 10 ); // 10 = '\n'  Linefeed in ASCII
    if (myString != null) {
      String[] serialInArray = split(trim(myString), ",");
      if (serialInArray.length == NUM_OF_VALUES) {
        for (int i=0; i<serialInArray.length; i++) {
          sensorValues[i] = int(serialInArray[i]);
        }
      }
    }
  }
}

void startGame(){
  gameScreen = 1;
}
void gameOver() {
  gameScreen = 2;
}

void initScreen(){
  init = loadImage("cave.png");
  init.resize(width,height);
  image(init, 0,0);
  textAlign(CENTER);
  fill(200, 73, 94);
  textSize(70);
  text("THE CAVE", width/2, height/2);
  textSize(15); 
  text("Click to start", width/2, height-30);
}

void gameScreen(){
  bg();
  updateSerial();
  playerY = sensorValues[0];
  player(playerY);
  stalactites();
  bullet(playerY, sensorValues[1]);
  drawHealthBar();
  printScore();  
}

void gameOverScreen() {
  background(44, 62, 80);
  textAlign(CENTER);
  fill(236, 240, 241);
  textSize(12);
  text("Your Score", width/2, height/2 - 120);
  textSize(130);
  text(score, width/2, height/2);
  textSize(15);
  text("Click to Restart", width/2, height-30);
}

void restart() {
  score = 0;
  health = maxHealth;
  lastAddTime = 0;
  walls.clear();
  gameScreen = 1;
}

public void mousePressed(){
  if (gameScreen == 0){
    startGame();
  }
  if (gameScreen==2){
    restart();
  }
}