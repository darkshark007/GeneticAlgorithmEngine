import "dart:async";
import "dart:math";

import "package:GeneticAlgorithmEngine/GeneticAlgorithmEngine.dart";

class GeneticAlgorithmEngine {

  Random random;
  Scenario scenario;
  GeneticAlgorithmEngineController controller;
  List<Gene> currentPopulation = [];
  List<Gene> newPopulation = [];
  List<List<Gene>> iterations = [];


  GeneticAlgorithmEngine(this.random, this.scenario) {
    controller = new GeneticAlgorithmEngineController(this);
  }

  Future run() async {
    // Init
    newPopulation = [];
    currentPopulation = [];
    scenario.initializationTasks.forEach((TaskOperation task) {
      task(controller, controller.population);
    });
    print("Finished Initialization");
    rollIteration();

    // Loop
    while (!scenario.iterationConditional(controller)) {

      print('Iteration  cp: ${currentPopulation.length}  np: ${newPopulation.length}');
      

      await scenario.willPerformIteration(controller);

      scenario.iterationTasks.forEach((TaskOperation task) {
        task(controller, controller.population);
      });
      rollIteration();

      await scenario.didPerformIteration(controller);
    }

    // Clean up
    scenario.completionTasks.forEach((TaskOperation task) {
      task(controller, controller.population);
    });
    rollIteration();

  }

  void rollIteration() {
    currentPopulation = newPopulation;
    iterations.add(currentPopulation);
    newPopulation = [];
  }

}