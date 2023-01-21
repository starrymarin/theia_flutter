import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/json.dart';
import 'package:theia_flutter/text.dart';

class CheckItemNode extends BlockNode {
  CheckItemNode(super.json);

  @override
  NodeWidget build(BuildContext context) {
    return CheckItemNodeWidget(key: key, node: this);
  }
}

class CheckItemNodeWidget extends NodeWidget<CheckItemNode> {
  const CheckItemNodeWidget({required super.key, required super.node});

  @override
  NodeWidgetState<NodeWidget> createState() {
    return CheckItemNodeWidgetState();
  }
}

class CheckItemNodeWidgetState extends NodeWidgetState<CheckItemNodeWidget> {

  bool get checked => widget.node.json[JsonKey.checked];

  @override
  Widget build(BuildContext context) {
    Icon icon;
    if (checked) {
      icon = const Icon(
        Icons.check_box,
        color: Color(0xFF6698FF),
        size: 18,
      );
    } else {
      icon = const Icon(
        Icons.check_box_outline_blank_rounded,
        color: Color(0xFFDDDDDD),
        size: 18,
      );
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
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 6, 0),
              child: icon,
            ),
          ),
          Expanded(child: InlineTextField(node: widget.node)),
        ],
      ),
    );
  }
}
