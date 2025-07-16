import 'package:fleetgo_drivers/resources/regx/regexp.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> signupFormFields({
  required TextEditingController usernameController,
  required TextEditingController numberController,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required TextEditingController confirmPassController,
  void Function(String)? onUserChange,
}) {
  return [
    {
      'controller': usernameController,
      'hintText': 'User name',
      'keyBoard': TextInputType.name,
      'obscureText': false,
      'validator': (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter User name';
        } else if (!Regexp.userNameExp.hasMatch(value)) {
          return 'Please enter a valid User name';
        }

        return null;
      },
      'prefixIcon': const Icon(Icons.person, size: 15),
      'suffixIcon': null,
      'prefixText': '',
      'onChanged': onUserChange,
    },
    {
      'controller': numberController,
      'hintText': 'Mobile number',
      'keyBoard': TextInputType.phone,
      'obscureText': false,
      'validator': (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Mobile number';
        } else if (!Regexp.phoneExp.hasMatch(value)) {
          return 'Please enter a valid Mobile number';
        }
        return null;
      },
      'prefixIcon': const Icon(Icons.phone_android, size: 15),
      'suffixIcon': null,
      'prefixText': '+91',
      'onChanged': onUserChange
    },
    {
      'controller': emailController,
      'hintText': 'Email address',
      'keyBoard': TextInputType.emailAddress,
      'obscureText': false,
      'validator': (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Email';
        } else if (!Regexp.emailExp.hasMatch(value)) {
          return 'Please enter a valid Email';
        }
        return null;
      },
      'prefixIcon': const Icon(Icons.email, size: 15),
      'suffixIcon': null,
      'prefixText': '',
      'onChanged': onUserChange
    },
    {
      'id': 'signup_password',
      'controller': passwordController,
      'hintText': 'Password',
      'keyBoard': TextInputType.visiblePassword,
      'obscureText': true,
      'validator': (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a Password';
        } else if (!Regexp.digitExp.hasMatch(value)) {
          return 'Your password should contain at least one digit.';
        } else if (!Regexp.lowercaseExp.hasMatch(value)) {
          return 'Your password should contain at least one lowercase letter.';
        } else if (!Regexp.uppercaseExp.hasMatch(value)) {
          return 'Your password should contain at least one uppercase letter.';
        } else if (!Regexp.minimumCharExp.hasMatch(value)) {
          return 'Your password should contain minimum 8 characters';
        }
        return null;
      },
      'prefixIcon': const Icon(Icons.password, size: 15),
      'suffixIcon': const Icon(Icons.visibility_off, size: 15),
      'prefixText': '',
      'onChanged': (value) {}
    },
    {
      'id': 'signup_confirm_password',
      'controller': confirmPassController,
      'hintText': 'Confirm password',
      'keyBoard': TextInputType.visiblePassword,
      'obscureText': true,
      'validator': (value) {
        if (value == null || value.isEmpty) {
          return 'Confirm your password';
        } else if (value != passwordController.text) {
          return 'Passwords should match';
        }
        return null;
      },
      'prefixIcon': const Icon(Icons.password, size: 15),
      'suffixIcon': const Icon(Icons.visibility_off, size: 15),
      'prefixText': '',
      'onChanged': (value) {}
    },
  ];
}
