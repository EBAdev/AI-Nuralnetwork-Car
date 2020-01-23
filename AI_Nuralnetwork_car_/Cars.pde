class Car {
  NeuralNetwork NN = new NeuralNetwork();
  int sensorLength = 60;

  PVector position =  new PVector();
  PVector velocity = new PVector(0, 0);
  PVector acceleration= new PVector(0, 0);
  PVector force;
  PVector startpos = new PVector(90, 110);
  PVector goal = new PVector(500, 55);
  PVector FrontDistance = new PVector(0, sensorLength);
  PVector LeftDistance = new PVector(-sensorLength, 0);
  PVector RightDistance = new PVector(sensorLength, 0); 
  PVector TopDistance = new PVector(0, -sensorLength); 
  float Heading = 0 + HALF_PI; 
  float startX = 130;
  float startY = 70;
  float c = 0.1;
  float normal = 2;
  float[] myInputs = {};
  float DistToGoal;

  int counter = 0;
  float maxSpeed = 0.2;

  boolean rightTurn;
  boolean Alive = true;

  Car(NeuralNetwork NN_) {
    NN = NN_; 
    NN.addLayer(6, 18);         
    NN.addLayer(18, 64);
    NN.addLayer(64, 3);

    position.x = startX;
    position.y = startY;
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    velocity.mult(0.983);
    velocity.limit(0.2);
    SlowDown();
    dead();
    CarSensor();
    seek();


    DistToGoal = position.y*2;
  }

  void accelerate(float speed) {
    force = PVector.fromAngle(Heading);
    force.setMag(speed);
    acceleration.add(force);
  }

  void SlowDown() {
    float frictionMag = c*normal;
    PVector friction = velocity;
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMag);
    acceleration.add(friction);

    float speed = velocity.mag();
    float dragMagnitude = c * speed * speed;
    PVector drag = velocity;
    drag.mult(-1);
    drag.normalize();
    drag.mult(dragMagnitude);
    acceleration.add(drag);
  }

  void turn() {
    if (rightTurn) {
      Heading += 0.05;
    } else {
      Heading -=0.05;
    }
  }


  void show() {
    pushMatrix();
    fill(DistToGoal, 0, 0);
    stroke(0);
    translate(position.x, position.y);
    rotate(Heading);
    rectMode(CENTER);
    rect(0, 0, 20, 10);
    popMatrix();
    line(position.x, position.y, position.x, position.y+FrontDistance.y);
    line(position.x, position.y, position.x - LeftDistance.x, position.y);
    line(position.x, position.y, position.x + RightDistance.x, position.y);
    line(position.x, position.y, position.x, position.y-TopDistance.y);
  }


  void dead() {
    int Mid = DrivingField.get(floor(position.x), floor(position.y));
    int C1 = DrivingField.get(floor(position.x-10), floor(position.y-5));
    int C2 = DrivingField.get(floor(position.x-10), floor(position.y+5));
    int C3 = DrivingField.get(floor(position.x+10), floor(position.y-5));
    int C4 = DrivingField.get(floor(position.x+10), floor(position.y+5));

    float mid = map(Mid, -1, -3, 0, 255);
    float c1 = map(C1, -1, -3, 0, 255);
    float c2 = map(C2, -1, -3, 0, 255);
    float c3 = map(C3, -1, -3, 0, 255);
    float c4 = map(C4, -1, -3, 0, 255);
    if (velocity.mag() < 0.001) {
      counter++;
    }
    if (mid > 0 || c1 > 0 || c2 > 0 || c3 > 0 || c4 > 0 || counter > 120  || mousePressed) {
      Alive = false;
      //DistToGoal -= 20;
    }
  }

  void CarSensor() {
    for (int i = 0; i < sensorLength; i++) {
      int frontPixels = DrivingField.get(floor(position.x), floor(position.y+i));
      float FrontPixels = map(frontPixels, -1, -3, 0, 255);
      if (FrontPixels > 0) {
        FrontDistance = new PVector(0, i);
      }
    }
    for (int j = 0; j < sensorLength; j++) {
      int leftPixels = DrivingField.get(floor(position.x-j), floor(position.y));
      float LeftPixels = map(leftPixels, -1, -3, 0, 255);
      if (LeftPixels > 0) {
        LeftDistance = new PVector(j, 0);
      }
    }
    for (int k = 0; k < sensorLength; k++) {
      int rightPixels = DrivingField.get(floor(position.x+k), floor(position.y));
      float RightPixels = map(rightPixels, -1, -3, 0, 255);
      if (RightPixels > 0) {
        RightDistance = new PVector(k, 0);
      }
    }
    for (int l = 0; l < sensorLength; l++) {
      int topPixels = DrivingField.get(floor(position.x), floor(position.y-l));
      float TopPixels = map(topPixels, -1, -3, 0, 255);
      if (TopPixels > 0) {
        TopDistance = new PVector(0, l);
      }
    }
  }


  void seek() {
    myInputs = new float[0];

    float CarVelocity = velocity.mag();
    myInputs = (float[]) append(myInputs, CarVelocity);
    float FrontSensor = FrontDistance.y;
    myInputs = (float[]) append(myInputs, FrontSensor);
    float RightSensor = RightDistance.x;
    myInputs = (float[]) append(myInputs, RightSensor);
    float LeftSensor =LeftDistance.x;
    myInputs = (float[]) append(myInputs, LeftSensor);
    float TopSensor = TopDistance.y;
    myInputs = (float[]) append(myInputs, TopSensor);
    float Orientation = Heading;
    myInputs = (float[]) append(myInputs, Orientation);

    NN.processInputsToOutputs(myInputs);                                          
    
    float speed = map(NN.arrayOfOutputs[0], -1, 1, 0, maxSpeed);
    accelerate(speed);
    if (NN.arrayOfOutputs[1] > 0.0) {
      rightTurn = false;
      turn();
    }
    if (NN.arrayOfOutputs[2] > 0.0) {
      rightTurn = true;
      turn();
    }
  }
}
