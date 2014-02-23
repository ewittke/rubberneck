public class Lane {
  int number = 0;
  float boost = 0.0;
  float startx = 10;
  float starty = 0;
  float x = 0;
  float y = 0;
  float gutter = 5;
  float w = 15;
  float laneWidth = gutter + w + gutter;

  Lane( float b, int n ) {
    number = n;
    boost = b;
    y = 100 + (laneWidth * number) + (laneOffset * number);
    starty = y + laneWidth/2;
    show();
  }
  
  void show() {
    fill( color(360, 0, 90) );
    noStroke();
    rect(0, y, width, laneWidth);
  }
  
  float getLaneToLeft() {
    return (starty - (laneWidth + laneOffset));
  }
}
