import 'package:flutter/material.dart';
import 'package:theia_flutter/constants.dart';
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
    final mediaWidth = MediaQuery.of(context).size.width;

    return Container(
      alignment: alignment?.systemValue ?? Alignment.centerLeft,
      child: SizedBox(
        width: fitSize(width?.toDouble(), mediaWidth),
        height: fitSize(height?.toDouble(), mediaWidth),
        child: Image.network(thumbURL ?? ""),
      ),
    );
  }

  /// 转换 web 尺寸为设备尺寸
  ///
  /// webSize: web 尺寸
  /// mediaWidth: 组件宽度
  double fitSize(double? webSize, double mediaWidth) {
    if ((webSize ?? 0) <= 0) {
      return mediaWidth;
    }

    // 16 为内边距
    return (mediaWidth - 16) / defaultWidth * (webSize ?? 0);
  }
}
