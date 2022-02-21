import 'dart:io';
import 'package:flutter/material.dart';
import 'package:slapp/custom_widget/my_text_field.dart';
import 'package:slapp/model/color_theme.dart';
import 'package:slapp/model/generic_method.dart';
import 'package:slapp/util/constants.dart';
import 'package:image_picker/image_picker.dart';

import '../custom_widget/my_gradient.dart';
import '../model/alert_helper.dart';
import '../util/firebase_handler.dart';

class WritePost extends StatefulWidget {
  String? memberId;

  WritePost({Key? key, required this.memberId}) : super(key: key);
  @override
  State<StatefulWidget> createState() => WriteState();
}

class WriteState extends State<WritePost> {

  late TextEditingController _controller;
  File? _imageFile;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
                color: ColorTheme().background(),
                border:  Border.all(width: 0, color: ColorTheme().background()),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: ColorTheme().card(),
                    border:  Border.all(width: 0, color: ColorTheme().card()),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: InkWell(
                    onTap: () => (GenericMethod().hideKeyboard(context)),
                    child: SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Nouvelle Publication", style: TextStyle(color: ColorTheme().text()),),
                              SizedBox(height: 10, width: MediaQuery.of(context).size.width,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(onPressed: (() => takePicker(ImageSource.camera)), icon: cameraIcon),
                                  IconButton(onPressed: (() => takePicker(ImageSource.gallery)), icon: libraryIcon)
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: MediaQuery.of(context).size.width * 0.8,
                                child: (_imageFile == null)
                                    ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  decoration: BoxDecoration(
                                      color: ColorTheme().card(),
                                      border:  Border.all(width: 1, color: ColorTheme().background()),
                                      borderRadius: const BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: Center(child: Text("Pas d'image ...", style: TextStyle(color: ColorTheme().textGrey()),),),
                                )
                                    : Image.file(_imageFile!),
                              ),
                              SizedBox(height: 10, width: MediaQuery.of(context).size.width,),
                              MyTextField(controller: _controller, hint: "Ajouter une légende ...",),
                              const Spacer(),
                              Card(
                                elevation: 7.5,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width / 2,
                                  decoration: MyGradient(
                                    startColor: ColorTheme().blue(),
                                    endColor: ColorTheme().blueGradiant(),
                                    radius: 25,
                                    diagonal: true,
                                  ),
                                  child: TextButton(
                                    child: Text("Envoyer"),
                                    onPressed: () {
                                      //Envoie à firebase
                                      sendToFirebase();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  )
                )
              )
            )
        );
  }

  takePicker(ImageSource source) async {
    final imagePath = await ImagePicker().pickImage(source: source, maxHeight: 500, maxWidth: 500);
    final file = File(imagePath!.path);
    setState(() {
      _imageFile = file;
    });
  }

  sendToFirebase(){
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pop(context);
    if ((_imageFile != null) && (_controller.text != null) && (_controller != null)){
      FirebaseHandler().addPostToFirebase(widget.memberId, _controller.text, _imageFile!);
    } else {
      AlertHelper().error(context, "Veuillez entrer une image et du text valide");
    }
  }
}