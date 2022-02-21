import 'package:flutter/material.dart';
import '../model/Member.dart';

class MemberPage extends StatefulWidget {
  Member? member;

  MemberPage({Key? key, required this.member}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MemberState();
}

class MemberState extends State<MemberPage> {

  @override
  Widget build(BuildContext context) {
    return Text("Member");
  }
}