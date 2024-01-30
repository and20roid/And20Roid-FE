import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomColor {
  static Color mainColor = const Color(0xFFA4C639);
  static Color primary1 = const Color(0XFF00DF7B);
  static Color primary2 = const Color(0XFFE4F5E6);
  static Color primary3 = const Color(0XFF00A84C);
  static Color primary4 = const Color(0XFFE4F5E6);
  static Color white = const Color(0XFFFFFFFF);
  static Color grey1 = const Color(0XFFF5F5F7);
  static Color grey2 = const Color(0XFFE7E7E7);
  static Color grey3 = const Color(0XFFACACAC);
  static Color grey4 = const Color(0XFF858585);
  static Color grey5 = const Color(0XFF1D1D1F);
  static Color gold = const Color(0XFFFFF5BF);
  static Color goldStroke = const Color(0XFFF1CB00);
  static Color silver = const Color(0XFFECECEC);
  static Color silverStroke = const Color(0XFFA3A3A3);
  static Color cooper = const Color(0XFFFCE4CC);
  static Color cooperStroke = const Color(0XFFCD7F32);

}

class Common {
  static String url = "http://43.201.223.16:8080/";

  void showToast(String msg, int nKind) {
    ToastGravity toastGravity;
    if (nKind == 1) {
      toastGravity = ToastGravity.CENTER;
    } else {
      toastGravity = ToastGravity.BOTTOM;
    }

    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: toastGravity,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16);
  }

  void showToastN(BuildContext context, String msg, int nKind) {
    FToast fToast = FToast().init(context);
    Widget toast = Container(
      margin: EdgeInsets.zero,
      child: Stack(children: <Widget>[
        Positioned(
            top: 20,
            bottom: 20,
            left: 1,
            right: 1,
            child: Container(
              margin: EdgeInsets.zero,
              child:
              Image.asset('assets/images/toastbg.png', fit: BoxFit.fill),
            )),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: 30,
              height: 50,
              margin: EdgeInsets.zero,
              child: Image.asset('assets/images/logoNoback.png'),
            )),
        Container(
          padding:
          const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 30, bottom: 30),
          child: Text(
            msg,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: CustomColor.grey5),
          ),
        ),
      ]),
    );

    fToast.showToast(
      child: toast,
      gravity: nKind == 1 ? ToastGravity.CENTER : ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

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
