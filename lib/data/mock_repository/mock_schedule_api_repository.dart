import 'dart:developer';

import '../../model/schedule.dart';
import '../repository/schedule_api_respository.dart';
import '../repository/schedule_local_repository.dart';

class FixedScheduleApiRepositoryStub implements ScheduleRemoteRepository{

  @override
  Future<MonthSchedule> fetchSchedule(String timeStamp, int year, int month, int day) async {

    Map<String,dynamic> testData =
    {
      "date": [
        {
          "id": 1,
          "day": "2023-09-01",
          "schedule": [
            {
              "id": 1,
              "time": [true, true, true, true, true, false, false, false, false, false, false, false ],
              "workers": [
                {
                  "id": 1,
                  "alias": "홍길동",
                  "color": "0xFF000000",
                  "cost": 10000
                }
              ]
            },
            {
              "id": 2,
              "time": [false, false, false, true, true, true, true, true, true, false, false, false ],
              "workers": [
                {
                  "id": 1,
                  "alias": "최판서",
                  "color": "0xFF000000",
                  "cost": 10000
                },
                {
                  "id": 2,
                  "alias": "홍길동",
                  "color": "0xFF000000",
                  "cost": 10000
                }
              ]
            },
            {
              "id": 3,
              "time": [false, false, false, false, true, true, true, true, false, false, false, false ],
              "workers": [
                {
                  "id": 1,
                  "alias": "김길동",
                  "color": "0xFF000000",
                  "cost": 10000
                }
              ]
            },
            {
              "id": 4,
              "time": [false, false, false, false, false, true, true, true, true, false, false, false ],
              "workers": [
                {
                  "id": 1,
                  "alias": "성춘향",
                  "color": "0xFF000000",
                  "cost": 10000
                }
              ]
            },
            {
              "id": 5,
              "time": [false, false, false, false, false, false, true, true, true, true, false, false ],
              "workers": [
                {
                  "id": 1,
                  "alias": "아무개",
                  "color": "0xFF000000",
                  "cost": 20000
                }
              ]
            },
            {
              "id": 6,
              "time": [false, false, false, false, false, false, false, true, true, true, true, false ],
              "workers": [
                {
                  "id": 1,
                  "alias": "박아무",
                  "color": "0xFF000000",
                  "cost": 20000
                }
              ]
            }
          ]
        },
        {
          "id": 2,
          "day": "2023-09-02",
          "schedule": [
            {
              "id": 1,
              "time": [true, true, true, true, false, false, false, false, false, false, false, false ],
              "workers": [
                {
                  "id": 1,
                  "alias": "홍길동",
                  "color": "0xFF000000",
                  "cost": 20000
                }
              ]
            },
            {
              "id": 2,
              "time": [false, false, false, true, true, true, true, false, false, false, false, false ],
              "workers": [
                {
                  "id": 1,
                  "alias": "최판서",
                  "color": "0xFF000000",
                  "cost": 10000
                }
              ]
            },
            {
              "id": 3,
              "time": [false, false, false, false, true, true, true, true, false, false, false, false ],
              "workers": [
                {
                  "id": 1,
                  "alias": "김길동",
                  "color": "0xFF000000",
                  "cost": 10000
                }
              ]
            },
            {
              "id": 4,
              "time": [false, false, false, false, false, true, true, true, true, false, false, false ],
              "workers": [
                {
                  "id": 1,
                  "alias": "성춘향",
                  "color": "0xFF000000",
                  "cost": 10000
                }
              ]
            },
            {
              "id": 5,
              "time": [false, false, false, false, false, false, true, true, true, true, false, false ],
              "workers": [
                {
                  "id": 1,
                  "alias": "아무개",
                  "color": "0xFF000000",
                  "cost": 10000
                }
              ]
            },
            {
              "id": 6,
              "time": [false, false, false, false, false, false, false, true, true, true, true, false ],
              "workers": [
                {
                  "id": 1,
                  "alias": "박아무",
                  "color": "0xFF000000",
                  "cost": 10000
                }
              ]
            }
          ]
        },
        null,
        null,
        null,
        null,
      ],
      "time_stamp": "2023-09-04T21:23:52"
    };

    //TODO: response status에 따라 분기처리
    if(testData['time_stamp'] == timeStamp){
      log('스케줄 버전이 최신입니다...');
      return MonthSchedule();
    }else{
      log('스케줄 버전 정보가 다릅니다...');
      await ScheduleLocalRepository().saveSchedule(testData, testData['time_stamp']);
    }
    return MonthSchedule.fromJson(testData);
  }
}

