class Car {
  PVector position =  new PVector();
  PVector velocity = new PVector(0, 0);
  PVector acceleration= new PVector(0, 0);
  PVector force;
  PVector goal = new PVector(500, 55);
  PVector FrontDistance = new PVector(0, 50);
  PVector LeftDistance = new PVector(-50, 0);
  PVector RightDistance = new PVector(50, 0);

  float Heading = 0 + HALF_PI; 
  float startX = 90;
  float startY = 110;
  float c = 0.1;
  float normal = 2;
  float[] myInputs = {};

  boolean rightTurn;
  boolean Alive = true;

  Car() {
    position.x = startX;
    position.y = startY;
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    velocity.mult(0.983);
    velocity.limit(0.2);
    show();
    SlowDown();
    dead();
    CarSensor();
  }

  void accelerate() {
    force = PVector.fromAngle(Heading);
    force.setMag(0.15);
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
    fill(255, 0, 0);
    stroke(0);
    translate(position.x, position.y);
    rotate(Heading);
    rectMode(CENTER);
    rect(0, 0, 20, 10);
    popMatrix();
    line(position.x, position.y, position.x, position.y+FrontDistance.y);
    line(position.x, position.y, position.x - LeftDistance.x, position.y);
    line(position.x, position.y, position.x + RightDistance.x, position.y);
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

    if (mid > 0 || c1 > 0 || c2 > 0 || c3 > 0 || c4 > 0 ) {
      Alive = false;
    }
  }

  void CarSensor() {
    for (int i = 0; i < 50; i++) {
      int frontPixels = DrivingField.get(floor(position.x), floor(position.y+i));
      float FrontPixels = map(frontPixels, -1, -3, 0, 255);
      if (FrontPixels > 0) {
        FrontDistance = new PVector(0, i);
      }
    }
    for (int j = 0; j < 50; j++) {
      int leftPixels = DrivingField.get(floor(position.x-j), floor(position.y));
      float LeftPixels = map(leftPixels, -1, -3, 0, 255);
      if (LeftPixels > 0) {
        LeftDistance = new PVector(j, 0);
      }
    }
    for (int k = 0; k < 50; k++) {
      int rightPixels = DrivingField.get(floor(position.x+k), floor(position.y));
      float RightPixels = map(rightPixels, -1, -3, 0, 255);
      if (RightPixels > 0) {
        RightDistance = new PVector(k, 0);
      }
    }
  }



  void seek() {
    myInputs = new float[0];

    float CarVelocity = velocity.mag();
    myInputs = (float[]) append(myInputs, CarVelocity);
    float CarHeading = Heading;
    myInputs = (float[]) append(myInputs, CarHeading);
    
    float DistToGoal = PVector.dist(position, goal);
    myInputs = (float[]) append(myInputs, DistToGoal);
   
    float FrontSensor = FrontDistance.y;
    myInputs = (float[]) append(myInputs, FrontSensor);
    float RightSensor = RightDistance.x;
    myInputs = (float[]) append(myInputs, RightSensor);
    float LeftSensor = LeftDistance.x;
    myInputs = (float[]) append(myInputs, LeftSensor);
  }
}
