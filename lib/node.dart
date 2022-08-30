import 'package:flutter/material.dart';

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

  bool isText();

  bool isBlock();

  bool isInline();

  Widget build();
}

abstract class ElementNode extends Node {
  ElementNode(super.json) {
    List<NodeJson> nodeJsonList = json["children"];
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

  @override
  bool isText() => false;
}

class TextNode extends Node {
  TextNode(super.json);

  String? _text;
  String get text {
    _text ??= json["text"];
    return _text ?? "";
  }

  @override
  bool isText() => true;

  @override
  bool isBlock() => false;

  @override
  bool isInline() => false;

  @override
  Widget build() {
    return TextField(
      controller: TextEditingController(text: text),
    );
  }
}

class ParagraphNode extends ElementNode {
  ParagraphNode(super.json);

  @override
  bool isBlock() => true;

  @override
  bool isInline() => false;

  @override
  Widget build() {
    if (children.isNotEmpty == true) {
      var firstChild = children.first;
      if (firstChild.isBlock()) {
        var childrenWidgets = children
            .map((child) => child.build())
            .toList();
        return Column(
          children: childrenWidgets,
        );
      }

      if (firstChild.isInline() || firstChild.isText()) {
        return Container();
      }
    }
    return Container();
  }
}

class InlineCodeNode extends ElementNode {
  InlineCodeNode(super.json);

  @override
  bool isBlock() => false;

  @override
  bool isInline() => true;

  @override
  Widget build() {
    return Container();
  }
}