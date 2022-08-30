import 'package:flutter/material.dart';
import 'package:theia_flutter/node.dart';

class InlineTextField extends StatefulWidget {
  const InlineTextField({
    Key? key,
    required this.elementNode,
    this.editable = true
  }) : super(key: key);

  final ElementNode elementNode;
  final bool editable;

  @override
  State<StatefulWidget> createState() => InlineTextFieldState();
}

class InlineTextFieldState extends State<InlineTextField> {
  late InlineTextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = InlineTextEditingController(
        widget.elementNode,
        editable: widget.editable
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _editingController,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
  }
}

class InlineTextEditingController extends TextEditingController {
  InlineTextEditingController(this.elementNode, {
    this.editable = true
  }) {
    if (editable) {
      StringBuffer stringBuffer = StringBuffer();
      for (Node child in elementNode.children) {
        if (child is InlineNode) {
          stringBuffer.writeCharCode(PlaceholderSpan.placeholderCodeUnit);
        } else if (child is TextNode) {
          stringBuffer.write(child.text);
        }
      }
      text = stringBuffer.toString();
    }
  }

  final ElementNode elementNode;
  final bool editable;

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    return TextSpan(
        style: style,
        children: elementNode.children
            .map((child) => child.buildSpan())
            .whereType<InlineSpan>()
            .toList(growable: false));
  }
}
