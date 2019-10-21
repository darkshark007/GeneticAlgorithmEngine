import 'dart:math' show Random;

import 'package:GeneticAlgorithmEngine/GeneticAlgorithmEngine.dart';

class Population<T extends Gene> {

  List<T> population = [];

  Population _copyPopulation() {
    var newPop = new Population();
    newPop.population.addAll(population);
    return newPop;
  }

  Population appendAll(Population input) {
    var newPop = _copyPopulation();
    newPop.population.addAll(input.population);
    return newPop;
  }

  Population removeAll(Population input) {
    var newPop = _copyPopulation();
    input.population.forEach((Gene item) => newPop.population.remove(item));
    return newPop;
  }

  Population removeDuplicates() {
    var newPop = _copyPopulation();
    var returnPop = new Population();

    while (newPop.population.isNotEmpty) {
      var currentItem = newPop.population.first;
      returnPop.population.add(currentItem);
      newPop.population.removeWhere((Gene a) => a == currentItem);
    }
    return returnPop;
  }

  Population sortByEvaluation() {
    var newPop = _copyPopulation();
    newPop.population.sort((Gene a, Gene b) {
      if (a.evaluate() < b.evaluate()) return 1;
      if (a.evaluate() > b.evaluate()) return -1;
      return 0;
    });
    return newPop;
  }

  Population getTop(int n) {
    var copyPop = _copyPopulation();
    var newPop = new Population();
    if (n <= 0) {
      return newPop;
    }

    var idx = n;
    while (copyPop.population.isNotEmpty && idx > 0) {
      newPop.population.add(copyPop.population.first);
      copyPop.population.remove(copyPop.population.first);
      idx--;
    }
    return newPop;
  }

  Population getBottom(int n) {
    var copyPop = _copyPopulation();
    var newPop = new Population();
    if (n <= 0) {
      return newPop;
    }

    var idx = n;
    while (copyPop.population.isNotEmpty && idx > 0) {
      newPop.population.add(copyPop.population.last);
      copyPop.population.remove(copyPop.population.last);
      idx--;
    }
    return newPop;
  }

  Population randomlySelect(int n, Random r) {
    var copyPop = _copyPopulation();
    var newPop = new Population();

    if (n <= 0) {
      return newPop;
    }

    var idx = n;
    while (copyPop.population.isNotEmpty && idx > 0) {
      var tempItem = copyPop.population[r.nextInt(copyPop.population.length)];
      newPop.population.add(tempItem);
      copyPop.population.remove(tempItem);
      idx--;
    }
    return newPop;
  }
}