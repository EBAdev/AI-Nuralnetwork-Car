class Car {
  PVector position =  new PVector();
  PVector velocity = new PVector(0, 0);
  PVector acceleration= new PVector(0, 0);
  PVector force;

  float Heading = 0 + HALF_PI; 
  float startX = 90;
  float startY = 110;
  float c = 0.1;
  float normal = 2;

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
    println(mid,c1,c2,c3,c4);
    if (mid > 0 || c1 > 0 || c2 > 0 || c3 > 0 || c4 > 0 ) {
      Alive = false;
    }
  }
}
