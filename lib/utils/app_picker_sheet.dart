import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_color.dart';
import 'custom_cupertino_picker.dart';

class AppPickerSheet{
  customCupertinoPicker(String indicator, setTime, selected, times){
    return Container(
      alignment: Alignment.bottomCenter,
      height: 300,
      child: CupertinoPicker(
        backgroundColor: Colors.white,
        magnification: 1.22,
        squeeze: 1.2,
        useMagnifier: true,
        itemExtent: 32.0,
        looping: true,
        selectionOverlay: CustomCupertinoPickerDefaultSelectionOverlay(
          text: indicator,
        ),
        // This sets the initial item.
        scrollController: FixedExtentScrollController(
          initialItem: selected,
        ),
        // This is called when selected item is changed.
        onSelectedItemChanged: (int selectedItem) {
          setTime(selectedItem);
        },
        children:
        List<Widget>.generate(times.length, (int index) {
          return Center(
              child: Text('${times[index]}'));
        }),
      ),
    );
  }

  weekdayPicker(context, selectDay, setDay){

    return Container(
      // color: Colors.white,
        height: 200,
        child : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List<Widget>.generate(7, (int index) {
            index+=1;
            return Expanded(
              child: Container(
                color: selectDay == index ? AppColor().mainColor : Colors.white,
                child: TextButton(
                    onPressed: () {
                      setDay(index);
                      Navigator.pop(context);
                    },
                    child : Text('${_convertWeekdayToKorean(index)}',
                        style: const TextStyle(fontSize: 20, color: Colors.black))
                ),
              ),
            );
          }),
        )
    );
  }

  _convertWeekdayToKorean(weekday) {
    // int? weekday = this.?.weekday;
    if(weekday == 1) {
      return '월';
    }else if(weekday == 2) {
      return '화';
    }else if(weekday == 3) {
      return '수';
    }else if(weekday == 4) {
      return '목';
    }else if(weekday == 5) {
      return '금';
    }else if(weekday == 6) {
      return '토';
    }else if(weekday == 7) {
      return '일';
    }
  }

}