import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HorizontalLine extends StatelessWidget {
  const HorizontalLine({
     this.label,
     this.height,
  });

  final String? label;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: Divider(
              color: Colors.black,
              height: height,
            )),
      ),
      if(label != null)
        Text(label!),

      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              color: Colors.black,
              height: height,
            )),
      ),
    ]);
  }
}