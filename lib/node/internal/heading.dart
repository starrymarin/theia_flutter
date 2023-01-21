import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/text.dart';

enum Heading {
  heading1,
  heading2,
  heading3,
  heading4,
  heading5,
  heading6;

  double get fontSize {
    switch (this) {
      case Heading.heading1: return 32;
      case Heading.heading2: return 28;
      case Heading.heading3: return 24;
      case Heading.heading4: return 20;
      case Heading.heading5: return 18;
      case Heading.heading6: return 16;
    }
  }
}

class HeadingNode extends BlockNode {
  HeadingNode(super.json, this.heading);

  Heading heading;

  @override
  NodeWidget build(BuildContext context) {
    return HeadingNodeWidget(key: key, node: this);
  }
}

class HeadingNodeWidget extends NodeWidget<HeadingNode> {
  const HeadingNodeWidget({required super.key, required super.node});

  @override
  NodeWidgetState<NodeWidget> createState() {
    return HeadingNodeWidgetState();
  }
}

class HeadingNodeWidgetState extends NodeWidgetState<HeadingNodeWidget> {
  @override
  Widget build(BuildContext context) {
    return InheritedTextTheme(
      textStyle: TextStyle(
        fontSize: widget.node.heading.fontSize,
        fontWeight: FontWeight.bold,
      ),
      child: InlineText(node: widget.node, key: widget.node.key),
    );
  }

}
