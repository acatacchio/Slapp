import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:slapp/controller/auth_controller.dart';
import 'package:slapp/model/alert_helper.dart';
import '../model/Member.dart';
import '../model/inside_notif.dart';
import '../model/post.dart';
import 'constants.dart';

class FirebaseHandler {

  //Auth
  final authInstance = FirebaseAuth.instance;

  //Connexion
  Future<User?> signIn(String mail, String pwd, context) async {
    try {
      final userCredential = await authInstance.signInWithEmailAndPassword(
          email: mail,
          password: pwd
      );
      final User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      AlertHelper().showSnackBar(e.message!, context);
    }

  }

  //Création User
  Future<User?> createUser(String mail, String pwd, String name, String surname, String proposer) async {
    final userCredential = await authInstance.createUserWithEmailAndPassword(
        email: mail,
        password: pwd
    );
    final User? user = userCredential.user;
    Map<String, dynamic>memberMap = {
      nameKey: name,
      surnameKey: surname,
      imageUrlKey: "",
      followersKey: [],
      followingKey: [proposer],
      uidKey: user?.uid
    };
    String u = user!.uid;

    //AddUser
    addUserToFirebase(memberMap);
    fire_proposing.doc(proposer).update({"memberSponsor": FieldValue.arrayUnion([user.uid])});
    fire_proposing.doc(user.uid).set({"proposingLink": "${u[0]}${u[1]}${u[2]}${u[3]}${u[4]}${u[5]}${u[6]}${u[7]}${u[8]}${u[9]}${u[10]}"});
    fire_user.doc(proposer).update({followersKey: FieldValue.arrayUnion([user.uid])});
    return user;
  }

  logOut(){
    authInstance.signOut();
  }

  //Database
  static final firestoreInstance = FirebaseFirestore.instance;
  final fire_user = firestoreInstance.collection(memberRef);
  final fire_notif = firestoreInstance.collection("notification");
  final fire_chat = firestoreInstance.collection("chat");
  final fire_proposing = firestoreInstance.collection("proposing");

  //Storage
  static final storageRef = storage.FirebaseStorage.instance.ref();


  addUserToFirebase(Map<String, dynamic> map) {
    fire_user.doc(map[uidKey]).set(map);
  }

  addPostToFirebase(String? memberId, String text, File file) async {
    int date = DateTime.now().millisecondsSinceEpoch.toInt();
    List<dynamic> likes = [];
    List<dynamic> comments = [];
    Map<String, dynamic> map = {
      uidKey: memberId,
      likeKey: likes,
      commentKey: comments,
      dateKey: date,
      showPostKey: true
    };

    if (text != null && text != "") {
      map[textKey] = text;
    }
    if(file != null) {
      final ref = storageRef.child(memberId!).child("post").child(date.toString());
      final urlString = await addImageToStorage(ref, file);
      map[imageUrlKey] = urlString;
      fire_user.doc(memberId).collection("post").doc().set(map);
    } else {
      fire_user.doc(memberId).collection("post").doc().set(map);
    }
  }

  Future<String> addImageToStorage(storage.Reference ref, File file) async {
    storage.UploadTask task = ref.putFile(file);
    storage.TaskSnapshot snapshot = await task.whenComplete(() => null);
    String urlString = await snapshot.ref.getDownloadURL();
    return urlString;
  }

  Stream<QuerySnapshot>? postFrom(String? uid) {
    return fire_user.doc(uid).collection("post").snapshots();
  }

  modifyMember(Map<String, dynamic> map, String? uid) {
    fire_user.doc(uid).update(map);
  }

  modifyPicture(File file) {
    String uid = authInstance.currentUser!.uid;
    final ref = storageRef.child(uid);
    addImageToStorage(ref, file).then((value) {
      Map<String, dynamic> newMap = {imageUrlKey: value};
      modifyMember(newMap, uid);
    });
  }

  deletePost(ref) async {
    String uid = authInstance.currentUser!.uid;
    Map<String, dynamic> newMap = {showPostKey: false};
    fire_user.doc(uid).collection("post").doc(ref).update(newMap);
  }

  addOrRemoveFollow(Member member) {
    String myId = authInstance.currentUser!.uid;
    DocumentReference myRef = fire_user.doc(myId);
    if (member.followers!.contains(myId)){
      member.ref.update({followersKey: FieldValue.arrayRemove([myId])});
      myRef.update({followingKey: FieldValue.arrayRemove([member.uid])});
    } else {
      member.ref.update({followersKey: FieldValue.arrayUnion([myId])});
      myRef.update({followingKey: FieldValue.arrayUnion([member.uid])});
      sendNotifTo(member.uid, authInstance.currentUser!.uid, "vous suit désormais", fire_user.doc(authInstance.currentUser!.uid), follow);
    }
  }

  addOrRemoveLike(Post post, String? memberId) {
    if (post.likes.contains(memberId)) {
      post.ref.update({likeKey: FieldValue.arrayRemove([memberId])});
    } else {
      post.ref.update({likeKey: FieldValue.arrayUnion([memberId])});
      sendNotifTo(post.memberId, authInstance.currentUser!.uid, "a aimé votre post", post.ref, like);
    }
  }

  addComment(Post post, String text){
    Map<String, dynamic> map = {
      uidKey: authInstance.currentUser!.uid,
      dateKey: DateTime.now().millisecondsSinceEpoch,
      textKey: text
    };
    post.ref.update({commentKey: FieldValue.arrayUnion([map])});
    sendNotifTo(post.memberId, authInstance.currentUser!.uid, "a commenté votre post", post.ref, comment);
  }

  sendNotifTo(String? to, String from, String text, DocumentReference ref, String type){
    bool seen = false;
    int date = DateTime.now().millisecondsSinceEpoch;
    Map<String, dynamic> map = {
      seenKey: seen,
      dateKey: date,
      textKey: text,
      refKey: ref,
      typeKey: type,
      uidKey: from
    };
    fire_notif.doc(to).collection("InsideNotif").add(map);
  }

  seenNotif(InsideNotif notif) {
    notif.reference.update({seenKey: true});
  }

  sendMessageTo(String? to, String? from, String text) {
    if (text != null && text != "") {
      bool seen = false;
      int date = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> map = {
        seenKey: seen,
        dateKey: date,
        textKey: text,
        uidKey: from
      };

      fire_chat.doc(getIdChat(from, to)).collection("talk").add(map);
      fire_user.doc(from).update({talksKey: FieldValue.arrayUnion([to])});
      fire_user.doc(to).update({talksKey: FieldValue.arrayUnion([from])});
    }
  }

  getIdChat(String? memberUid, String? peerUid){
    if (memberUid.hashCode <= peerUid.hashCode) {
      return "$memberUid-$peerUid";
    } else {
      return "$peerUid-$memberUid";
    }
  }

  resetPassword(String email, context) async {
    try {
      await authInstance.sendPasswordResetEmail(email: email);
      AlertHelper().showSnackBar("E-mail de réinitialisation du mot de passe envoyé", context);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      AlertHelper().showSnackBar(e.message!, context);
      Navigator.of(context).pop();
    }
  }
}