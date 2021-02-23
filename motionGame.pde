/*

 * Title : Ocean Pump 
 * Description : Ocean Pump is the rhythm based music game. 
                 You can get the points if you move your mobile phone to the direction of arrows when the arrow reaches ending line.
                 The goal of this game is to grow ponyo (chracter in the middle) to the adults.
 
 */
import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

OscP5 oscP5;
NetAddress dest;

int x=0;
PVector accel;

int timeGap=70;
int gestureType=-1;
int imgSize=100; // the intial size of ponyo image
int scoreLine=80;
int score=0;
int scoreChange=100; /////////////////// needs to change
int goalLine=720;
int s=100; // the size of arrow
int life=5; // the number of heart
boolean startBtn=false;
boolean mouseClickFlag=false;
boolean bigPonyoAppear=false;

StartPage startPage;
EndPage endPage;
ArrayList<Arrow> arrows;

// Assets for Concept (font, picture, music, etc)
PFont font;
PImage[] ponyo;
PImage[] arrowImg;
PImage background;
PImage mainLogo;
PImage startButton;
PImage heart;

// Music setting
Minim minim;
AudioPlayer matchSound, btnSound, bgm;
AudioPlayer successSound, failSound, growingSound;
AudioPlayer wowSound, tadaSound;

// counting variables
int cnt=0;
int cnt2=0;
int cnt3=0;
int delay=0;
void setup() {
  size(600, 800);

  oscP5 = new OscP5(this, 12000);
  dest = new NetAddress("127.0.0.1", 6448);

  accel = new PVector(0, 0, 0);
  startPage=new StartPage(); // make start page
  arrows=new ArrayList<Arrow>(); // make arrow List
  arrows.add(new Arrow());

  // Text Settings
  textSize(32);
  textAlign(CENTER);
  font=createFont("font/slkscr.ttf", 32);
  textFont(font);

  // Load Ponyo images
  ponyo=new PImage[10];
  for (int i=0; i<ponyo.length; i++) {
    ponyo[i]=loadImage("img/"+(i+1)+".png");
    // make the size of ponyo differently
    if (i<2) ponyo[i].resize(100, 100);
    else if (i<4) ponyo[i].resize(150, 150);
    else if (i<6) ponyo[i].resize(200, 200);
    else if (i<8) ponyo[i].resize(250, 250);
    else if (i<9) ponyo[i].resize(300, 300);
    else ponyo[i].resize(400, 400);
  }
  // Load arrow images
  arrowImg=new PImage[4];
  for (int i=0; i<arrowImg.length; i++) {
    arrowImg[i]=loadImage("img/a"+(i+1)+".png"); 
    arrowImg[i].resize(s, s);
  }
  // Load background image, logo, button
  background=loadImage("img/background.png");
  mainLogo=loadImage("img/title.png");
  mainLogo.resize(300, 300);
  startButton=loadImage("img/startButton.png");
  heart=loadImage("img/heart.png");
  heart.resize(30, 30);

  imageMode(CENTER);

  // Load sounds
  minim = new Minim(this);
  matchSound = minim.loadFile("sound/correctSound.wav");
  btnSound=minim.loadFile("sound/buttonSound.mp3");
  bgm=minim.loadFile("sound/backgroundMusic.mp3");
  failSound=minim.loadFile("sound/fail.wav");
  successSound=minim.loadFile("sound/win.wav");
  growingSound=minim.loadFile("sound/grows.wav");
  wowSound=minim.loadFile("sound/wow.mp3");
  tadaSound=minim.loadFile("sound/tada.WAV");

  noStroke();
}

int order, prevOrder;

