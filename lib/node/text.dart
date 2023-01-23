import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/theia.dart';
import 'package:theia_flutter/utils/color.dart';

import 'json.dart';

class TextNode extends Node implements SpanNode {
  TextNode(super.json);

  @override
  NodeKey<NodeWidgetState<NodeWidget<Node>>>? get key => null;

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
    return StyledTextSpan(
      node: this,
      text: text,
      style: style,
    );
  }
}

/// 这是一个"接近纯文本"的风格化TextSpan，意思是[text]有什么就显示什么，只是添加了粗体、
/// 斜体、字号、颜色等等简单样式，目的是[text]作为纯文本可以传输给TextEditingValue
class StyledTextSpan extends TextSpan {
  StyledTextSpan({
    required this.node,
    super.text,
    super.children,
    super.style,
    super.mouseCursor,
    super.onEnter,
    super.onExit,
    super.semanticsLabel,
    super.locale,
    super.spellOut,
  }) : super(recognizer: TapGestureRecognizer()) {
    if (recognizer is TapGestureRecognizer) {
      (recognizer as TapGestureRecognizer)
          ..onTapDown = _onTapDown
          ..onTap = _onTap;
    }
  }

  final TextNode node;

  BuildContext? get _context => node.key?.currentContext;

  late final Theia? _theia = () {
    if (_context != null) {
      return theia(_context!);
    }
    return null;
  }();

  void _onTapDown(TapDownDetails details) {

  }

  void _onTap() {
    Theia? theia = _theia;
    if (theia == null) {
      return;
    }
  }
}

/// InlineText不具备通过Node更新的能力，因为InlineText不对应具体Node，它的作用是用来显示TextSpan
class InlineText extends StatelessWidget {
  const InlineText({super.key, required this.children});

  final List<Node> children;

  TextSpan buildTextSpan() {
    return TextSpan(
      children: children
          .whereType<SpanNode>()
          .map((child) => child.buildSpan())
          .toList(growable: false),
    );
  }

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
