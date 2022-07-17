import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SpeechToText speech2Text = SpeechToText();
  FlutterTts text2Speech = FlutterTts();
  String res = '';
  bool isCompletedListening = false;
  List<dynamic> installedApps = [];
  List<List<String>> appNames = [];
  List packageNames = [];
  List<dynamic> words = [];

  void initTextToSpeech() async {}

  void initSpeechToText() async {
    await speech2Text.initialize();
  }

  void startSpeaking(String command) async {
    await text2Speech.speak(command);
  }

  void startListening() async {
    print("Starting Listening");
    words = [];
    await speech2Text.listen(
      listenFor: const Duration(milliseconds: 3000),
      onResult: (result) {
        var temp = result.recognizedWords;
        if (temp.isNotEmpty) {
          words.add(temp.toLowerCase());
        }
        res = result.recognizedWords.toLowerCase();
        print("Result $res");
      },
    );
  }

  void stopListening() async {
    await speech2Text.stop();
  }

  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
    getApps();
  }

  List<String> filterAppName(String s) {
    List<String> temp = [];
    var word = "";
    var fullAppName = "";
    s = s.toLowerCase();
    for (var i = 0; i < s.length; i++) {
      if (s[i] == " " || s[i] == "_" || s[i] == "-" || s[i] == ".") {
        if (!temp.contains(word) && word != " ") {
          temp.add(word);
        }
        word = '';
        if (!temp.contains(fullAppName)) {
          temp.add(fullAppName);
        }
      } else {
        word += s[i];
        fullAppName += s[i];
      }
    }
    if (word.isNotEmpty) {
      temp.add(word);
    }
    if (!temp.contains(fullAppName)) {
      temp.add(fullAppName);
    }
    return temp;
  }

  void getApps() async {
    // installedApps = await AppAvailability.getInstalledApps();
    installedApps = await InstalledApps.getInstalledApps(false);

    Future.delayed(const Duration(milliseconds: 100), () {
      for (int i = 0; i < installedApps.length; i++) {
        // appNames.add(filterAppNames(installedApps[i]["app_name"]));
        // packageNames.add(installedApps[i]["package_name"]);
        //
        appNames.add(filterAppName(installedApps[i].name));
        packageNames.add(installedApps[i].packageName);
      }
    });
  }

  void executeCommand() {
    res = res.toLowerCase();
    if (words.contains("open")) {
      openApp();
    }
  }

  void openApp() async {
    var openappName = "";
    for (int i = 5; i < res.length; i++) {
      if (res[i] != " ") {
        openappName += res[i];
      }
    }

    print("AppName : $openappName");
    print("AppNames: $appNames");

    for (int i = 0; i < appNames.length; i++) {
      if (appNames[i].contains(openappName)) {
        print("Opening $openappName");
        print("Opening ${appNames[i]}");
        print("Opening ${appNames[i][appNames[i].length - 1]}");
        startSpeaking("Opening ${appNames[i][appNames[i].length - 1]}");
        // AppAvailability.launchApp(packageNames[i]);
        InstalledApps.startApp(packageNames[i]);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                  color: Colors.blue,
                  child: InkWell(
                    onTap: () {
                      startListening();
                      Future.delayed(const Duration(milliseconds: 3500), () {
                        executeCommand();
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      child: Text("Mic On"),
                    ),
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
