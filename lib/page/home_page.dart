import 'package:flutter/material.dart';
import '../model/Member.dart';

class HomePage extends StatefulWidget {
  Member? member;

  HomePage({Key? key, required this.member}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Text("home");
  }
}