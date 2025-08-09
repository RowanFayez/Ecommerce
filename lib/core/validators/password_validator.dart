import 'app_validator.dart';
import 'app_reg_exp.dart';

class PasswordValidator extends AppValidator {
  PasswordValidator({String? initValue}) : super(initValue: initValue);

  @override
  List<String> check() {
    List<String> errors = [];

    if (value.isEmpty) {
      errors.add('Password is required');
      return errors;
    }

    // More flexible validation for Fake Store API compatibility
    if (value.length < 6) {
      errors.add('Password must be at least 6 characters long');
    }

    // Only require these for new signups, not for existing API credentials
    if (value.length >= 8) {
      if (!AppRegExp.capitalLetter.hasMatch(value)) {
        errors.add('Password must contain at least one capital letter');
      }

      if (!AppRegExp.smallLetter.hasMatch(value)) {
        errors.add('Password must contain at least one small letter');
      }

      if (!AppRegExp.numbers.hasMatch(value)) {
        errors.add('Password must contain at least one number');
      }
    }

    if (AppRegExp.space.hasMatch(value)) {
      errors.add('Password cannot contain spaces');
    }

    return errors;
  }
}
