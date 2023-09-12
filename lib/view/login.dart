import 'package:flutter/material.dart';

import 'login_web_view_page.dart';

class LoginScreen extends StatelessWidget {
  final _designWidth = 411;
  final _designHeight = 683;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    double maxWidth = 280 * deviceWidth / _designWidth;

    return Scaffold(
      appBar: AppBar(
        //title: const Text('로그인'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("\"시담\"에 오신 것을 환영합니다.\n "
                "\"시담\"은 점주님의 아르바이트 스케줄\n "
                "관리를 위한 앱입니다."),
            const SizedBox(height: 10, width: 2,),
            const Divider(
              indent: 20,
              endIndent: 20,
            ),
            Flexible(
                child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginWebViewPage()) // (context) => WebViewWidget(controller: _webViewController,))
                    );
              },
              icon: Image.asset('asset/image/kakao_login_medium_narrow.png'),
            )),
            const SizedBox(
              height: 30, width: 2,
            ),
            Flexible(
                child: SizedBox(
              width: maxWidth,
              child: const Text(
                    '위의 "카카오 로그인"을 선택하면, '
                    '시담의 이용약관 및 개인정보 보호정책을 읽고 이해했으며, '
                    '그에 동의하는 것으로 간주됩니다.',
                style: TextStyle(color: Colors.grey),
              ),
            )),
            Flexible(child: Container()),
            Flexible(child: Container()),
          ],
        ),
      ),
    );
  }
}
