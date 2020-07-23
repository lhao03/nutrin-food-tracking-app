import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileapp/model/directory.dart';
import 'package:mobileapp/model/mealmodel.dart';
import 'package:mobileapp/model/tracked_food.dart';
import 'package:mobileapp/model/tracker.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // collection reference for tracker
  final CollectionReference trackerCollection =
      Firestore.instance.collection('Tracker');

  // TODO: should use enum
  // TODO: coupled with tracker
  Future createNewUser(String name, bool metric, String sex, double height,
      double weight, int age, double activityLevel, String goal) async {
    String currentDate = DateTime.now().day.toString() +
        "/" +
        DateTime.now().month.toString() +
        "/" +
        DateTime.now().year.toString();
    return await trackerCollection.document(uid).setData({
      'name': name,
      'metric': metric,
      'sex': sex,
      'height': height,
      'weight': weight,
      'age': age,
      'activityLevel': activityLevel,
      'goal': goal,
      'userFoods': [],
      currentDate: [
        {'mealName': 'breakfast', 'foods': []},
        {'mealName': 'lunch', 'foods': []},
        {'mealName': 'dinner', 'foods': []},
      ],
      'personalNutrients': _generateNutrients(
          metric, sex, height, weight, age, activityLevel, goal)
    });
  }

  Future setDefaultMacros(String name, bool metric, String sex, double height,
      double weight, int age, double activityLevel, String goal) async {
    return await trackerCollection.document(uid).setData({
      'personalNutrients': _generateNutrients(
          metric, sex, height, weight, age, activityLevel, goal)
    }, merge: true);
  }

  Future updatePersonalNutrients(Map<String, double> nutrients) async {
    return await trackerCollection
        .document(uid)
        .setData({'personalNutrients': nutrients}, merge: true);
  }

  Future createNewPersonalFood(String name, String carbs, String protein,
      String fat, String serving, String unit) async {
    return await trackerCollection.document(uid).setData({
      'userFoods': [
        {
          'name': name,
          'carbohydrates': carbs,
          'protein': protein,
          'fat': fat,
          'serving': serving,
          'unit': unit,
        }
      ]
    }, merge: true);
  }

  // TODO: edit object then use to map
  // TODO: add foods up (sum total value)
  Future updateMeals(String mealName, List<TrackedFood> foods,
      [String date]) async {
    var currentDate;
    date == null
        ? currentDate = DateTime.now().day.toString() +
            "/" +
            DateTime.now().month.toString() +
            "/" +
            DateTime.now().year.toString()
        : currentDate = date;

    return await trackerCollection.document(uid).setData({
      currentDate: [
        {
          'mealName': mealName,
          'foods': foods.map((food) => food.toMap()).toList(),
        }
      ]
    }, merge: true);
  }

  // get tracker stream
  Stream<Tracker> get tracker {
    return trackerCollection
        .document(uid)
        .snapshots()
        .map(_trackerFromSnapshot);
  }

  // get tracker list from snapshot
  Tracker _trackerFromSnapshot(DocumentSnapshot snapshot) {
    return Tracker(
      snapshot.data['name'],
      snapshot.data['sex'],
      snapshot.data['metric'],
      snapshot.data['height'],
      snapshot.data['weight'],
      snapshot.data['age'],
      snapshot.data['activityLevel'],
      snapshot.data['goal'],
      Map<dynamic, dynamic>.from(snapshot.data['personalNutrients'])
          .map((key, value) => MapEntry(key.toString(), value.toDouble())),
      List<dynamic>.from(snapshot.data['meals'])
          .map(
            (mealJson) => MealModel(
              mealJson['mealName'],
              List<dynamic>.from(mealJson['foods'])
                  .map((foodJson) => TrackedFood(
                        foodJson['name'],
                        // foodJson['calories'].toDouble(),
                        foodJson['protein'],
                        foodJson['carbohydrates'],
                        foodJson['fat'],
                        // foodJson['calcium'].toDouble(),
                        // foodJson['fiber'].toDouble(),
                        // foodJson['cholesterol'].toDouble(),
                        // foodJson['iron'].toDouble(),
                        // foodJson['potassium'].toDouble(),
                        // foodJson['sodium'].toDouble(),
                        // foodJson['vitaminA'].toDouble(),
                        // foodJson['vitaminC'].toDouble(),
                        foodJson['serving'],
                        foodJson['unit'],
                      ))
                  .toList(),
            ),
          )
          .toList(),
      Directory(List<dynamic>.from(snapshot.data['userFoods'])
          .map((foodJson) => TrackedFood(
              foodJson['name'],
              foodJson['protein'],
              foodJson['carbohydrates'],
              foodJson['fat'],
              foodJson['serving'],
              foodJson['unit']))
          .toList()),
    );
  }

  _generateNutrients(bool metric, String sex, double height, double weight,
      int age, double activityLevel, String goal) {
    double calories;
    double carbohydrates;
    double protein;
    double fat;
    if (sex == "F") {
      if (age <= 18) {
        calories = (135.3 -
            (30.8 * age) +
            activityLevel * ((10.0 * weight) + (934 * height)) +
            25);
      } else {
        calories = (354 -
            (6.91 * age) +
            activityLevel * ((9.36 * weight) + (726 * height)));
      }

      if (goal == "lose") {
        calories *= 0.7;
        carbohydrates = calories * 0.45 / 4;
        protein = calories * 0.35 / 4;
        fat = calories * 0.2 / 9;
      } else if (goal == "gain") {
        calories *= 1.25;
        carbohydrates = calories * 0.45 / 4;
        protein = calories * 0.25 / 4;
        fat = calories * 0.3 / 9;
      } else {
        carbohydrates = calories * 0.5 / 4;
        protein = calories * 0.15 / 4;
        fat = calories * 0.35 / 9;
      }
    } else {
      if (age <= 18) {
        calories = (88.5 -
            (61.9 * age) +
            activityLevel * ((26.7 * weight) + (903 * height)) +
            25);
      } else {
        calories = (662 -
            (9.53 * age) +
            activityLevel * ((15.91 * weight) + (539.6 * height)) +
            25);
      }

      if (goal == "lose") {
        calories *= 0.8;
        carbohydrates = calories * 0.45 / 4;
        protein = calories * 0.35 / 4;
        fat = calories * 0.2 / 9;
      } else if (goal == "gain") {
        calories *= 1.35;
        carbohydrates = calories * 0.45 / 4;
        protein = calories * 0.25 / 4;
        fat = calories * 0.3 / 9;
      } else {
        carbohydrates = calories * 0.5 / 4;
        protein = calories * 0.15 / 4;
        fat = calories * 0.35 / 9;
      }
    }

    return {
      'calories': calories,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fat': fat,
      // 'calcium': sex == "F" ? 1200 : 1000,
      // 'iron': sex == "F" ? age <= 50 ? 18 : 8 : age <= 18 ? 11 : 8,
      // 'potassium': 4600,
      // 'sodium': 2300,
      // 'fiber': sex == "F" ? 25 : 40,
      // 'vitaminA': sex == "F" ? 700 : 900,
      // 'vitaminC': sex == "F" ? 75 : 90,
    };
  }
}
