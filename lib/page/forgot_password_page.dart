import 'package:flutter/material.dart';
import 'package:slapp/util/firebase_handler.dart';

import '../custom_widget/my_text_field.dart';
import '../model/color_theme.dart';
import '../model/generic_method.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPasswordPage>{

  late PageController _pageController;
  late TextEditingController _mail;

  @override
  void initState() {
    _pageController = PageController();
    _mail = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme().background(),
      body: SingleChildScrollView(
        child: InkWell(
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
                            "Réinitialiser le mot de passe",
                            style: TextStyle(
                                fontSize: 20,
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                          ),
                          ElevatedButton(
                            onPressed: (){
                              resetPassword(_mail.text);
                            },
                            child: const Text("Réinitialiser le mot de passe"),
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

  Future resetPassword(String email) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator(),)
    );
    return FirebaseHandler().resetPassword(email, context);
  }
}