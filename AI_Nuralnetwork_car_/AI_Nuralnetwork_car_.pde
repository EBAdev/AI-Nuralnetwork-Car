World world;

PImage DrivingField;

int numE;

void setup() {
  DrivingField = loadImage("untitled.jpg");
  size(600, 600);
  numE = 1;
  world = new World(numE);
}

void draw() {
  background(255);
  image(DrivingField, 0, 0);
    world.RunWorld();
}
