class EndPage {
  int btnWidth, btnHeight; // the size of start button
  float btnX, btnY; // the location of start button
  int count;
  int flag;
  boolean isSuccess;

  EndPage(boolean _isSuccess) {
    btnWidth=110;
    btnHeight=50;
    btnX=width/2;
    btnY=height/1.5;
    count=0; // for the blinking effect of text
    flag=0;
    isSuccess=_isSuccess;
  }

  void draw() {
    if (flag==0) {
      mouseClickFlag=false;
      if (isSuccess) {
       
      } else {
        failSound.rewind(); 
        failSound.play();
      }
    }
    flag++;
    fill(0, 150);
    noStroke();
    rectMode(CENTER);
    rect(width/2, height/2, 400, 400);
    // text setting 
    fill(255);
    textSize(30);
    text("Total Score", width/2, height/3);
    textSize(50);
    text(score, width/2, height/3+70);
    // check whether misson fail or pass
    count++;
    textSize(32);
    if (count<30) {
      if (score>=5*scoreChange) text("Congratulations!", width/2, height/2+40);
      else text("Misson Fail!", width/2, height/2+40);
    } else if (count==60) {
      count=0;
    }

    // restart button
    startButton.resize(btnWidth, btnHeight);
    image(startButton, btnX, btnY);
  }
  boolean mousePressed() {
    if (btnX-btnWidth/2<=mouseX && mouseX <=btnX+btnWidth/2 && btnY-btnHeight/2<=mouseY && mouseY<=btnY+btnHeight/2)
      return true;
    return false;
  }
}