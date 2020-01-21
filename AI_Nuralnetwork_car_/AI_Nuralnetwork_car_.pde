float startX = 90;
float startY = 110;
float startDirX = random(-0.5,0.5);
float startDirY = random(1,2);
PImage DrivingField;
void setup() {
  DrivingField = loadImage("DrivingField.png");
  size(600, 600);
  
}

void draw() {
  background(255);
  image(DrivingField, 0, 0);
  rectMode(CENTER);
  
  rect(startX, startY+startDirY, 10, 30);
  
  startDirY++;
  startDirX++;
  
}
