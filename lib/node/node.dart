import 'dart:math';

import 'package:flutter/material.dart';

import 'transform.dart';
import 'json.dart';

typedef NodeJson = Map<String, dynamic>;

class NodeKey<T extends State<StatefulWidget>> extends GlobalKey<T> {
  const NodeKey({String? value})
      : _value = value,
        super.constructor();

  static const _availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';

  final String? _value;

  String get value {
    String? value = _value;
    if (value != null) {
      return value;
    }
    return List.generate(
      5,
      (index) => _availableChars[Random().nextInt(_availableChars.length)],
    ).join();
  }
}

abstract class Node extends ChangeNotifier {
  Node(this.json);

  NodeJson json;

  Node? parent;

  NodeWidget? build(BuildContext context);

  InlineSpan? buildSpan({TextStyle? textStyle});
}

abstract class ElementNode extends Node {
  ElementNode(super.json);

  List<Node>? _children;

  List<Node> get children => _children ?? [];

  late NodeKey key = NodeKey(value: json[JsonKey.key]);

  late String? type = json[JsonKey.type];

  void generateChildren(Map<String, NodePlugin>? plugins) {
    _children = [];
    List<dynamic> nodeJsonList = json[JsonKey.children];
    for (NodeJson json in nodeJsonList) {
      var node = json.toNode(plugins);
      if (node != null) {
        _children?.add(node);
        node.parent = this;
        if (node is ElementNode) {
          node.generateChildren(plugins);
        }
      }
    }
  }
}

abstract class BlockNode extends ElementNode {
  BlockNode(super.json);

  @override
  NodeWidget build(BuildContext context);

  @override
  InlineSpan? buildSpan({TextStyle? textStyle}) => null;
}

abstract class InlineNode extends ElementNode {
  InlineNode(super.json);

  @override
  NodeWidget? build(BuildContext context) => null;

  @override
  InlineSpan buildSpan({TextStyle? textStyle});
}

class NodePlugin {
  NodePlugin(this.type, this.createNode);

  final String type;

  final Node Function(NodeJson nodeJson) createNode;
}

abstract class NodeWidget<T extends Node> extends StatefulWidget {
  const NodeWidget({super.key, required this.node});

  final T node;

  @override
  NodeWidgetState createState();
}

abstract class NodeWidgetState<T extends NodeWidget> extends State<T> {
  NodeWidgetState();

  @override
  void initState() {
    widget.node.addListener(() {
      setState(() {});
    });
    super.initState();
  }
}
