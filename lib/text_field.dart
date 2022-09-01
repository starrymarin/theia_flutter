import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/text.dart';
import 'package:theia_flutter/style.dart';
import 'package:theia_flutter/theia.dart';

class InlineTextField extends StatefulWidget {
  const InlineTextField({
    Key? key,
    required this.elementNode,
  }) : super(key: key);

  final ElementNode elementNode;

  @override
  State<StatefulWidget> createState() => InlineTextFieldState();
}

class InlineTextFieldState extends State<InlineTextField> {
  @protected
  late InlineTextEditingController editingController;

  @override
  void initState() {
    super.initState();
    editingController = InlineTextEditingController(widget.elementNode);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: editingController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(
        isCollapsed: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none
      ),
      style: globalTextStyle(context),
      readOnly: theia(context).readOnly,
    );
  }

  @override
  void dispose() {
    super.dispose();
    editingController.dispose();
  }
}

class InlineTextEditingController extends TextEditingController {
  InlineTextEditingController(this.elementNode) {
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

  final ElementNode elementNode;

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    return TextSpan(
        children: elementNode.children
            .map((child) => child.buildSpan(textStyle: style))
            .whereType<InlineSpan>()
            .toList(growable: false),
    );
  }
}
