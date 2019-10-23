import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

greyTextView (BuildContext context, String text, double textSize) {
  return RichText(
    text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
              text: text,
              style: TextStyle(
                  fontSize: textSize,
                  color: Colors.grey[800]
              )
          )
        ]
    ),
  );
}