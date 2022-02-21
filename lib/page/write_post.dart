import 'package:flutter/material.dart';
import 'package:slapp/model/color_theme.dart';
import '../model/Member.dart';

class WritePost extends StatefulWidget {
  String? memberId;

  WritePost({Key? key, required this.memberId}) : super(key: key);
  @override
  State<StatefulWidget> createState() => WriteState();
}

class WriteState extends State<WritePost> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorTheme().card(),
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Text("WritePost"),
            Spacer(),
            Divider(thickness: 12,)
          ],
        ),
      )
    );
  }
}