import 'package:eduapp/login/controller/signController.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

final signCont = Get.find<SignController>();

class CnfPwdValidator extends TextFieldValidator {
  CnfPwdValidator({required String errorText}) : super(errorText);

  @override
  bool isValid(String? value) => hasMatch(signCont.supPwd1, signCont.supPwd2);
}

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
  // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
  //     errorText: 'Passwords must have at least one special character')
]);

final cnfpasswordValidator = MultiValidator([
  CnfPwdValidator(errorText: 'Please enter the same password'),
  RequiredValidator(errorText: 'This field is required'),
]);

final signInPwdValidator = MultiValidator([
  RequiredValidator(errorText: 'This field is required'),
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: "Enter a valid email.")
]);
final usernameValidator = MultiValidator([
  RequiredValidator(errorText: 'Username is required'),
]);
final requiredField = MultiValidator([
  RequiredValidator(errorText: 'Username is required'),
]);
