import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:masafat/core/constant/color.dart';

class CustomTextFormAuth extends StatelessWidget {
  final String hinttext;
  final String labeltext;
  final IconData iconData;
  final TextEditingController? mycontroller;
  final String? Function(String?) valid;
  final bool isNumber;
  final bool? obscureText;
  final void Function()? onTapIcon;

  const CustomTextFormAuth({
    Key? key,
    this.obscureText,
    this.onTapIcon,
    required this.hinttext,
    required this.labeltext,
    required this.iconData,
    required this.mycontroller,
    required this.valid,
    required this.isNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
      child: TextFormField(
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        validator: valid,
        controller: mycontroller,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
            hintText: hinttext,
            hintStyle: const TextStyle(fontSize: 14),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            suffixIcon: InkWell(child: Icon(iconData), onTap: onTapIcon),
            // Adjusting the prefix icon with padding
            prefixIcon: Container(
              // Wrap the Row in a Container
              width: 94, // Adjust the width accordingly
              padding: const EdgeInsets.only(left: 10), // Add padding here
              child: Row(
                // Use Row to place padding and flag in line
                mainAxisAlignment: MainAxisAlignment.start, // Align to start
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10), // Adjust the space between the padding and the flag
                    child: Flag.fromCode(
                      FlagsCode.JO,
                      height: 24, // Adjust the height to fit your design
                      width: 40, // Adjust the width to fit your design
                    ),
                  ),
                ],
              ),
            ),
            border: OutlineInputBorder(
              gapPadding: 20,
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: AppColor.primaryColor,
              ),
            ),
            filled: true,
            fillColor: AppColor.backgroundcolor),
      ),
    );
  }
}
