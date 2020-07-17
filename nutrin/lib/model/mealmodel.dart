import 'package:mobileapp/model/tracked_food.dart';

class MealModel {
  final String mealName;
  List<TrackedFood> foods;

  MealModel(
    this.mealName,
    this.foods,
  );

  double calculateCarbs() {
    double trackedCarbs = 0.0;
    for (TrackedFood food in foods) {
      trackedCarbs += food.toMap().containsKey('carbohydrates')
          ? food.toMap()['carbohydrates']
          : 0;
    }
    return trackedCarbs;
  }

  double calculateProtein() {
    double trackedProtein = 0.0;
    for (TrackedFood food in foods) {
      trackedProtein +=
          food.toMap().containsKey('protein') ? food.toMap()['protein'] : 0;
    }
    return trackedProtein;
  }

  double calculateFat() {
    double trackedFat = 0.0;
    for (TrackedFood food in foods) {
      trackedFat += food.toMap().containsKey('fat') ? food.toMap()['fat'] : 0;
    }
    return trackedFat;
  }

  double calculateCalories() {
    return ((calculateCarbs() + calculateProtein()) * 4) + (calculateFat() * 9);
  }

  void deleteFoodItem(String foodName) {
    foods.where((element) => element.name != foodName);
  }

  void addFoodItem(TrackedFood food) {
    foods.add(food);
  }
}