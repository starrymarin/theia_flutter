import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/paragraph.dart';
import 'package:theia_flutter/text.dart';

/// 目前认为block-quote里面只有blockNode，如果出现非BlockNode将会被忽略
class BlockQuoteNode extends BlockNode {
  BlockQuoteNode(super.json);

  @override
  Widget build(BuildContext context) {
    List<Widget> childrenWidgets = [];
    for (var index = 0; index < children.length; index++) {
      var child = children[index];
      if (child is! BlockNode) {
        continue;
      }
      childrenWidgets.add(
        ParagraphNodeStyle(
          inlineTextMargin:
              EdgeInsets.fromLTRB(0, 0, 0, index < children.length - 1 ? 8 : 0),
          child: Builder(builder: (context) => child.build(context)),
        ),
      );
    }

    return InheritedTextTheme(
      textStyle: const TextStyle(color: Color(0xFF999999)),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(color: Color(0xFFEEEEEE), width: 4),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: Column(children: childrenWidgets),
      ),
    );
  }
}
