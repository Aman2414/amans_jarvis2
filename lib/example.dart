import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spotify_sdk/spotify_sdk.dart';

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  String token_url = "https://accounts.spotify.com/api/token";
  String auth_url = "https://accounts.spotify.com/authorize";
  String login_url = "https://accounts.spotify.com/";
  String client_id = "83f51efbb5bf4ca79a3e2fc9594681ae";
  String client_secret = "fbdfc66ea23a4d94893b2eb4147d6bc6";

  void getData() async {
    // var accessToken = await SpotifySdk.getAccessToken(
    //   clientId: client_id,
    //   scope:
    //       "app-remote-control,user-modify-playback-state,playlist-read-private",
    //   redirectUrl: login_url,
    // );
    // print("Access Token $accessToken");

    var response = await http.get(
      Uri.parse(auth_url),
      headers: {
        'client_id': client_id,
        'response_type': 'application/json',
        'redirect_uri': 'http://com.example.amans_jarvis2://callback',
        'scope':
            'app-remote-control,user-modify-playback-state,playlist-read-private',
      },
    );
    print("Response Status Code ${response.statusCode}");
    print("Response Body ${response.body}");
  }

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(),
      ),
    );
  }
}
