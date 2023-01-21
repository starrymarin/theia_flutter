import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/internal/paragraph.dart';
import 'package:theia_flutter/text.dart';

enum ListType { numbered, bulleted }

abstract class ListNode extends BlockNode {
  ListNode(super.json);

  ListType listType();

  @override
  NodeWidget build(BuildContext context) {
    return ListNodeWidget(key: key, node: this);
  }
}

class ListNodeWidget extends NodeWidget<ListNode> {
  const ListNodeWidget({required super.key, required super.node});

  @override
  NodeWidgetState<NodeWidget<Node>> createState() {
    return ListNodeWidgetState();
  }
}

class ListNodeWidgetState extends NodeWidgetState<ListNodeWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    for (var index = 0; index < widget.node.children.length; index++) {
      final child = widget.node.children[index];
      if (child is! ListItemNode) {
        continue;
      }
      child.index = index;
      child.listType = widget.node.listType();
      items.add(ParagraphNodeStyle(
        inlineTextMargin: EdgeInsets.zero,
        child: Builder(
          builder: (context) {
            return child.build(context);
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

  late int index;

  late ListType listType;

  @override
  NodeWidget<Node> build(BuildContext context) {
    return ListItemNodeWidget(key: key, node: this);
  }
}

class ListItemNodeWidget extends NodeWidget<ListItemNode> {
  const ListItemNodeWidget({required super.key, required super.node});

  @override
  NodeWidgetState<NodeWidget<Node>> createState() {
    return ListItemNodeWidgetState();
  }
}

class ListItemNodeWidgetState extends NodeWidgetState<ListItemNodeWidget> {
  @override
  Widget build(BuildContext context) {
    var label = "";
    var labelStyle = inheritedTextStyle(context);
    switch (widget.node.listType) {
      case ListType.numbered:
        label = "${widget.node.index + 1}. ";
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
              children: widget.node.children
                  .whereType<BlockNode>()
                  .map(
                    (child) => Builder(
                      builder: (context) {
                        return child.build(context);
                      },
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
