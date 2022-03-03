import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slapp/page/comment_page.dart';
import '../model/Member.dart';
import '../model/color_theme.dart';
import '../model/inside_notif.dart';
import '../model/post.dart';
import '../page/profile_page.dart';
import '../util/constants.dart';
import '../util/firebase_handler.dart';
import '../util/images.dart';
import 'my_gradient.dart';

class NotifContent extends StatelessWidget {

  Member? me;
  InsideNotif notif;

  NotifContent({required this.notif, required this.me});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseHandler().fire_user.doc(notif.userId).snapshots(),
        builder: (context, snap) {
          if (snap.hasData) {
            Member member = Member(snap.data!);
            return Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 5),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  FirebaseHandler().seenNotif(notif);
                  if (notif.type == follow) {
                    Navigator.push(context, MaterialPageRoute(builder: (build) {
                      return Scaffold(
                        body: ProfilePage(member: member,),
                      );
                    }));
                  } else if (notif.type == comment){
                    notif.aboutRef.get().then((value) {
                      Post post = Post(value);
                      Navigator.push(context, MaterialPageRoute(builder: (build) {
                        return CommentPage(post: post, member: me,);
                      }));
                    });
                  }
                },
                child: Row(
                    children: [
                      Container(
                          height: 40,
                          width: 40,
                          decoration: MyGradient(startColor: ColorTheme().blue(), endColor: ColorTheme().blueGradiant(), diagonal: true, radius: 20),
                          child: Padding(
                            padding: const EdgeInsets.all(2.5),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: ColorTheme().background(),
                                  image: DecorationImage(
                                      image: (member.imageUrl != null && member.imageUrl != "")
                                          ? CachedNetworkImageProvider(member.imageUrl)
                                          : AssetImage(avatar) as ImageProvider, fit: BoxFit.cover
                                  )
                              ),
                            ),
                          )
                      ),
                      const SizedBox(width: 5,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("${member.name} ${member.surname} ", style: TextStyle(color: ColorTheme().text()),),
                              Text(notif.text, style: TextStyle(color: ColorTheme().textGrey()),)
                            ],
                          ),
                          Text(notif.date, style: TextStyle(color: ColorTheme().textGrey()),)
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: 2,
                        height: 40,
                        color: (notif.seen) ? Colors.transparent : ColorTheme().blueGradiant(),
                      ),
                    ]
                ),
              ),
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