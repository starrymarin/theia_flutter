import 'package:flutter/material.dart';
import 'package:theia_flutter/node/block_quote.dart';
import 'package:theia_flutter/node/inline_code.dart';
import 'package:theia_flutter/node/list.dart';
import 'package:theia_flutter/node/paragraph.dart';
import 'package:theia_flutter/node/text.dart';

import 'package:theia_flutter/node/json.dart' as node_json;

typedef NodeJson = Map<String, dynamic>;

class NodeType {
  static const inlineCode = "inline-code";
  static const paragraph = "paragraph";
  static const blockQuote = "block-quote";
  static const numberedList = "numbered-list";
  static const bulletedList = "bulleted-list";
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
        case NodeType.blockQuote:
          return BlockQuoteNode(this);
        case NodeType.numberedList:
          return NumberedListNode(this);
        case NodeType.bulletedList:
          return BulletedListNode(this);
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