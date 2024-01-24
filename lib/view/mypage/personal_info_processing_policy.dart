import 'package:flutter/material.dart';

import '../../utility/common.dart';

class PersonalInfoProccessingPolicy extends StatelessWidget {
  const PersonalInfoProccessingPolicy({Key? key}) : super(key: key);

  // 개인정보 처리방침 내용 변수
  final String privacyPolicyContent = """
    1. 수집하는 개인 정보의 종류
    - 사용자의 구글 이메일 주소
    - 사용자의 구글 프로필 사진
    
    2. 개인 정보의 수집 및 이용 목적:
    로그인 및 사용자 식별
    
    3. 수집 방법
    처음 시작할 때 사용자가 직접 입력
    
    4. 보유 기간
    개인 정보는 사용자가 서비스를 이용하는 동안에만 보유하며, 서비스 이용 종료 후 즉시 파기
    
    5. 개인 정보의 공유
    사용자의 개인 정보는 해당 서비스에서만 사용되며, 제 3자와 공유하지 않습니다.
    
    6. 보안 조치
    사용자의 개인 정보는 암호화되어 안전하게 보호되며, 접근 권한은 필요한 직원만이 갖도록 제한됩니다.
    
    7. 사용자 권리
    사용자는 언제든지 자신의 개인 정보에 대한 열람, 수정, 삭제를 요청할 수 있습니다.
    
    8. 변경 사항 통지
    개인 정보처리 방침이 변경될 경우, 사용자에게 사전에 알립니다.
    
    9. 연락처 정보
    개인 정보와 관련된 문의나 민원은 ms990926@gmail.com으로 문의 가능합니다.
    
    10. 법적 근거
    개인 정보 수집은 사용자의 동의를 기반으로 하며, 해당 동의를 철회할 수 있는 권리가 있습니다.
    
    11. 권한
    앱에서는 다음과 같은 권한을 요청합니다.
    기기 사진 및 미디어, 카메라: 구글 프로필 사진을 업로드하기 위해 필요합니다.
    인터넷: 서비스에 접근하고 데이터를 업데이트하기 위해 필요합니다.
    계정: 로그인 및 사용자 식별을 위해 Google 계정 정보에 접근합니다.
    알림: 새로운 소식 및 중요 정보를 푸시 알림으로 받아보기 위해 필요합니다.
  """;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColor.grey1,
        appBar: _appBar(),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Text(privacyPolicyContent),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: CustomColor.grey1,
      title: Text("개인정보 처리방침",
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PersonalInfoProccessingPolicy(),
  ));
}
