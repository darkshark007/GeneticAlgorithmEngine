import 'dart:math' show Random;

import 'package:GeneticAlgorithmEngine/GeneticAlgorithmEngine.dart';

class GeneticAlgorithmEngineController {

  GeneticAlgorithmEngine _engine;

  GeneticAlgorithmEngineController(GeneticAlgorithmEngine eng) : _engine = eng { 

  }

  Population get population => _engine.currentPopulation;
  Population get newPopulation => _engine.newPopulation;
  Random get random => _engine.random;

  void addToPopulation(Population toAdd) {
    _engine.newPopulation = _engine.newPopulation.appendAll(toAdd);
  }

  void removeFromPopulation(Population toRemove) {
    _engine.newPopulation = _engine.newPopulation.removeAll(toRemove);
  }

  void setPopulation(Population toSet) {
    _engine.newPopulation = toSet;
  }

  void recombinate(Population parents, Population newGenes) {
    // TODO: Implement parent markup
    _engine.newPopulation = _engine.newPopulation.appendAll(newGenes);
  }
}