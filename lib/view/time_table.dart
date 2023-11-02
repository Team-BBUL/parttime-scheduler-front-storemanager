import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sidam_storemanager/utils/sp_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sidam_storemanager/view/widget/weekly_schedule_viewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:sidam_storemanager/utils/app_color.dart';

class TimeTableScreen  extends StatelessWidget{
  TimeTableScreen({super.key});

  AppColor color = AppColor();
  SPHelper sp = SPHelper();

  void initSp() async {
    sp.init();
  }

  @override
  Widget build(BuildContext context) {
    initSp();
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: const Text('주간 시간표'),
        centerTitle: true,
        actions: [
          TextButton(onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute<void>(builder: (BuildContext context) => editSchedule())//scheduleView())
            );

            /*var url = Uri.parse('https://release.d26jxlq0zcsb2a.amplifyapp.com/login');
            if (await canLaunchUrl(url)) {
              await launchUrl(
                url,
                webViewConfiguration: WebViewConfiguration(headers: {
                  "jwtToken" : "Bearer ${sp.getJWT()}",
                  "roleId" : "${sp.getRoleId()}",
                  "storeId" : "${sp.getStoreId()}"
                })
              );
            }*/
          }, child: Text('수정'))
        ],
      ),
        body: Center(
          child: WeeklyScheduleViewer(),
        )
    );
  }

  Widget scheduleView() {
    var cookieManager = WebViewCookieManager()
      .setCookie(WebViewCookie(name: "jwtToken", value: sp.getJWT(), domain: "https://release.d26jxlq0zcsb2a.amplifyapp.com/"));

    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // 자바 스크립트 사용 여부
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        // 웹뷰 이벤트 처리
        NavigationDelegate(
          onProgress: (int progress) {
            // 창 로딩 중에 할 일
            debugPrint('progressing $progress');
          },
          onPageStarted: (String url) {
            // 페이지 시작 때 할 일
            debugPrint(url);
          },
          onPageFinished: (String url) {
            // 페이지 닫을 때 할 일
            debugPrint('Page Finished');
          },
          onWebResourceError: (WebResourceError error) {
            // 웹에 에러 났을 때
            debugPrint('web error');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://release.d26jxlq0zcsb2a.amplifyapp.com/login')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..runJavaScript("window.localStorage.setItem('jwtToken','${sp.getJWT()}')")
      ..runJavaScript("window.localStorage.setItem('roleId','${sp.getRoleId()}')")
      ..runJavaScript("window.localStorage.setItem('storeId','${sp.getStoreId()}')")
      ..loadRequest(Uri.parse('https://release.d26jxlq0zcsb2a.amplifyapp.com/login')); // 접속할 url 여기에 토큰 추가

    return Scaffold(
        body: WebViewWidget(
          controller: controller,
        )
    );
  }

  Widget editSchedule() {

    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse('https://release.d26jxlq0zcsb2a.amplifyapp.com/login')),
        onLoadStart: (InAppWebViewController controller, Uri? url) async {
          debugPrint('${sp.getRoleId()}\n${sp.getJWT()}\n${sp.getStoreId()}');
          await controller.evaluateJavascript(source: """
          window.localStorage.setItem('jwtToken','Bearer ${sp.getJWT()}');
          window.localStorage.setItem('roleId','${sp.getRoleId()}');
          window.localStorage.setItem('storeId','${sp.getStoreId()}');
          """);
        },
      ),
    );
  }
}