import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/utils/color.dart';

import 'json.dart';

class TextNode extends Node {
  TextNode(super.json);

  String get text => json[JsonKey.text] ?? "";

  Color? get backgroundColor =>
      json[JsonKey.backgroundColor]?.toString().toColor();

  Color? get color => json[JsonKey.color]?.toString().toColor();

  double? get fontSize => json[JsonKey.fontSize]?.toDouble();

  bool? get bold => json[JsonKey.bold];

  bool? get italic => json[JsonKey.italic];

  bool? get underlined => json[JsonKey.underlined];

  bool? get strikethrough => json[JsonKey.strikethrough];

  @override
  Widget? build(BuildContext context) => null;

  @override
  InlineSpan buildSpan({TextStyle? textStyle}) {
    TextStyle newStyle = TextStyle(
      backgroundColor: backgroundColor,
      color: color,
      fontSize: fontSize,
      fontWeight: bold ?? false ? FontWeight.bold : textStyle?.fontWeight,
      fontStyle: italic ?? false ? FontStyle.italic : textStyle?.fontStyle,
      decoration: TextDecoration.combine([
        underlined ?? false ? TextDecoration.underline : TextDecoration.none,
        strikethrough ?? false ? TextDecoration.lineThrough : TextDecoration.none,
      ]),
    );

    TextStyle style = textStyle?.merge(newStyle) ?? newStyle;
    return TextSpan(
      text: text,
      style: style,
    );
  }
}
