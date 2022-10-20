import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/json.dart' as node_json;

enum ImageAlignment {
  left,
  center,
  right;

  static ImageAlignment? tryParse(String string) {
    switch (string) {
      case "left":
        return ImageAlignment.left;
      case "center":
        return ImageAlignment.center;
      case "right":
        return ImageAlignment.right;
    }

    return null;
  }

  Alignment get systemValue {
    switch (this) {
      case ImageAlignment.left:
        return Alignment.centerLeft;
      case ImageAlignment.center:
        return Alignment.center;
      case ImageAlignment.right:
        return Alignment.centerRight;
    }
  }
}

class ImageNode extends BlockNode {
  ImageNode(super.json);

  String? get thumbURL => json[node_json.thumbURL];

  String? get originalURL => json[node_json.originalURL];

  int? get width => json[node_json.width];

  int? get height => json[node_json.height];

  ImageAlignment? get alignment =>
      ImageAlignment.tryParse(json[node_json.align] ?? "");

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment?.systemValue ?? Alignment.centerLeft,
      child: SizedBox(
        width: width?.toDouble(),
        height: height?.toDouble(),
        child: Image.network(thumbURL ?? ""),
      ),
    );
  }
}
