import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/internal/paragraph.dart';
import 'package:theia_flutter/text.dart';

enum ListType { numbered, bulleted }

abstract class ListNode extends BlockNode {
  ListNode(super.json);

  ListType listType();

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    for (var index = 0; index < children.length; index++) {
      final child = children[index];
      if (child is! ListItemNode) {
        continue;
      }
      items.add(ParagraphNodeStyle(
        inlineTextMargin: EdgeInsets.zero,
        child: Builder(
          builder: (context) {
            return child.buildByListType(context, index, listType());
          },
        ),
      ));
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Column(children: items),
    );
  }
}

class NumberedListNode extends ListNode {
  NumberedListNode(super.json);

  @override
  ListType listType() => ListType.numbered;
}

class BulletedListNode extends ListNode {
  BulletedListNode(super.json);

  @override
  ListType listType() => ListType.bulleted;
}

class ListItemNode extends BlockNode {
  ListItemNode(super.json);

  /// use [buildByListType]
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget buildByListType(BuildContext context, int index, ListType listType) {
    var label = "";
    var labelStyle = inheritedTextStyle(context);
    switch (listType) {
      case ListType.numbered:
        label = "${index + 1}. ";
        break;
      case ListType.bulleted:
        label = "\u2022  ";
        labelStyle =
            const TextStyle(fontWeight: FontWeight.w900).merge(labelStyle);
        break;
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Container(
            alignment: Alignment.topRight,
            width: 30,
            child: IntrinsicWidth(
              child: RichText(
                text: TextSpan(text: label, style: labelStyle),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: children
                  .whereType<BlockNode>()
                  .map((child) => Builder(builder: (context) {
                        return child.build(context);
                      }))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
