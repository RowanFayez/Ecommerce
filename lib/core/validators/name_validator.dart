import 'app_validator.dart';
import 'app_reg_exp.dart';

class NameValidator extends AppValidator {
  NameValidator({String? initValue}) : super(initValue: initValue);

  @override
  List<String> check() {
    List<String> errors = [];

    if (value.isEmpty) {
      errors.add('Name is required');
      return errors;
    }

    if (value.length < 2) {
      errors.add('Name must be at least 2 characters long');
    }

    if (value.length > 50) {
      errors.add('Name is too long');
    }

    if (AppRegExp.numbers.hasMatch(value)) {
      errors.add('Name cannot contain numbers');
    }

    if (AppRegExp.specialCharacters.hasMatch(value)) {
      errors.add('Name cannot contain special characters');
    }

    return errors;
  }
}
