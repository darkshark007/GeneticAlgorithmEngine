import 'dart:math' show Random;

import "package:GeneticAlgorithmEngine/GeneticAlgorithmEngine.dart";


typedef TaskConditional = bool Function(GeneticAlgorithmEngineController controller);
typedef TaskOperation = void Function(GeneticAlgorithmEngineController controller, List<Gene> population);

class Ops {

  /// ==========================================================================
  /// Reducers and Filters
  /// ==========================================================================
  static TaskOperation sortByValue(TaskOperation operation) {
    void func(GeneticAlgorithmEngineController controller, List<Gene> population) {
      // Copy the list
      List<Gene> copiedPopulation = [];
      copiedPopulation.insertAll(0, population);

      // Sort them
      copiedPopulation.sort((Gene a, Gene b) {
        if (a.evaluate() == b.evaluate()) return 0;
        if (a.evaluate() > b.evaluate()) return 1;
        else return -1;
      });

      operation(controller, copiedPopulation);
    }
    return func;
  }

  static TaskOperation getTop(int n, TaskOperation operation) {
    void func(GeneticAlgorithmEngineController controller, List<Gene> population) {
      // Copy the list
      List<Gene> copiedPopulation = [];
      copiedPopulation.insertAll(0, population);

      var idx = n;
      List<Gene> newPopulation = [];
      while (copiedPopulation.isNotEmpty && idx > 0) {
        idx--;
        newPopulation.add(copiedPopulation.removeLast());
      }

      operation(controller, newPopulation);
    }
    return func;
  }

  static TaskOperation getBottom(int n, TaskOperation operation) {
    void func(GeneticAlgorithmEngineController controller, List<Gene> population) {
      // Copy the list
      List<Gene> copiedPopulation = [];
      copiedPopulation.insertAll(0, population);
      
      var idx = n;
      List<Gene> newPopulation = [];
      while (copiedPopulation.isNotEmpty && idx > 0) {
        idx--;
        newPopulation.add(copiedPopulation.first);
        copiedPopulation.remove(copiedPopulation.first);
      }

      operation(controller, newPopulation);
    }
    return func;
  }

  static TaskOperation randomlySelect(int n, Random r, TaskOperation operation) {
    void func(GeneticAlgorithmEngineController controller, List<Gene> population) {
      List<Gene> newPopulation = [];

      while (newPopulation.length < n) {
        Gene tempGene = population[r.nextInt(population.length)];
        if (newPopulation.contains(tempGene)) {
          continue;
        }
        newPopulation.add(tempGene);
      }

      operation(controller, newPopulation);
    }
    return func;
  }

  /// ==========================================================================
  /// Operators
  /// ==========================================================================
  static TaskOperation generateNewGene(GeneGenerator generator, TaskOperation operation) {
    void func(GeneticAlgorithmEngineController controller, List<Gene> population) {
      Gene newGene = generator();
      operation(controller, [newGene]);
    }
    return func;
  }

  static TaskOperation setAsPopulation() {
    void func(GeneticAlgorithmEngineController controller, List<Gene> population) {
      controller.setPopulation(population);
    }
    return func;
  }

  static TaskOperation addToPopulation() {
    void func(GeneticAlgorithmEngineController controller, List<Gene> population) {
      population.forEach((Gene g) => controller.addGene(g));
    }
    return func;
  }

  static TaskOperation removeFromPopulation() {
    void func(GeneticAlgorithmEngineController controller, List<Gene> population) {
      population.forEach((Gene g) => controller.removeGene(g));
    }
    return func;
  }

  static TaskOperation repeat(TaskConditional conditional, TaskOperation operation) {
    void func(GeneticAlgorithmEngineController controller, List<Gene> population) {
      while (!conditional(controller)) {
        operation(controller, population);
      }
    }
    return func;
  }

  static TaskOperation recombinate(Random r, GeneRecombinator recombinator, TaskOperation operation) {
    void func(GeneticAlgorithmEngineController controller, List<Gene> population) {
      Gene newGene = recombinator(r, population);
      controller.recombinate(population, newGene);
    }
    return func;
  }
}


class Conditions {

  static TaskConditional untilPopulationSizeIncreasesTo(int n) {
    bool func(GeneticAlgorithmEngineController controller) {
      if (controller.newPopulation.length >= n) { 
        return true;
      }
      return false;
    }
    return func;
  }

  static TaskConditional untilPopulationSizeDecreasesTo(int n) {
    bool func(GeneticAlgorithmEngineController controller) {
      if (controller.newPopulation.length <= n) { 
        return true;
      }
      return false;
    }
    return func;
  }

  static TaskConditional thisManyTimes(int n) {
    int iteratorIdx = 0;
    bool func(GeneticAlgorithmEngineController controller) {
      if (iteratorIdx == n) {
        iteratorIdx = 0;
        return true;
      }
      iteratorIdx++;
      return false;
    }
    return func;
  }

}

