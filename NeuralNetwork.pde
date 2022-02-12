import java.util.Arrays;
import java.util.List;

class NeuralNetwork {
  
  final float varians = 0.5;
  
  List<Float> genes = new ArrayList<Float>();
  /*
  Weights from input to hidden layer.
  i11=0, i12=1, i13=2
  i21=3, i22=4, i23=5
  i31=6, i32=7, i33=8
  
  Biases in hidden layer.
  bi1=9, bi2=10, bi3=11
  
  Weights from hidden to output layer.
  o11=12, o12=13, o13=14
  o21=15, o22=16, o23=17
  
  Biases in output layer.
  bo1=18, bo2=19
  */
  
  PVector getOutput(float x1, float x2, float x3) {
    //hidden layer
    float h1 = genes.get(0)*x1 + genes.get(1)*x2 + genes.get(2)*x3 + genes.get(9);
    float h2 = genes.get(3)*x1 + genes.get(4)*x2 + genes.get(5)*x3 + genes.get(10);
    float h3 = genes.get(6)*x1 + genes.get(7)*x2 + genes.get(8)*x3 + genes.get(11);
    
    //output layer
    float o1 = genes.get(12)*h1 + genes.get(13)*h2 + genes.get(14)*h3 + genes.get(18);
    float o2 = genes.get(15)*h1 + genes.get(16)*h2 + genes.get(17)*h3 + genes.get(19);
    
    return new PVector(o1, o2);
  }
  
  NeuralNetwork() {
    IntStream.range(0, 20).forEach(a -> genes.add(getRandomGene()));
  }
  
  NeuralNetwork(List<Float> genes) {
    this.genes = new ArrayList<Float>(genes);
  }
  
  float getRandomGene() {
    return random(-varians, varians);
  }
  
  void mutate() {
    genes = genes.stream().map(g -> getMutatedGene(g)).collect(Collectors.toList());
  }
  
  float getMutatedGene(float gene) {
    gene += random(-varians/carSystem.generation, varians/carSystem.generation);
    gene = gene > varians
           ? varians
           : gene < -varians
             ? -varians
             : gene;
    return gene;
  }
  
}
