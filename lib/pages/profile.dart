import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/themepro.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isNightModeEnabled = true;
  void toggleNightMode() {
    final themeModeProvider = Provider.of<ThemeModeProvider>(context, listen: false);
    themeModeProvider.toggleTheme();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Screen"),
      ),
      backgroundColor: AppColors.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Profile Information", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Night Mode: "),
                Switch(
                  value: isNightModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      isNightModeEnabled = !isNightModeEnabled;
                      toggleNightMode();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
