import '../../model/schedule.dart';
import '../repository/schedule_api_respository.dart';

class FixedScheduleApiRepositoryStub implements ScheduleRemoteRepository{

  @override
  Future<MonthSchedule> getData(String timeStamp) async {

    Map<String,dynamic> testData =
    {
      "date": [
        {
          "id": 1,
          "day": "2023-07-03",
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
        {
          "id": 2,
          "day": "2023-07-04",
          "schedule": [
            {
              "id": 1,
              "time": [true, true, true, true, false, false, false, false, false, false, false, false ],
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
      "time_stamp": "2023-07-08T21:23:52"
    };
    print(testData['time_stamp']);
    print(timeStamp);
    //TODO: response status에 따라 분기처리
    if(testData['time_stamp'] == timeStamp){
      print('스케줄 버전이 최신입니다..');
      return MonthSchedule();
    }
    return MonthSchedule.fromJson(testData);
  }
}

