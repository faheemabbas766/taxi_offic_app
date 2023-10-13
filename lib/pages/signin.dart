import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
import '../providers/homepro.dart';
import '../providers/signinpro.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController companyid = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController pwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 216, 216, 216),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: RouteManager.width / 3.5,
              ),
              Container(
                width: RouteManager.width / 1.2,
                // color: Colors.red,
                height: RouteManager.height / 1.4,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(172, 172, 172, 1),
                      blurRadius: 20.0,
                    ),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(RouteManager.width / 10),
                  ),
                  color: RouteManager.appclr,
                  // color: Color.fromARGB(28, 20, 0, 70),
                  child: Column(
                    children: [
                      SizedBox(
                        height: RouteManager.width / 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            RouteManager.width / 7,
                          ),
                          image: const DecorationImage(
                            image: AssetImage("assets/taxilogo.png"),
                            fit: BoxFit.cover,
                          ),
                          // color: Colors.red,
                        ),
                        width: RouteManager.height / 4.2,
                        height: RouteManager.height / 3.7,
                        // child: Image.asset("assets/taxi.jpg", fit: BoxFit.contain),
                      ),
                      SizedBox(height: RouteManager.width / 12),
                      SizedBox(
                        width: RouteManager.width / 1.4,
                        child: TextField(
                          controller: companyid,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'myfonts',
                          ),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 158, 158, 158),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xfffebd23),
                              ),
                            ),
                            hintText: "Enter Company ID",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.workspaces_rounded,
                                color: Color(0xfffebd23)),
                          ),
                        ),
                      ),
                      SizedBox(height: RouteManager.width / 30),
                      SizedBox(
                        width: RouteManager.width / 1.4,
                        child: TextField(
                          controller: username,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'myfonts',
                          ),
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 158, 158, 158),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xfffebd23),
                              ),
                            ),
                            hintText: "Enter User Name",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon:
                                Icon(Icons.person, color: Color(0xfffebd23)),
                          ),
                        ),
                      ),
                      SizedBox(height: RouteManager.width / 30),
                      SizedBox(
                        width: RouteManager.width / 1.4,
                        child: TextField(
                          controller: pwd,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'myfonts',
                          ),
                          obscureText: Provider.of<SignInPro>(context).obscure,
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 158, 158, 158),
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xfffebd23),
                              ),
                            ),
                            hintText: "Enter Password",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.lock_open,
                                color: Color(0xfffebd23)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Provider.of<SignInPro>(context).obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                Provider.of<SignInPro>(context, listen: false)
                                    .obscure = !Provider.of<SignInPro>(context,
                                        listen: false)
                                    .obscure;
                                Provider.of<SignInPro>(context, listen: false)
                                    .notifyListenerz();
                                // setState(() {
                                //   obscure1 = !obscure1;
                                // });
                              },
                            ),
                          ),
                        ),
                        // child: TextField(decoration: InputDecoration(prefix: Icon(Icons.verified_user_outlined, color: Colors.orange))),
                      ),
                      SizedBox(height: RouteManager.width / 30),
                      SizedBox(
                        width: RouteManager.width / 1.4,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xfffebd23)),
                          onPressed: () async {
                            if (companyid.text == "" ||
                                username.text == "" ||
                                pwd.text == "") {
                              ft.Fluttertoast.showToast(
                                msg: "Please Fill all Fields",
                                toastLength: ft.Toast.LENGTH_LONG,
                              );
                              return;
                            }
                            API.showLoading('Signing In', context);
                            API
                                .logIn(username.text, companyid.text, pwd.text,
                                    context)
                                .then((value) {
                              if (value) {
                                SharedPreferences.getInstance().then((prefs) {prefs.clear();
                                    prefs.setString('username', username.text.toString()).then((value) {prefs.setString('userid',
                                          Provider.of<HomePro>(context, listen: false).userid.toString(),).then(
                                          (value) {prefs.setString('token', Provider.of<HomePro>(context, listen: false).token).then(
                                                  (value) {
                                                if (kDebugMode) {
                                                  print(
                                                  "SHARED PREFERENCES SAVEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD",
                                                );
                                                }

                                                Navigator.of(context).pushNamedAndRemoveUntil(
                                                  RouteManager.bottomPage,
                                                      (route) => false,
                                                );
                                                Provider.of<SignInPro>(context, listen: false).clearAll();
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              } else {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }
                            });
                            print(
                                "AYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa");
                            return;
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.login,
                                  color: Colors.white,
                                  size: RouteManager.width / 17),
                              Text(" LOGIN",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: RouteManager.width / 18)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
