import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/utils/app_color.dart';
import 'package:sidam_storemanager/view_model/store_list_view_model.dart';

import '../../view_model/schedule_view_model.dart';

class ScheduleViewer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ScheduleViewerState();
}

class ScheduleViewerState extends State<ScheduleViewer> {
  AppColor color = AppColor();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    var week = ['error', '월', '화', '수', '목', '금', '토', '일'];
    DateTime now = DateTime.now();

    return Consumer<ScheduleViewModel>(builder: (context, state, child) {
      return SizedBox(
          height: deviceHeight - 250,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Stack(children: [
                    Positioned(
                        top: 0,
                        left: (deviceWidth / 2) - 75,
                        child: Column(children: [
                          const Text(
                            '오늘의 근무자',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${DateFormat('M월 d일').format(now)} ${week[now.weekday]}요일',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ])),
                    Positioned(
                      top: 10,
                      right: 5,
                      child: IconButton(
                          onPressed: () {
                            state.renew();
                          },
                          icon: const Icon(
                            Icons.cached,
                            color: Colors.black54,
                          )),
                    )
                  ])),
              timeTable(deviceWidth, deviceHeight),
            ],
          ));
    });
  }

  Widget timeTable(double deviceWidth, double deviceHeight) {
    return Consumer2<ScheduleViewModel, StoreListViewModel>(
        builder: (context, schedule, store, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: SizedBox(
          width: deviceWidth - 20,
          height: deviceHeight - 320,
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
              itemCount:
                  ((store.store!.closed ?? 0) - (store.store!.open ?? 0)) < 0
                      ? 0
                      : (store.store!.closed ?? 0) - (store.store!.open ?? 0),
              itemBuilder: (context, idx) {
                int before = idx - 1 < 0 ? 12 : idx - 1;
                return SizedBox(
                  width: double.infinity,
                    height: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '${idx + (store.store!.open ?? 0)}:00',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Row(
                                  children: [
                                    for(int i = 0; i < (schedule.today.length); i++)...[
                                      Container(
                                        alignment: Alignment.center,
                                        height: 38,
                                        width: (deviceWidth - 90) / (schedule.today.isEmpty ? 1 : schedule.today.length),
                                        color: schedule.today[i].time[idx]
                                            ? Color(int.parse(schedule.today[i].worker.color ?? '0xFFFFFFFF'))
                                            : Colors.black12,
                                        child: Text(schedule.today[i].time[idx] && !schedule.today[i].time[before]
                                            ? schedule.today[i].worker.alias ?? ''
                                            : '',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),

                                    ]
                                  ]
                              )
                            ]
                        )
                      ]
                    )
                );
              }),
        ),
      );
    });
  }
}
