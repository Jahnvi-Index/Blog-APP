import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/screens/home/home_screen.dart';
import 'package:untitled1/screens/option_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth=FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user=auth.currentUser;
    if(user!=null)
      {
        Timer(Duration(seconds: 3),()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen()))

        );


      }else
        {
          Timer(Duration(seconds: 3),()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>OptionScreen()))

          );
        }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(

        mainAxisAlignment:MainAxisAlignment.center ,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         Image(
           height:MediaQuery.of(context).size.height * .3,
           width:MediaQuery.of(context).size.height * .6,
           image: AssetImage('images/logo1.jpeg'),
         ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),

            child: Align(
              alignment: Alignment.center,
              child: Text(
                '-Tell your story with us.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