void draw() {
  background(255);

  if (!startBtn) { // if the start button is not yet clicked
    startPage.draw();
    if (mouseClickFlag && startPage.mousePressed()) {
      bigPonyoAppear=false;
      startBtn=true;
      timeGap=70;
      order=0;
      prevOrder=0;
      cnt2=0;
      cnt3=0;
      life=5; 
      cnt=0; 
      score=0;
      bgm.play();
      startPage=new StartPage();
    }
    mouseClickFlag=false;
  } else { // if the start button is clicked
    //background Image
    image(background, width/2, height/2);

    // show score text
    fill(0);
    textSize(32);
    text("Score : "+score, width/2, 50);
    stroke(0);
    strokeWeight(3);

    // changing image regarding game score (every 50 scores)
    prevOrder=order;
    order=score/scoreChange; //  
    if (order>5) order=5;

    if (prevOrder!=order) { // if ponyo grows (6 stages)
      growingSound.rewind();
      growingSound.play();
      // make arrows faster
      for (int i=0; i<arrows.size(); i++) {
        arrows.get(i).faster();
      }
      //make arrows mucher
      timeGap-=10;
      if (timeGap<=1) timeGap=1;
    }

    // moving ponoys
    cnt2++;
    if (score<scoreChange*4) {
      for (int i=1; i<=4; i++) {
        if (score<scoreChange*i) {
          if (cnt2<30) image(ponyo[(i-1)*2], width/2, height/2);
          else {
            image(ponyo[(i-1)*2+1], width/2, height/2);
            if (cnt2==60) cnt2=0;
          }
          break;
        }
      }
    } else {
      image(ponyo[order+4], width/2, height/2);
    }

    //draw hearts (life)
    for (int i=0; i<life; i++) {
      image(heart, i*30+20, 20);
    }

    // draw arrows
    // check whether the music still plays or not
    if (bgm.isPlaying()) {
      for (int i=0; i<arrows.size(); i++) {
        arrows.get(i).drawArrow();
        arrows.get(i).update();

        if (gestureType>=1) { // if wekinator Gesture output comes
          delay ++;
          // if the user matches arrow correctly
          if (gestureType==arrows.get(i).type && arrows.get(i).inGoalLine()) {
            score += 10;
            if (score>=scoreChange*5) { // mission complete
              bigPonyoAppear=true;
              endPage=new EndPage(true);
              bgm.pause();
            }
            arrows.remove(i);
            // if there are no arrows left inside array, add one arrow
            if (arrows.size()==0) arrows.add(new Arrow());
            gestureType=-1;
            matchSound.rewind();
            matchSound.play();
            delay=0;
          }

          if (delay==30) { // wait for gesture 0.5 second (maintain current gesture)
            delay=0;
            gestureType=-1;
          }
        }
        // if the user misses arrow, it will disappear  
        if (arrows.get(i).fail()) {
          arrows.remove(i); 
          if (arrows.size()==0) arrows.add(new Arrow());
          life --;
          if (life<=0) { // game end (fail)
            endPage=new EndPage(false);
            bgm.pause();
          }
        }
      }
    } else {  // if bgm ends
      if (bigPonyoAppear) { // big ponyo (mission complete)
        cnt3++;
        if (cnt3==1) { // Tada!
          tadaSound.rewind(); 
          tadaSound.play();
        } else if (cnt3==20) { // WOW
          wowSound.rewind(); 
          wowSound.play();
        }
        if (cnt3>100) {
          bigPonyoAppear=false;
          cnt3=0;
        }
      } else { // ending scene
        endPage.draw();
        arrows.clear();
        if (mouseClickFlag && endPage.mousePressed()) {
          startBtn=false;
          bgm.pause();
          bgm.rewind();
        }
      }
    }

    // add arrow after specific amount of time (2 sec)
    cnt++;
    println(cnt+" "+timeGap);
    if (cnt==timeGap) {
      arrows.add(new Arrow());
      cnt=0;
    }
  }
}

void mouseClicked() {
  mouseClickFlag=true;
}

void sendOsc() {
  OscMessage msg = new OscMessage("/oschook");
  msg.add(accel.x); 
  msg.add(accel.y);
  msg.add(accel.z);
  oscP5.send(msg, dest);
}

// automatically called whenever osc message is received
void oscEvent(OscMessage m) {
  m.print();
  // message from phone to processing
  if (m.checkAddrPattern("/oschook")==true) {
    /* check if the typetag is the right one. */
    if (m.checkTypetag("ifffffffff")) {
      /* extract the acceleration values from the osc message */
      accel.x = m.get(4).floatValue();  
      accel.y = m.get(5).floatValue();  
      accel.z = m.get(6).floatValue();  

      sendOsc();
    }
  }

  // message from wekinator to processing
  if (m.checkAddrPattern("/wek/outputs")==true) {
    int res=0;
    if (m.checkTypetag("f")) {
      res=(int)m.get(0).floatValue();
    }
    if (res==1) { // left
      gestureType=1;
    } else if (res==2) { // up
      gestureType=2;
    } else if (res==3) { // down
      gestureType=3;
    } else if (res==4) { // right
      gestureType=4;
    } else if (res==5) { // normal
      gestureType=5;
    }
  }
}