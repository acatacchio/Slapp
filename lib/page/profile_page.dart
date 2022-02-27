import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slapp/model/color_theme.dart';
import 'package:slapp/page/personal_fil.dart';
import 'package:slapp/util/firebase_handler.dart';
import '../custom_widget/my_gradient.dart';
import '../model/Member.dart';
import '../model/alert_helper.dart';
import '../model/post.dart';
import '../util/constants.dart';
import '../util/images.dart';

class ProfilePage extends StatefulWidget {
  Member? member;

  ProfilePage({Key? key, required this.member}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {

  late bool isMe;
  bool edit = false;
  TextEditingController? _name;
  TextEditingController? _surname;
  TextEditingController? _description;

  @override
  void initState() {
    final authId = FirebaseHandler().authInstance.currentUser!.uid;
    isMe = (authId == widget.member!.uid);
    _name = TextEditingController();
    _surname = TextEditingController();
    _description = TextEditingController();
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
                      InkWell(
                        onTap: (edit)
                            ? () => updateUser()
                            : () => {},
                        child: Row(
                          children: [
                            const Spacer(),
                            (edit) ? Icon(Icons.check_box_outline_blank, color: ColorTheme().background(), size: 15,) : const Spacer(),
                            Text("${widget.member?.name} ${widget.member?.surname} ", style: TextStyle(color: ColorTheme().text()),),
                            (edit) ? Icon(Icons.border_color, color: ColorTheme().text(), size: 15) : const Spacer(),
                            const Spacer()
                          ],
                        ),
                      ),
                      const SizedBox(height: 15,),
                      InkWell(
                        onTap: (edit)
                            ? () => updateUser()
                            : () => {},
                        child: Row(
                          children: [
                            const Spacer(),
                            (edit) ? Icon(Icons.check_box_outline_blank, color: ColorTheme().background(), size: 15,) : const Spacer(),
                            Text(widget.member?.description ?? "Aucune description ", style: TextStyle(color: ColorTheme().textGrey()),),
                            (edit) ? Icon(Icons.border_color, color: ColorTheme().textGrey(), size: 15,) : const Spacer(),
                            const Spacer()
                          ],
                        ),
                      ),
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
                                  child: const Text("Follow"),
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
          (edit)
          ? const SizedBox(height: 40, width: 40,)
          : SizedBox(height: 40, width: 40, child: IconButton(onPressed: (){editPage();}, icon: const Icon(Icons.settings), color: ColorTheme().textGrey(),),),
          Text("${member.name} ${member.surname}", style: TextStyle(fontSize: 20, color: ColorTheme().textGrey()),),
          (edit)
          ? SizedBox(height: 40, width: 40, child: IconButton(onPressed: (){saveEdit();}, icon: const Icon(Icons.check), color: ColorTheme().textGrey(),),)
          : SizedBox(height: 40, width: 40, child: IconButton(onPressed: (){AlertHelper().disconnect(context);}, icon: const Icon(Icons.power_settings_new_rounded), color: ColorTheme().textGrey(),),)
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

  InkWell profileImage(urlString) {
    return InkWell(
      onTap: (edit)
      ? () => takePicture()
      : () => {},
      child: Container(
          height: 100,
          width: 100,
          decoration: MyGradient(startColor: ColorTheme().blueGradiant(), endColor: ColorTheme().blue(), diagonal: true, radius: 35),
          child: Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(35)),
                  color: ColorTheme().background(),
                  image: DecorationImage(
                    image: (urlString != null && urlString != "")
                        ? CachedNetworkImageProvider(urlString)
                        : AssetImage(avatar) as ImageProvider, fit: BoxFit.cover,),
                  ),
                  child: (edit)
                  ? Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                        color: Color.fromRGBO(0, 0, 0, 0.5)
                    ),
                    child: Icon(Icons.add_a_photo_outlined, color: ColorTheme().text(),),
                  ) : null
                ),
              )
          )
      );
  }

  GridView posts(List<QueryDocumentSnapshot>? snapshots){
    List<QueryDocumentSnapshot> listPosts = [];
    snapshots?.forEach((element) {
      if(element[showPost] == true) {
        listPosts.add(element);
      }
    });
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (BuildContext context, int index){
        return RotationTransition(
          turns: (edit) ? const AlwaysStoppedAnimation(2 / 360) : const AlwaysStoppedAnimation(0 / 360),
          child: Padding(
              padding: (edit) ? const EdgeInsets.only(left: 2, right: 2, top: 1, bottom: 1) : const EdgeInsets.all(1),
              child: InkWell(
                onTap: (){
                  if (!edit){
                    final route = MaterialPageRoute(builder: (_) => PersonalFil(snapshots: listPosts, member: widget.member));
                    Navigator.push(context, route);
                  } else {
                    AlertHelper().deletePost(context, snapshots![index].id);
                  }
                },
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: (edit) ? BorderRadius.circular(10) : BorderRadius.circular(0),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(Post(listPosts[index]).imageUrl),
                            fit: BoxFit.cover
                        )
                    ),
                    child: (edit) ? Padding(padding: const EdgeInsets.all(2), child: Column(children: [const Spacer(), Row(children: const [Spacer(), Icon(Icons.delete_forever_rounded, color: Colors.redAccent,),],)],),) : null
                ),
              )
          ),
        );
      },
      itemCount: listPosts.length,
    );
  }

  saveEdit(){
    setState(() {
      edit = false;
    });
  }

  editPage(){
      setState(() {
        edit = true;
      });
  }

  updateUser() {
    if (isMe) {
      AlertHelper().changeUser(
          context,
          member: widget.member,
          name: _name,
          surname: _surname,
          description: _description
      );
    }
  }

  takePicture(){
    if (isMe) {
      showModalBottomSheet(context: context, builder: (BuildContext ctx) {
        return Container(
          color: Colors.transparent,
          child: Card(
            elevation: 7,
            margin: const EdgeInsets.all(15),
            child: Container(
              color: ColorTheme().background(),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Modifier la photo de profil"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(onPressed: (() => picker(ImageSource.camera)), icon: cameraIcon),
                      IconButton(onPressed: (() => picker(ImageSource.gallery)), icon: libraryIcon)
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
    }
  }

  picker(ImageSource source) async {
    final f = await ImagePicker().pickImage(source: source, maxWidth: 500, maxHeight: 500);
    final File file = File(f!.path);
    FirebaseHandler().modifyPicture(file);
  }
}