import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionUtils {
  static bool updateMessageShown = false;

  static Future<bool> checkAppVersion(BuildContext context) async {
    try {
      DatabaseReference versionRef =
          FirebaseDatabase.instance.ref().child("MobileAppDetails");

      // Check device app version
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String currentVersion = packageInfo.version;

      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String buildNumber = packageInfo.buildNumber;

      print("AppName: " + appName);
      print("Version: " + currentVersion);
      print("PackageName: " + packageName);
      print("BuildNumber: " + buildNumber);

      var snapshot = await versionRef.get();
      if (snapshot.exists) {
        print("Found data on the server ... ");

        var data = Map<String, dynamic>.from(
          snapshot.value as Map,
        );

        var deviceVersion = num.parse(currentVersion.split(".")[0]).toInt();
        var androidServerVersion =
            num.parse(data["androidVersion"].toString().split(".")[0]).toInt();
        var iosServerVersion =
            num.parse(data["iosVersion"].toString().split(".")[0]).toInt();
        print(androidServerVersion);

        if (Platform.isAndroid) {
          if (androidServerVersion > deviceVersion) {
            print("Found new version !!");
            if (updateMessageShown) return true;

            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Update Required!!"),
                  content: const Text(
                      "Please update your application to the latest version"),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        String url = data["latestAndroid"].toString();

                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        }
                      },
                      child: const Text(
                        "Update",
                      ),
                    ),
                  ],
                );
              },
            );

            updateMessageShown = true;
            return true;
          }
        } else if (Platform.isIOS) {
          if (iosServerVersion > deviceVersion) {
            if (updateMessageShown) return true;

            await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Update Required!!"),
                  content: const Text(
                      "Please update your application to the latest version"),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        String url = data["latestIOS"].toString();

                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        }
                      },
                      child: const Text(
                        "Update",
                      ),
                    ),
                  ],
                );
              },
            );

            updateMessageShown = true;
            return true;
          }
        }

        return false;
      } else {
        print("No data found on server!!");
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
