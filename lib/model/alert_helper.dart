import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../util/firebase_handler.dart';

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

  TextButton disconnectBtn(BuildContext context){
    return TextButton(
        onPressed: (){
          Navigator.pop(context);
          FirebaseHandler().logOut();
        },
        child: Text("Oui")
    );
  }

  TextButton close(BuildContext context, String string){
    return TextButton(
        onPressed: (() => Navigator.pop(context)),
        child: Text(string)
    );
  }
}