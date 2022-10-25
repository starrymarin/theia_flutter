import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';

import '../text.dart';

enum Heading {
  heading1,
  heading2,
  heading3,
  heading4,
  heading5,
  heading6;

  double get fontSize {
    switch (this) {
      case Heading.heading1: return 32;
      case Heading.heading2: return 28;
      case Heading.heading3: return 24;
      case Heading.heading4: return 20;
      case Heading.heading5: return 18;
      case Heading.heading6: return 16;
    }
  }
}

class HeadingNode extends BlockNode {
  HeadingNode(super.json, this.heading);

  Heading heading;

  @override
  Widget build(BuildContext context) {
    return InheritedTextTheme(
      textStyle: TextStyle(
        fontSize: heading.fontSize,
        fontWeight: FontWeight.bold,
      ),
      child: InlineTextField(elementNode: this),
    );
  }
}
