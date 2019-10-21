import "dart:math";

import 'package:GeneticAlgorithmEngine/GeneticAlgorithmEngine.dart';
import 'package:GeneticAlgorithmEngine/Scenarios/KnapsackScenario.dart';

main(List<String> arguments) async {
  print('Running Knapsack Scenario Analysis');
  // List<KnapsackItem> items = [
  //   new KnapsackItem(1,1),
  //   new KnapsackItem(2,2),
  //   new KnapsackItem(5,5),
  //   new KnapsackItem(10,1),
  //   new KnapsackItem(1,10),
  //   new KnapsackItem(1,2),
  //   new KnapsackItem(2,1),
  //   new KnapsackItem(1,2),
  //   new KnapsackItem(2,1),
  //   new KnapsackItem(1,2),
  //   new KnapsackItem(2,1),
  //   new KnapsackItem(3,1),
  //   new KnapsackItem(1,3),
  //   new KnapsackItem(4,2),
  //   new KnapsackItem(2,4),
  //   new KnapsackItem(3,4),
  //   new KnapsackItem(4,3),
  //   new KnapsackItem(10,8),
  //   new KnapsackItem(8,10),
  //   new KnapsackItem(10,8),
  //   new KnapsackItem(8,10),
  //   new KnapsackItem(10,8),
  //   new KnapsackItem(8,10),
  //   new KnapsackItem(10,8),
  //   new KnapsackItem(8,10),
  // ];
  // List<KnapsackItem> items = [
  //   new KnapsackItem(23, 505),
  //   new KnapsackItem(26,352),
  //   new KnapsackItem(20,458),
  //   new KnapsackItem(18,220),
  //   new KnapsackItem(32,354),
  //   new KnapsackItem(27,414),
  //   new KnapsackItem(29,498),
  //   new KnapsackItem(26,545),
  //   new KnapsackItem(30,473),
  //   new KnapsackItem(27,543),
  // ];

  List<KnapsackItem> items = generateKnapsackItems(new Random(23), count: 50, maxSize: 40, maxValue: 500);
  items.forEach((KnapsackItem item) {
    print('Item: size: ${item.size}  value: ${item.value}');
  });
  var res = solver1(items, 167);
  print('res: ${res}');
  res = solver2(items, 167);
  print('res2: ${res}');
  res = solver3(items, 167);
  print('res3: ${res}');
  // if (true == true) return;

  Random r = new Random(51);
  KnapsackScenario scen = new KnapsackScenario(r, items, 167, maxIterations: 50);

  GeneticAlgorithmEngine engine = new GeneticAlgorithmEngine(r, scen);

  await engine.run();

  print(engine.currentPopulation.population.length);

  engine.currentPopulation.population.forEach((Gene item) {
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
        print('    >> Item:   size: ${i.size}   value: ${i.value}');
      });
    }
  });
}

List<KnapsackItem> generateKnapsackItems(
  Random r, {
  int count,
  int minSize: 1,
  int maxSize: 10,
  int minValue: 0,
  int maxValue: 10,
}) {
  List<KnapsackItem> list = [];

  var mV = (maxValue-minValue)+1;
  var mV2 = (mV * mV)-1;

  var mS = (maxSize-minSize)+1;
  var mS2 = (mS * mS)-1;
  
  for ( var i = 0; i < count; i++) {
    // Calculate Value
    var tempValue = (mV-sqrt(r.nextInt(mV2))).floor()+minValue;
    var tempSize = sqrt(r.nextInt(mS2)).floor()+minSize;
    list.add(new KnapsackItem(tempSize, tempValue));
  }
  return list;
}

