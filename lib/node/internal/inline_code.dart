import 'package:flutter/material.dart';
import 'package:theia_flutter/constants.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/text.dart';
import 'package:theia_flutter/theia.dart';

class InlineCodeNode extends InlineNode {
  InlineCodeNode(super.json);

  @override
  NodeWidgetSpan buildSpan({TextStyle? textStyle}) {
    return NodeWidgetSpan(
      child: InlineCodeNodeWidget(key: key, node: this),
      baseline: TextBaseline.alphabetic,
      alignment: PlaceholderAlignment.baseline,
    );
  }
}

class InlineCodeNodeWidget extends NodeWidget<InlineNode> {
  const InlineCodeNodeWidget({required super.key, required super.node});

  @override
  NodeWidgetState<NodeWidget<Node>> createState() {
    return InlineCodeNodeWidgetState();
  }
}

class InlineCodeNodeWidgetState extends NodeWidgetState<InlineCodeNodeWidget> {
  final board = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(
      color: Color(0xFFDDDDDD),
      width: 1,
    ),
  );

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontFamily: monospace, color: Color(0xFF666666));
    Widget content = Text.rich(
      TextSpan(
        children: widget.node.children
            .whereType<SpanNode>()
            .map((child) => child.buildSpan())
            .toList(growable: false),
      ),
      style: inheritedTextStyle(context)?.merge(style) ?? style,
      maxLines: 1,
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 2, 6),
      // 本来left也应该是2，但不知为何TextField右边总是有大约2的padding
      margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDDDDDD), width: 0.5),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: const Color(0xFFF5F5F5),
      ),
      child: IntrinsicWidth(
        child: content,
      ),
    );
  }
}
