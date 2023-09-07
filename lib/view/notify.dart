import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/utils/app_picker_sheet.dart';

import '../utils/dialog_message.dart';
import '../view_model/notify_view_model.dart';
import '../utils/custom_cupertino_picker.dart';

class NotifyScreen extends StatelessWidget {
  const NotifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('알림 설정'),
          centerTitle: true,
        ),
        body : Consumer<NotifyViewModel>(
            builder: (context, viewModel, _) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom : BorderSide(width: 1, color: Colors.black12)
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("알림", style: TextStyle(fontSize: 16)),
                                Container(child: toggleButton(viewModel,'notify'))
                              ],
                            )
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom : BorderSide(width: 1, color: Colors.black12)
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("근무표 작성 및 수정 알림", style: TextStyle(fontSize: 16)),
                                Container(child: toggleButton(viewModel,'modifyNotify'))
                              ],
                            )
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom : BorderSide(width: 1, color: Colors.black12)
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("근무변경요청 알림", style: TextStyle(fontSize: 16)),
                                Container(child: toggleButton(viewModel,'changeRequestNotify'))
                              ],
                            )
                        )
                    ),
                  ]
              );
            }
        )
    );
  }
  Widget toggleButton(viewModel, String key){
    return FlutterSwitch(
      width: 40,
      height: 25,
      toggleSize: 17,
      padding: 2,
      value: viewModel.notifyList[key]!,
      activeColor: Color(0xFF7CFF67),
      onToggle: (bool value) {
        viewModel.toggle(key);
        },
    );
  }

  // 동기적으로 처리하여 모달팝업이 pop될 시 api호출 function을 작동하게 함.
  showDialog(Widget child, context,viewModel) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 3.0),
        // The bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: true,
          child: child,
        ),
      ),
    );
    viewModel.sendTime(viewModel.selectedNotifyWorkTime);
  }
}
