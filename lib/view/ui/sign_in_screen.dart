import 'package:flutter/material.dart';
import 'package:locationexplorer/config/app_colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locationexplorer/utilities/firebase_auth_credential.dart';
import 'package:locationexplorer/view/ui/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailinputcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const passwordSnackBar = SnackBar(content: Text('Please enter a password'));
    const emailSnackBar = SnackBar(
        content: Text(
            'Please enter email address or try checking the validity of email address'));

    return Scaffold(
      backgroundColor: backGroundBlue,
      appBar: AppBar(
        backgroundColor: backGroundBlue,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.all(2),
          // decoration: BoxDecoration(
          //     border: Border.all(color: appBarDecoration),
          //     borderRadius: BorderRadius.circular(5)),
          child: const Text(
            'Location Explorer',
            style: TextStyle(fontSize: 25, color: appBarFontBlack),
          ),
        ),
      ),
      body: Container(
        // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        margin: const EdgeInsets.all(15),
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            "Sign In",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 18,
          ),
          TextField(
            controller: emailinputcontroller,
            decoration: const InputDecoration(
              hintText: "email address",
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          TextField(
            obscureText: true,
            controller: passwordcontroller,
            decoration: const InputDecoration(
              hintText: "password",
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(elevatedButtonColor)),
              onPressed: () async {
                var isEmailValid =
                    EmailValidator.validate(emailinputcontroller.text);
                if (isEmailValid == true) {
                  if (passwordcontroller.text.isNotEmpty) {
                    firebase_cred_in(emailinputcontroller.text,
                        passwordcontroller.text, context);
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(passwordSnackBar);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(emailSnackBar);
                }
              },
              child: const Text('Sign In',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
          //TODO: add a forgot password feature
        ]),
      ),
    );
  }

  @override
  void dispose() {
    emailinputcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }
}
