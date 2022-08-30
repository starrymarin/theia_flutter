import 'package:flutter/material.dart';
import 'package:theia_flutter/text_field.dart';
import 'package:theia_flutter/utils/hex_color.dart';

typedef NodeJson = Map<String, dynamic>;

enum NodeType {
  paragraph,
  inlineCode,
}

extension NodeTypeExtension on NodeType {
  static NodeType? getTypeByName(String name) {
    switch (name) {
      case "inline-code":
        return NodeType.inlineCode;
      case "paragraph":
        return NodeType.paragraph;
    }
    return null;
  }
}

extension NodeJsonExtension on NodeJson {
  bool isText() => containsKey("text");

  Node? toNode() {
    if (isText()) {
      return TextNode(this);
    } else {
      var type = NodeTypeExtension.getTypeByName(this["type"]);
      switch (type) {
        case NodeType.paragraph:
          return ParagraphNode(this);
        case NodeType.inlineCode:
          return InlineCodeNode(this);
        case null:
          return null;
      }
    }
  }
}

abstract class Node {
  Node(this.json);

  final NodeJson json;

  Widget? build();

  InlineSpan? buildSpan({TextStyle? textStyle});
}

abstract class ElementNode extends Node {
  ElementNode(super.json) {
    List<dynamic> nodeJsonList = json["children"];
    for (NodeJson json in nodeJsonList) {
      var node = json.toNode();
      if (node != null) {
        children.add(node);
      }
    }
  }

  String? _key;
  String? get key {
    _key ??= json["key"];
    return _key;
  }

  NodeType? _type;
  NodeType? get type {
    _type ??= NodeTypeExtension.getTypeByName(json["type"]);
    return _type;
  }

  List<Node> children = [];
}

abstract class BlockNode extends ElementNode {
  BlockNode(super.json);

  @override
  Widget build();

  @override
  InlineSpan? buildSpan({TextStyle? textStyle}) => null;
}

abstract class InlineNode extends ElementNode {
  InlineNode(super.json);

  @override
  Widget? build() => null;

  @override
  WidgetSpan buildSpan({TextStyle? textStyle});
}

class TextNode extends Node {
  TextNode(super.json);

  String? _text;
  String get text {
    _text ??= json["text"];
    return _text ?? "";
  }

  Color? _backgroundColor;
  Color? get backgroundColor {
    String? colorString = json["background-color"];
    _backgroundColor ??= colorString != null ? HexColor(colorString) : null;
    return _backgroundColor;
  }

  Color? _color;
  Color? get color {
    String? colorString = json["color"];
    _color ??= colorString != null ? HexColor(colorString) : null;
    return _color;
  }

  @override
  Widget? build() => null;

  @override
  InlineSpan buildSpan({TextStyle? textStyle}) {
    TextStyle newStyle = TextStyle(
        backgroundColor: backgroundColor,
        color: color
    );
    TextStyle style =
        textStyle?.copyWith(
            backgroundColor: newStyle.backgroundColor,
            color: newStyle.color
        ) ?? newStyle;
    return TextSpan(
      text: text,
      style: style
    );
  }
}

class ParagraphNode extends BlockNode {
  ParagraphNode(super.json);

  @override
  Widget build() {
    if (children.isNotEmpty == true) {
      var firstChild = children.first;
      if (firstChild is BlockNode) {
        var childrenWidgets = children
            .map((child) => child.build())
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