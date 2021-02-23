class Arrow {
  int type; // 1: left, 2: up, 3: down, 4: right, decided randomly
  float x, y; // location of arrow
  float speed; // speed of arrow
  
  int size; // size of arrow

  Arrow() {
    type=(int)random(4)+1; // generate random type of arrow
    x=(width/4)*type-(width/8); // initial x-location of arrow
    y=scoreLine; // initial y-location of arrow
    speed=random(0.6,0.61)*2; // random speed
    size=50;
  }
  
  void drawArrow(){
   noStroke();
   if(type==1) image(arrowImg[0],x,y);
   else if(type==2) image(arrowImg[1],x,y);
   else if(type==3) image(arrowImg[2],x,y);
   else if(type==4) image(arrowImg[3],x,y);

  }
  
  void faster(){
    speed += 0.3;
  }
  void update(){
    y += speed;
  }
  
  boolean inGoalLine(){
    if(goalLine-size/2<=y && y<=goalLine+size/2) return true;
   return false; 
  }
  boolean fail(){
   if(y>height) return true;
   return false;
  }
}