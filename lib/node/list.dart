import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';

class ListNode extends BlockNode {
  ListNode(super.json);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: children
            .whereType<ListNode>()
            .map((child) => Builder(builder: (context) => child.build(context)))
            .toList(),
      ),
    );
  }

}

class NumberedListNode extends ListNode {
  NumberedListNode(super.json);

}

class BulletedListNode extends ListNode {
  BulletedListNode(super.json);

}

class ListItemNode extends BlockNode {
  ListItemNode(super.json);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}