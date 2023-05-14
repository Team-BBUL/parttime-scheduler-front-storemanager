import 'package:flutter/material.dart';

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
          title: const Text('Store Management Screen'),
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
          ],
        )
    );
  }
}