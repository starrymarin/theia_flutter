import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:theia_flutter/edit/input_action.dart';
import 'package:theia_flutter/edit/text_input_client.dart';
import 'package:theia_flutter/edit/theia_action.dart';
import 'package:theia_flutter/node/json.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/theia.dart';
import 'package:theia_flutter/utils/color.dart';

class TextNode extends Node implements SpanNode {
  TextNode(super.json);

  @override
  NodeKey<NodeWidgetState<NodeWidget<Node>>>? get nodeKey => null;

  String get text => json[JsonKey.text] ?? "";

  Color? get backgroundColor =>
      json[JsonKey.backgroundColor]?.toString().toColor();

  Color? get color => json[JsonKey.color]?.toString().toColor();

  double? get fontSize => json[JsonKey.fontSize]?.toDouble();

  bool? get bold => json[JsonKey.bold];

  bool? get italic => json[JsonKey.italic];

  bool? get underlined => json[JsonKey.underlined];

  bool? get strikethrough => json[JsonKey.strikethrough];

  /// 即使发生了rebuild，[RenderParagraph.text]也不一定使用最新的span，因为set
  /// [RenderParagraph.text]的时候会执行对比，没有必要的更新则不会使用新的span，因此，
  /// 有些需要更改的数据不建议构造时传递，如必须传递，必须保证旧span的数据最新
  @override
  StyledTextSpan buildSpan({TextStyle? textStyle}) {
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

  @override
  bool handleTheiaAction(TheiaAction action) {
    switch (action.type) {
      case TheiaActionType.removeNode:
        return parent?.handleTheiaAction(RemoveNodeAction(node: this)) ?? false;
    }
    return super.handleTheiaAction(action);
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
  }) : super(recognizer: StyledTextTapRecognizer()) {
    StyledTextTapRecognizer tapRecognizer =
        recognizer as StyledTextTapRecognizer;
    tapRecognizer
      ..node = node
      ..text = text;
  }

  final TextNode node;

  @override
  RenderComparison compareTo(InlineSpan other) {
    RenderComparison result = super.compareTo(other);
    if (other is StyledTextSpan &&
        (result == RenderComparison.identical ||
            result == RenderComparison.metadata)) {
      StyledTextTapRecognizer tapRecognizer =
          recognizer as StyledTextTapRecognizer;
      StyledTextTapRecognizer otherTapRecognizer =
          other.recognizer as StyledTextTapRecognizer;
      tapRecognizer.node = otherTapRecognizer.node;
      tapRecognizer.text = otherTapRecognizer.text;
    }
    return result;
  }
}

class StyledTextTapRecognizer extends TapGestureRecognizer {
  late TextNode node;

  String? text;

  BuildContext? get _context {
    NodeKey? nodeKey = node.nodeKey;
    while (nodeKey == null) {
      Node? parent = node.parent;
      if (parent == null) {
        return null;
      } else {
        nodeKey = parent.nodeKey;
      }
    }
    return nodeKey.currentContext;
  }

  RenderParagraph? get _paragraph {
    BuildContext? context = _context;
    if (context == null) {
      return null;
    } else {
      return _findRenderParagraph(context);
    }
  }

  TapDownDetails? _downDetails;

  RenderParagraph? _findRenderParagraph(BuildContext context) {
    RenderParagraph? paragraph;
    context.visitChildElements((element) {
      RenderObject? renderObject = element.renderObject;
      if (renderObject is RenderParagraph) {
        paragraph = renderObject;
      } else {
        paragraph = _findRenderParagraph(element);
      }
    });
    return paragraph;
  }

  @override
  GestureTapDownCallback? get onTapDown => _onTapDown;

  @override
  GestureTapCallback? get onTap => _onTap;

  void _onTapDown(TapDownDetails downDetails) {
    _downDetails = downDetails;
  }

  void _onTap() {
    RenderParagraph? paragraph = _paragraph;
    if (paragraph == null) {
      return;
    }

    TapDownDetails? downDetails = _downDetails;
    if (downDetails == null) {
      return;
    }

    TextPosition positionInParagraph =
        paragraph.getPositionForOffset(downDetails.localPosition);
    int preLength = 0;
    paragraph.text.visitChildren((span) {
      int spanLength = 0;
      if (span is TextSpan) {
        spanLength = span.text?.length ?? 0;
      } else if (span is PlaceholderSpan) {
        spanLength = 1;
      }
      int newLength = preLength + spanLength;
      if (newLength >= positionInParagraph.offset) {
        if (positionInParagraph.affinity == TextAffinity.downstream &&
            newLength == positionInParagraph.offset) {
          preLength = newLength;
        }
        return false;
      }
      preLength = newLength;
      return true;
    });
    TextPosition positionInSpan = TextPosition(
      offset: positionInParagraph.offset - preLength,
      affinity: positionInParagraph.affinity,
    );

    BuildContext? context = _context;
    if (context == null) {
      return;
    }
    TheiaState? state = theiaState(context);
    if (state == null) {
      return;
    }
    state.useTextInputClient(
      StyledSpanInputClient(
        TextEditingValue(
          text: node.text,
          selection: TextSelection.fromPosition(positionInSpan),
        ),
        node: node,
      ),
    );
  }
}

class StyledSpanInputClient extends TheiaTextInputClient {
  StyledSpanInputClient(super.value, {required this.node});

  final TextNode node;

  @override
  void update(TextEditingValue value) {
    node.json[JsonKey.text] = value.text;
    node.update();
  }

  @override
  bool handleInputAction(InputAction action) {
    switch (action.type) {
      case InputActionType.delete:
        return node.handleTheiaAction(RemoveNodeAction(node: node));
    }
    return super.handleInputAction(action);
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
