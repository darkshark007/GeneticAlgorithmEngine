import "dart:math";

import 'package:GeneticAlgorithmEngine/GeneticAlgorithmEngine.dart';
import 'package:GeneticAlgorithmEngine/Scenarios/KnapsackScenario.dart';

main(List<String> arguments) async {
  print('Hello world !');

  Random r = new Random();

  List<KnapsackItem> items = [
    new KnapsackItem(1,1),
    new KnapsackItem(2,2),
    new KnapsackItem(5,5),
    new KnapsackItem(10,1),
    new KnapsackItem(1,10),
    new KnapsackItem(1,2),
    new KnapsackItem(2,1),
    new KnapsackItem(1,2),
    new KnapsackItem(2,1),
    new KnapsackItem(1,2),
    new KnapsackItem(2,1),
    new KnapsackItem(3,1),
    new KnapsackItem(1,3),
    new KnapsackItem(4,2),
    new KnapsackItem(2,4),
    new KnapsackItem(3,4),
    new KnapsackItem(4,3),
    new KnapsackItem(10,8),
    new KnapsackItem(8,10),
    new KnapsackItem(10,8),
    new KnapsackItem(8,10),
    new KnapsackItem(10,8),
    new KnapsackItem(8,10),
    new KnapsackItem(10,8),
    new KnapsackItem(8,10),
  ];

  KnapsackScenario scen = new KnapsackScenario(r, items, 25);

  GeneticAlgorithmEngine engine = new GeneticAlgorithmEngine(r, scen);

  await engine.run();

  print(engine.currentPopulation.length);

  engine.currentPopulation.forEach((Gene item) {
    if (item is KnapsackGene) {
      print('>> Gene:   eval: ${item.evaluate()}   length: ${item.sack.items.length}');
      item.sack.items.sort((KnapsackItem a, KnapsackItem b) {
        if (a.size > b.size) { return 1; }
        if (a.size < b.size) { return -1; }
        if (a.value > b.value) { return 1; }
        if (a.value < b.value) { return -1; }
        return 0;
      });
      item.sack.items.forEach((KnapsackItem i) {
        // print('    >> Item:   size: ${i.size}   value: ${i.value}');
      });
    }
  });
}
