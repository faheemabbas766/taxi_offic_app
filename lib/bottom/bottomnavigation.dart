import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:taxi_app/pages/profile.dart';

import '../controller/homecontroller.dart';
import '../pages/home.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    var naBody = [
      Home(),
      Container(
        color: Colors.amber,
      ),
      Container(
        color: Colors.green,
      ),
      Container(
        color: Colors.black,
      ),
      ProfileScreen(),
    ];
    return Scaffold(
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: naBody.elementAt(controller.currentNavIndex.value),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: GNav(
              backgroundColor: Colors.white,
              color: const Color(0xff878787),
              activeColor: const Color(0xffFEBD11),
              gap: 4,
              padding: const EdgeInsets.all(16),
              tabBackgroundColor: const Color(0xffF5F5FF),
              onTabChange: (value) {
                controller.currentNavIndex.value = value;
              },
              tabs: const [
                GButton(
                  icon: Icons.home,
                  iconSize: 24,
                  textSize: 12,
                  text: "Home",
                ),
                GButton(
                  icon: Icons.search,
                  text: "Search",
                ),
                GButton(
                  icon: Icons.bookmark,
                  text: "Book",
                ),
                GButton(
                  icon: Icons.explore,
                  text: "Explore",
                ),
                GButton(
                  icon: Icons.person,
                  text: "Profile",
                ),
              ]),
        ),
      ),
    );
  }
}
