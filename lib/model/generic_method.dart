import 'package:flutter/material.dart';

class GenericMethod {
  hideKeyboard(context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}