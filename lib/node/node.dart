import 'package:flutter/material.dart';

import 'transform.dart';
import 'json.dart';

typedef NodeJson = Map<String, dynamic>;

abstract class Node {
  Node(this.json);

  final NodeJson json;

  Widget? build(BuildContext context);

  InlineSpan? buildSpan({TextStyle? textStyle});
}

abstract class ElementNode extends Node {
  ElementNode(super.json);

  List<Node>? _children;

  List<Node> get children => _children ?? [];

  String? _key;

  String? get key {
    _key ??= json[JsonKey.key];
    return _key;
  }

  String? _type;

  String? get type {
    _type ??= json[JsonKey.type];
    return _type;
  }

  void generateChildren(Map<String, NodePlugin>? plugins) {
    _children = [];
    List<dynamic> nodeJsonList = json[JsonKey.children];
    for (NodeJson json in nodeJsonList) {
      var node = json.toNode(plugins);
      if (node != null) {
        _children?.add(node);
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
  Widget build(BuildContext context);

  @override
  InlineSpan? buildSpan({TextStyle? textStyle}) => null;
}

abstract class InlineNode extends ElementNode {
  InlineNode(super.json);

  @override
  Widget? build(BuildContext context) => null;

  @override
  InlineSpan buildSpan({TextStyle? textStyle});
}

class NodePlugin {
  NodePlugin(this.type, this.createNode);

  final String type;

  final Node Function(NodeJson nodeJson) createNode;
}
