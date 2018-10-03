class Knapsack {
  int capacity;
  List<KnapsackItem> items = new List();

  Knapsack(this.capacity);

  int size() {
    int total = 0;
    items.forEach((item) => total+= item.size);
    return total;
  }

  int value() {
    int total = 0;
    items.forEach((item) => total+= item.value);
    return total;
  }
}

class KnapsackItem {
  int size;
  int value;

  KnapsackItem(this.size, this.value);
}