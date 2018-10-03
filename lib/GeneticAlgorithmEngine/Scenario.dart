import 'dart:math' show Random;
import 'dart:async';

import 'package:GeneticAlgorithmEngine/GeneticAlgorithmEngine.dart';

abstract class Scenario {

  Random random;

  List<TaskOperation> initializationTasks;
  List<TaskOperation> iterationTasks;
  List<TaskOperation> completionTasks;


  Scenario(this.random);

  TaskConditional iterationConditional = (_) => true;

  Future willPerformIteration(GeneticAlgorithmEngineController controller) async { }

  Future didPerformIteration(GeneticAlgorithmEngineController controller) async { }

  Gene recombinate(Random random, List<Gene> genes);
}

typedef GeneGenerator = Gene Function();
typedef GeneRecombinator = Gene Function(Random random, List<Gene> gene);