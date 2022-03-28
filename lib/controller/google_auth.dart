// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goapp/pages/home.dart';

GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference users = FirebaseFirestore.instance.collection('users');

void signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      final UserCredential userCredential =
          await auth.signInWithCredential(authCredential);

      final User? user = userCredential.user;

      var userData = {
        'name': googleSignInAccount.displayName,
        'provider': 'google',
        'photoURL': googleSignInAccount.photoUrl,
        'email': googleSignInAccount.email
      };

      //uid
      users.doc(user?.uid).get().then((value) {
        if (value.exists) {
          // old user
          value.reference.update(userData);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          users.doc(user?.uid).set(userData);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        }
      });
    }
  } on PlatformException {
    print(PlatformException);
    print("Sign in not successful !");
    // better show an alert here
  }
}
