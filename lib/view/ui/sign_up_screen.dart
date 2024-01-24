import 'package:flutter/material.dart';
import 'package:locationexplorer/utilities/app_colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locationexplorer/view/ui/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailinputcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const passwordSnackBar = SnackBar(content: Text('Please enter a password'));
    const emailSnackBar = SnackBar(
        content: Text(
            'Please enter email address or try checking the validity of email address'));
    const passwordweak =
        SnackBar(content: Text('The password provided is too weak.'));
    const accountexist =
        SnackBar(content: Text('The account already exists for that email.'));

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
            "Sign Up",
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
                          .createUserWithEmailAndPassword(
                              email: emailinputcontroller.text,
                              password: passwordcontroller.text);
                      //TODO: Route to main page
                    } on FirebaseAuthException catch (error) {
                      if (error.code == 'weak-password') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(passwordweak);
                      } else if (error.code == 'email-already-in-use') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(accountexist);
                      }
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(passwordSnackBar);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(emailSnackBar);
                }
              },
              child: const Text('Sign Up',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
          const SizedBox(
            height: 10,
          ),
          // const Text(
          //   'or',
          //   style: TextStyle(fontSize: 20),
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          //The custom auth system requires custom token which is not currently available so this feature can be implemented
          // ElevatedButton(
          //     style: const ButtonStyle(
          //         backgroundColor:
          //             MaterialStatePropertyAll(elevatedButtonColor)),
          //     onPressed: () {}, //TODO: google auth sign up
          //     child: const Text('Google',
          //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?'),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  }, //TODO: Add the route for login screen
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          )
        ]),
      ),
    );
  }
}
