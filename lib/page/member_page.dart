import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slapp/controller/main_controller.dart';
import 'package:slapp/custom_widget/my_gradient.dart';
import 'package:slapp/page/profile_page.dart';
import '../model/Member.dart';
import '../model/color_theme.dart';
import '../util/firebase_handler.dart';
import '../util/images.dart';

class MemberPage extends StatefulWidget {
  Member? member;

  MemberPage({Key? key, required this.member}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MemberState();
}

class MemberState extends State<MemberPage> {

  @override
  Widget build(BuildContext context) {
    String myId = FirebaseHandler().authInstance.currentUser!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseHandler().fire_user.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index){
                    Member member = Member(snapshot.data!.docs[index]);
                    if(member.uid != myId){
                      return Column(
                        children: [
                          InkWell(
                            onTap: (){
                              final route = MaterialPageRoute(builder: (_) => ProfilePage(member: member,));
                              Navigator.push(context, route);
                            },
                            child: Row(
                              children: [
                                Container(
                                    width: 42,
                                    height: 42,
                                    decoration: MyGradient(startColor: ColorTheme().blue(), endColor: ColorTheme().blueGradiant(), diagonal: true, radius: 21),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          image: DecorationImage(
                                              image: (member.imageUrl != null && member.imageUrl != "")
                                                  ? CachedNetworkImageProvider(member.imageUrl)
                                                  : AssetImage(avatar) as ImageProvider , fit: BoxFit.cover
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                                const SizedBox(width: 10,),
                                Text("${member.name} ${member.surname}"),
                                const Spacer(),
                                TextButton(
                                  onPressed: (){
                                    FirebaseHandler().addOrRemoveFollow(member);
                                  },
                                  child: Text((member.followers!.contains(myId) ? "Ne plus suivre" : "Suivre")),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 8,),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                  itemCount: snapshot.data!.docs.length,
                )
            ),
          );
        } else {
          return const Center(child: Text("Aucun utilisateur sur l'app"),);
        }
      }
    );
  }
}