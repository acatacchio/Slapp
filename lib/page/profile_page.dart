import 'package:flutter/material.dart';
import '../model/Member.dart';

class ProfilePage extends StatefulWidget {
  Member? member;

  ProfilePage({Key? key, required this.member}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Text("Profile");
  }
}