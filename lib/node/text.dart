import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/utils/color.dart';

import 'json.dart';

class TextNode extends Node {
  TextNode(super.json);

  String get text => json[JsonKey.text] ?? "";

  Color? get backgroundColor =>
      json[JsonKey.backgroundColor]?.toString().toColor();

  Color? get color => json[JsonKey.color]?.toString().toColor();

  double? get fontSize => json[JsonKey.fontSize]?.toDouble();

  bool? get bold => json[JsonKey.bold];

  bool? get italic => json[JsonKey.italic];

  bool? get underlined => json[JsonKey.underlined];

  bool? get strikethrough => json[JsonKey.strikethrough];

  @override
  NodeWidget? build(BuildContext context) => null;

  @override
  InlineSpan buildSpan({TextStyle? textStyle}) {
    TextStyle newStyle = TextStyle(
      backgroundColor: backgroundColor,
      color: color,
      fontSize: fontSize,
      fontWeight: bold ?? false ? FontWeight.bold : textStyle?.fontWeight,
      fontStyle: italic ?? false ? FontStyle.italic : textStyle?.fontStyle,
      decoration: TextDecoration.combine([
        underlined ?? false ? TextDecoration.underline : TextDecoration.none,
        strikethrough ?? false
            ? TextDecoration.lineThrough
            : TextDecoration.none,
      ]),
    );

    TextStyle style = textStyle?.merge(newStyle) ?? newStyle;
    return TextSpan(
      text: text,
      style: style,
      recognizer: TapGestureRecognizer()..onTap = () {
        debugPrint("textSpan clickkkkkkkkkkkkkkkkkkkkkk");
      },
    );
  }
}

class InlineText extends NodeWidget<ElementNode> {
  const InlineText({required NodeKey super.key, required super.node});

  @override
  NodeWidgetState<NodeWidget<Node>> createState() {
    return InlineTextState();
  }
}

class InlineTextState extends NodeWidgetState<InlineText> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text.rich(
        buildTextSpan(),
        style: inheritedTextStyle(context),
        textAlign: inheritedTextAlign(context),
      ),
    );
  }

  TextSpan buildTextSpan() {
    return TextSpan(
      children: widget.node.children
          .map((child) => child.buildSpan())
          .whereType<InlineSpan>()
          .toList(growable: false),
    );
  }
}

TextStyle? inheritedTextStyle(BuildContext context) {
  return _InheritedTextTheme.of(context)?.textStyle;
}

TextAlign? inheritedTextAlign(BuildContext context) {
  return _InheritedTextTheme.of(context)?.textAlign;
}

class InheritedTextTheme extends StatelessWidget {
  const InheritedTextTheme({
    super.key,
    TextStyle? textStyle,
    TextAlign? textAlign,
    required this.child,
    this.inherit = true,
  })  : _textStyle = textStyle,
        _textAlign = textAlign;

  final TextStyle? _textStyle;
  final TextAlign? _textAlign;

  final Widget child;

  /// 如果为真，会合并parent的style，如果为假，则不会合并
  final bool inherit;

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = _textStyle;
    if (inherit) {
      var ancestorTextStyle = context
          .dependOnInheritedWidgetOfExactType<_InheritedTextTheme>()
          ?.textStyle;
      textStyle = ancestorTextStyle?.merge(_textStyle) ?? _textStyle;
    }
    return _InheritedTextTheme(textStyle, _textAlign, child);
  }
}

class _InheritedTextTheme extends InheritedWidget {
  static _InheritedTextTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedTextTheme>();
  }

  const _InheritedTextTheme(this.textStyle, this.textAlign, Widget child)
      : super(child: child);

  final TextStyle? textStyle;
  final TextAlign? textAlign;

  @override
  bool updateShouldNotify(covariant _InheritedTextTheme oldWidget) {
    return oldWidget.textStyle != textStyle;
  }
}
