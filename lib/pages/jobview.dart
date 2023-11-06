import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/pages/pendingjobs.dart';
import 'package:taxi_app/providers/themepro.dart';
import '../Api & Routes/routes.dart';
import '../providers/bottomnavpro.dart';
import 'completedjobs.dart';
import 'currentjobs.dart';

class JobView extends StatefulWidget {
  const JobView({super.key});

  @override
  State<JobView> createState() => _JobViewState();
}

class _JobViewState extends State<JobView> {
  final tabs = [
    const CurrentJobs(),
    const PendingJobs(),
    const CompletedJobs(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<BottomNavigationPro>(context, listen: false).clearAll();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.of(context).accentColor,
          title: Row(
            children: [
              SizedBox(
                width: RouteManager.width / 10,
              ),
              Text(
                "  JobView",
                style: TextStyle(fontSize: RouteManager.width / 15),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Scaffold(
            backgroundColor:AppColors.of(context).primaryColor,
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Selector<BottomNavigationPro, Icon>(
                    selector: (p0, p1) => p1.currentjobicon,
                    builder: (context1, currentjobicon, child) {
                      return currentjobicon;
                    },
                  ),
                  label: "Current Job",
                  activeIcon: const Icon(Icons.work, color: Color(0xffFBC02D)),
                ),
                BottomNavigationBarItem(
                  icon: Selector<BottomNavigationPro, Icon>(
                    selector: (p0, p1) => p1.pendingjobicon,
                    builder: (context1, pendingjobicon, child) {
                      return pendingjobicon;
                    },
                  ),
                  label: "Future Job",
                  activeIcon: const Icon(Icons.info, color: Color(0xffFBC02D)),
                ),
                BottomNavigationBarItem(
                  icon: Selector<BottomNavigationPro, Icon>(
                    selector: (p0, p1) => p1.completedjobicon,
                    builder: (context1, completedjobicon, child) {
                      return completedjobicon;
                    },
                  ),
                  label: "Completed Job",
                  activeIcon: const Icon(Icons.check, color: Color(0xffFBC02D)),
                ),
              ],
              backgroundColor: AppColors.of(context).primaryColor,
              selectedFontSize: RouteManager.width / 26,
              iconSize: RouteManager.width / 12,
              unselectedIconTheme: const IconThemeData(opacity: 0.7),
              selectedIconTheme: const IconThemeData(opacity: 1),
              // fixedColor: Colors.white,
              unselectedItemColor: const Color(0xff5E5F60),
              unselectedFontSize: RouteManager.width / 30,
              selectedItemColor: const Color(0xffFBC02D),
              currentIndex: Provider.of<BottomNavigationPro>(context).navindex,
              onTap: (value) {
                Provider.of<BottomNavigationPro>(context, listen: false)
                    .navindex = value;
                Provider.of<BottomNavigationPro>(context, listen: false)
                    .notifyListenerz();
              },
            ),
            body: Selector<BottomNavigationPro, int>(
              selector: (p0, p1) => p1.navindex,
              builder: (context, pindex, child) {
                return tabs[pindex];
              },
            ),
          ),
        ),
      ),
    );
  }
}
