import 'package:flutter/material.dart';
import 'package:theia_flutter/node/alert.dart';
import 'package:theia_flutter/node/block_quote.dart';
import 'package:theia_flutter/node/check.dart';
import 'package:theia_flutter/node/date.dart';
import 'package:theia_flutter/node/heading.dart';
import 'package:theia_flutter/node/inline_code.dart';
import 'package:theia_flutter/node/label.dart';
import 'package:theia_flutter/node/link.dart';
import 'package:theia_flutter/node/list.dart';
import 'package:theia_flutter/node/paragraph.dart';
import 'package:theia_flutter/node/table.dart';
import 'package:theia_flutter/node/text.dart';

import 'package:theia_flutter/node/json.dart' as node_json;

typedef NodeJson = Map<String, dynamic>;

class NodeType {
  static const inlineCode = "inline-code";
  static const paragraph = "paragraph";
  static const blockQuote = "block-quote";
  static const numberedList = "numbered-list";
  static const bulletedList = "bulleted-list";
  static const listItem = "list-item";
  static const checkItem = "check-item";
  static const table = "table";
  static const tableRow = "table-row";
  static const tableCell = "table-cell";
  static const label = "label";
  static const date = "date";
  static const heading1 = "heading-one";
  static const heading2 = "heading-two";
  static const heading3 = "heading-three";
  static const heading4 = "heading-four";
  static const heading5 = "heading-five";
  static const heading6 = "heading-six";
  static const link = "link";
  static const alert = "alert";
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
        case NodeType.listItem:
          return ListItemNode(this);
        case NodeType.checkItem:
          return CheckItemNode(this);
        case NodeType.table:
          return TableNode(this);
        case NodeType.tableRow:
          return TableRowNode(this);
        case NodeType.tableCell:
          return TableCellNode(this);
        case NodeType.label:
          return LabelNode(this);
        case NodeType.date:
          return DateNode(this);
        case NodeType.heading1:
          return HeadingNode(this, Heading.heading1);
        case NodeType.heading2:
          return HeadingNode(this, Heading.heading2);
        case NodeType.heading3:
          return HeadingNode(this, Heading.heading3);
        case NodeType.heading4:
          return HeadingNode(this, Heading.heading4);
        case NodeType.heading5:
          return HeadingNode(this, Heading.heading5);
        case NodeType.heading6:
          return HeadingNode(this, Heading.heading6);
        case NodeType.link:
          return LinkNode(this);
        case NodeType.alert:
          return AlertNode(this);
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
  InlineSpan buildSpan({TextStyle? textStyle});
}