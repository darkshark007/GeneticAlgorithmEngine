import "dart:math" show Random;

import "../../GeneticAlgorithmEngine.dart";
import "Knapsack.dart";

class KnapsackGene extends Gene {

  Knapsack sack;
  double _value = null;

  KnapsackGene(this.sack);

  @override
  double evaluate() {
    if (_value == null) {
      _value = sack.value().toDouble();
    }
    return _value;
  }

  @override
  void mutate(Random random) {
    // TODO: IMPLEMENT

  }
}