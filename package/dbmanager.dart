
library dbmanager;

import 'package:food/food/food.dart';

class DbManager {

  Future<void> createFood() async {

  }

  Future<void> editFood(int id) async {

  }

  Future<Food> getFood() async {
    return throw UnimplementedError();
  }

  Future<void> addFood() async {

  }

}

class Food {

  const Food._({
    required this.name,
    required this.calories,
    required this.carbs,
    required this.proteins,
    required this.fats,
    required this.amount,
    required this.unit,
  });

  int get id => 0;

  final String name;
  final double calories;
  final double carbs;
  final double proteins;
  final double fats;
  final int amount;
  final Unit unit;

}