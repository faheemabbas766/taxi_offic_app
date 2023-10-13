import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/themepro.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late SharedPreferences _prefs;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadTheme();
  }
  void loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    isLoading = false;
    setState(() {});
  }
  void toggleNightMode() {
    final themeModeProvider = Provider.of<ThemeModeProvider>(context, listen: false);
    themeModeProvider.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.of(context).primaryColor,
        title: Center(
          child: Text(
            "Profile Screen",
            style: TextStyle(
              fontSize: 20,
              color: AppColors.of(context).secondaryColor,
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.of(context).primaryDimColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Profile Information",
              style: TextStyle(
                fontSize: 20,
                color: AppColors.of(context).secondaryColor,
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Night Mode: "),
                Switch(
                  value: _prefs.getString('theme') == null? false :_prefs.getString('theme') == 'dark',
                  onChanged: (value) {
                    setState(() {
                      toggleNightMode();
                      _prefs.setString('theme', value ? 'dark' : 'light');
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
