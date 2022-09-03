import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/text.dart';
import 'package:theia_flutter/theia.dart';

class InlineTextField extends StatefulWidget {
  const InlineTextField({
    Key? key,
    required this.elementNode
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
    final readOnly = theia(context).readOnly;
    if (readOnly) {
      return SizedBox(
        width: double.infinity,
        child: Text.rich(
          editingController.buildTextSpan(context: context, withComposing: false),
          style: inheritedTextStyle(context),
        ),
      );
    } else {
      return TextField(
        controller: editingController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: const InputDecoration(
            isCollapsed: true,
            border: InputBorder.none,
            focusedBorder: InputBorder.none
        ),
        style: inheritedTextStyle(context),
      );
    }
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

TextStyle? inheritedTextStyle(BuildContext context) {
  return context.dependOnInheritedWidgetOfExactType<_InheritedTextTheme>()?.textStyle;
}

class InheritedTextTheme extends StatelessWidget {
  const InheritedTextTheme({
    super.key,
    required TextStyle textStyle,
    required this.child,
    this.inherit = true
  }) : _textStyle = textStyle;

  final TextStyle _textStyle;
  final Widget child;

  /// 如果为真，会合并parent的style，如果为假，则不会合并
  final bool inherit;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = _textStyle;
    if (inherit) {
      var ancestorTextStyle = context
          .dependOnInheritedWidgetOfExactType<_InheritedTextTheme>()
          ?.textStyle;
      textStyle = ancestorTextStyle?.merge(_textStyle) ?? _textStyle;
    }
    return _InheritedTextTheme(textStyle: textStyle, child: child);
  }
}

class _InheritedTextTheme extends InheritedWidget {
  const _InheritedTextTheme({
    required this.textStyle,
    required super.child
  });

  final TextStyle textStyle;

  @override
  bool updateShouldNotify(covariant _InheritedTextTheme oldWidget) {
    return oldWidget.textStyle != textStyle;
  }
}
