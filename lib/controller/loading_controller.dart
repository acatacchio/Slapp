import 'package:flutter/material.dart';

class LoadingController extends StatelessWidget {
  const LoadingController({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Chargement ...",),),
    );
  }
}