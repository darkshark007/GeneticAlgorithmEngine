import "dart:math" show Random;

import "../../GeneticAlgorithmEngine.dart";
import "Knapsack.dart";
import "KnapsackGene.dart" show KnapsackGene;




class KnapsackScenario extends Scenario {

  List<KnapsackItem> itemsList;
  int capacity;

  KnapsackScenario(Random r, this.itemsList, this.capacity) : super(r) {
    initializationTasks = initFunc;
    iterationTasks = iterFunc;

    completionTasks = completionFunc;
  }

  var _iterations = 0;
  @override
  bool shouldIterate(GeneticAlgorithmEngineController controller) {
    _iterations++;
    return _iterations <= 50;

  }

  void initFunc(GeneticAlgorithmEngineController controller) {

    // Add 25
    var newPop = new Population();
    for (var i = 0; i < 25; i++) {
      newPop.population.add(this.generateGene());
    }
    controller.addToPopulation(newPop);

    // Add 5
    var newPop2 = new Population();
    for (var i = 0; i < 5; i++) {
      newPop2.population.add(this.generateGene());
    }
    controller.addToPopulation(newPop2);

    // Add until 100
    var newPop3 = new Population();
    while (controller.newPopulation.population.length + newPop3.population.length < 100) {
      newPop3.population.add(this.generateGene());
    }
    controller.addToPopulation(newPop3);

  }

  void iterFunc(GeneticAlgorithmEngineController controller) {

    // Sort
    var sortedPopulation = controller.population.sortByEvaluation();

    // Add top 150
    var topPopulation = sortedPopulation.getTop(150);
    controller.addToPopulation(topPopulation);

    // Add Recombinations
    topPopulation = sortedPopulation.getTop(250);
    for (var i = 0; i < 20; i++) {
      var randPop = topPopulation.randomlySelect(2, random);
      var recomPop = this.recombinate(random, randPop);
      controller.recombinate(randPop, recomPop);
    }

    // Add new genes
    var newPop = new Population();
    for (var i = 0; i < 100; i++) {
      newPop.population.add(this.generateGene());
    }
    controller.addToPopulation(newPop);
  }

  void completionFunc(GeneticAlgorithmEngineController controller) {
    // Propagate population
    controller.addToPopulation(controller.population);
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
  Population recombinate(Random random, Population genes) {

    Set<KnapsackItem> itemSet = new Set();

    genes.population.forEach((Gene g) {
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
    var newPop = new Population();
    newPop.population.add(new KnapsackGene(sack));
    return newPop;
  }
}



