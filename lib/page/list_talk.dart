import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slapp/page/chat_page.dart';
import '../custom_widget/my_gradient.dart';
import '../model/Member.dart';
import '../model/color_theme.dart';
import '../model/talk.dart';
import '../util/firebase_handler.dart';
import '../util/images.dart';

class ListTalk extends StatefulWidget {

  Member? member;

  ListTalk({Key? key, required this.member}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ListTalkState();

}

class ListTalkState extends State<ListTalk>{

  String myId = FirebaseHandler().authInstance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme().background(),
      appBar: AppBar(
        title: const Text("Conversations"),
        backgroundColor: ColorTheme().background(),
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("member").doc(widget.member!.uid).snapshots(),
        builder: (BuildContext context, snaps) {
          if(snaps.hasData){
            return ListView.builder(
              itemBuilder: (BuildContext ctx, int index) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: talkContent(getIdChat(widget.member!.uid, Member(snaps.data!).talks?[index]), Member(snaps.data!).talks?[index], index),
                );
              },
              itemCount: Member(snaps.data!).talks?.length,
            );
          } else {
            return const SizedBox();
          }
        },
      )
    );
  }

  talkContent(idGroup, String? peerUid, int index){
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("chat").doc(idGroup).collection("talk").snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            List<Talk> talks = [];
            snapshot.data!.docs.forEach((talk) {
              talks.add(Talk(talk));
            });
            talks.sort((a, b) => b.date.compareTo(a.date));
            return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection("member").doc(peerUid).snapshots(),
                builder: (BuildContext context, snapshot) {
                  if(snapshot.hasData){
                    Member peer = Member(snapshot.data!);
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(peer: peer,)));
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
                                      borderRadius: BorderRadius.circular(20),
                                      color: ColorTheme().background(),
                                      image: DecorationImage(
                                          image: (peer.imageUrl != null && peer.imageUrl != "")
                                              ? CachedNetworkImageProvider(peer.imageUrl)
                                              : AssetImage(avatar) as ImageProvider, fit: BoxFit.cover
                                      )
                                  ),
                                ),
                              )
                          ),
                          const SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${peer.name!} ${peer.surname!}", style: TextStyle(color: ColorTheme().text(), fontSize: 16),),
                                    Text(talks[0].date, style: TextStyle(color: ColorTheme().textGrey(),),)
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  (talks[0].userId == widget.member!.uid) ? Text("Vous : ", style: TextStyle(color: ColorTheme().textGrey(),),) : Text("${peer.name!} : ", style: TextStyle(color: ColorTheme().textGrey(),),),
                                  Text(talks[0].text, style: TextStyle(color: ColorTheme().textGrey(),),)
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }
            );
          } else {
            return const SizedBox();
          }
        }
    );
  }

  getIdChat(String? memberUid, String? peerUid){
    if (memberUid.hashCode <= peerUid.hashCode) {
      return "$memberUid-$peerUid";
    } else {
      return "$peerUid-$memberUid";
    }
  }
}