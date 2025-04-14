import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:untitled1/screens/home/home_screen.dart';

import '../components/round_button.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth=FirebaseAuth.instance;
  bool showSpinner=false;
  final _formkey=GlobalKey<FormState>();
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
  String email="",password="";
  @override


  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          backgroundColor: Colors.blueGrey,
        ),
        backgroundColor: Colors.white,

          body:Padding(

          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [   Text('Login',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller:emailcontroller,
                        keyboardType:TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder()
                        ),
                        onChanged: (String value){
                          email=value;
                        },
                        validator: (value){
                          return value!.isEmpty ? 'Enter Email':null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          controller:passwordcontroller,
                          keyboardType:TextInputType.emailAddress,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: 'Password',
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder()
                          ),
                          onChanged: (String value){
                            password=value;
                          },
                          validator: (value){
                            return value!.isEmpty ? 'Must enter password':null;
                          },
                        ),
                      ),
                      RoundButton(title: 'Login', onPress:() async{
                        if(_formkey.currentState!.validate())
                        {
                          setState(() {
                            showSpinner=true;
                          });
                          try
                          {
                            final user=await _auth.signInWithEmailAndPassword(email: email.toString().trim(),
                                password: password.toString().trim());
                            if(user!=null)
                            {
                              print('success');
                              toastMessage("user successfully Login");
                              setState(() {
                                showSpinner=false;
                              });
                              Navigator.push(context, MaterialPageRoute(builder:(context)=>HomeScreen()));
                            }
                          }catch(e){
                            print(e.toString());
                            toastMessage(e.toString());
                            setState(() {
                              showSpinner=false;
                            });
                          }
                        }
                      })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void toastMessage(String message){
    Fluttertoast.showToast(
        msg:message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