void solver1(List<KnapsackItem> items, int capacity) {

  var v = [];
  var w = [];
  var n = items.length;
  var cW = capacity;
  var m = [];
  // Setup
  v.add(0);
  w.add(0);
  for (var i = 0; i < items.length+2; i++) {
    if (i < items.length) {
      v.add(items[i].value);
      w.add(items[i].size);
    }
    m.add([]);
    m[i] = [];
    for (var i2 = 0; i2 < cW+2; i2++) {
      m[i].add(0);
    }
  }


  for (var j = 0; j <= cW; j++) {
     m[0][j] = 0;
  }
 
  for (var i = 1; i < n; i++ ) {
    for (var j = 0; j <= cW; j++) {
      if (w[i] > j) {
        m[i][j] = m[i-1][j];
      }
      else {
        num v1 = m[i-1][j];
        num v2 = m[i-1][j-w[i]] + v[i];
        m[i][j] = max(v1, v2);
      }
    }
  }
  print(m);
  return m[n-1][cW];

  //   for j from 0 to W do:
  //      m[0, j] := 0
  //  for i from 1 to n do:
  //      for j from 0 to W do:
  //          if w[i] > j then:
  //              m[i, j] := m[i-1, j]
  //          else:
  //              m[i, j] := max(m[i-1, j], m[i-1, j-w[i]] + v[i])
}


int solver2(List<KnapsackItem> items, int capacity) {
  // Input:
  // Values (stored in array v)
  var v = [];
  // Weights (stored in array w)
  var w = [];
  // Number of distinct items (n)
  var n = items.length;
  // Knapsack capacity (W)
  var cW = capacity;
  // NOTE: The array "v" and array "w" are assumed to store all relevant values starting at index 1.

  // Setup
  v.add(0);
  w.add(0);
  for (var i = 0; i < items.length; i++) {
    var currentItem = items[i];
    v.add(currentItem.value);
    w.add(currentItem.size);
  }

  var value = [];
  for (var i = 0; i < items.length+2; i++) {
    value.add([]);
    for (var i2 = 0; i2 < cW+2; i2++) {
      value[i].add(-1);
    }
  }

  int recurseSolve(int i, int j) {
    if (i==0) return 0;
    if (j<0 || j==0 ) return 0;
    if (value[i][j] != -1) return value[i][j];
    num temp_1 = recurseSolve(i-1,j);               //m[i-1, j] has not been calculated, we have to call function m
    num temp_2 = recurseSolve(i-1,j-w[i])+v[i];    //m[i-1,j-w[i]] has not been calculated, we have to call function m
    var backvalue = max(temp_1,temp_2);
    value[i][j] = backvalue;
    return backvalue;
  }
  return recurseSolve(n,cW);

  // // Input:
  // // Values (stored in array v)
  // // Weights (stored in array w)
  // // Number of distinct items (n)
  // // Knapsack capacity (W)
  // // NOTE: The array "v" and array "w" are assumed to store all relevant values starting at index 1.

  // Define value[n, W]

  // Initialize All value[i, j]=-1

  // Define m:=(i,j)         //Define function m so that it represents the maximum value we can get under the condition: use first i items, total weight limit is j
  // {
  //   if i=0 then:
  //     return 0
  //   if j<0 or j=0 then:
  //     return 0
  //   if(value[i-1, j]!=-1) then:     //m[i-1, j] has been calculated and it is stored in value[i-1, j]
  //     temp_1=value[i-1, j]
  //   else
  //     temp_1=m(i-1,j)               //m[i-1, j] has not been calculated, we have to call function m
  //   if(value[i-1,j-w[i]]!=-1) then: //m[i-1,j-w[i]] has been calculated and it is stored in value[i-1,j-w[i]]
  //     temp_2=value[i-1,j-w[i]]+v[i]
  //   else
  //     temp_2=m(i-1,j-w[i])+v[i])    //m[i-1,j-w[i]] has not been calculated, we have to call function m
  //   backvalue=max(temp_1,temp_2)
  //   value[i, j]=backvalue;//If function m is called, then the vlue of m(i,j) will be calculated and in the future there is no need for repeated calculation.So, store it!
  //   return backvalue
  // }

  // Run m(n,W)
}

int solver3(List<KnapsackItem> items, int capacity) {
  var res = -2;
  int recurseSolver(int idx, int sumValue, int sumWeight) {
    if (sumWeight > capacity) return -1;
    if (idx >= items.length) return sumValue;
    var included = recurseSolver(idx+1, sumValue+items[idx].value, sumWeight+items[idx].size);
    var excluded = recurseSolver(idx+1, sumValue, sumWeight);
    if (included == res) print('Solution (${sumValue}/${sumWeight}) includes #${idx} >> s: ${items[idx].size} / v: ${items[idx].value}');
    return max(included, excluded);
  }
  res = recurseSolver(0,0,0);
  print('2nd Iteration');
  return recurseSolver(0,0,0);

}