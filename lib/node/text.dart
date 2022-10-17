import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/json.dart' as node_json;
import 'package:theia_flutter/utils/color.dart';

class TextNode extends Node {
  TextNode(super.json);

  String get text => json[node_json.text] ?? "";

  Color? get backgroundColor => json[node_json.backgroundColor]?.toString().toColor();

  Color? get color => json[node_json.color]?.toString().toColor();

  double? get fontSize => json[node_json.fontSize]?.toDouble();

  bool? get bold => json[node_json.bold];

  bool? get italic => json[node_json.italic];

  bool? get underlined => json[node_json.underlined];

  bool? get strikethrough => json[node_json.strikethrough];

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
