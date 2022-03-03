import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slapp/util/firebase_handler.dart';
import '../custom_widget/my_gradient.dart';
import '../model/Member.dart';
import '../model/color_theme.dart';
import '../util/images.dart';

class MemberList extends StatefulWidget {

  String title;
  List<dynamic>? members;

  MemberList({Key? key, required this.members, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MemberListState();

}

class MemberListState extends State<MemberList>{

  String myId = FirebaseHandler().authInstance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme().background(),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: ColorTheme().background(),
        elevation: 0,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
              itemCount: widget.members!.length,
              itemBuilder: (BuildContext context, int index){
                String memberUid = widget.members![index];
                return StreamBuilder(
                  stream: FirebaseHandler().fire_user.doc(memberUid).snapshots(),
                  builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if(snapshot.hasData){
                      return memberItem(Member(snapshot.data!), 50);
                    } else {
                      return const SizedBox();
                    }
                  }
                );
              }
        )
      )
    );
  }

  memberItem(Member? member, double imageSize){
    return Column(
      children: [
        Row(
          children: [
            Container(
                height: imageSize,
                width: imageSize,
                decoration: MyGradient(startColor: ColorTheme().blue(), endColor: ColorTheme().blueGradiant(), diagonal: true, radius: imageSize),
                child: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(imageSize),
                        color: ColorTheme().background(),
                        image: DecorationImage(
                            image: (member!.imageUrl != null && member.imageUrl != "")
                                ? CachedNetworkImageProvider(member.imageUrl)
                                : AssetImage(avatar) as ImageProvider, fit: BoxFit.cover
                        )
                    ),
                  ),
                )
            ),
            const SizedBox(width: 5,),
            Text("${member.name} ${member.surname}", style: TextStyle(color: ColorTheme().text()),),
            const Spacer(),
            TextButton(
              onPressed: (){
                FirebaseHandler().addOrRemoveFollow(member);
              },
              child: Text((member.followers != null) ? (member.followers!.contains(myId) ? "Ne plus suivre" : "Suivre") : "Suivre", style: TextStyle(color: (member.followers!.contains(myId)) ? ColorTheme().textGrey() : ColorTheme().blueGradiant()),),
            )
          ],
        ),
        const SizedBox(height: 10,)
      ],
    );
  }

}