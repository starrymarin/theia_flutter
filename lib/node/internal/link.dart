import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/json.dart';

class LinkNode extends InlineNode {
  LinkNode(super.json);

  String get url => json[JsonKey.url] ?? "";

  @override
  NodeWidgetSpan buildSpan({TextStyle? textStyle}) {
    return NodeWidgetSpan(
      child: LinkNodeWidget(key: nodeKey, node: this),
    );
  }
}

class LinkNodeWidget extends NodeWidget<LinkNode> {
  const LinkNodeWidget({required super.key, required super.node});

  @override
  NodeWidgetState<NodeWidget<Node>> createState() {
    return LinkNodeWidgetState();
  }
}

class LinkNodeWidgetState extends NodeWidgetState<LinkNodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
        style: const TextStyle(color: Color(0xFF6698FF)),
        children: widget.node.children
            .whereType<SpanNode>()
            .map((child) => child.buildSpan())
            .toList()));
  }
}
