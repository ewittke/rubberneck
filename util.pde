void keyPressed() {
  if(keyCode == UP) {
//    cars[0]._switchLanes( lanes[ cars[0].currentLane.number-1 ] );
  }
}

// Tween v = new Tween(100, 150, 60);
// if( !v.done() ){ v.tick(); }
// else { v.reset(); }

public class Tween {
  String type = ""; // Optional, for use in records

  float val;
  float startVal;
  float targetVal;
  float i;
  float coef;
  int speed;
  int steps;
  int speedPerStep;
  int nextFrameCount;
  int targetFrameCount;
  
  Tween(){ reset(); }
  
  void set( float sV, float tV, int s, float coef ) {
    reset();
    startVal = sV;
    targetVal = tV;
    coef = coef;
    speed = s;
    
    val = startVal;
    i = (targetVal - startVal)/steps;
    speedPerStep = floor(speed/steps);

    targetFrameCount = frameCount + speed;
    nextFrameCount = frameCount + speedPerStep; 
  }
  
  float tick() {
    if( frameCount == nextFrameCount ) {
      val = val + (i);
      nextFrameCount += speedPerStep;
    }
    return val;
  }
  
  boolean active() {
    if(frameCount > targetFrameCount || speed > 0) {
      speed = -1;
      return false;
    }
    else { 
      return true;
    }
  }
  
  void reset() {
    val = 0.0;
    startVal = 0.0;
    targetVal = 0.0;
    i = 0.0;
    speed = -1;
    steps = 10;
    nextFrameCount = 0;
  }
}

void cout(String text, String position) {
  float pos;
  textFont(f,16);
  colorMode(HSB, 360, 100, 100);
  fill(360,0,100);
  
  if(position == "left"){
    textAlign(LEFT);
    text(text, 50, height-50);
  }
  if(position == "right"){
    textAlign(RIGHT);
    text(text, width-50, height-50);
  }
  if(position == "center1"){
    textAlign(CENTER);
    text(text, width/2, 50);
  }
  if(position == "center2"){
    textAlign(CENTER);
    text(text, width/2, 75);
  }
}
