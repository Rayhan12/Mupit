import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper
{

  // Setting Up Keys For Firebase
  static String userIDKey = "USERIDKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userDisplayNameKey = "USERSIDPLAYNAME";
  static String userEmailKey = "USEREMAIL";
  static String userProfileImageKey = "USERPROFILEIMAGE";


  // Saving User Data
  Future<bool> saveUserID (String userID) async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userIDKey, userID);
  }

  Future<bool> saveUserName (String userName) async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userNameKey, userName);
  }

  Future<bool> saveUserDisplayName (String userDisplayName) async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userDisplayNameKey, userDisplayName);
  }

  Future<bool> saveUserEmail (String userEmail) async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userEmailKey, userEmail);
  }

  Future<bool> saveUserProfileImage (String userProfileImage) async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userProfileImageKey, userProfileImage);
  }

  //Getting User Data

  Future<String> getUserID () async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userIDKey);
  }

  Future<String> getUserName () async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userNameKey);
  }

  Future<String> getUserDisplayName () async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userDisplayNameKey);
  }

  Future<String> getUserEmail () async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userEmailKey);
  }

  Future<String> getUserProfileImage () async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userProfileImageKey);
  }

}