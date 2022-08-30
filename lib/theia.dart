import 'dart:core';

import 'package:flutter/material.dart';
import 'package:theia_flutter/node.dart';

/// 基本思路是将slate的节点一一对应到flutter，所以一个theia widget里面有很多的textField，
/// 因此在处理选区的时候是首先让flutter处理当前触摸到的TextField的选区，然后通过处理手势，
/// 手势到哪一个TextField上面，哪一个TextField处理选区，最后再拼接起来

class Theia extends StatefulWidget {
  const Theia({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TheiaState();
}

class _TheiaState extends State<Theia> {
  _TheiaState({
    List<NodeJson>? document
  }) : document = document ?? [],
       super();

  List<NodeJson> document;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: document
          .map((node) => node.toNode()?.build())
          .whereType<Widget>()
          .toList(growable: false),
    );
  }
}
