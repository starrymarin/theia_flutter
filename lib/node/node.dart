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

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return other is NodeKey<T> && identical(other.value, value);
  }

  @override
  int get hashCode => identityHashCode(value);
}

abstract class Node extends ChangeNotifier {
  Node(this.json);

  NodeJson json;

  Node? parent;

  late NodeKey<NodeWidgetState>? key = NodeKey(value: json[JsonKey.key]);

  NodeWidget? build(BuildContext context);

  InlineSpan? buildSpan({TextStyle? textStyle});

  /// 当key是null时，通过parent更新，例如TextNode，它的key为null，它不对应任何的StatefulWidget，
  /// 而是对应TextSpan，因此不具备json更新之后更新ui的能力，所以需要通过parent更新widget
  void update() {
    if (key == null) {
      parent?.update();
    } else {
      var state = key?.currentState;
      if (state is NodeWidgetState) {
        state.update();
      }
    }
  }
}

abstract class ElementNode extends Node {
  ElementNode(super.json);

  @override
  NodeKey<NodeWidgetState<NodeWidget<Node>>> get key => super.key!;

  List<Node>? _children;

  List<Node> get children => _children ?? [];

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
  const NodeWidget({
    required NodeKey<NodeWidgetState> super.key,
    required this.node,
  });

  @override
  NodeKey<NodeWidgetState> get key => super.key as NodeKey<NodeWidgetState>;

  final T node;

  @override
  NodeWidgetState createState();
}

abstract class NodeWidgetState<T extends NodeWidget> extends State<T> {
  void update() {
    setState(() {});
  }
}
