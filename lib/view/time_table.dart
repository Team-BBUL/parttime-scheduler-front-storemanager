import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sidam_storemanager/view/widget/weekly_schedule_viewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:sidam_storemanager/utils/app_color.dart';

class TimeTableScreen  extends StatelessWidget{
  TimeTableScreen({super.key});

  AppColor color = AppColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주간 시간표'),
        centerTitle: true,
        actions: [
          TextButton(onPressed: (){
            launchUrl(
              Uri.parse('https://naver.com/')
            );
          }, child: Text('수정'))
        ],
      ),
        body: Center(
          child: WeeklyScheduleViewer(),
        )
    );
  }

  Widget scheduleView() {
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
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev')); // 접속할 url 여기에 토큰 추가

    return Scaffold(
        body: WebViewWidget(
          controller: controller,
        ));
  }
}