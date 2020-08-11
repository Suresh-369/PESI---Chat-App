import 'package:flutter/material.dart';

final primaryColor = Color(0xFF13684B);
final scaffoldColor = Color(0xFF101820);
final impColor = Color(0xFFFFFFFF);

Widget commonAppBar(BuildContext context) {
  return AppBar(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(44),
      ),
    ),
    backgroundColor: primaryColor,
    title: Text(
      'PESI',
      style: TextStyle(
        fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 5.5, fontFamily: 'Courgette', color: impColor,
//            fontStyle: FontStyle.italic,
      ),
    ),
    centerTitle: true,
  );
}

TextStyle textFieldTextStyle() {
  return TextStyle(color: Colors.white, letterSpacing: 1.5);
}

InputDecoration textFieldsInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w500),
    border: InputBorder.none,
  );
}

BoxDecoration bgColorwithShadow() {
  return BoxDecoration(
    color: scaffoldColor,
    boxShadow: customShadow,
    borderRadius: BorderRadius.circular(33.0),
  );
}

final customShadow = [
  BoxShadow(
    color: Colors.white /*withOpacity(0.5)*/,
    blurRadius: 3,
  )
];
