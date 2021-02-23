class StartPage {
  int btnWidth,btnHeight; // the size of start button
  float btnX,btnY; // the location of start button
  int count=0;
  
  StartPage() {
    btnWidth=110;
    btnHeight=50;
    btnX=width/2;
    btnY=height/1.3;
    count=0;
  }

  void draw() {
    // background
    fill(0);
    rectMode(CORNER);
    rect(0,0,width,height);
    // main logo
    image(mainLogo,width/2,height/3);
    // start button
    startButton.resize(btnWidth,btnHeight);
    image(startButton,btnX,btnY);
    // click to start text
    fill(255);
    count++;
    textSize(15);
    if (count<40) {
     text("click to start", width/2, btnY+50);
    } else if (count==80) {
      count=0;
    }

  }
  boolean mousePressed(){
    if(btnX-btnWidth/2<=mouseX && mouseX <=btnX+btnWidth/2 && btnY-btnHeight/2<=mouseY && mouseY<=btnY+btnHeight/2)
    return true;
   return false;
  }
}