

class World {
  ArrayList<Car> Cars;
  World(int numC) {
    Cars = new ArrayList <Car>();

    for (int i = 0; i < numC; i++) {
      Cars.add(new Car());
    }
  }

  void RunWorld () {
    for (int i = Cars.size()-1; i >= 0; i--) {
      Car c = Cars.get(i);
      c.update();
      if (keyPressed) {
        if (key == 'w') {
          c.accelerate();
        }
      }

      if (keyPressed) {
        if (key == 'w') {
          c.accelerate();
        } else if ( key == 'd') {
          c.rightTurn = true;
          c.turn();
        } else if (key == 'a') {
          c.rightTurn = false;
          c.turn();
        }
      }
      if (c.Alive == false) {
        Cars.remove(i);
      }
    }
  }
}
