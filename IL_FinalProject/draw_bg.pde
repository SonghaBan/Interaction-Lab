PImage night;
PImage gun;
PImage day;
PImage twilight;
PImage title;
PImage shanghai;
PImage smoke;
PImage start;
PImage next;
PImage restart;

void bg_setup(){
  title = loadImage("smog.png");
  shanghai = loadImage("shanghai.png");
  smoke = loadImage("smoke.png");
  start = loadImage("start.png");
  next = loadImage("continue.png");
  restart = loadImage("restart.png");
  night = loadImage("night.jpg");
  gun = loadImage("gun1.png");
  gun.resize(550,450);
  day = loadImage("Shanghai-skyline-panoramic-water.jpg");
  twilight = loadImage("twilight.jpeg");
}

void outline_night(){
  fill(0);
  noStroke();
  rect(0-cameraX,0-cameraY,1400,50);
  rect(0-cameraX,750-cameraY,1400,50);
  rect(0-cameraX,0-cameraY,100,800);
  rect(1300-cameraX,0-cameraY,100,800);
}

void outline_day(){
  fill(0);
  noStroke();
  rect(0-cameraX,0-cameraY,1400,50);
  rect(0-cameraX,750-cameraY,1400,50);
  rect(0-cameraX,0-cameraY,20,800);
  rect(1380-cameraX,0-cameraY,20,800);
}

void bg_night(){
  translate(cameraX,cameraY);
  night.resize(2800,1600);
  image(night,-1300,-750);  
}

void bg_day(){
  translate(cameraX,cameraY);
  day.resize(2800,1600);
  image(day,-1380,-750); 
}

void bg_twilight(){
  translate(cameraX,cameraY);
  twilight.resize(2800,1600);
  image(twilight,-1380,-750);
}