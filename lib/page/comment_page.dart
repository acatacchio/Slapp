import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../custom_widget/my_gradient.dart';
import '../custom_widget/my_text_field.dart';
import '../model/Member.dart';
import '../model/color_theme.dart';
import '../model/generic_method.dart';
import '../model/member_comment.dart';
import '../model/post.dart';
import '../util/constants.dart';
import '../util/date_handler.dart';
import '../util/firebase_handler.dart';
import '../util/images.dart';

class CommentPage extends StatefulWidget {

  Post post;
  Member? member;

  CommentPage({Key? key, required this.post, required this.member}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CommentPageState();

}

class CommentPageState extends State<CommentPage>{

  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorTheme().background(),
        appBar: AppBar(
          title: const Text("Commentaires"),
          backgroundColor: ColorTheme().background(),
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: (){
                  GenericMethod().hideKeyboard(context);
                },
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                        children: [
                          description(),
                          commentsList(),
                          input()
                        ],
                    )
                ),
            ),
          )
    );
  }

  description(){
    String date = DateHandler().myDate(widget.post.date);
    return Column(
      children: [
        Divider(color: ColorTheme().textGrey(),),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 40,
                width: 40,
                decoration: MyGradient(startColor: ColorTheme().blue(), endColor: ColorTheme().blueGradiant(), diagonal: true, radius: 20),
                child: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: ColorTheme().background(),
                        image: DecorationImage(
                            image: (widget.member!.imageUrl != null && widget.member!.imageUrl != "")
                                ? CachedNetworkImageProvider(widget.member!.imageUrl)
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
                Text("${widget.member!.name} ${widget.member!.surname}", style: TextStyle(color: ColorTheme().text()),),
                Text(date, style: TextStyle(color: ColorTheme().textGrey()),)
              ],
            ),
            const SizedBox(width: 5,),
            Text(widget.post.text, style: TextStyle(color: ColorTheme().textGrey(), fontSize: 15),),
          ],
        ),
        Divider(color: ColorTheme().textGrey(),)
      ],
    );
  }

  commentsList(){
    return StreamBuilder<DocumentSnapshot>(
      stream: widget.post.ref.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snaps) {
        List<MemberComment> comments = [];
        if (snaps.data != null) {
          final datas = snaps.data!.data() as Map<String, dynamic>;
          final commentsSnap = datas[commentKey];
          commentsSnap.forEach((s) {
            comments.add(MemberComment((s)));
          });
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height - 280,
          child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                MemberComment comment = comments[index];
                return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseHandler().fire_user.doc(comment.memberId).snapshots(),
                    builder: (context, snap) {
                      if (snap.hasData){
                        Member member = Member(snap.data!);
                        return commentsCard(member: member, comment: comment);
                      } else {
                        return const SizedBox(height: 0, width: 0,);
                      }
                    });
              }
          ),
        );
      },
    );
  }

  commentsCard({required Member member, required MemberComment comment}){
    return SizedBox(
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
                    borderRadius: BorderRadius.circular(50),
                    color: ColorTheme().background(),
                    image: DecorationImage(
                        image: (member.imageUrl != null && member.imageUrl != "")
                            ? CachedNetworkImageProvider(member.imageUrl)
                            : AssetImage(avatar) as ImageProvider, fit: BoxFit.cover
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Row(
                    children: [
                      Text("${member.name} ${member.surname}", style: TextStyle(color: ColorTheme().text()),),
                      const Spacer(),
                      Text(comment.date, style: TextStyle(color: ColorTheme().text()),),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width - 55,
                ),
                Text(comment.text, style: TextStyle(color: ColorTheme().textGrey()),)
              ],
            )
          ],
        ),
      );
  }

  input(){
    return Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 84,
            child: MyTextField(controller: _controller, hint: "Ajouter un commentaire ...",),
          ),
          TextButton(
              onPressed: (){
                if (_controller.text != null && _controller.text != "") {
                  FirebaseHandler().addComment(widget.post, _controller.text);
                  _controller.text = "";
                }
              },
              child: Icon(Icons.send, color: ColorTheme().blueGradiant(), size: 30,)
          )
        ],
    );
  }
}