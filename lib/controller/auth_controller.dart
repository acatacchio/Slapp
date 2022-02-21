import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slapp/custom_widget/my_text_field.dart';
import 'package:slapp/model/color_theme.dart';
import 'package:slapp/model/generic_method.dart';
import 'package:slapp/page/register_page.dart';
import 'package:slapp/util/images.dart';

import '../model/alert_helper.dart';
import '../util/firebase_handler.dart';
import 'main_controller.dart';

class AuthController extends StatefulWidget {
  const AuthController({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AuthState();

}

class AuthState extends State<AuthController> {

  late PageController _pageController;
  late TextEditingController _mail;
  late TextEditingController _password;

  @override
  void initState() {
    _pageController = PageController();
    _mail = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mail.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (BuildContext context, snapshot) {
        return (snapshot.hasData) ? const MainController() : uiAuthPage();
      },
    );
  }

  Scaffold uiAuthPage(){
    return Scaffold(
      backgroundColor: ColorTheme().background(),
      body: SingleChildScrollView(
        child: InkWell(
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
                            "Connexion",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: ColorTheme().text()
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                          ),
                          MyTextField(controller: _mail, hint: "Entrez votre e-mail"),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 10,
                          ),
                          MyTextField(controller: _password, hint: "Entrez votre mot de passe", obscure: true,),
                          Row(
                            children: [
                              TextButton(
                                  onPressed: (){},
                                  child: const Text(
                                    "Mot de passe oublié ?",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  )
                              ),
                              const Spacer()
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 80,
                          ),
                          Text(
                            "Ou connectez vous en utilisant vos comptes de",
                            style: TextStyle(
                                fontSize: 15,
                                color: ColorTheme().textGrey()
                            ),
                          ),
                          Text(
                            "réseaux sociaux",
                            style: TextStyle(
                                fontSize: 15,
                                color: ColorTheme().textGrey()
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: (){},
                                child: const Icon(Icons.facebook),
                                style: ElevatedButton.styleFrom(
                                  primary: ColorTheme().card(),
                                  fixedSize: Size(MediaQuery.of(context).size.width/3.7, 50),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: (){},
                                child: Image.asset(logoApple, height: 30, width: 30,),
                                style: ElevatedButton.styleFrom(
                                  primary: ColorTheme().card(),
                                  fixedSize: Size(MediaQuery.of(context).size.width/3.7, 50),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: (){},
                                child: Image.asset(logoGoogle, height: 30, width: 30,),
                                style: ElevatedButton.styleFrom(
                                  primary: ColorTheme().card(),
                                  fixedSize: Size(MediaQuery.of(context).size.width/3.7, 50),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 30,
                          ),
                          Text(
                            "Vous n'avez pas encore de compte ?",
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                                },
                                child: const Text(
                                  "Créez-en un",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                )
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 80,
                          ),
                          ElevatedButton(
                            onPressed: (){
                              authToFirebase();
                            },
                            child: const Text("S'identifier"),
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
        ),
      ),
    );
  }

  authToFirebase() {
    GenericMethod().hideKeyboard(context);
    String mail = _mail.text;
    String pwd = _password.text;

    if ((validText(mail)) && (validText(pwd))) {
        FirebaseHandler().signIn(mail, pwd);
    }else{
      //alert pas de mail ou mdp
      AlertHelper().error(context, "Mot de passe ou mail invalide");
    }
  }

  bool validText(String string) {
    return (string != null && string != "");
  }
}