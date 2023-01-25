import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/internal/paragraph.dart';
import 'package:theia_flutter/node/json.dart';

enum AlertType {
  success,
  danger,
  warning,
  info;

  static AlertType? tryParse(String string) {
    switch (string) {
      case "success":
        return AlertType.success;
      case "danger":
        return AlertType.danger;
      case "warning":
        return AlertType.warning;
      case "info":
        return AlertType.info;
    }

    return null;
  }

  IconData get icon {
    switch (this) {
      case AlertType.success:
        return Icons.check;
      case AlertType.danger:
        return Icons.close;
      case AlertType.warning:
        return Icons.warning;
      case AlertType.info:
        return Icons.info;
    }
  }

  Color get color {
    switch (this) {
      case AlertType.success:
        return const Color(0xFF73D897);
      case AlertType.danger:
        return const Color(0xFFFF7575);
      case AlertType.warning:
        return const Color(0xFFFFCD5D);
      case AlertType.info:
        return const Color(0xFF5DCFFF);
    }
  }
}

class AlertNode extends BlockNode {
  AlertNode(super.json);

  @override
  NodeWidget build(BuildContext context) {
    return AlterNodeWidget(key: nodeKey, node: this);
  }
}

class AlterNodeWidget extends NodeWidget<AlertNode> {
  const AlterNodeWidget({required super.key, required super.node});

  @override
  NodeWidgetState createState() {
    return AlterNodeWidgetState();
  }
}

class AlterNodeWidgetState extends NodeWidgetState<AlterNodeWidget> {
  AlterNodeWidgetState();

  AlertType get alertType =>
      AlertType.tryParse(widget.node.json[JsonKey.alertType] ?? "") ??
      AlertType.success;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: alertType.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Container(
            alignment: Alignment.topRight,
            width: 36,
            height: 36,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 6, 0),
              decoration: BoxDecoration(
                color: alertType.color,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                alertType.icon,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: widget.node.children
                  .map((node) => ParagraphNode(node.json).build(context))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
