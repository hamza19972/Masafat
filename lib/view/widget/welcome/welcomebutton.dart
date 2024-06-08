import 'package:flutter/material.dart';
import 'package:masafat/core/constant/color.dart';

class Welcomebutton extends StatelessWidget {
  final String buttontext;
  final Color color;
  final void Function() onClic;
  const Welcomebutton(
      {Key? key,
      required this.buttontext,
      required this.color,
      required this.onClic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: MaterialButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: color,
        onPressed: onClic,
        padding: const EdgeInsets.symmetric(horizontal: 130.0, vertical: 12),
        child: Text(buttontext,
            style:
                const TextStyle(fontSize: 16, color: AppColor.backgroundcolor)),
      ),
    );
  }
}
