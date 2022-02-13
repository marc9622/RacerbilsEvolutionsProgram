import java.util.Random;
import java.util.stream.IntStream;

public static class NeuralNetwork {

    private static Random random = new Random();

    public double range;
    private Layer[] layers;

    /**
     * Creates a new Neural network where each given integer is a new layer with an amount of nodes equal to that integer.
     * @param layerSizes the node size of each layer.
     */
    public NeuralNetwork(int... layerSizes) {
        if(layerSizes.length <= 1)
            throw new IllegalArgumentException("The amount was " + layerSizes.length + " but has to be greater than 1");
        layers = initializeLayers(layerSizes);
    }

    /**
     * Creates a new Neural network where each given integer is a new layer with an amount of nodes equal to that integer.
     * @param range the max value for the weights and biases will be equal to range,
     *          and the min value will be equal to negative range.
     * @param layerSizes the node size of each layer.
     */
    public NeuralNetwork(double range, int... layerSizes) {
        if(layerSizes.length <= 1)
            throw new IllegalArgumentException("The amount was " + layerSizes.length + " but has to be greater than 1");
        layers = initializeLayers(range, layerSizes);
        this.range = range;
    }

    /**
     * Creates a neural network which is identical to the given neural network in terms of weight and bias values.
     * @param neuralNetwork the neural network to be cloned.
     */
    public NeuralNetwork(NeuralNetwork neuralNetwork) {
        int[] layerSizes = new int[neuralNetwork.layers.length + 1];
        layerSizes[0] = neuralNetwork.layers[0].nodes[0].weights.length;
        for(int i = 1; i < layerSizes.length; i++) {
            layerSizes[i] = neuralNetwork.layers[i - 1].nodes.length;
        }
        layers = initializeLayers(layerSizes);
        for(int i = 0; i < neuralNetwork.layers.length; i++) {
            for(int j = 0; j < neuralNetwork.layers[i].nodes.length; j++) {
                for(int k = 0; k < neuralNetwork.layers[i].nodes[j].weights.length; k++) {
                    layers[i].nodes[j].weights[k] = neuralNetwork.layers[i].nodes[j].weights[k];
                }
                layers[i].nodes[j].bias = neuralNetwork.layers[i].nodes[j].bias;
            }
        }
        range = neuralNetwork.range;
    }

    /**
     * @param sizes the node size of each layer.
     * @return an array of layers that matches the given integer array of layer sizes.
     *         The values of all weights and biases are set to zero.
     */
    private static Layer[] initializeLayers(int[] sizes) {
        return IntStream.range(1, sizes.length).mapToObj(i -> new NeuralNetwork.Layer(sizes[i], sizes[i - 1])).toArray(Layer[]::new);
    }

    /**
     * @param sizes the node size of each layer.
     * @param range the max value for the weights and biases will be equal to range,
     *          and the min value will be equal to negative min.
     * @return an array of layers that matches the given integer array of layer sizes.
     *         The values of all weights and biases are set to a random value from negative range to positive range.
     */
    private static Layer[] initializeLayers(double range, int[] sizes) {
        return IntStream.range(1, sizes.length).mapToObj(i -> new NeuralNetwork.Layer(range, sizes[i], sizes[i - 1])).toArray(Layer[]::new);
    }

    /**
     * Uses the given inputs and runs them through the neural network and returns the result.
     */
    public double[] getOutput(double... input) {
        return NeuralNetwork.getOutput(input, this);
    }

    /**
     * Uses the given inputs and runs them through the given neural network and returns the result.
     */
    public static double[] getOutput(double[] input, NeuralNetwork neuralNetwork) {
        for(Layer layer : neuralNetwork.layers) {
            input = calculateLayer(input, layer);
        }
        return input;
    }

