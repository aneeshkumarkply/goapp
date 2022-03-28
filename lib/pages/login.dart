import 'package:flutter/material.dart';

import '../controller/google_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/google.png"))),
          )),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Text(
              "Create And Manage your notes",
              style: TextStyle(fontFamily: "lato", fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(100.0),
            child: ElevatedButton(
              onPressed: () {
                signInWithGoogle(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/google.png",
                    height: 27,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Contine with Google", textAlign: TextAlign.center),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
