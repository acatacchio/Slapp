import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slapp/controller/auth_controller.dart';
import 'package:slapp/model/generic_method.dart';
import '../controller/main_controller.dart';
import '../custom_widget/my_text_field.dart';
import '../model/alert_helper.dart';
import '../model/color_theme.dart';
import '../util/firebase_handler.dart';
import '../util/images.dart';

class RegisterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => RegisterState();

}

class RegisterState extends State<RegisterPage> {

  late PageController _pageController;
  late TextEditingController _mail;
  late TextEditingController _password;
  late TextEditingController _name;
  late TextEditingController _surname;
  late TextEditingController _proposingLink;
  bool validProposingLink = false;
  late String proposer;

  @override
  void initState() {
    _pageController = PageController();
    _mail = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
    _surname = TextEditingController();
    _proposingLink = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mail.dispose();
    _password.dispose();
    _name.dispose();
    _surname.dispose();
    _proposingLink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (BuildContext context, snapshot) {
        return (snapshot.hasData) ? MainController(memberUid: snapshot.data?.uid) : uIRegisterPage();
      },
    );
  }

  Scaffold uIRegisterPage() {
    return Scaffold(
        backgroundColor: ColorTheme().background(),
        body: SingleChildScrollView(
          child: (validProposingLink) ? register() : checkProposingLink()
        )
    );
  }

  checkProposingLink(){
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: (){
        GenericMethod().hideKeyboard(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Entrez votre lien de parrainage"),
              const SizedBox(height: 10,),
              MyTextField(controller: _proposingLink,),
              const SizedBox(height: 10,),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseHandler().fire_proposing.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots){
                  return ElevatedButton(
                    onPressed: (){
                      if (snapshots.data != null) {
                        for (var i = 0; i < snapshots.data!.size; i++) {
                          if(snapshots.data?.docs[i]["proposingLink"] == _proposingLink.text){
                            _proposingLink.text = "";
                            proposer = snapshots.data!.docs[i].id;
                            validProposingLink = true;
                          }
                        }

                        if (validProposingLink == false){
                          _proposingLink.text = "";
                          AlertHelper().error(context, "Lien invalide");
                        }
                      }

                      setState(() {

                      });
                    },
                    child: const Text("Vérifier"),
                    style: ElevatedButton.styleFrom(
                      primary: ColorTheme().orange(),
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                    ),
                  );
                },
              ),
              const SizedBox(height: 50,),
              Text(
                "Vous avez déjà un compte ?",
                style: TextStyle(
                    fontSize: 15,
                    color: ColorTheme().textGrey()
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight:30,
                ),
                child: TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthController()));
                    },
                    child: const Text(
                      "Connectez-vous",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  register(){
    return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: (){
          GenericMethod().hideKeyboard(context);
        },
        child: SafeArea(
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 10,
                      ),
                      Text(
                        "Inscription",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: ColorTheme().text()
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 30,
                      ),
                      MyTextField(controller: _name, hint: "Entrez votre prénom"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 10,
                      ),
                      MyTextField(controller: _surname, hint: "Entrez votre nom"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 10,
                      ),
                      MyTextField(controller: _mail, hint: "Entrez votre e-mail"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 10,
                      ),
                      MyTextField(controller: _password, hint: "Entrez votre mot de passe", obscure: true,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: (){
                          authToFirebase();
                        },
                        child: const Text("S'inscrire"),
                        style: ElevatedButton.styleFrom(
                          primary: ColorTheme().orange(),
                          fixedSize: Size(MediaQuery.of(context).size.width, 50),
                        ),
                      )
                    ],
                  ),
                )
            )
        )
    );
  }

  authToFirebase() {
    GenericMethod().hideKeyboard(context);
    String name = _name.text;
    String surname = _surname.text;
    String mail = _mail.text;
    String pwd = _password.text;

    _name.text = "";
    _surname.text = "";
    _mail.text = "";
    _password.text = "";

    if ((validText(mail)) && (validText(pwd))) {
      if ((validText(name)) && (validText(surname))) {
        // methode vers firebase
        validProposingLink = false;
        FirebaseHandler().createUser(mail, pwd, name, surname, proposer);
      }else{
        //Alert nom prenom
        AlertHelper().error(context, "Nom ou prénom invalide");
      }
    }else{
      //alert pas de mail ou mdp
      AlertHelper().error(context, "Mot de passe ou mail invalide");
    }
  }

  bool validText(String string) {
    return (string != null && string != "");
  }

}