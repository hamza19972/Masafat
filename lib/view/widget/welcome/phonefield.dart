import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:masafat/core/constant/color.dart';

class Phonefield extends StatelessWidget {
  final String hinttext;
  final String labeltext;
  final IconData iconData;
  final TextEditingController? mycontroller;
  final String? Function(String?) valid;
  final bool isNumber;
  final bool? obscureText;
  final void Function()? onTapIcon;
  final String prefixText; // Add a parameter for prefix text

  const Phonefield({
    Key? key,
    this.obscureText,
    this.onTapIcon,
    required this.hinttext,
    required this.labeltext,
    required this.iconData,
    required this.mycontroller,
    required this.valid,
    required this.isNumber,
    this.prefixText = '+962', // Initialize prefix text with a default value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
      child: TextFormField(
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        validator: valid,
        controller: mycontroller,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
            hintText: hinttext,
            hintStyle: const TextStyle(fontSize: 15,height: 2,fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            suffixIcon: InkWell(child: Icon(iconData), onTap: onTapIcon),
            prefixIcon: Container(
              height: 50,
              width: prefixText.isNotEmpty
                  ? 80
                  : 20, // Adjust width based on if prefix text exists
              margin: const EdgeInsets.only(right: 8,top: 0), // Adjust for spacing
              child: Row(
                
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .start, // Align items to start of Row
                      children: [
                        if (prefixText.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 2,left: 5,top: 2), // Space between text and flag
                            child: Flag.fromCode(
                              FlagsCode.JO,
                              height:
                                  24, // Adjust the height to fit your design
                              width: 40, // Adjust the width to fit your design
                            ),
                          ),
                        Text(prefixText, style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            border: OutlineInputBorder(
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
