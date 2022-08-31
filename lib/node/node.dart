import 'package:flutter/material.dart';
import 'package:theia_flutter/text_field.dart';
import 'package:theia_flutter/utils/color.dart';

import 'package:theia_flutter/node/json_constants.dart' as node_json;

typedef NodeJson = Map<String, dynamic>;

class NodeType {
  static const inlineCode = "inline-code";
  static const paragraph = "paragraph";
}

extension NodeJsonExtension on NodeJson {
  bool isText() => containsKey(node_json.text);

  Node? toNode() {
    if (isText()) {
      return TextNode(this);
    } else {
      switch (this[node_json.type]) {
        case NodeType.paragraph:
          return ParagraphNode(this);
        case NodeType.inlineCode:
          return InlineCodeNode(this);
        case null:
          return null;
      }
    }
    return null;
  }
}

abstract class Node {
  Node(this.json);

  final NodeJson json;

  Widget? build(BuildContext context);

  InlineSpan? buildSpan({TextStyle? textStyle});
}

abstract class ElementNode extends Node {
  ElementNode(super.json) {
    List<dynamic> nodeJsonList = json[node_json.children];
    for (NodeJson json in nodeJsonList) {
      var node = json.toNode();
      if (node != null) {
        children.add(node);
      }
    }
  }

  String? _key;
  String? get key {
    _key ??= json[node_json.key];
    return _key;
  }

  String? _type;
  String? get type {
    _type ??= json[node_json.type];
    return _type;
  }

  List<Node> children = [];
}

abstract class BlockNode extends ElementNode {
  BlockNode(super.json);

  @override
  Widget build(BuildContext context);

  @override
  InlineSpan? buildSpan({TextStyle? textStyle}) => null;
}

abstract class InlineNode extends ElementNode {
  InlineNode(super.json);

  @override
  Widget? build(BuildContext context) => null;

  @override
  WidgetSpan buildSpan({TextStyle? textStyle});
}

class TextNode extends Node {
  TextNode(super.json);

  String get text => json[node_json.text] ?? "";

  Color? get backgroundColor => json[node_json.backgroundColor]?.toString().toColor();

  Color? get color => json[node_json.color]?.toString().toColor();

  double get fontSize => json[node_json.fontSize]?.toDouble() ?? 15;

  @override
  Widget? build(BuildContext context) => null;

  @override
  InlineSpan buildSpan({TextStyle? textStyle}) {
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

class ParagraphNode extends BlockNode {
  ParagraphNode(super.json);

  @override
  Widget build(BuildContext context) {
    if (children.isNotEmpty == true) {
      var firstChild = children.first;
      if (firstChild is BlockNode) {
        var childrenWidgets = children
            .map((child) => child.build(context))
            .whereType<Widget>()
            .toList();
        return Column(
          children: childrenWidgets,
        );
      }

      if (firstChild is InlineNode || firstChild is TextNode) {
        return InlineTextField(elementNode: this);
      }
    }
    return Container();
  }
}

class InlineCodeNode extends InlineNode {
  InlineCodeNode(super.json);

  @override
  WidgetSpan buildSpan({TextStyle? textStyle}) {
    return WidgetSpan(child: Container());
  }
}