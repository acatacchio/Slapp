import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slapp/custom_widget/my_text_field.dart';
import 'package:slapp/model/generic_method.dart';
import '../custom_widget/my_gradient.dart';
import '../model/Member.dart';
import '../model/color_theme.dart';
import '../model/talk.dart';
import '../util/firebase_handler.dart';
import '../util/images.dart';

class ChatPage extends StatefulWidget {

  String? memberUid = FirebaseHandler().authInstance.currentUser!.uid;
  Member? peer;

  ChatPage({Key? key, required this.peer}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatState();

}

class ChatState extends State<ChatPage> {

  late TextEditingController _controller;
  bool seenDate = false;

  @override
  void initState() {
    seenDate = false;
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
    String idChat = getIdChat(widget.memberUid, widget.peer!.uid);
    return Scaffold(
      backgroundColor: ColorTheme().background(),
      appBar: AppBar(
        title: Text("${widget.peer!.name} ${widget.peer!.surname}"),
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
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                talk(idChat, widget.memberUid, widget.peer),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width-84,
                      child: MyTextField(controller: _controller, hint: "Envoyer un message ...",),
                    ),
                    TextButton(
                        onPressed: (){
                          FirebaseHandler().sendMessageTo(widget.peer!.uid, widget.memberUid, _controller.text);
                          _controller.text = "";
                        },
                        child: const Icon(Icons.send)
                    )
                  ],
                )
              ],
            ),
          ),
        )
      )
    );
  }

  getIdChat(String? memberUid, String? peerUid){
    if (memberUid.hashCode <= peerUid.hashCode) {
      return "$memberUid-$peerUid";
    } else {
      return "$peerUid-$memberUid";
    }
  }

  talk(idChat, memberUid, peer){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseHandler().fire_chat.doc(idChat).collection("talk").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final datas = snapshot.data!.docs;
          List<Talk> messages = [];
          for (var message in datas) {
            messages.add(Talk(message));
          }
          messages.sort((a, b) => b.intDate.compareTo(a.intDate));
          return SizedBox(
            height: MediaQuery.of(context).size.height-210,
            child: ListView.builder(
              reverse: true,
              itemBuilder: (ctx, index){
                return message(messages[index], messages[index].userId == memberUid, (index == 0));
              },
              itemCount: messages.length
            )
          );
        } else {
          return const Text("Pas de conversation en cous");
        }
      }
    );
  }

  message(Talk message, bool isMe, bool lastMessage) {
    return Column(
      children: [
        Row(
          children: [
            (isMe)
              ? const Spacer()
              : Container(
                height: 30,
                width: 30,
                decoration: MyGradient(startColor: ColorTheme().blue(), endColor: ColorTheme().blueGradiant(), diagonal: true, radius: 15),
                child: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ColorTheme().background(),
                      image: DecorationImage(
                        image: (widget.peer!.imageUrl != null && widget.peer!.imageUrl != "")
                          ? CachedNetworkImageProvider(widget.peer!.imageUrl)
                          : AssetImage(avatar) as ImageProvider, fit: BoxFit.cover
                      )
                    ),
                  ),
                )
              ),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: (isMe) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: (isMe) ? ColorTheme().blueGradiant() : ColorTheme().card()
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: Text(message.text, style: TextStyle(color: ColorTheme().text()),),
                  ),
                ),
                (lastMessage) ? Text(message.date, style: TextStyle(color: ColorTheme().textGrey(), fontSize: 12),) : const SizedBox(),
              ],
            )
          ],
        ),
        const SizedBox(height: 5,)
      ],
    );
  }
}