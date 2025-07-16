class Regexp {
  Regexp._();
  static RegExp phoneExp = RegExp(r'^[0-9]{10}$');
  static RegExp emailExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static RegExp passwordExp = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );
  static RegExp uppercaseExp = RegExp(r'^(?=.*[A-Z])');
  static RegExp lowercaseExp = RegExp(r'^(?=.*[a-z])');
  static RegExp digitExp = RegExp(r'^(?=.*\d)');
  static RegExp specialCharExp = RegExp(r'^(?=.*[@$!%*?&])');
  static RegExp minimumCharExp = RegExp(r'^[A-Za-z\d@$!%*?&]{8,}$');
  static RegExp userNameExp =
      RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9._]{1,18}[a-zA-Z0-9]$');
}
