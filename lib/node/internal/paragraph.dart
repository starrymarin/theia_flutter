import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/text.dart';
import 'package:theia_flutter/text.dart';
import 'package:theia_flutter/node/json.dart';

class ParagraphNode extends BlockNode {
  ParagraphNode(super.json);

  int get indent => json[JsonKey.indent] ?? 0;
  final int _indentSize = 30;

  ParagraphNodeStyle? _style(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ParagraphNodeStyle>();

  String? _align;

  TextAlign? get align {
    _align ??= json[JsonKey.align];
    switch (_align) {
      case "center":
        return TextAlign.center;
      case "right":
        return TextAlign.end;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (children.isNotEmpty == true) {
      var firstChild = children.first;
      if (firstChild is BlockNode) {
        var childrenWidgets = children
            .whereType<BlockNode>()
            .map((child) => Builder(builder: (context) => child.build(context)))
            .whereType<Widget>()
            .toList();
        return Column(
          children: childrenWidgets,
        );
      }

      if (firstChild is InlineNode || firstChild is TextNode) {
        final style = _style(context);
        return Container(
            margin: style?.inlineTextMargin ??
                const EdgeInsets.fromLTRB(0, 8, 0, 8),
            padding:
                EdgeInsets.fromLTRB((_indentSize * indent).toDouble(), 0, 0, 0),
            child: InheritedTextTheme(
              textAlign: align,
              child: InlineTextField(elementNode: this),
            ),
        );
      }
    }
    return Container();
  }
}

class ParagraphNodeStyle extends InheritedWidget {
  const ParagraphNodeStyle(
      {super.key, this.inlineTextMargin, required super.child});

  final EdgeInsetsGeometry? inlineTextMargin;

  @override
  bool updateShouldNotify(covariant ParagraphNodeStyle oldWidget) {
    return inlineTextMargin != oldWidget.inlineTextMargin;
  }
}
