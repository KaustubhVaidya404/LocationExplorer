import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:locationexplorer/firebase_options.dart';
import 'package:locationexplorer/view/ui/home_screen.dart';
import 'package:locationexplorer/view/ui/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  var state = sharedPreferences.getBool('state');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: state == true ? const HomeScreen() : const SignUpScreen(),
  ));
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
