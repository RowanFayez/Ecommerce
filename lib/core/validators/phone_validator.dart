import 'app_validator.dart';
import 'app_reg_exp.dart';

class PhoneValidator extends AppValidator {
  PhoneValidator({String? initValue}) : super(initValue: initValue);

  @override
  List<String> check() {
    List<String> errors = [];

    if (value.isEmpty) {
      errors.add('Phone number is required');
      return errors;
    }

    // Remove any non-digit characters for validation
    String cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanPhone.length < 10) {
      errors.add('Phone number must be at least 10 digits');
    }

    if (cleanPhone.length > 15) {
      errors.add('Phone number is too long');
    }

    if (!RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(value)) {
      errors.add('Please enter a valid phone number');
    }

    return errors;
  }
}
