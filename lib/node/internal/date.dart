import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/json.dart';

class DateNode extends InlineNode {
  DateNode(super.json);

  @override
  InlineSpan buildSpan({TextStyle? textStyle}) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: DateNodeWidget(node: this),
    );
  }
}

class DateNodeWidget extends NodeWidget<DateNode> {
  const DateNodeWidget({super.key, required super.node});

  @override
  NodeWidgetState<NodeWidget> createState() {
    return DateNodeWidgetState();
  }
}

class DateNodeWidgetState extends NodeWidgetState<DateNodeWidget> {
  int get date {
    int date = widget.node.json[JsonKey.date] ?? 0;

    // 时间戳可能是10位或13位
    return date < 9999999999 ? date * 1000 : date;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: nodeKey,
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      constraints: const BoxConstraints(
        maxWidth: 160,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: const Color(0xFF666666).withOpacity(0.15),
      ),
      child: Text(
        DateFormat('yyyy-MM-dd')
            .format(DateTime.fromMillisecondsSinceEpoch(date)),
        style: const TextStyle(
          color: Color(0xFF666666),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