    /**
     * Uses the given inputs and runs them through a single layer of the neural network.
     */
    private static double[] calculateLayer(double[] input, Layer layer) {
        if(input.length != layer.nodes[0].weights.length)
            throw new IllegalArgumentException("The given input length " + input.length + " needs to be equal to the amount of weights " + layer.nodes[0].weights.length + " for each node in the layer");
        double[] outputArray = new double[layer.nodes.length];
        for(int i = 0; i < layer.nodes.length; i++) {
            double tempValue = 0;
            for(int j = 0; j < input.length; j++) {
                tempValue += layer.nodes[i].weights[j] * input[j];
            }
            outputArray[i] = tempValue + layer.nodes[i].bias;
        }
        return outputArray;
    }

    /**
     * Sets alle wrights and biases within the neural network to random values from negative range to positive range.
     */
    public void setRandomValues() {
        NeuralNetwork.setRandomValues(range, this);
    }

    /**
     * Sets all weights and biases within the given neural network to random values from negative range to positive range.
     */
    public static void setRandomValues(double range, NeuralNetwork neuralNetwork) {
        for(Layer layer : neuralNetwork.layers) {
            for(Layer.Node node : layer.nodes) {
                node.setRandomValues(range);
            }
        }
    }

    /**
     * Adds a random value between negative variation and positive variation
     * to all weights and biases within the given neural.
     * Values will never be above positive variation or below negative variation.
     */
    public void mutateValues(double variation) {
        NeuralNetwork.mutateValues(range, variation, layers);
    }

    /**
     * Adds a random value between negative variation and positive variation
     * to all weights and biases within the given neural.
     * Values will never be above positive variation or below negative variation.
     */
    public static void mutateValues(double range, double variation, Layer[] layers) {
        for(Layer layer : layers) {
            for(Layer.Node node : layer.nodes) {
                node.mutateValues(range, variation);
            }
        }
    }

    /**
     * Returns a neural network where the amount of layers and nodes as well as all the weights and biases matches the neural network.
     */
    public NeuralNetwork clone() {
        return NeuralNetwork.clone(this);
    }

    /**
     * Returns a neural network where the amount of layers and nodes as well as all the weights and biases matches the given neural network.
     */
    public static NeuralNetwork clone(NeuralNetwork neuralNetwork) {
        return new NeuralNetwork(neuralNetwork);
    }

    /**
     * A class representation of a layer of nodes within a neural network.
     */
    private static class Layer {

        public Node[] nodes;

        public Layer(int nodeSize, int weightSize) {
            nodes = new Node[nodeSize];
            for(int i = 0; i < nodeSize; i++) {
                nodes[i] = new Node(weightSize);
            }
        }

        public Layer(double range, int nodeSize, int weightSize) {
            nodes = new Node[nodeSize];
            for(int i = 0; i < nodeSize; i++) {
                nodes[i] = new Node(range, weightSize);
            }
        }

        /**
         * A class representation of a node with weights and a bias.
         */
        public class Node{

            public double[] weights; //Equal to the amount of nodes in the next layer.
            public double bias;

            public Node(int weightSize) {
                weights = new double[weightSize];
            }

            public Node(double range, int weightSize) {
                weights = new double[weightSize];
                setRandomValues(range);
            }

            public void setRandomValues(double range) {
                for(int i = 0; i < weights.length; i++) {
                    weights[i] = getRandomValue(range);
                }
                bias = getRandomValue(range);
            }

            public void mutateValues(double range, double variation) {
                for(int i = 0; i < weights.length; i++) {
                    weights[i] += getRandomValue(variation);
                    if(weights[i] >  range) weights[i] =  range;
                    if(weights[i] < -range) weights[i] = -range;
                }
                bias += getRandomValue(variation);
                if(bias >  range) bias =  range;
                if(bias < -range) bias = -range;
            }

            private double getRandomValue(double range) {
                double temp = random.nextDouble() % range;
                return random.nextBoolean() ? temp : - temp;
            }

        }

    }

}
