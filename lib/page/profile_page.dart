import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slapp/controller/main_controller.dart';
import 'package:slapp/model/color_theme.dart';
import 'package:slapp/page/personal_fil.dart';
import 'package:slapp/util/firebase_handler.dart';
import '../custom_widget/my_gradient.dart';
import '../model/Member.dart';
import '../model/alert_helper.dart';
import '../model/post.dart';
import '../util/images.dart';

class ProfilePage extends StatefulWidget {
  Member? member;

  ProfilePage({Key? key, required this.member}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {

  late bool isMe;

  @override
  void initState() {
    final authId = FirebaseHandler().authInstance.currentUser!.uid;
    isMe = (authId == widget.member!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseHandler().postFrom(widget.member?.uid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
        if (snapshots.hasData) {
          return Center(
            child: Column(
              children: [
                appBar(widget.member),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          const Spacer(),
                          follow(widget.member?.followers!.length, "Followers", CrossAxisAlignment.end),
                          const SizedBox(width: 15,),
                          profileImage(widget.member!.imageUrl),
                          const SizedBox(width: 15,),
                          follow(widget.member?.following!.length, "Following", CrossAxisAlignment.start),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Text("${widget.member?.name} ${widget.member?.surname}", style: TextStyle(color: ColorTheme().text()),),
                      const SizedBox(height: 15,),
                      Text(widget.member?.description ?? "Aucune description", style: TextStyle(color: ColorTheme().textGrey()),),
                      const SizedBox(height: 15,),
                      Container(
                        child: (!isMe) ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2.2,
                                decoration: MyGradient(
                                  startColor: ColorTheme().blue(),
                                  endColor: ColorTheme().blueGradiant(),
                                  radius: 25,
                                  diagonal: true,
                                ),
                                child: TextButton(
                                  child: Text("Follow"),
                                  onPressed: () {
                                    //Follow
                                    print("Ajout de la personne au followers");
                                  },
                                ),
                              ),
                            ),
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2.2,
                                decoration: BoxDecoration(
                                  color: ColorTheme().card(),
                                  borderRadius: BorderRadius.circular(25),
                                  border:  Border.all(width: 0, color: ColorTheme().card()),
                                ),
                                child: TextButton(
                                  child: const Text("Message"),
                                  onPressed: () {
                                    //Vers message
                                    print("Aller dans les messages");
                                  },
                                ),
                              ),
                            ),
                          ],
                        ):null,
                      ),
                      const SizedBox(height: 15,),
                      Divider(color: ColorTheme().textGrey(),),
                      SizedBox(height: 300, child: posts(snapshots.data?.docs),)
                    ],
                  ),
                )
              ],
            )
          );
        } else {
          return const Center(
            child: Text("Aucun post pour l'instant"),
          );
        }
      },
    );
  }

  Container appBar(member){
    return Container(
      child: (isMe)
      ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 40, width: 40,),
          Text("${member.name} ${member.surname}", style: TextStyle(fontSize: 20, color: ColorTheme().textGrey()),),
          SizedBox(height: 40, width: 40, child: IconButton(onPressed: (() => AlertHelper().disconnect(context)), icon: const Icon(Icons.settings), color: ColorTheme().textGrey(),),)
        ],
      )
      : Text("${member.name} ${member.surname}", style: TextStyle(fontSize: 20, color: ColorTheme().textGrey()),),
    );
  }

  InkWell follow(nb, libelle, align){
    return InkWell(
      onTap: (){
        if (libelle == "Following") {
          print("Liste des personnes suivie");
        } else if (libelle == "Followers") {
          print("Liste des followers");
        }
      },
      child: Column(
        crossAxisAlignment: align,
          children: [
            Text("$nb", style: TextStyle(fontSize: 25, color: ColorTheme().text()),),
            const SizedBox(height: 5,),
            Text("$libelle", style: TextStyle(fontSize: 15, color: ColorTheme().textGrey()),)
          ]
      ),
    );
  }

  Container profileImage(urlString) {
    return Container(
        height: 100,
        width: 100,
        decoration: MyGradient(startColor: ColorTheme().blueGradiant(), endColor: ColorTheme().blue(), diagonal: true, radius: 35),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(35)),
              color: ColorTheme().background(),
            ),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(35)),
                child: Image(image: (urlString != null && urlString != "")
                    ? CachedNetworkImageProvider(urlString)
                    : AssetImage(avatar) as ImageProvider, fit: BoxFit.cover,)
            ),
          )
        )
      );
  }

  GridView posts(List<QueryDocumentSnapshot>? snapshots){
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (BuildContext context, int index){
        return Padding(
          padding: const EdgeInsets.all(1),
          child: InkWell(
              onTap: (){
                final route = MaterialPageRoute(builder: (_) => PersonalFil(snapshots: snapshots, member: widget.member));
                Navigator.push(context, route);
              },
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(Post(snapshots![index]).imageUrl),
                        fit: BoxFit.cover
                    )
                ),
              ),
            )
        );
      },
      itemCount: snapshots!.length,
    );
  }
}