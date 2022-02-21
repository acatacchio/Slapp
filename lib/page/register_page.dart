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

  @override
  void initState() {
    _pageController = PageController();
    _mail = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
    _surname = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mail.dispose();
    _password.dispose();
    _name.dispose();
    _surname.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (BuildContext context, snapshot) {
        return (snapshot.hasData) ? const MainController() : uIRegisterPage();
      },
    );
  }

  Scaffold uIRegisterPage() {
    return Scaffold(
        backgroundColor: ColorTheme().background(),
        body: SingleChildScrollView(
          child: InkWell(
              onTap: (){},
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
                              height: 40,
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
          ),
        )
    );
  }

  authToFirebase() {
    GenericMethod().hideKeyboard(context);
    String name = _name.text;
    String surname = _surname.text;
    String mail = _mail.text;
    String pwd = _password.text;

    if ((validText(mail)) && (validText(pwd))) {
      if ((validText(name)) && (validText(surname))) {
        // methode vers firebase
        FirebaseHandler().createUser(mail, pwd, name, surname);
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