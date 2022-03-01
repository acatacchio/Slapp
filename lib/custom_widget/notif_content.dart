import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttersocial/custom_widget/profile_image.dart';
import 'package:fluttersocial/model/color_theme.dart';
import 'package:fluttersocial/model/inside_notif.dart';
import 'package:fluttersocial/page/detail_page.dart';
import 'package:fluttersocial/page/profile_page.dart';
import 'package:fluttersocial/util/firebase_handler.dart';
import '../model/Member.dart';
import '../model/post.dart';
import '../util/constants.dart';

class NotifTile extends StatelessWidget {

  InsideNotif notif;

  NotifTile({required this.notif});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseHandler().fire_user.doc(notif.userId).snapshots(),
        builder: (context, snap) {
          if (snap.hasData) {
            Member member = Member(snap.data!);
            return InkWell(
              onTap: () {
                FirebaseHandler().seenNotif(notif);
                if (notif.type == follow) {
                  Navigator.push(context, MaterialPageRoute(builder: (build) {
                    return Scaffold(
                      body: ProfilePage(member: member,),
                    );
                  }));
                } else {
                  notif.aboutRef.get().then((value) {
                    Post post = Post(value);
                    Navigator.push(context, MaterialPageRoute(builder: (build) {
                      return DetailPage(post: post, member: member);
                    }));
                  });
                }
              },
              child: Container(
                color: (notif.seen) ? Colors.transparent : ColorTheme().accent(context),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              ProfileImage(urlString: member.imageUrl, onPressed: (){}, context: context),
                              colorText("${member.surname} ${ member.name}", context)
                            ],
                          ),
                          colorText(notif.date, context)
                        ]
                    ),
                    Center(child: colorText(notif.text, context),)
                  ],
                ),
              )
            );
          } else {
            return const Center(child: Text("Aucune données"),);
          }
        }
    );
  }

  Text colorText(String text, context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black
      ),
    );
  }
}