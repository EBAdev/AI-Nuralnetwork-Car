World world;

PImage DrivingField;

int numE;
int time;
int generation;
int longestGeneration;
float oldestEater;
int bestGen;

void setup() {
  DrivingField = loadImage("untitled.jpg");
  size(600, 600);
  numE = 10;
  
  world = new World(numE);
}

void draw() {
  //background(255);
  image(DrivingField, 0, 0);
  
    if (world.carClones.size() < numE) {
    world.RunWorld();
    time += 1;
  } else {

    if (time > longestGeneration) longestGeneration = time;
    if (world.getCarsMaxFitness() > oldestEater) {
      oldestEater = world.getCarsMaxFitness();
      bestGen = generation;
    }

    time = 0;
    generation++;

    
    
    

    world.carsSelection();
    world.carsReproduction();
  }

  fill(0);                                                               // display some stats
  textSize(12);
  text("Generation #: " + (generation), 10, 18);
  text("Lifetime: " + (time), 10, 36);
  text("living Cars: " + world.Cars.size(), 10, 54);
  text("Longest gen: " + longestGeneration, 110, 36);
  text("Oldest Car: gen" +bestGen + " - " + oldestEater, 110, 18);

}
