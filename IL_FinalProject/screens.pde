PImage maskOn;
PImage crying;
PImage ss;
PImage smogattack;
PImage overbg;
int s = 0;
int f = 0;
int count = 0;
int count2 = 0;
int sx = 100;


void initScreen(){
  image(shanghai,0,height-600);
  smoke.resize(1100,400);
  image(smoke, 200,0);
  title.resize(650,320);
  image(title,width/2-325,height/2-260);
  start.resize(200,100);
  image(start,100,400);
}

void settingScreen(){
  if (video.available()) {
      video.read();
  }
  chSmog.resize(450,335);
  image(chSmog,width/2 + 100,100);
  textAlign(CENTER);
  fill(0);
  textSize(30);
  text("Click the gun to be tracked", width/2, height/2 + 230);
}


void gameScreen(int scene){
  if (scene == 1){
    bg_night();
    Balloons();
    outline_night();
  }else if(scene == 2){
    bg_day();
    Balloons();
    outline_day();
  }else {
    bg_twilight();
    Balloons();
    outline_day();
  }
  image(gun,width/2-cameraX-150,height/2-cameraY);
  printScore();
  timer();
  drawTimer();
  textFont(font,32);
  textAlign(CENTER);
  fill(255);
  textSize(15);
  text("Press 's' to reset the gun", 100-cameraX, height-30-cameraY);
  
}

void smogScreen(){
  smogattack = loadImage("smogattack.png");
  //smogattack.resize(1000, 600);
  if (scene == 1){
    overbg = loadImage("night.jpg");
    outline_night();
  }else if(scene == 2){
    overbg = loadImage("Shanghai-skyline-panoramic-water.jpg");
    outline_day();
  }else {
    overbg = loadImage("twilight.jpeg");
    outline_day();
  }
  image(overbg,0,0);
  image(smogattack, sx, 100);
  image(timesup, width/2-200, height/2-100);
  sx += 25;
  if (sx > 150){
    count_masks();
  }
}

void countingSetup(){
  maskOn = loadImage("gotmask.png");
  crying = loadImage("crying.png");
  ss = loadImage("smog_shanghai.jpg");
  ss.resize(1400,800);
  maskOn.resize(180,190);
  crying.resize(125, 250);
}

void countingScreen(){
  s = score;
  if (score >= needs) {
    s = needs;
  }else{
    f = needs - score;
  }
  image(ss,0,0);
  whoGotMasks();
  if (count > s){
  noMasks();}
  if (count2 > f){
    count = 0;
    count2 = 0;
    screen = 4;
    delay(1000);
  } 
}

void whoGotMasks(){
  if (count <= s){
    for (int i = 0; i < count; i++){
      if(i<=5) {image(maskOn, i*180+100, 100);}
      else {image(maskOn, (i-6)*180+100, 400);}
    }
  }
  count++;
  delay(500);
}

void noMasks(){
  if (count2 < f){
    for (int i = 0; i < count2+1; i++){
      image(crying, i*125+100, 400);
    }
  }
  count2++;
  delay(300);
}

void resultScreen(){
  fill(0);
  rect(0,0,1400,800);
  textFont(font,32);
  textAlign(CENTER);
  fill(255);
  textSize(50);
  text("Level : "+level+"\nMasks Collected : "+score, 700, 100);
  if(score >= needs){
    text("Congratulations!\nYou saved everyone in Shanghai! \nLEVEL UP!",700,350);
    image(next, 575, 540);
    if (mousePressed){levelup();}    
  }else{
    text("More masks needed.. \nGAME OVER",700,350);
    restart.resize(240,80);
    image(restart, 575, 540);
    if (mousePressed){restart();}
  }
}