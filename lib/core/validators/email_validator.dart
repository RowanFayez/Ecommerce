import 'app_validator.dart';
import 'app_reg_exp.dart';

class EmailValidator extends AppValidator {
  EmailValidator({String? initValue}) : super(initValue: initValue);

  @override
  List<String> check() {
    List<String> errors = [];

    if (value.isEmpty) {
      errors.add('Email is required');
      return errors;
    }

    // Accept both email format and username format (for Fake Store API compatibility)
    bool isValidEmail = AppRegExp.email.hasMatch(value);
    bool isValidUsername =
        RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value) && value.length >= 3;

    if (!isValidEmail && !isValidUsername) {
      errors.add('Please enter a valid email address or username');
    }

    if (value.length > 100) {
      errors.add('Email is too long');
    }

    return errors;
  }
}
