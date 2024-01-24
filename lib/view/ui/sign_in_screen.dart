import 'package:flutter/material.dart';
import 'package:locationexplorer/utilities/app_colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    const nouserfound = SnackBar(content: Text("No user found for that email"));
    const wrongpassword =
        SnackBar(content: Text('Wrong password provided for that user.'));

    return Scaffold(
      backgroundColor: backGroundBlue,
      appBar: AppBar(
        backgroundColor: backGroundBlue,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              border: Border.all(color: appBarDecoration),
              borderRadius: BorderRadius.circular(5)),
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
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailinputcontroller.text,
                              password: passwordcontroller.text);
                      //TODO: Route to main page
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        ScaffoldMessenger.of(context).showSnackBar(nouserfound);
                      } else if (e.code == 'wrong-password') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(wrongpassword);
                      }
                    }
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
          // const SizedBox(
          //   height: 10,
          // ),
          // const Text(
          //   'or',
          //   style: TextStyle(fontSize: 20),
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Text('Already have an account?'),
          //     TextButton(
          //         onPressed: () {}, //TODO: Add the route for login screen
          //         child: const Text(
          //           'Sign In',
          //           style: TextStyle(fontWeight: FontWeight.bold),
          //         ))
          //   ],
          // )
        ]),
      ),
    );
  }
}
