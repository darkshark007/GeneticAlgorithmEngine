import 'dart:math' show Random;
import 'dart:async';

import 'package:GeneticAlgorithmEngine/GeneticAlgorithmEngine.dart';

abstract class Scenario {

  Random random;

  TaskRunner initializationTasks;
  TaskRunner iterationTasks;
  TaskRunner completionTasks;

  Scenario(this.random);

  bool shouldIterate(GeneticAlgorithmEngineController controller) => false;

  Future willPerformIteration(GeneticAlgorithmEngineController controller) async { }

  Future didPerformIteration(GeneticAlgorithmEngineController controller) async { }

  Population recombinate(Random random, Population genes);
}

typedef TaskRunner = void Function(GeneticAlgorithmEngineController controller);