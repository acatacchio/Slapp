import 'package:cloud_firestore/cloud_firestore.dart';
import '../util/constants.dart';

class Member {

  String? uid;
  String? name;
  String? surname;
  late String imageUrl;
  List<dynamic>? followers;
  List<dynamic>? following;
  DocumentReference? documentId;
  late DocumentReference ref;
  String? description;

  Member(DocumentSnapshot snapshot) {
    ref = snapshot.reference;
    uid = snapshot.id;
    Map<String, dynamic>? datas = snapshot.data() as Map<String, dynamic>?;
    name = datas![nameKey];
    surname = datas[surnameKey];
    imageUrl = datas[imageUrlKey];
    followers = datas[followersKey];
    following = datas[followingKey];
    description = datas[descriptionKey];
  }

  Map<String, dynamic> toMap(){
    return {
      uidKey: uid,
      nameKey: name,
      surnameKey: surname,
      imageUrlKey: imageUrl,
      followersKey: followers,
      followingKey: following,
      descriptionKey: description,
    };
  }

}