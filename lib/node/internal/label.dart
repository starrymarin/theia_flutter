import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/json.dart';
import 'package:theia_flutter/utils/color.dart';

class LabelNode extends InlineNode {
  LabelNode(super.json);

  String get label => json[JsonKey.label] ?? "";

  Color? get color => json[JsonKey.color]?.toString().toColor();

  @override
  InlineSpan buildSpan({TextStyle? textStyle}) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: LabelNodeWidget(key: key, node: this),
    );
  }
}

class LabelNodeWidget extends NodeWidget<LabelNode> {
  const LabelNodeWidget({super.key, required super.node});

  @override
  NodeWidgetState createState() {
    return LabelNodeWidgetState();
  }
}

class LabelNodeWidgetState extends NodeWidgetState<LabelNodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      constraints: const BoxConstraints(
        maxWidth: 160,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: widget.node.color?.withOpacity(0.1),
      ),
      child: Text(
        widget.node.label,
        style: TextStyle(
            color: widget.node.color, textBaseline: TextBaseline.ideographic),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
