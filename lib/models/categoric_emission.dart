class CategoricEmission {
  String category;
  double emission;

  CategoricEmission({required this.category, required this.emission});

  void increaseEmission(double amount) {
    emission += amount;
  }
}
