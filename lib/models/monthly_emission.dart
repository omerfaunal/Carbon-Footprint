class MonthlyEmission {
  DateTime month;
  double emission;

  MonthlyEmission({required this.month, required this.emission});

  void increaseEmission(double amount) {
    emission += amount;
  }
}
