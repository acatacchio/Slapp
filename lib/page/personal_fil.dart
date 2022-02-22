import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slapp/custom_widget/header_post.dart';
import 'package:slapp/custom_widget/post_content.dart';
import 'package:slapp/model/color_theme.dart';
import '../model/Member.dart';
import '../model/post.dart';

class PersonalFil extends StatefulWidget {

  Member? member;
  List<QueryDocumentSnapshot>? snapshots;

  PersonalFil({Key? key, required this.snapshots, required this.member}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PersonalFilState();

}

class PersonalFilState extends State<PersonalFil>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme().background(),
      appBar: AppBar(
        title: Column(
          children: [
            Text("${widget.member!.name} ${widget.member!.surname}", style: TextStyle(color: ColorTheme().textGrey(), fontSize: 15),),
            const Text("Publications")
          ],
        ), 
        backgroundColor: ColorTheme().background(), 
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index){
                  return PostContent(post: Post(widget.snapshots![index]), member: widget.member);
                },
                itemCount: widget.snapshots!.length,
              ),
            ),
          ],
        )
      ),
    );
  }
}