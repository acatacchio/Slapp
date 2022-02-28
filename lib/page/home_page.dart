import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slapp/custom_widget/header_post.dart';
import 'package:slapp/util/date_handler.dart';
import '../custom_widget/post_content.dart';
import '../model/Member.dart';
import '../model/color_theme.dart';
import '../model/post.dart';
import '../util/constants.dart';
import '../util/firebase_handler.dart';

class HomePage extends StatefulWidget {
  Member? member;

  HomePage({Key? key, required this.member}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomePage> {

  late StreamSubscription streamSubscription;
  List<Member> members = [];
  List<Post> posts = [];

  @override
  void initState() {
    setupStream();
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 40, width: 40,),
              Text("Slapp", style: TextStyle(fontSize: 20, color: ColorTheme().textGrey()),),
              SizedBox(height: 40, width: 40, child: IconButton(
                onPressed: (){
                  print("Ajout de la page notif");
                },
                icon: const Icon(Icons.notifications), color: ColorTheme().textGrey(),)
              )
            ],
          )
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height - 169,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index){
              Post post = posts[index];
              Member member = members.singleWhere((element) => element.uid == post.memberId);
              if(posts.length - 1 == index){
                return PostContent(post: post, member: member, last: true);
              } else {
                return PostContent(post: post, member: member);
              }
            },
            itemCount: posts.length,
          ),
        ),
      ],
    );
  }

  setupStream() {
    streamSubscription = FirebaseHandler().fire_user.where(followersKey, arrayContains: widget.member!.uid).snapshots().listen((event) {
      getMembers(event.docs);
      event.docs.forEach((docs) {
        docs.reference.collection("post").snapshots().listen((newPost) {
          posts = getPost(newPost.docs);
        });
      });
    });
  }

  getMembers(List<DocumentSnapshot> membersDoc) {
    List<Member> membersLists = members;
    membersDoc.forEach((memberSnapShot) {
      Member newMember = Member(memberSnapShot);
      if (membersLists.every((element) => element.uid != newMember.uid)) {
        membersLists.add(newMember);
      } else {
        Member toBeUpdated = membersLists.singleWhere((element) => element.uid == newMember.uid);
        membersLists.remove(toBeUpdated);
        membersLists.add(toBeUpdated);
      }
    });
    setState(() {
      members = membersLists;
    });
  }

  List<Post> getPost(List<DocumentSnapshot> snaps) {
    List<Post> newList = posts;
    snaps.forEach((element) {
      Post newPost = Post(element);
      listenToPost(newPost);
      if (newList.every((post) => post.documentId != newPost.documentId)){
        newList.add(newPost);
      } else {
        Post toBeUpdated = newList.singleWhere((existing) => existing.documentId == newPost.documentId);
        newList.remove(toBeUpdated);
        newList.add(toBeUpdated);
      }
    });
    newList.sort((a, b) => b.date.compareTo(a.date));
    return newList;
  }

  listenToPost(Post post){
    post.ref.snapshots().listen((changes) {
      Post postToChange = posts.singleWhere((element) => element.documentId == post.documentId);
      posts.remove(postToChange);
      posts.add(post);
      posts.sort((a, b) => b.date.compareTo(a.date));
      setState(() {});
    });
  }
}