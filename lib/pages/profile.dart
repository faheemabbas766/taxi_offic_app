import 'package:flutter/material.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isVibrateEnabled = false;
  bool isNightModeEnabled = false;

  // Function to toggle vibrate mode
  void toggleVibrateMode() {
    setState(() {
      isVibrateEnabled = !isVibrateEnabled;
    });
  }

  // Function to toggle night mode
  void toggleNightMode() {
    setState(() {
      isNightModeEnabled = !isNightModeEnabled;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Profile Information", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
              },
              child: Text("Play Ringtone"),
            ),
            ElevatedButton(
              onPressed: () {
              },
              child: Text("Stop Ringtone"),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Vibrate Mode: "),
                Switch(
                  value: isVibrateEnabled,
                  onChanged: (value) {
                    toggleVibrateMode();
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Night Mode: "),
                Switch(
                  value: isNightModeEnabled,
                  onChanged: (value) {
                    toggleNightMode();
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
