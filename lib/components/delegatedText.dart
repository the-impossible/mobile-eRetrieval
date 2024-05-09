import 'package:e_retrieval/utils/constant.dart';
import 'package:flutter/material.dart';

class DelegatedText extends StatelessWidget {
  final String text;
  final double fontSize;
  String? fontName = 'InterBold';
  Color? color = Constants.basicColor;
  TextAlign? align;
  bool? truncate;

  DelegatedText({
    required this.text,
    required this.fontSize,
    this.fontName,
    this.color,
    this.align,
    this.truncate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      (truncate == true) ? truncateString(text, 20) : text,
      softWrap: true,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        letterSpacing: 1,
        fontFamily: fontName,
      ),
      textAlign: align,
      overflow: (truncate == true) ? TextOverflow.ellipsis : null,
    );
  }

  String truncateString(String input, int maxLength) {
    if (input.length <= maxLength) {
      return input;
    } else {
      return "${input.substring(0, maxLength)}...";
    }
  }
}
