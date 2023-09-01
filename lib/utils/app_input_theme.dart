import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_color.dart';

class AppInputTheme{
  InputDecoration buildDecoration({required String borderText,required bool writable}) => InputDecoration(
    contentPadding: EdgeInsets.all(12.0),
    enabled: writable,
    disabledBorder: AppInputTheme()._buildBorder(),
    border: AppInputTheme()._buildBorder(),
    labelText: borderText,
    labelStyle: TextStyle(color: Colors.grey[800], fontSize: 20.0),
    floatingLabelBehavior:FloatingLabelBehavior.always,
    enabledBorder: AppInputTheme()._buildBorder(),
    focusedBorder: AppInputTheme()._buildBorder(),
  );

  OutlineInputBorder _buildBorder(){
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(width: 2, color: AppColor().mainColor)
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
    border: Border.all(width: 2, color: AppColor().mainColor),
    borderRadius: BorderRadius.circular(14),
  );

  EdgeInsets marginSpace(){
    return const EdgeInsets.symmetric(vertical: 10,horizontal: 20);
  }

  InputDecoration registerDecoration({required String hint}) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey),
        ),
      );
}

