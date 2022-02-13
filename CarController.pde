class CarController {
  Car bil;
  NeuralNetwork hjerne; 
  SensorSystem  sensorSystem;
      
  CarController() {
    bil = new Car();
    hjerne = new NeuralNetwork(2.0, 3, 3, 2);
    sensorSystem = new SensorSystem();
  }
  CarController(NeuralNetwork oldNN) {
    bil = new Car();
    hjerne = new NeuralNetwork(oldNN);
    sensorSystem = new SensorSystem();
  }
      
  void update() {
    bil.update();
    sensorSystem.updateSensorsignals(bil.pos, bil.vel);
    
    double[] output = hjerne.getOutput(
      (double)int(sensorSystem.leftSensorSignal),
      (double)int(sensorSystem.frontSensorSignal),
      (double)int(sensorSystem.rightSensorSignal)
    );
    
    bil.turnCar((float)output[0]);
    bil.changeVel((float)output[1]);
  }
  
  void display(){
    bil.display();
    sensorSystem.displaySensors();
    //fill(255);
    //text((int)sensorSystem.clockWiseRotationFrameCounter, bil.pos.x, bil.pos.y - 10);
  }
  
  void display(int index) {
    bil.display(index);
    sensorSystem.displaySensors();
  }
}
