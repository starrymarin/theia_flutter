import 'package:theia_flutter/node/text.dart';

import 'internal/alert.dart';
import 'internal/block_quote.dart';
import 'internal/check.dart';
import 'internal/date.dart';
import 'internal/heading.dart';
import 'internal/image.dart';
import 'internal/inline_code.dart';
import 'internal/label.dart';
import 'internal/link.dart';
import 'internal/list.dart';
import 'internal/paragraph.dart';
import 'internal/table.dart';
import 'json.dart';
import 'node.dart';

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
  bool isText() => containsKey(JsonKey.text);

  /// 对于NodeJson的拓展方法来说，想要实现插件功能，必须要把插件作为参数传递到函数
  ///（为什么不可以作为顶层属性或者static属性保存？是因为希望每个theia实例可以有自己的插件）
  Node? toNode(Map<String, NodePlugin>? nodePlugins) {
    Node? node;
    if (isText()) {
      node = TextNode(this);
    } else {
      switch (this[JsonKey.type]) {
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
          node = nodePlugins?[this[JsonKey.type]]?.createNode(this);
          break;
      }
    }
    if (node is ElementNode) {
      node.generateChildren(nodePlugins);
    }
    return node;
  }
}