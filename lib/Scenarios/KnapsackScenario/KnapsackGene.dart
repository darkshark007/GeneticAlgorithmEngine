import "dart:math" show Random;

import 'package:quiver/core.dart';

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

  @override
  bool operator ==(Object g) {
    if (g is KnapsackGene) {
      if (g.evaluate() != evaluate()) return false;
      if (g.sack.capacity != sack.capacity) return false;
      if (g.sack.items.length != sack.items.length) return false;

      // Deep Check items
      List<KnapsackItem> items = []..addAll(sack.items);
      List<KnapsackItem> compareItems = []..addAll(g.sack.items);
      while (items.isNotEmpty) {
        var currentItem = items.first;
        var compareItem = compareItems.firstWhere((KnapsackItem item) => item.size == currentItem.size && item.value == currentItem.value, orElse: () => null);
        if (compareItem == null) return false;
        items.remove(currentItem);
        compareItems.remove(compareItem);
      }
      if (compareItems.isNotEmpty) return false;
      return true;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => sack.hashCode;
}