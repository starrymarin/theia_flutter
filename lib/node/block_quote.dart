import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/style.dart';

/// 目前认为block-quote里面只有blockNode，如果出现非BlockNode将会被忽略
class BlockQuoteNode extends BlockNode {
  BlockQuoteNode(super.json);

  @override
  Widget build(BuildContext context) {
    return GlobalTextStyle(
      style: const TextStyle(
          color: Color(0xFF999999)
      ),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Color(0xFFEEEEEE),
              width: 4
            )
          )
        ),
        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: Column(
          children: children
              .map((child) => child.build(context))
              .whereType<Widget>()
              .toList(),
        ),
      )
    );
  }
}