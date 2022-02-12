class CarController {
  Car bil;
  NeuralNetwork hjerne; 
  SensorSystem  sensorSystem;
      
  CarController() {
    bil = new Car();
    hjerne = new NeuralNetwork();
    sensorSystem = new SensorSystem();
  }
  CarController(List<Float> genes) {
    bil = new Car();
    hjerne = new NeuralNetwork(genes);
    sensorSystem = new SensorSystem();
  }
      
  void update() {
    bil.update();
    sensorSystem.updateSensorsignals(bil.pos, bil.vel);
    
    PVector output = hjerne.getOutput(
      int(sensorSystem.leftSensorSignal),
      int(sensorSystem.frontSensorSignal),
      int(sensorSystem.rightSensorSignal)
    );
    
    bil.turnCar(output.x);
    bil.changeVel(output.y);
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
