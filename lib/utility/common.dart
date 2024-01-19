import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomColor {
  static Color mainColor = const Color(0xFFA4C639);
  static Color primary1 = const Color(0XFF00DF7B);
  static Color primary2 = const Color(0XFFE4F5E6);
  static Color primary3 = const Color(0XFF00A84C);
  static Color white = const Color(0XFFFFFFFF);
  static Color grey1 = const Color(0XFFF5F5F7);
  static Color grey2 = const Color(0XFFE7E7E7);
  static Color grey3 = const Color(0XFFACACAC);
  static Color grey4 = const Color(0XFF858585);
  static Color grey5 = const Color(0XFF1D1D1F);
}

class Common {
  static String url = "http://43.201.223.16:8080/";
}

class SaveSharedPreferences {
  String uTokenKey = "uToken";
  String uNickkey = "uNick";
  String profileUrlKey = 'profileUrl';

  Future<void> setUserProfile(String url) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (url != null) {
      preferences.setString(profileUrlKey, url);
    }
  }

  Future<String> getUserProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(profileUrlKey) ?? "";
  }

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
