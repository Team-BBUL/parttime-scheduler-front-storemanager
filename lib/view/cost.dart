import 'package:flutter/material.dart';

class CostScreen extends StatelessWidget{
  const CostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cost Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Row(
                children: const [
                  Expanded(
                      child: Icon(Icons.arrow_circle_left)
                  ),
                  Expanded(
                      child: Center(
                        child: Text("2023년 3월"),
                      ),
                  ),
                  Expanded(
                      child: Icon(Icons.arrow_circle_right)
                  )
                ],
              )
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Row(
                children: const [
                  Expanded(
                    child:
                        Text("이번 달 총 인건비")
                  ),
                  Expanded(
                    child: Text(""),
                  ),
                  Expanded(
                    child: Text(""),
                  ),
                ],
              )
          ),
          Container(
              child: Row(
                children: const [
                  Expanded(
                    child: Center(
                        child: Text('10,000,000원', style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
          ),
          Container(
              child: Row(
                children: const [
                  Expanded(
                    child: Center(
                      child: Text("")
                    ),
                  ),
                  Expanded(
                      child: Text("2월 달 보다 20,000원 증가"),
                  )
                ],
              )
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Row(
                children: const [
                  Expanded(
                    child:
                        Text("특정 근무자 별 월급")
                  ),
                  Expanded(
                    child: Text(""),
                  ),
                  Expanded(
                    child: Text(""),
                  ),
                ],
              )
          ),
          Container(
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(40, 20, 0, 0),
                    child: Row(
                      children: [
                        Expanded(
                            child:Row(
                              children: const [
                                Icon(Icons.arrow_drop_down),
                                Text("매니저 홍길동"),
                              ],
                            )
                        ),
                        const Expanded(
                          child: Text(""),
                        ),
                        const Expanded(
                          child: Text(""),
                        ),
                      ],
                    )
                ),
                Container(
                    child: Row(
                      children: const [
                        Expanded(
                          child: Center(
                            child: Text('2,200,000원', style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                    child: Row(
                      children: const [
                        Expanded(
                          child: Center(
                              child: Text("")
                          ),
                        ),
                        Expanded(
                          child: Text("2월 달 보다 원 변동 없음"),
                        )
                      ],
                    )
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(40, 20, 0, 0),
                    child: Row(
                      children: [
                        Expanded(
                            child:Row(
                              children: const [
                                Icon(Icons.arrow_drop_down),
                                Text("직원 성춘향"),
                              ],
                            )
                        ),
                        const Expanded(
                          child: Text(""),
                        ),
                        const Expanded(
                          child: Text(""),
                        ),
                      ],
                    )
                ),
                Container(
                    child: Row(
                      children: const [
                        Expanded(
                          child: Center(
                            child: Text('2,200,000원', style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                    child: Row(
                      children: const [
                        Expanded(
                          child: Center(
                              child: Text("")
                          ),
                        ),
                        Expanded( 
                          child: Text("2월 달 보다 원 변동 없음"),
                        )
                      ],
                    )
                ),
              ],
            )
          )
        ],
      )
    );
  }


}