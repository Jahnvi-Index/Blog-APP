import 'package:firebase_auth/firebase_auth.dart';
class AuthService
{
  //sign in anon
  //sign in with email and password
  //register with email and password
  //sign out
  final FirebaseAuth _auth=FirebaseAuth.instance;
  Future signInAnon()  async
  {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    }catch(e)
    {
      print(e.toString());
      return null;
    }
  }
}