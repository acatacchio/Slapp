import 'dart:async';

import 'package:flutter/material.dart';
import 'package:slapp/model/color_theme.dart';
import 'package:slapp/page/organization_page.dart';
import 'package:slapp/page/personal_fil.dart';
import 'package:slapp/page/write_post.dart';
import '../custom_widget/bar_item.dart';
import '../custom_widget/my_gradient.dart';
import '../model/Member.dart';
import '../model/alert_helper.dart';
import '../page/home_page.dart';
import '../page/member_page.dart';
import '../page/profile_page.dart';
import '../util/constants.dart';
import '../util/firebase_handler.dart';
import 'loading_controller.dart';

class MainController extends StatefulWidget {

  String? memberUid;
  bool edit;
  int? index;

  MainController({
    Key? key,
    required this.memberUid,
    this.edit = false,
    this.index
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainState();

}

class MainState extends State<MainController> {

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  late StreamSubscription streamSubscription;
  Member? member;
  int index = 0;
  bool showPostButton = true;

  @override
  void initState() {
    streamSubscription = FirebaseHandler().fire_user.doc(widget.memberUid).snapshots().listen((event) {
      setState(() {
        member = Member(event);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.index != null){
      buttonSelected(widget.index);
    }
    return (member == null)
      ? const LoadingController()
      : Scaffold(
        key: _globalKey,
        backgroundColor: ColorTheme().background(),
        body: SafeArea(
          child: showPage(),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          shape: const CircularNotchedRectangle(),
          color: ColorTheme().card(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              BarItem(icon: homeIcon, onPressed: (() => buttonSelected(0)), selected: (index == 0), context: context,),
              BarItem(icon: friendsIcon, onPressed: (() => buttonSelected(1)), selected: (index == 1), context: context,),
              const SizedBox(width: 0, height: 0,),
              BarItem(icon: organizationIcon, onPressed: (() => buttonSelected(2)), selected: (index == 2), context: context,),
              BarItem(icon: profileIcon, onPressed: (() => buttonSelected(3)), selected: (index == 3), context: context,),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _globalKey.currentState?.showBottomSheet((context) => WritePost(memberId: widget.memberUid,));
          },
          child: Container(
            decoration: MyGradient(startColor: ColorTheme().blue(), endColor: ColorTheme().blueGradiant(),diagonal: true, radius: MediaQuery.of(context).size.height),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: writePost,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    }

  buttonSelected(int? index) {
    setState(() {
      this.index = index!;
    });
  }

  showPage() {
    switch (index) {
      case 0: return HomePage(member: member);
      case 1: return MemberPage(member: member);
      case 2: return OrganizationPage(member: member);
      case 3: return ProfilePage(member: member);
    }
  }
}

