// Explorable Mandelbrot Set
 import controlP5.*;
 ControlP5 cp5;

//World w;
PFont f;

boolean loop = true;
boolean pause = false;
int dispenseAt = 10;
float baseSpeed = 30;
int volatility = 5;

// Control herd density by lowering the min and max.
int dispenseVariationMax = 15;
int dispenseVariationMin = 8;

// Raise max to increase variety™
int speedVariationMax = 6;
int speedVariationMin = 0;

int maxcars = 15;
int carcount = 0;
int laneCount = 3;
int laneOffset = 2;

// Records
Lane[] lanes = new Lane[ laneCount ];
Car[] cars = new Car[ maxcars ];

// Launch
void setup() {
  size(1000, 350);
  frameRate(60);

  colorMode(HSB, 360, 100, 100);
  f = createFont("Arial",12,true);
  cp5 = new ControlP5(this);  
  
  _load();
}

void draw() {  
  clearScreen();
  
  for(int i=0; i<lanes.length; i++) {
    lanes[i].show();
  }

  if(frameCount == dispenseAt) {
    dispenseAt = frameCount+int(random(dispenseVariationMin, dispenseVariationMax));
    for(int i=0; i < maxcars; i++){
      if(cars[i].hide == true){
        if(cars[i]._getNeighborAhead() == -1){
          cars[i].dispense();
          break;
        }
      }
    }
  }
  for(int i=0; i < maxcars; i++){
    cars[i].drive();
  }
}

void _load() {
  lanes[0] = new Lane( 0.6, 0 );
  lanes[1] = new Lane( 0.0, 1 );
  lanes[2] = new Lane( -0.2, 2 );
  
  for(int i=0; i < maxcars; i++){
    cars[i] = new Car( lanes[ (int)(random(0,laneCount)) ], (float)(random(speedVariationMin, speedVariationMax))/10.0 );
    cars[i].queue();
  }
}

void clearScreen() {
  background( color(360, 0, 100) );
}
