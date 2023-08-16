import 'package:flutter/material.dart';

import '../utils/app_input_theme.dart';

class CostPolicyScreen extends StatefulWidget{
  const CostPolicyScreen({super.key});

  @override
  State<StatefulWidget> createState() => _StatePolicyState();
}
class _StatePolicyState extends State<CostPolicyScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cost Policy Screen'),
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
                margin: AppInputTheme().marginSpace(),
                child: TextField(
                  decoration: AppInputTheme().buildDecoration(
                      borderText: '기본 시급',
                      writable: true
                  ),
                  enabled: false,
                  // controller: TextEditingController(text: viewModel.store?.location ?? ''),
                )
            ),
            Container(
              margin: AppInputTheme().marginSpace(),
              child: InputDecorator(
                decoration: AppInputTheme().buildDecoration(
                    borderText: "규칙",
                    writable: true
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Expanded(
                          child: Text(
                              '규칙' ,
                              style: TextStyle(fontSize: 16)),
                        ),
                        Expanded(
                            child: Center(
                                child: Text("버튼")
                            )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: AppInputTheme().marginSpace(),
              child: InputDecorator(
                decoration: AppInputTheme().buildDecoration(
                    borderText: "날짜",
                    writable: true
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                            child: Row(
                              children: const [
                                Text('매월', style: TextStyle(fontSize: 16)),
                                Icon(Icons.arrow_drop_down)
                              ] ,
                            )
                        )
                    ),
                    const Expanded(
                      child: Text('양력', style: TextStyle(fontSize: 16)),
                    ),
                    Expanded(
                        child: IconButton(
                          icon:  const Icon(Icons.calendar_month),
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                          },
                        )
                    )
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}