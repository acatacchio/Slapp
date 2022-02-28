import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import '../model/Member.dart';
import 'constants.dart';

class FirebaseHandler {

  //Auth
  final authInstance = FirebaseAuth.instance;

  //Connexion
  Future<User?> signIn(String mail, String pwd) async {
    final userCredential = await authInstance.signInWithEmailAndPassword(
        email: mail,
        password: pwd
    );
    final User? user = userCredential.user;
    return user;
  }

  //Création User
  Future<User?> createUser(String mail, String pwd, String name, String surname) async {
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
      followingKey: [],
      uidKey: user?.uid
    };
    //AddUser
    addUserToFirebase(memberMap);
    return user;
  }

  logOut(){
    authInstance.signOut();
  }

  //Database
  static final firestoreInstance = FirebaseFirestore.instance;
  final fire_user = firestoreInstance.collection(memberRef);
  //final fire_notif = firestoreInstance.collection("notification");

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
      showPost: true
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
    Map<String, dynamic> newMap = {showPost: false};
    //fire_user.doc(uid).update(newMap);
    fire_user.doc(uid).collection("post").doc(ref).update(newMap);
    print("Suppression du post");
  }

  addOrRemoveFollow(Member? member) {
    String myId = authInstance.currentUser!.uid;
    DocumentReference myRef = fire_user.doc(myId);
    if (member!.followers!.contains(myId)){
      member.ref.update({followersKey: FieldValue.arrayRemove([myId])});
      myRef.update({followingKey: FieldValue.arrayRemove([member.uid])});
    } else {
      member.ref.update({followersKey: FieldValue.arrayUnion([myId])});
      myRef.update({followingKey: FieldValue.arrayUnion([member.uid])});
      //Notif
      //sendNotifTo(member.uid, authInstance.currentUser!.uid, "Vous suit désormais", fire_user.doc(authInstance.currentUser!.uid), follow);
    }
  }

}