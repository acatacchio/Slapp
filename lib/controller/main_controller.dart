import 'package:flutter/material.dart';

import '../model/alert_helper.dart';

class MainController extends StatefulWidget {
  const MainController({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainState();

}

class MainState extends State<MainController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Slapp"),),
      body: Center(
        child: Column(
            children: [
              const Text("Accueil"),
              IconButton(
                  onPressed: (() => AlertHelper().disconnect(context)),
                  icon: const Icon(Icons.settings))
            ],
      ),
      ),
    );
  }
}