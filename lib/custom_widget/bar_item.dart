import 'package:flutter/material.dart';
import '../model/color_theme.dart';

class BarItem extends IconButton {
  BarItem({
    Key? key,
    required Icon icon,
    required VoidCallback onPressed,
    required bool selected,
    required BuildContext context
  }):super(key: key,
    icon: icon,
    onPressed: onPressed,
    color: selected ? ColorTheme().text() : ColorTheme().textGrey(),
  );
}