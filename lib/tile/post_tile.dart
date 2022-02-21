import 'package:flutter/material.dart';
import 'package:slapp/model/alert_helper.dart';
import 'package:slapp/model/color_theme.dart';
import 'package:slapp/util/date_handler.dart';
import 'package:slapp/util/firebase_handler.dart';
import '../custom_widget/post_content.dart';
import '../model/Member.dart';
import '../model/post.dart';

class PostTile extends StatelessWidget {

  Post post;
  Member? member;
  bool isDetail;

  PostTile({required this.post, required this.member, this.isDetail = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){

      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                PostContent(post: post, member: member),
                const Divider(),
              ],
            ),
          ),
        ),
      )
    );
  }
}