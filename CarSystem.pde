import java.util.stream.IntStream;
import java.util.AbstractMap.SimpleEntry;
import java.util.stream.Collectors;

class CarSystem {
  
  int generation = 1;

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
    CarControllerList = CarControllerList.stream().map(c -> new SimpleEntry<CarController, Integer>(c, scoreCar(c))).sorted((a, b) -> b.getValue() - a.getValue()).map(e -> e.getKey()).collect(Collectors.toList());
    CarControllerList.stream().limit(100).skip(1).forEach(c -> c.display());
  }

  void advanceGeneration() {
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
    car.hjerne.mutateValues(0.1f);
    return car;
  }

  CarController combineCars(List<CarController> list) {
    return new CarController(list.get(0).hjerne);
  }
}
