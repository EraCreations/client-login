import 'package:form_field_validator/form_field_validator.dart';

/*
  this constant validators validates password and email in login and registration page
*/
final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(6, errorText: 'Password must be at least\n6 characters')
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: 'Must be valid email'),
]);

final nameValidator = MultiValidator([
  RequiredValidator(errorText: 'Name is required'),
]);
