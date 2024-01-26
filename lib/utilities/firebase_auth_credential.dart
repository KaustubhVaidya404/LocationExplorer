import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/ui/home_screen.dart';

const passwordweak =
    SnackBar(content: Text('The password provided is too weak.'));
const accountexist =
    SnackBar(content: Text('The account already exists for that email.'));

void firebase_cred_up(
    String email, String password, BuildContext context) async {
  try {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool('state', true);
  } on FirebaseAuthException catch (error) {
    if (error.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(passwordweak);
    } else if (error.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(accountexist);
    }
  } catch (e) {
    print(e);
  }
}

void firebase_cred_in(
    String email, String password, BuildContext context) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool('state', true);
  } on FirebaseAuthException catch (error) {
    if (error.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(passwordweak);
    } else if (error.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(accountexist);
    }
  } catch (e) {
    print(e);
  }
}
