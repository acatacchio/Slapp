import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
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
      followersKey: [user?.uid],
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

}