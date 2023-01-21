import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/json.dart';

class LinkNode extends InlineNode {
  LinkNode(super.json);

  String get url => json[JsonKey.url] ?? "";

  @override
  InlineSpan buildSpan({TextStyle? textStyle}) {
    return TextSpan(
      style: const TextStyle(color: Color(0xFF6698FF)),
      children: children
          .map((child) => child.buildSpan(textStyle: textStyle))
          .whereType<InlineSpan>()
          .toList(),
    );
  }
}
