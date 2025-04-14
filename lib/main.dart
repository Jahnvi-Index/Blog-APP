import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:untitled1/screens/home/splash_screen.dart';
import 'package:untitled1/screens/option_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      messagingSenderId:"",
      apiKey: "AIzaSyCJkgeR1eFkdeR-3aJ-PGRYzte7nI7RChQ",
      appId: "1:1028639529853:android:5d1afb9b9db43266394a14",
      projectId: "heyyy-b84c8",
      storageBucket:"heyyy-b84c8.appspot.com",
  //chatgpt suggest
      databaseURL: "https://heyyy-b84c8.firebaseio.com",
    ),
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //  root of application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(

     theme: ThemeData(
         visualDensity: VisualDensity.adaptivePlatformDensity,
       primarySwatch: Colors.blueGrey
     ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SplashScreen (), 
      ),

    );
  }
}


