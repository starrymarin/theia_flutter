import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/text.dart';
import 'package:theia_flutter/text_field.dart';

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
        return Container(
          margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: InlineTextField(elementNode: this),
        );
      }
    }
    return Container();
  }
}