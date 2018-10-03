import 'dart:math' show Random;

abstract class Gene {

  List<Gene> parents;

  double evaluate();

  void mutate(Random random);

}