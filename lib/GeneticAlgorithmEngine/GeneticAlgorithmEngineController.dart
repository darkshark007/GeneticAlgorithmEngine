import 'package:GeneticAlgorithmEngine/GeneticAlgorithmEngine.dart';

class GeneticAlgorithmEngineController {

  GeneticAlgorithmEngine _engine;

  GeneticAlgorithmEngineController(GeneticAlgorithmEngine eng) : _engine = eng { 

  }

  List<Gene> get population => _engine.currentPopulation;
  List<Gene> get newPopulation => _engine.newPopulation;

  void addGene(Gene toAdd) {
    _engine.newPopulation.add(toAdd);
  }

  void removeGene(Gene toRemove) {
    _engine.newPopulation.remove(toRemove);
  }

  void setPopulation(List<Gene> toSet) {
    _engine.newPopulation = toSet;
  }

  void recombinate(List<Gene> parents, Gene newGene) {
    // TODO: Implement
  }
}