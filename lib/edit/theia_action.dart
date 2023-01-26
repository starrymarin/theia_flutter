import 'package:theia_flutter/node/node.dart';

enum TheiaActionType { removeNode }

class TheiaAction {
  const TheiaAction({required this.type});

  final TheiaActionType type;
}

class RemoveNodeAction extends TheiaAction {
  RemoveNodeAction({required this.node})
      : super(type: TheiaActionType.removeNode);

  final Node node;
}
