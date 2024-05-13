import 'package:e_retrieval/services/database.dart';
import 'package:e_retrieval/utils/constant.dart';
import 'package:e_retrieval/views/get_question.dart';
import 'package:e_retrieval/views/profile.dart';
import 'package:fancy_bottom_navigation_2/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey bottomNavigationKey = GlobalKey();
  DatabaseService databaseService = Get.put(DatabaseService());

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Constants.basicColor,
        body: IndexedStack(
          index: currentPage,
          children: const [
            GetPastQuestion(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: FancyBottomNavigation(
          circleColor: Constants.primaryColor,
          inactiveIconColor: Constants.primaryColor,
          textColor: Constants.primaryColor,
          tabs: [
            TabData(
              iconData: Icons.document_scanner,
              title: "Past Questions",
            ),
            TabData(iconData: Icons.person, title: "Profile")
          ],
          initialSelection: currentPage,
          key: bottomNavigationKey,
          onTabChangedListener: (position) {
            setState(() {
              currentPage = position;
            });
          },
        ),
      ),
    );
  }
}
