PImage redb, greenb, pinkb;
PImage shoot;
ArrayList<int[]> balloons = new ArrayList<int[]>();
int interval = round(random(2000,4000));
float lastAddTime=0; 
boolean shooting = false;
int gx, gy;
float bSpeed = 1;

void balloons_setup(){
  redb = loadImage("redb.png");
  greenb = loadImage("greenb.png");
  pinkb = loadImage("pinkb.png");
  redb.resize(100,250);
  greenb.resize(130,250);
  pinkb.resize(125,250);
  shoot = loadImage("fire1.png");
  shoot.resize(390,280);
}

void Balloons(){
  balloonAdder();
  balloonHandler();
}

void balloonHandler(){
  for (int i = 0; i < balloons.size(); i++){
    balloonDrawer(i);
    balloonFloating(i);
    balloonRemover(i);   
  }
}

void balloonAdder(){
  if (millis()-lastAddTime > interval){
    int x = int(random(1600)) - 900;
    int y = 200 + int(random(400));
    int rcolor = int(random(3));
    int[] randB = {x,y,rcolor};
    balloons.add(randB);
    lastAddTime = millis();    
  }
}


void balloonDrawer(int index){
  int[] balloon = balloons.get(index);
  PImage bcolor;
  if (balloon[2] == 0){
    bcolor = redb;
  } else if (balloon[2] == 1){
    bcolor = greenb;
  } else{
    bcolor = pinkb;
  }
  image(bcolor, balloon[0], balloon[1]);
}

void balloonFloating(int index){
  int[] balloon = balloons.get(index);
  balloon[1] -= bSpeed;  
}

void balloonRemover(int index){
  gx = width/2-cameraX-150;
  gy = height/2-cameraY;
  shooting = shoot();
  int[] balloon = balloons.get(index);
  if (balloon[1] < -800){
    balloons.remove(index);
    score();
  } else if (shooting
        && (gx > balloon[0]-50 && gx < balloon[0]+50) &&
          (gy > balloon[1]-50 && gy < balloon[1]+50)){
     balloons.remove(index);
     score();
  }
}

boolean shoot(){
  updateSerial();
  if (val == 0 || mousePressed){
    image(shoot,width/2-cameraX-220,height/2-cameraY-20);
    return true;
  }
  return false;
}

void setupSerial(){
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
}

void updateSerial(){
  if (myPort.available() >0){
    val = myPort.read();
  }
  println(val);
}