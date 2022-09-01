import 'dart:core';

import 'package:flutter/material.dart';
import 'package:theia_flutter/constants.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/json.dart' as node_json;
import 'package:theia_flutter/text.dart';

/// 基本思路是将slate的节点一一对应到flutter，所以一个theia widget里面有很多的textField，
/// 因此在处理选区的时候是首先让flutter处理当前触摸到的TextField的选区，然后通过处理手势，
/// 手势到哪一个TextField上面，哪一个TextField处理选区，最后再拼接起来

Theia theia(BuildContext context) => context.findAncestorWidgetOfExactType<Theia>()!;

class Theia extends StatefulWidget {
  const Theia({
    Key? key,
    List<NodeJson>? document,
    this.readOnly = true
  }) : _document = document,
        super(key: key);

  final List<NodeJson>? _document;
  List<NodeJson> get document => _document ??
      [
        {
          node_json.type: NodeType.paragraph,
          node_json.children: [
            {
              node_json.text: "\u200b"
            }
          ]
        },
      ];

  final bool readOnly;

  @override
  State<StatefulWidget> createState() => _TheiaState();
}

class _TheiaState extends State<Theia> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: GlobalTextStyle(
            style: const TextStyle(
              fontSize: defaultFontSize
            ),
            child: Column(
              children: widget.document
                  .map((nodeJson) => nodeJson.toNode())
                  .whereType<BlockNode>()
                  .map((node) => Builder(builder: (context) => node.build(context)))
                  .whereType<Widget>()
                  .toList(growable: false),
            ),
        )
      ),
    );
  }
}
