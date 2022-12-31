import 'package:flutter/material.dart';
import 'package:theia_flutter/node/alert.dart';
import 'package:theia_flutter/node/block_quote.dart';
import 'package:theia_flutter/node/check.dart';
import 'package:theia_flutter/node/date.dart';
import 'package:theia_flutter/node/heading.dart';
import 'package:theia_flutter/node/image.dart';
import 'package:theia_flutter/node/inline_code.dart';
import 'package:theia_flutter/node/label.dart';
import 'package:theia_flutter/node/link.dart';
import 'package:theia_flutter/node/list.dart';
import 'package:theia_flutter/node/paragraph.dart';
import 'package:theia_flutter/node/table.dart';
import 'package:theia_flutter/node/text.dart';

import 'package:theia_flutter/node/json.dart' as node_json;
import 'package:theia_flutter/theia.dart';

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
  static const image = "image";
}

extension NodeJsonExtension on NodeJson {
  bool isText() => containsKey(node_json.text);

  /// 对于NodeJson的拓展方法来说，想要实现插件功能，必须要把插件作为参数传递到函数
  ///（为什么不可以作为顶层属性或者static属性保存？是因为希望每个theia实例可以有自己的插件）
  Node? toNode(Map<String, NodePlugin>? nodePlugins) {
    Node? node;
    if (isText()) {
      node = TextNode(this);
    } else {
      switch (this[node_json.type]) {
        case NodeType.paragraph:
          node = ParagraphNode(this);
          break;
        case NodeType.inlineCode:
          node = InlineCodeNode(this);
          break;
        case NodeType.blockQuote:
          node = BlockQuoteNode(this);
          break;
        case NodeType.numberedList:
          node = NumberedListNode(this);
          break;
        case NodeType.bulletedList:
          node = BulletedListNode(this);
          break;
        case NodeType.listItem:
          node = ListItemNode(this);
          break;
        case NodeType.checkItem:
          node = CheckItemNode(this);
          break;
        case NodeType.table:
          node = TableNode(this);
          break;
        case NodeType.tableRow:
          node = TableRowNode(this);
          break;
        case NodeType.tableCell:
          node = TableCellNode(this);
          break;
        case NodeType.label:
          node = LabelNode(this);
          break;
        case NodeType.date:
          node = DateNode(this);
          break;
        case NodeType.heading1:
          node = HeadingNode(this, Heading.heading1);
          break;
        case NodeType.heading2:
          node = HeadingNode(this, Heading.heading2);
          break;
        case NodeType.heading3:
          node = HeadingNode(this, Heading.heading3);
          break;
        case NodeType.heading4:
          node = HeadingNode(this, Heading.heading4);
          break;
        case NodeType.heading5:
          node = HeadingNode(this, Heading.heading5);
          break;
        case NodeType.heading6:
          node = HeadingNode(this, Heading.heading6);
          break;
        case NodeType.link:
          node = LinkNode(this);
          break;
        case NodeType.alert:
          node = AlertNode(this);
          break;
        case NodeType.image:
          node = ImageNode(this);
          break;
        case null:
          node = null;
          break;
        default:
          node = nodePlugins?[this[node_json.type]]?.createNode(this);
          break;
      }
    }
    // 生成node之后，把plugins保存在node中，是为了执行node.children.toNode时，可以有plugins可用
    node?._plugins = nodePlugins;
    return node;
  }
}

abstract class Node {
  Node(this.json);

  final NodeJson json;

  Map<String, NodePlugin>? _plugins;

  Widget? build(BuildContext context);

  InlineSpan? buildSpan({TextStyle? textStyle});
}

abstract class ElementNode extends Node {
  ElementNode(super.json);

  List<Node>? _children;

  // children的初始化从随着ElementNode构造一起初始化，变成第一次使用时初始化，是因为_plugins是在Node构造完毕后赋值的，参见NodeJson.toNode()
  List<Node> get children {
    if (_children == null) {
      _children = [];
      List<dynamic> nodeJsonList = json[node_json.children];
      for (NodeJson json in nodeJsonList) {
        var node = json.toNode(_plugins);
        if (node != null) {
          _children?.add(node);
        }
      }
    }
    return _children ?? [];
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

class NodePlugin {
  NodePlugin(this.type, this.createNode);

  final String type;

  final Node Function(NodeJson nodeJson) createNode;
}
