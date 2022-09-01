import 'package:flutter/material.dart';

TextStyle? globalTextStyle(BuildContext context) {
  final globalTextStyle = context
      .findAncestorWidgetOfExactType<GlobalTextStyle>();
  return globalTextStyle?.style;
}

class GlobalTextStyle extends StatelessWidget {
  GlobalTextStyle({
    Key? key,
    this.inherit = true,
    required TextStyle style,
    required this.child,
  }) : _style = style,
        super(key: key);

  final Widget child;

  TextStyle _style;
  TextStyle get style => _style;

  /// 如果为真，会合并parent的style，如果为假，则不会合并
  final bool inherit;

  @override
  Widget build(BuildContext context) {
    if (inherit) {
      final parentGlobalTextStyle = context
          .findAncestorWidgetOfExactType<GlobalTextStyle>();
      _style = parentGlobalTextStyle?.style.merge(_style) ?? style;
    }
    return child;
  }
}