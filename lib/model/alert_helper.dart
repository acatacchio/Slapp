import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:slapp/controller/main_controller.dart';
import 'package:slapp/page/profile_page.dart';
import 'package:slapp/util/constants.dart';

import '../custom_widget/my_text_field.dart';
import '../util/firebase_handler.dart';
import 'Member.dart';

class AlertHelper {

  Future<void> error(BuildContext context, String error) async {
    bool isiOS = (Theme.of(context).platform == TargetPlatform.iOS);
    final title = Text("Erreur");
    final explanation = Text(error);
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return (isiOS)
              ? CupertinoAlertDialog(title: title, content: explanation, actions: [close(ctx, "Ok")],)
              : AlertDialog(title: title, content: explanation, actions: [close(ctx, "Ok")],);
        }
    );
  }

  Future<void> disconnect(BuildContext context) async {
    bool isiOS = (Theme.of(context).platform == TargetPlatform.iOS);
    Text title = const Text("Voulez-vous vous deconnecter ?");
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return (isiOS)
              ? CupertinoAlertDialog(title: title, actions: [close(context, "Non"), disconnectBtn(context)],)
              : AlertDialog(title: title, actions: [close(context, "Non"), disconnectBtn(context)],);
        }
    );
  }

  Future<void> settings(BuildContext context, String? memberUid) async {
    bool isiOS = (Theme.of(context).platform == TargetPlatform.iOS);
    return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return (isiOS)
            ? CupertinoAlertDialog(title: const Text("Paramètres"), actions: [editProfil(context, memberUid), disconnectBtn(context)],)
            :AlertDialog(title: const Text("Paramètres"), actions: [editProfil(context, memberUid), disconnectBtn(context)],);
      }
    );
  }

  TextButton disconnectBtn(BuildContext context){
    return TextButton(
        onPressed: (){
          Navigator.pop(context);
          FirebaseHandler().logOut();
        },
        child: const Text("Se déconnecter", style: TextStyle(fontSize: 12),)
    );
  }

  TextButton close(BuildContext context, String string){
    return TextButton(
        onPressed: (() => Navigator.pop(context)),
        child: Text(string)
    );
  }

  TextButton editProfil(BuildContext context, String? memberUid) {
    return TextButton(
        onPressed: (){
          ProfileState().editPage();
          //Navigator.push(context, MaterialPageRoute(builder: (_) => MainController(memberUid: memberUid, edit: true, index: 3)));
        },
        child: const Text("Modifier le profile", style: TextStyle(fontSize: 12),)
    );
  }

  Future<void> changeUser(
      BuildContext context, {
        required Member? member,
        required TextEditingController? name,
        required TextEditingController? surname,
        required TextEditingController? description
      }) async {
    MyTextField nameTF = MyTextField(controller: name, hint: member!.name,);
    MyTextField surnameTF = MyTextField(controller: surname, hint: member.surname,);
    MyTextField descriptionTF = MyTextField(controller: description, hint: member.description ?? "Description",);
    Text text = const Text("Modification des données");
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: text,
            content: Column(
              children: [nameTF, surnameTF, descriptionTF],
            ),
            actions: [
              close(context, "Annuler"),
              TextButton(
                  onPressed: (){
                    Map<String, dynamic> datas = {};
                    if (name?.text != null && name?.text != "") {
                      datas[nameKey] = name?.text;
                    }
                    if (surname?.text != null && surname?.text != "") {
                      datas[surnameKey] = surname?.text;
                    }
                    if (description?.text != null && description?.text != "") {
                      datas[descriptionKey] = description?.text;
                    }
                    FirebaseHandler().modifyMember(datas, member.uid);
                    Navigator.pop(context);
                  },
                  child: const Text("Valider")
              )
            ],
          );
        });
  }
}