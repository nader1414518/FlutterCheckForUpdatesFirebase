import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bill_tracker/controllers/auth_controller.dart';
import 'package:bill_tracker/screens/authentication/login_screen.dart';
import 'package:bill_tracker/screens/generic/home_screen.dart';
import 'package:bill_tracker/utils/assets_utility.dart';
import 'package:bill_tracker/utils/globals.dart';
import 'package:bill_tracker/utils/version_utils.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:icons_plus/icons_plus.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  Future<bool> checkVersion() async {
    try {
      // Check for updates here
      return await VersionUtils.checkAppVersion(context);
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> checkLogin() async {
    try {
      var res = await AuthController.checkLogin(context);
      if (res["result"] == true) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen();
            },
          ),
        );
      } else {
        // Fluttertoast.showToast(
        //   msg: res["message"].toString(),
        // );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return LoginScreen();
            },
          ),
        );
      }
    } catch (e) {
      print(e.toString());
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
      );
    }
  }

  Future<void> configure() async {
    try {
      var needsUpdate = await checkVersion();

      if (!needsUpdate) {
        await checkLogin();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    configure();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Hero(
            tag: "logoElement",
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width - 40) * 0.6,
                  height: (MediaQuery.of(context).size.width - 40) * 0.6,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        AssetsUtility.appLogo,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Globals.currentTheme == "light"
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Arima",
                        ),
                        child: AnimatedTextKit(
                          // totalRepeatCount: 10,
                          stopPauseOnTap: true,
                          repeatForever: true,
                          displayFullTextOnTap: true,
                          pause: const Duration(
                            milliseconds: 0,
                          ),
                          animatedTexts: [
                            RotateAnimatedText(
                              'Bills Tracker',
                              duration: const Duration(
                                milliseconds: 2000,
                              ),
                            ),
                            RotateAnimatedText(
                              'Invoices Tracker',
                              duration: const Duration(
                                milliseconds: 2000,
                              ),
                            ),
                            RotateAnimatedText(
                              'Expenses Tracker',
                              duration: const Duration(
                                milliseconds: 2000,
                              ),
                            ),
                            RotateAnimatedText(
                              'All in one place!!',
                              duration: const Duration(
                                milliseconds: 2000,
                              ),
                            ),
                          ],
                          onTap: () {
                            print("Tap Event");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
