import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mupit/Helper_Functions/Shared_Preference_Helper.dart';
import 'package:mupit/Services/Database.dart';
import 'package:mupit/UI/Home.dart';
import 'package:mupit/UI/Sign_In.dart';
import 'package:mupit/Helper_Functions/Shared_Preference_Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethod
{
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async
  {
   return await auth.currentUser;
  }

  SingOut() async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    await auth.signOut();
  }

  SignInWithGoogle(BuildContext context) async
  {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken
    );

    UserCredential result = await _firebaseAuth.signInWithCredential(credential);

    User user = result.user;

    if(result != null) {
      SharedPreferenceHelper().saveUserID(user.uid);
      SharedPreferenceHelper().saveUserEmail(user.email);
      SharedPreferenceHelper().saveUserName(user.email.replaceAll("@gmail.com", ""));
      SharedPreferenceHelper().saveUserDisplayName(user.displayName);
      SharedPreferenceHelper().saveUserProfileImage(user.photoURL);

      Map<String, dynamic> userInfoMap = {
        "email": user.email,
        "username": user.email.replaceAll("@gmail.com", ""),
        "name": user.displayName,
        "profileurl": user.photoURL
      };


      Database().AddUserInfoToDatabase(user.uid, userInfoMap).then(
              (value) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
              });
    }
  }
}