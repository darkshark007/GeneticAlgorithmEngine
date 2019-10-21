import 'dart:math' show Random;

abstract class Gene {

  List<Gene> parents;

  double evaluate();

  void mutate(Random random);

  List<Gene> crossover(List<Gene> g) {
  	List<Gene> result = this.performCrossover(g);
  	List<Gene> parents = [].addAll(g).add(this);
  	for (Gene child in result) {
  		child.parents = parents;
  	}
  	return result;
  }

  List<Gene> performCrossover(List<Gene> g);
}