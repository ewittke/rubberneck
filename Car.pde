public class Car {
  private int number = 0;
  private boolean _isMarked = false;

  private float startSpeed = 0;
  public float speed = startSpeed;  // Current; Essentially x+=dx
  private float idealSpeed = 0;      // Speed the driver tries to maintain
  private float maxSpeed;
  private float speedVariant = 0;

  private int safezone = 25;
  private float accelerator = 0.0;   // How quickly driver is speeding up
  private float extragas = 0.01;      // An accelerator preset. Todo: Allow for variability (more powerful cars)
  private boolean brakes = false;
  boolean hide = false;
  Tween laneSwitch = new Tween();

  color paint = color(0);
  float w = 12;
  float h = 8;
  float startx = 0;
  float starty = 0;
  float cx = 0;
  float cy = 0;

  Lane currentLane;
  Car forecar;
  
  Car( Lane l, float sv ) {
    speedVariant = sv;

    _assignLane( l, true );
    _init();
  }

  void _init(){
    number = cars.length+1;
    startx = currentLane.startx - w;
    _calcIdealSpeed();
    _calcSpeed();
    
    cx = startx;
    cy = starty;

    queue();
  }
      
  void setBrakes(boolean b){ brakes = b; }  // Later: Remove variable, set to -1.0 acceleration
  void hide(){ hide = true; }
  void show(){ hide = false; }  

  void queue(){
    hide();
    setBrakes(true);
  }
  
  void dispense(){
    reset();
    show();
    drive();
    setBrakes(false);
  }
    
  void drive() {
    // Are they at the end?
    if(cx + speed/10.0 >= width) {
      reset();
    }
    
    if( laneSwitch.active() ){
      cy = laneSwitch.tick();
    }

    if(!brakes){
      // Calculate forces
      _calcIdealSpeed();
      _calcAccelerator();
      _calcSpeed();
      
      // Map dx (speed) to pixels
      cx += (speed)/10.0;
    }
    _draw(cx, cy);
  }
  
  void _calcAccelerator() {
    if( speed < idealSpeed ) {
      accelerator = extragas;
    }
    else if( speed >= idealSpeed ) {
      accelerator = 0.0;
    }
    assessNeighbors(); // Adjusts accelerator to be negative if necessary
  }
  
  void assessNeighbors() {
    // Load with -1 if zones are clear.
    int nl = _getNeighborToLeft();
    int na = _getNeighborAhead();

    // If there's someone ahead, match their speed.
    if( na > -1 ) {
      speed = cars[na].speed;
      accelerator = 0.0;

      // If the left side is empty, give a 30% chance of switching lanes.
      if( nl == -1 && frameCount > 200 ) {
        // If it's slower than desired and outside of the buffer zone.
        if(speed < idealSpeed && cx > 50){
          if(currentLane.number != 0){
            if(round(random( volatility )) == 1) {
              _switchLanes( lanes[currentLane.number-1] );
            }
          }
        }
      }
    }
  }

  void _calcIdealSpeed(){
      idealSpeed = baseSpeed + baseSpeed*currentLane.boost + baseSpeed*speedVariant;  
  }

  void _calcSpeed(){
    if( speed < idealSpeed ) {
      speed = speed + idealSpeed*accelerator;
    }
    else if( speed >= idealSpeed ) {
      _calcIdealSpeed();
      speed = idealSpeed;
    }
  }

  void _draw(float x, float y){
    if(!hide){
      colorMode(HSB, 360, 100, 100);
      paint = color(360, 0, 100-(speed/idealSpeed)*100);
      
      if(_getNeighborAhead() > -1){
        //paint = color(220, 50, 100);
      }
      
      if(_isMarked){}
      
      fill( paint );
      noStroke();
      rect(x, y, w, h, 3);
    }
  }
  
  void _assignLane( Lane l, boolean moveTo ) {
    currentLane = l;  
    
    if(moveTo) {
      starty = currentLane.starty - h/2;
      cy = starty;
    }
  }
  
  void _switchLanes( Lane newLane ) {
    float ty = currentLane.getLaneToLeft() - h/2;    
    _assignLane( newLane, false );

    laneSwitch.set( cy, ty, 40, -1 );
  }
  
  int _getNeighborAhead() {
    for(int c=0; c < maxcars; c++){
      if(this!=cars[c] && !cars[c].hide){
        if( currentLane == cars[c].currentLane){
          if( (cx <= cars[c].cx) && (cars[c].cx <= cx+w+safezone) ) {
            return c;
          }
        }
      }
    }
    return -1;
  }
  int _getNeighborToLeft() {
    double cyN = starty - laneOffset - currentLane.laneWidth;
    for(int c=0; c < maxcars; c++){
      if(this!=cars[c] && !cars[c].hide){
        if( cars[c].cy == cyN ){
          if( (cars[c].cx > cx-20) && (cars[c].cx <= cx+w+safezone) ) {
            return c;
          }
        }
      }
    }
    return -1;    
  }
  
  void reset() {
    if(!loop){
      paint = color(350, 0, 0);
      speed = startSpeed;
      _assignLane( lanes[(int)(random(0,6))], true ); // Move to a random lane
      _init();
    }
    else {
      cx = startx;
    } 
  }
}
