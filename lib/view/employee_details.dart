import 'package:flutter/material.dart';
import 'package:sidam_storemanager/data/model/user_role.dart';

class EmployeeDetailScreen extends StatefulWidget{
  final UserRole userRole;
  const EmployeeDetailScreen({required this.userRole});
  @override
  State<StatefulWidget> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetailScreen>{
  late String selectedText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Employee Details Screen'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.check_box),
              tooltip: 'Go to the next page',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('기본시급', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                )
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('규칙', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                )
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('날짜', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                )
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Row(
                    children: [
                      Column(
                        children: [
                          Row(
                            children:  [
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('생일', style: TextStyle(fontSize: 16)),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('3.27', style: TextStyle(fontSize: 16)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.calendar_month),
                                onPressed: () async {
                                  final selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now(),
                                  );
                                },
                              )
                            ],
                          ),

                        ],
                      )]
                )
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(widget.userRole.role, style: TextStyle(fontSize: 16)),
                    ),
                  ],
                )
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Column(
                  children: [
                    Row(
                      children:  [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('시급', style: TextStyle(fontSize: 16)),
                        ),

                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Select Text'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        GestureDetector(
                                          child: const Text('시급'),
                                          onTap: () {
                                            setState(() {
                                              selectedText = 'Text 1';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Padding(padding: EdgeInsets.all(8.0)),
                                        GestureDetector(
                                          child: const Text('월급'),
                                          onTap: () {
                                            setState(() {
                                              selectedText = 'Text 2';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('시간당 9,620원', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    )
                  ],
                )
            ),
          ],
        )
    );
  }

}