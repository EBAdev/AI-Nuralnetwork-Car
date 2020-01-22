class World {
  ArrayList<Car> Cars;
  ArrayList<Car> carClones;           //clones array we will use to recover stats from dead creatures
  ArrayList<Car> carsMatingPool;
  float mutationRate;
  
  World(int numC) {
    Cars = new ArrayList <Car>();
    carClones = new ArrayList<Car>();
    carsMatingPool = new ArrayList<Car>();
    mutationRate = 0.01;

    for (int i = 0; i < numC; i++) {
      Cars.add(new Car(new NeuralNetwork()));
    }
  
  }

  void RunWorld () {
    for (int i = Cars.size()-1; i >= 0; i--) {
      Car c = Cars.get(i);
      c.update();
      c.show();
      if (c.Alive == false) {
        carClones.add(c); 
        Cars.remove(i);
      }
    }
  }


  void carsSelection() {                             //function to prepare the mating pool for reproduction
    carsMatingPool.clear();                         //first we clear the old mating pool
    float maxFitness = getCarsMaxFitness();         //we determine who's the best creature of the generation

    for (int i = 0; i < carClones.size(); i++) {                               //for every dead creature
      float fitnessNormal = map(carClones.get(i).DistToGoal, 0, maxFitness, 0, 1);    //we normalize the fitness score between 0 and 1
      int n = (int) (fitnessNormal*100);                                          //multiply it by 100
      for (int j = 0; j < n; j++) {                                               //and add the clone to the pool as many times as it deserves.
        carsMatingPool.add(carClones.get(i));                                //the better you are, the more chances you get to reproduce
      }
    }
  }
  float getCarsMaxFitness() {                             //function to get the highest fitness score of the generation
    float record = 0;
    for (int i = 0; i < carClones.size(); i++) {
      if (carClones.get(i).DistToGoal > record) {
        record = carClones.get(i).DistToGoal;
      }
    }
    return record;
  }
  void carsReproduction() {                        //function to select parents and cross brain data
    float tempWeight;

    for (int i = 0; i < numE; i++) {                 
      Cars.add(new Car(new NeuralNetwork())); //first we generate a random eater

      int m = int(random(carsMatingPool.size()));          //choose two random parents from the mating pool
      int d = int(random(carsMatingPool.size()));

      Car mom = carsMatingPool.get(m);                   //get them
      Car dad = carsMatingPool.get(d);

      for (int k = 0; k < mom.NN.getLayerCount(); k++) {     //for every layer of the brain...
        float[] momWeights = new float[0];                   //create 3 arrays to store weights and biases of the family
        float[] dadWeights = new float[0];
        float[] childWeights = new float[0];

        momWeights = mom.NN.layers[k].getWeigths();          //get mom and dad weights and biases
        dadWeights = dad.NN.layers[k].getWeigths();

        for (int j = 0; j < momWeights.length; j++) {                      //for every weights of the layer
          if (random(1) > 0.5)  tempWeight = momWeights[j];                //choose random between mom and dad
          else                  tempWeight = dadWeights[j];
          if (random(1) < mutationRate) tempWeight += random(-0.1, 0.1);   //apply chance of mutation
          tempWeight = constrain(tempWeight, -1, 1);                       //clamp new weight
          childWeights = (float[]) append(childWeights, tempWeight);       //add weight to the child weights and bias array
        }
        Car c = Cars.get(i);                                           //take the random eater we've created at the start
        c.NN.layers[k].setWeights(childWeights);                           //set its brain with the new weights
      }
    }
    carClones.clear();                                                  //clear the clones array for the next generation
  }

  Car getBestCar() {                                    //function to clone the best eater and store it across generations (actually unused)
    Car bestCar = new Car(new NeuralNetwork());
    for (int i = 0; i < carClones.size(); i++) {
      if (carClones.get(i).DistToGoal > bestCar.DistToGoal) {
        bestCar = carClones.get(i);
      }
    }
    return bestCar;
  }

  ArrayList getEater() {
    return Cars;
  }
}
