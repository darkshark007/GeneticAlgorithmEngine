import "dart:math" show Random;

import "../../GeneticAlgorithmEngine.dart";
import "Knapsack.dart";
import "KnapsackGene.dart" show KnapsackGene;




class KnapsackScenario extends Scenario {

  List<KnapsackItem> itemsList;
  int capacity;

  KnapsackScenario(Random r, this.itemsList, this.capacity) : super(r) {
    initializationTasks = [
      Ops.repeat(Conditions.thisManyTimes(25), 
        Ops.generateNewGene(this.generateGene, 
        Ops.addToPopulation())),
      Ops.repeat(Conditions.thisManyTimes(5), 
        Ops.generateNewGene(this.generateGene, 
        Ops.addToPopulation())),
      Ops.repeat(Conditions.thisManyTimes(5), 
        Ops.generateNewGene(this.generateGene, 
        Ops.addToPopulation())),
      Ops.repeat(Conditions.thisManyTimes(5), 
        Ops.generateNewGene(this.generateGene, 
        Ops.addToPopulation())),
      Ops.repeat(Conditions.untilPopulationSizeIncreasesTo(100), 
        Ops.generateNewGene(this.generateGene, Ops.addToPopulation()))
    ];
    iterationTasks = [
      Ops.sortByValue(
        Ops.getTop(150, Ops.addToPopulation())),
      Ops.sortByValue(
        Ops.getTop(250, 
        Ops.repeat(Conditions.thisManyTimes(20), 
          Ops.randomlySelect(2, r, 
          Ops.recombinate(r, this.recombinate, 
          Ops.addToPopulation()))))),
      Ops.repeat(Conditions.thisManyTimes(100),
        Ops.generateNewGene(this.generateGene, Ops.addToPopulation())),
    ];
    completionTasks = [
      Ops.addToPopulation(),
      // Ops.sortByValue(Ops.getTop(10, Ops.setAsPopulation())),
      // Ops.repeat(Conditions.thisManyTimes(5), 
      //   Ops.generateNewGene(this.generateGene, Ops.addToPopulation())),
    ];

    iterationConditional = Conditions.thisManyTimes(500);
  }

  KnapsackGene generateGene() {
    print('Generating Gene!');
    var sack = new Knapsack(this.capacity);

    int maxLoops = 10;
    int idx = 0;
    do {
      idx++;
      KnapsackItem tempItem = itemsList[random.nextInt(itemsList.length)];
      if (sack.items.contains(tempItem)) {
        continue;
      }
      if (sack.size() + tempItem.size > sack.capacity) {
        continue;
      }
      idx = 0;
      sack.items.add(tempItem);
    } while (idx < maxLoops);
    return new KnapsackGene(sack);
  }

  @override
  KnapsackGene recombinate(Random random, List<Gene> genes) {

    Set<KnapsackItem> itemSet = new Set();

    genes.forEach((Gene g) {
      if (g is KnapsackGene) {
        itemSet.addAll(g.sack.items);
      }
    });

    var itemList = itemSet.toList();

    print('Recombinating Gene!');
    var sack = new Knapsack(this.capacity);

    int maxLoops = 10;
    int idx = 0;
    do {
      idx++;
      KnapsackItem tempItem = itemList[random.nextInt(itemList.length)];
      if (sack.items.contains(tempItem)) {
        continue;
      }
      if (sack.size() + tempItem.size > sack.capacity) {
        continue;
      }
      idx = 0;
      sack.items.add(tempItem);
    } while (idx < maxLoops);
    return new KnapsackGene(sack);
  }
}



