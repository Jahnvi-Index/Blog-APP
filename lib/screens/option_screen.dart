import 'package:flutter/material.dart';
import 'package:untitled1/screens/login_screen.dart';
import 'package:untitled1/screens/sign_in.dart';

import '../components/round_button.dart';
class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.white,
    body: SafeArea(

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage('images/logo1.jpeg')),

            SizedBox(height: 30,),
            RoundButton(title:'Login',onPress:(){
              Navigator.push(
                  context, MaterialPageRoute(builder:(context)=>LoginScreen()));
            },),
            SizedBox(height: 30,),
            RoundButton(title:'sign In',onPress:(){
            Navigator.push(
                context, MaterialPageRoute(builder:(context)=>SignIn()));
            },),
          ],
        ),
      ),
    ),
    );

  }
}

