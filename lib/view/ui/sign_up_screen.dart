import 'package:flutter/material.dart';
import 'package:locationexplorer/config/app_colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:locationexplorer/utilities/firebase_auth_credential.dart';
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
      body: SafeArea(
        child: Container(
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
                      firebaseCredUp(emailinputcontroller.text,
                          passwordcontroller.text, context);
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(passwordSnackBar);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(emailSnackBar);
                  }
                },
                child: const Text('Sign Up',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
            const SizedBox(
              height: 10,
            ),
            //The custom auth system requires custom token which is not currently available so this feature can be implemented
            // ElevatedButton(
            //     style: const ButtonStyle(
            //         backgroundColor:
            //             MaterialStatePropertyAll(elevatedButtonColor)),
            //     onPressed: () {},
            //     child: const Text('Google',
            //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInScreen(),
                          ));
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            )
          ]),
        ),
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
