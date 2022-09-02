import 'package:flutter/material.dart';
import 'package:theia_flutter/constants.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/text.dart';
import 'package:theia_flutter/theia.dart';

class InlineCodeNode extends InlineNode {
  InlineCodeNode(super.json);

  @override
  WidgetSpan buildSpan({TextStyle? textStyle, required TheiaKey theiaKey}) {
    return WidgetSpan(
      child: InlineCodeTextField(elementNode: this, theiaKey: theiaKey),
      baseline: TextBaseline.alphabetic,
      alignment: PlaceholderAlignment.baseline
    );
  }
}

class InlineCodeTextField extends InlineTextField {
  const InlineCodeTextField({
    super.key,
    required super.elementNode,
    required super.theiaKey
  });

  @override
  State<StatefulWidget> createState() => InlineCodeTextFieldState();
}

class InlineCodeTextFieldState extends InlineTextFieldState {
  final board = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(
          color: Color(0xFFDDDDDD),
          width: 1
      )
  );

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
        fontFamily: monospace,
        color: Color(0xFF666666)
    );
    Widget content;
    final readOnly = widget.theiaKey.currentState?.widget.readOnly ?? false;
    if (readOnly) {
      content = Text.rich(
        editingController.buildTextSpan(context: context, withComposing: false),
        style: globalTextStyle(context)?.merge(style) ?? style,
        maxLines: 1,
      );
    } else {
      content = TextField(
        controller: editingController,
        decoration: const InputDecoration(
          isCollapsed: true,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
              borderSide: BorderSide.none
          ),
        ),
        maxLines: 1,
        minLines: 1,
        style: globalTextStyle(context)?.merge(style) ?? style,
        readOnly: readOnly,
      );
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 2, 6), // 本来left也应该是2，但不知为何TextField右边总是有大约2的padding
      margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color(0xFFDDDDDD),
            width: 0.5
        ),
        borderRadius: const BorderRadius.all(
            Radius.circular(4)
        ),
        color: const Color(0xFFF5F5F5),
      ),
      child: IntrinsicWidth(child: content,),
    );
  }
}