import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../custom_widget/notif_content.dart';
import '../model/Member.dart';
import '../model/color_theme.dart';
import '../model/inside_notif.dart';
import '../util/firebase_handler.dart';

class NotifPage extends StatefulWidget {
  Member? member;

  NotifPage({Key? key, required this.member}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NotifState();
}

class NotifState extends State<NotifPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme().background(),
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: ColorTheme().background(),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseHandler().fire_notif.doc(FirebaseHandler().authInstance.currentUser!.uid).collection("InsideNotif").snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              final datas = snapshot.data!.docs;
              List<InsideNotif> notifs = [];
              for (var notif in datas) {
                notifs.add(InsideNotif(notif));
              }
              notifs.sort((a, b) => b.date.compareTo(a.date));
              return ListView.builder(
                  itemBuilder: (ctx, index){
                    return NotifContent(notif: notifs[index], me: widget.member);
                  },
                  itemCount: notifs.length
              );
            }else {
              return const Center(child: Text("Aucune notif"),);
            }
          }),
    );
  }
}