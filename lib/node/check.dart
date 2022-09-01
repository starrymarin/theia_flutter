import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/json.dart' as node_json;
import 'package:theia_flutter/node/paragraph.dart';
import 'package:theia_flutter/text.dart';

class CheckItemNode extends BlockNode {
  CheckItemNode(super.json);

  bool get checked => json[node_json.checked];

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Expanded(child: Column(
            children: children
                .map((child) => InlineTextField(elementNode: this))
                .toList(),
          ))
        ],
      ),
    );
  }

}