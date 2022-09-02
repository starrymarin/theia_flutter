import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/text.dart';
import 'package:theia_flutter/text.dart';
import 'package:theia_flutter/node/json.dart' as node_json;
import 'package:theia_flutter/theia.dart';

class ParagraphNode extends BlockNode {
  ParagraphNode(super.json);

  int get indent => json[node_json.indent] ?? 0;
  final int _indentSize = 30;

  ParagraphNodeStyle? _style(BuildContext context) => context
      .findAncestorWidgetOfExactType<ParagraphNodeStyle>();

  @override
  Widget build(BuildContext context, TheiaKey theiaKey) {
    if (children.isNotEmpty == true) {
      var firstChild = children.first;
      if (firstChild is BlockNode) {
        var childrenWidgets = children
            .whereType<BlockNode>()
            .map((child) => Builder(builder: (context) => child.build(context, theiaKey)))
            .whereType<Widget>()
            .toList();
        return Column(
          children: childrenWidgets,
        );
      }

      if (firstChild is InlineNode || firstChild is TextNode) {
        final style = _style(context);
        return Container(
          margin: style?.inlineTextMargin ?? const EdgeInsets.fromLTRB(0, 8, 0, 8),
          padding: EdgeInsets.fromLTRB((_indentSize * indent).toDouble(), 0, 0, 0),
          child: InlineTextField(elementNode: this, theiaKey: theiaKey),
        );
      }
    }
    return Container();
  }
}

class ParagraphNodeStyle extends StatelessWidget {
  const ParagraphNodeStyle({
    Key? key,
    this.inlineTextMargin,
    required this.child
  }) : super(key: key);

  final EdgeInsetsGeometry? inlineTextMargin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }

}