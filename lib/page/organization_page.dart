import 'package:flutter/material.dart';
import '../model/Member.dart';

class OrganizationPage extends StatefulWidget {
  Member? member;

  OrganizationPage({Key? key, required this.member}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OrganizationState();
}

class OrganizationState extends State<OrganizationPage> {

  @override
  Widget build(BuildContext context) {
    return Text("Organization");
  }
}