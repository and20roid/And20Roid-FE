import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MyColor {
  static Color mainColor = const Color(0xFFA4C639);
}

class Common {
  static String url = "http://43.201.223.16:8080/";
}

class SaveSharedPreferences {
  String uTokenKey = "uToken";
  String uNickkey = "uNick";

  void setUserToken(String userToken) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(uTokenKey, userToken);
  }

  Future<String> getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(uTokenKey) ?? "";
  }

  void setUserNick(String userNickname) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(uNickkey, userNickname);
  }

  Future<String> getUserNick() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(uNickkey) ?? "";
  }

}