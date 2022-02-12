import java.util.List;
import java.util.AbstractMap.SimpleEntry;
import java.util.function.Function;
import java.util.function.Supplier;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public static class GeneticAlgorithm<Type> {
    
    public int generationSize, //the object type of the child.
               parentAmount;   //the number of children within each generation.
    public Supplier<Type> childSupplier; //a function that supplies a new random child.
    public Function<Type, Integer> childScorer; //a function that takes a child and returns a mutated variant.
    public Function<Type, Type> childMutater; //a function that takes a child and gives a score to determine its effectiveness,
    //which is used to compare it to other children.
    public Function<List<Type>, Type> childCombiner; //a function that takes a list of children a returns a new child from them.

    private List<Type> currentGeneration;

    public GeneticAlgorithm() {
    }

    /**
     * @param <Type> the object type of the child.
     * @param generationSize the number of children within each generation.
     * @param parentAmount the number of children used as parents for the next generation.
     * @param childSupplier a function that supplies a new random child.
     * @param childMutater a function that takes a child and returns a mutated variant.
     * @param childScorer a function that takes a child and gives a score to determine its effectiveness,
     * which is used to compare it to other children.
     */
    public GeneticAlgorithm(int generationSize, int parentAmount,
                            Supplier<Type> childSupplier, Function<Type, Type> childMutater,
                            Function<Type, Integer> childScorer, Function<List<Type>, Type> childCombiner) {
        this.generationSize = generationSize;
        this.parentAmount = parentAmount;
        this.childSupplier = childSupplier;
        this.childMutater = childMutater;
        this.childScorer = childScorer;
        this.childCombiner = childCombiner;
    }

    public Type       getBestChildAfterGenerations(int generationAmount) {
        currentGeneration = makeGenerations(generationAmount, generationSize, parentAmount, childSupplier, childMutater, childScorer, childCombiner);
        return getBestChild(currentGeneration, childScorer);
    }

    public List<Type> makeGenerations(int generationAmount) {
        currentGeneration = GeneticAlgorithm.makeGenerations(generationAmount, generationSize, parentAmount,
                                                             childSupplier, childMutater, childScorer, childCombiner);
        return currentGeneration;
    }

    public List<Type> makeGenerationsFromGeneration() {
        currentGeneration = GeneticAlgorithm.makeGenerationFromGeneration(currentGeneration, generationSize, parentAmount,
                                                                          childMutater, childScorer, childCombiner);
        return currentGeneration;
    }

    public List<Type> makeGenerationFromSupplier() {
        currentGeneration = GeneticAlgorithm.makeGenerationFromSupplier(generationSize, childSupplier);
        return currentGeneration;
    }

    public List<Type> makeGenerationFromGeneration() {
        currentGeneration = GeneticAlgorithm.makeGenerationFromGeneration(currentGeneration, generationSize, parentAmount,
                                                                          childMutater, childScorer, childCombiner);
        return currentGeneration;
    }

    public List<Type> makeMutatedGeneration() {
        currentGeneration = GeneticAlgorithm.makeMutatedGeneration(currentGeneration, childMutater);
        return currentGeneration;
    }

    public Type       getBestChild() {
        return GeneticAlgorithm.getBestChild(currentGeneration, childScorer);
    }

    public List<Type> getBestChildren(int childrenAmount) {
        return GeneticAlgorithm.getBestChildren(currentGeneration, childrenAmount, childScorer);
    }

    public List<Type> getCurrentGeneration() {
        return currentGeneration;
    }

    /**
     * @param <Type> the object type of the child.
     * @param generationAmount the number of generations to iterate through.
     * @param generationSize the number of children within each generation.
     * @param parentAmount the number of children used as parents for the next generation.
     * @param childSupplier a function that supplies new random children,
     * which is used to make the first generation of children.
     * @param childMutater a function that takes a child and returns a mutated variant.
     * @param childScorer a function that takes a child and gives a score to determine its effectiveness,
     * which is used to compare it to other children.
     * @return the best child after a specified number of generations.
     */
    public static <Type> Type       getBestChildAfterGenerations  (int generationAmount, int generationSize, int parentAmount,
                                                                   Supplier<Type> childSupplier, Function<Type, Type> childMutater,
                                                                   Function<Type, Integer> childScorer, Function<List<Type>, Type> childCombiner) {
        return getBestChild(makeGenerations(generationAmount, generationSize, parentAmount, childSupplier, childMutater, childScorer, childCombiner), childScorer);
    }

    /**
     * @param <Type> the object type of the child.
     * @param generationAmount the number of generations to iterate through.
     * @param generationSize the number of children within each generation.
     * @param parentAmount the number of children used as parents for the next generation.
     * @param childSupplier a function that supplies new random children,
     * which is used to make the first generation of children.
     * @param childMutater a function that takes a child and returns a mutated variant.
     * @param childScorer a function that takes a child and gives a score to determine its effectiveness,
     * which is used to compare it to other children.
     * @return a new generation after a specified number of generations.
     */
    public static <Type> List<Type> makeGenerations               (int generationAmount, int generationSize, int parentAmount,
                                                                   Supplier<Type> childSupplier, Function<Type, Type> childMutater,
                                                                   Function<Type, Integer> childScorer, Function<List<Type>, Type> childCombiner) {
        List<Type> generation = makeGenerationFromSupplier(generationSize, childSupplier);
        generation = makeGenerationsFromGeneration(generation, generationAmount - 1, generation.size(), parentAmount, childMutater, childScorer, childCombiner);
        return generation;
    }

    /**
     * @param <Type> the object type of the child.
     * @param generation the previous generation of which to make the new one.
     * @param generationAmount the number of generations to iterate through.
     * @param generationSize the number of children within each generation.
     * @param parentAmount the number of children used as parents for the next generation.
     * @param childMutater a function that takes a child and returns a mutated variant.
     * @param childScorer a function that takes a child and gives a score to determine its effectiveness,
     * which is used to compare it to other children.
     * @return a new generation from a previous generation after a specified number of generations.
     */
    public static <Type> List<Type> makeGenerationsFromGeneration (List<Type> generation, int generationAmount, int generationSize, int parentAmount,
                                                                   Function<Type, Type> childMutater, Function<Type, Integer> childScorer,
                                                                   Function<List<Type>, Type> childCombiner) {
        for(int i = 0; i < generationAmount; i++)
            generation = makeGenerationFromGeneration(generation, generationSize, parentAmount, childMutater, childScorer, childCombiner);
        return generation;
    }

    /**
     * @param <Type> the object type of the child.
     * @param generationSize the number of children within the generation.
     * @param childSupplier a function that supplies new random children,
     * @return a new generation made from the child supplier.
     */
    public static <Type> List<Type> makeGenerationFromSupplier    (int generationSize, Supplier<Type> childSupplier) {
        return Stream.generate(() -> makeChildFromSupplier(childSupplier))
                     .limit(generationSize)
                     .collect(Collectors.toList());
    }

    /**
     * @param <Type> the object type of the child.
     * @param generation the previous generation of which to make the new one.
     * @param generationSize the number of children within the generation.
     * @param parentAmount the amount of children used as parents for the new generation.
     * @param childMutater a function that takes a child and returns a mutated variant.
     * @param childScorer a function that takes a child and gives a score to determine its effectiveness,
     * which is used to compare it to other children.
     * @return a new generation made from the previous generation.
     */
    public static <Type> List<Type> makeGenerationFromGeneration  (List<Type> generation, int generationSize, int parentAmount,
                                                                   Function<Type, Type> childMutater, Function<Type, Integer> childScorer,
                                                                   Function<List<Type>, Type> childCombiner) {
        return makeGenerationFromParents(getBestChildren(generation, parentAmount, childScorer),
                                         generationSize,
                                         childMutater,
                                         childCombiner);
    }

    /**
     * @param <Type> the object type of the child.
     * @param parents the parents of which to make the generation.
     * @param generationSize the number of children within the generation.
     * @param childMutater a function that takes a child and returns a mutated variant.
     * @param childCombiner a function that takes a list of children a returns a new child from them.
     * @return a mutated generation made from the parents.
     */
    public static <Type> List<Type> makeGenerationFromParents     (List<Type> parents, int generationSize,
                                                                   Function<Type, Type> childMutater, Function<List<Type>, Type> childCombiner) {
        if(generationSize < 1)
            throw new IllegalArgumentException("generationSize was " + generationSize + " but cannot be less than 1.");
        return makeMutatedGeneration(Stream.generate(() ->  makeChildFromParents(parents, childCombiner))
                                           .limit(generationSize)
                                           .collect(Collectors.toList()),
                                     childMutater);
    }
    
    /**
     * @param <Type> the object type of the child.
     * @param childSupplier a function that supplies a new random child.
     * @return a child made with the child supplier.
     */
    public static <Type> Type       makeChildFromSupplier         (Supplier<Type> childSupplier) {
        return childSupplier.get();
    }

    /**
     * @param <Type> the object type of the child.
     * @param parents the parents of which to make the child.
     * @param childCombiner a function that takes a list of children a returns a new child from them.
     * @return a child made from combining the parents.
     */
    public static <Type> Type       makeChildFromParents          (List<Type> parents, Function<List<Type>, Type> childCombiner) {
        return childCombiner.apply(parents);
    }

    /**
     * @param <Type> the object type of the child.
     * @param child the child of which to make the mutated child.
     * @param childMutater a function that takes a child and returns a mutated variant.
     * @return a mutated variant of the child.
     */
    public static <Type> Type       makeMutatedChild              (Type child, Function<Type, Type> childMutater) {
        return childMutater.apply(child);
    }

    /**
     * @param <Type> the object type of the child.
     * @param generation the generation of which to make the mutated generation.
     * @param childMutater a function that takes a child and returns a mutated variant.
     * @return a mutated variation of the generation.
     */
    public static <Type> List<Type> makeMutatedGeneration         (List<Type> generation, Function<Type, Type> childMutater) {
        return generation.stream()
                         .map(i -> childMutater.apply(i))
                         .collect(Collectors.toList());
    }

    /**
     * @param <Type> the object type of the child.
     * @param generation the generation from which to get the best child.
     * @param childScorer a function that takes a child and gives a score to determine its effectiveness,
     * which is used to compare it to other children.
     * @return the best child from the generation.
     */
    public static <Type> Type       getBestChild                  (List<Type> generation, Function<Type, Integer> childScorer) {
        return generation.stream()
                         .map(a -> new SimpleEntry<Type, Integer>(a, childScorer.apply(a)))
                         .max((a, b) -> a.getValue() - b.getValue())
                         .get()
                         .getKey();
    }

    /**
     * @param <Type> the object type of the child.
     * @param generation the generation from which to get the best children.
     * @param childrenAmount the number of children to get.
     * @param childScorer a function that takes a child and gives a score to determine its effectiveness,
     * which is used to compare it to other children.
     * @return the best children from the generation.
     */
    public static <Type> List<Type> getBestChildren               (List<Type> generation, int childrenAmount, Function<Type, Integer> childScorer) {
        if(childrenAmount < 1)
            throw new IllegalArgumentException("childrenAmount was " + childrenAmount + " but cannot be less than 1.");
        if(childrenAmount > generation.size())
            throw new IllegalArgumentException("childrenAmount was " + childrenAmount + " but cannot be larger than generationSize which was " + generation.size() + ".");
        return generation.stream()
                         .map(a -> new SimpleEntry<Type, Integer>(a, childScorer.apply(a)))
                         .sorted((a, b) -> b.getValue() - a.getValue()) //Reversed because we want the highest scores first.
                         .limit(childrenAmount)
                         .map(a -> a.getKey())
                         .collect(Collectors.toList());
    }

}
