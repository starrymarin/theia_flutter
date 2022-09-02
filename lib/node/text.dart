import 'package:flutter/material.dart';
import 'package:theia_flutter/constants.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/json.dart' as node_json;
import 'package:theia_flutter/theia.dart';
import 'package:theia_flutter/utils/color.dart';

class TextNode extends Node {
  TextNode(super.json);

  String get text => json[node_json.text] ?? "";

  Color? get backgroundColor => json[node_json.backgroundColor]?.toString().toColor();

  Color? get color => json[node_json.color]?.toString().toColor();

  double? get fontSize => json[node_json.fontSize]?.toDouble();

  @override
  Widget? build(BuildContext context, TheiaKey theiaKey) => null;

  @override
  InlineSpan buildSpan({TextStyle? textStyle, required TheiaKey theiaKey}) {
    TextStyle newStyle = TextStyle(
      backgroundColor: backgroundColor,
      color: color,
      fontSize: fontSize,
    );
    TextStyle style = textStyle?.merge(newStyle) ?? newStyle;
    return TextSpan(
      text: text,
      style: style,
    );
  }
}