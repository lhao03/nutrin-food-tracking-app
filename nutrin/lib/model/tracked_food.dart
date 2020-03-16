class TrackedFood {
  // TODO: could make nutrient class
  final String _name;
  final double _calories;
  final double _protein;
  final double _carbohydrates;
  final double _fat;
  final double _calcium;
  final double _fiber;
  final double _cholesterol;
  final double _iron;
  final double _potassium;
  final double _sodium;
  final double _vitaminA;
  final double _vitaminC;

  TrackedFood(
      this._name,
      this._calories,
      this._protein,
      this._carbohydrates,
      this._fat,
      this._calcium,
      this._fiber,
      this._cholesterol,
      this._iron,
      this._potassium,
      this._sodium,
      this._vitaminA,
      this._vitaminC);

  Map<String, dynamic> toMap() {
    return {
      'name': _name,
      'protein': _protein,
      'fat': _fat,
      'carbohydrates': _carbohydrates,
      'calcium': _calcium,
      'fiber': _fiber,
      'calories': _calories,
      'cholesterol': _cholesterol,
      'iron': _iron,
      'potassium': _potassium,
      'sodium': _sodium,
      'vitaminA': _vitaminA,
      'vitaminC': _vitaminC
    };
  }
}