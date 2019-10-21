import "dart:async";
import "dart:math";

import "package:GeneticAlgorithmEngine/GeneticAlgorithmEngine.dart";

class GeneticAlgorithmEngine {

  Random random;
  Scenario scenario;
  GeneticAlgorithmEngineController controller;
  Population currentPopulation = new Population();
  Population newPopulation = new Population();
  List<Population> iterations = [];


  GeneticAlgorithmEngine(this.random, this.scenario) {
    controller = new GeneticAlgorithmEngineController(this);
  }

  Future run() async {
    // Init
    newPopulation = new Population();
    currentPopulation = new Population();
    print("Initializing...");
    if (scenario.initializationTasks != null) {
      scenario.initializationTasks(controller);
    }
    print("Finished Initialization");
    rollIteration();

    // Loop
    while (scenario.shouldIterate(controller)) {

      // print('Iteration #${iterations.length}\n  cp: ${currentPopulation.population.length}\n  np: ${newPopulation.population.length}');

      await scenario.willPerformIteration(controller);

      if (scenario.iterationTasks != null) {
        scenario.iterationTasks(controller);
      }
      rollIteration();

      await scenario.didPerformIteration(controller);
    }

    // Clean up
    if (scenario.completionTasks != null) {
      scenario.completionTasks(controller);
    }
    rollIteration();
  }

  void rollIteration() {
    currentPopulation = newPopulation;
    iterations.add(currentPopulation);
    newPopulation = new Population();
  }

}