import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:slapp/custom_widget/header_post.dart';
import 'package:slapp/page/comment_page.dart';
import 'package:slapp/page/profile_page.dart';
import '../model/Member.dart';
import '../model/color_theme.dart';
import '../model/post.dart';
import '../util/constants.dart';
import '../util/date_handler.dart';
import '../util/firebase_handler.dart';

class PostContent extends StatelessWidget {

  Post post;
  Member? member;
  bool last;

  PostContent({required this.post, required this.member, this.last = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (last) ? const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 40) : const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: ColorTheme().card(),
          borderRadius: BorderRadius.circular(25)
        ),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            SizedBox(
              width: MediaQuery.of(context).size.width *0.85,
              child: HeaderPost(urlString: member!.imageUrl, onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage(member: member, redirect: true,)));}, member: member, date: DateHandler().myDate(post.date), context: context),
            ),
            const SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                     image: DecorationImage(
                         image: CachedNetworkImageProvider(post.imageUrl),
                         fit: BoxFit.cover
                    )
                 ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: MediaQuery.of(context).size.width *0.85,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color.fromRGBO(55, 55, 70, 1)
                        ),
                        child: TextButton(
                          child: Row(children: [
                            (post.likes.contains(FirebaseHandler().authInstance.currentUser!.uid)) ? likeIcon : unlikeIcon,
                            const SizedBox(width: 5,),
                            Text("${post.likes.length}", style: TextStyle(fontSize: 20, color: ColorTheme().textGrey()),)],),
                          onPressed: () {
                            FirebaseHandler().addOrRemoveLike(post, FirebaseHandler().authInstance.currentUser!.uid);
                          },
                        ),
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        height: 35,
                        child: TextButton(
                          child: Row(children: [
                            commentIcon,
                            const SizedBox(width: 5,),
                            Text("${post.comments.length}", style: TextStyle(fontSize: 20, color: ColorTheme().textGrey()),)],),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => CommentPage(post: post, member: member,)));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("${member!.name} ${member!.surname}", style: TextStyle(color: ColorTheme().text(), fontSize: 15),),
                      const SizedBox(width: 5,),
                      Text(post.text, style: TextStyle(color: ColorTheme().textGrey(), fontSize: 15),),
                    ],
                  ),
                ],
              )
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}