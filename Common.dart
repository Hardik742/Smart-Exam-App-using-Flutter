import 'package:flutter/material.dart';

Widget addtion({Color containerColor = Colors.blue, String text = "hardik"}) {
  return Container(
    color: containerColor,
    child: Text(
      text,
      style: TextStyle(fontSize: 100, color: Colors.green),
    ),
  );
}

Widget appButton({required Function() click}) {
  return GestureDetector(
    onTap: () {
      click();
    },
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
      decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Center(
        child: Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}

Widget appButtonWithRequiredParameter({required Function() click}) {
  return GestureDetector(
    onTap: () {
      click();
    },
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
      decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Center(
        child: Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
