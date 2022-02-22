import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:slapp/custom_widget/header_post.dart';
import '../model/Member.dart';
import '../model/color_theme.dart';
import '../model/post.dart';
import '../util/constants.dart';
import '../util/date_handler.dart';
import '../util/firebase_handler.dart';
import 'my_gradient.dart';

class PostContent extends StatelessWidget {

  Post post;
  Member? member;

  PostContent({required this.post, required this.member});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
              child: HeaderPost(urlString: member!.imageUrl, onPressed: (){}, member: member, date: DateHandler().myDate(post.date), context: context),
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
                            color: Color.fromRGBO(55, 55, 70, 1)
                        ),
                        child: TextButton(
                          child: Row(children: [
                            (post.likes.contains(FirebaseHandler().authInstance.currentUser!.uid)) ? likeIcon : unlikeIcon,
                            const SizedBox(width: 5,),
                            Text("${post.likes.length}", style: TextStyle(fontSize: 20, color: ColorTheme().textGrey()),)],),
                          onPressed: () {
                            //Follow
                            print("Ajout d'un like'");
                          },
                        ),
                      ),
                      const SizedBox(width: 10,),
                      commentIcon,
                      const SizedBox(width: 5,),
                      Text("${post.comments.length}", style: TextStyle(fontSize: 20, color: ColorTheme().textGrey()),),
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

//Column(
//       children: [
//         Row(
//           children: [
//             HeaderPost(urlString: member!.imageUrl, onPressed: (){}, context: context),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("${member?.surname} ${member?.name}"),
//                 Text(DateHandler().myDate(post.date))
//               ],
//             ),
//           ],
//         ),
//         const Divider(),
//         (post.imageUrl != null && post.imageUrl != "")
//             ? Padding(
//             padding: const EdgeInsets.all(20),
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.85,
//                 height: MediaQuery.of(context).size.width * 0.85,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     image: DecorationImage(
//                         image: CachedNetworkImageProvider(post.imageUrl),
//                         fit: BoxFit.cover
//                     )
//                 ),
//               )
//             )
//             : const SizedBox(height: 0, width: 0,),
//         (post.text != null && post.text != "")
//             ?
//             : const SizedBox(height: 0, width: 0,),
//       ],
//     )