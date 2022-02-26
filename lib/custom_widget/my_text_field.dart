import 'package:flutter/material.dart';
import 'package:slapp/model/color_theme.dart';

class MyTextField extends TextField{

  MyTextField({Key? key,
    required TextEditingController? controller,
    TextInputType type = TextInputType.text,
    Icon? icon,
    bool obscure = false,
    String? hint = ""
  }):super(key: key,
    controller: controller,
    keyboardType: type,
    obscureText: obscure,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: ColorTheme().textGrey()),
      border: const OutlineInputBorder(),
      icon: icon
    ),
    style: TextStyle(color: ColorTheme().text()),
  );
}