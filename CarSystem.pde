import java.util.stream.IntStream;

class CarSystem {
  
  int generation = 1;

  final float varians = 2;

  final int generationSize = populationSize,
            parentAmount = 1;
  final Supplier<CarController> supplier = () -> supplyCar();
  final Function<CarController, Integer> scorer = car -> scoreCar(car);
  final Function<CarController, CarController> mutater = car -> mutateCar(car);
  final Function<List<CarController>, CarController> combiner = list -> combineCars(list); //Den tager bare forældre nummber 0, da der kun vil være én forældre.

  List<CarController> CarControllerList;

  CarSystem() {
    CarControllerList = GeneticAlgorithm.makeGenerationFromSupplier(generationSize, supplier);
  }

  void updateAndDisplay() {
    CarControllerList.forEach(c -> c.update());
    CarControllerList.get(0).display(0);
    CarControllerList.stream().limit(100).filter(c -> scoreCar(c) > 0).skip(1).forEach(c -> c.display());
    //if(frameCount%10==0)
      CarControllerList.sort((a, b) -> scoreCar(b) - scoreCar(a));
  }

  void advanceGeneration() {
    println(CarControllerList.get(0).hjerne.genes);
    generation++;
    CarControllerList = GeneticAlgorithm.makeGenerationFromGeneration(CarControllerList, generationSize, 1, mutater, scorer, combiner);
  }
  
  int bestTime() {
    return 10000 - CarControllerList.stream().mapToInt(c -> scoreCar(c)).max().orElse(10000);
  }

  CarController supplyCar() {
    return new CarController();
  }

  int scoreCar(CarController car) {
    SensorSystem sensorSystem = car.sensorSystem;
    if (sensorSystem.whiteSensorFrameCount > 0 || sensorSystem.clockWiseRotationFrameCounter < 0)
      return 0;
    return 10001 - sensorSystem.lapTimeInFrames;
  }

  CarController mutateCar(CarController car) {
    var newCar = new CarController(car.hjerne.genes);
    newCar.hjerne.mutate();
    return newCar;
  }

  CarController combineCars(List<CarController> list) {
    return new CarController(list.get(0).hjerne.genes);
  }
}
