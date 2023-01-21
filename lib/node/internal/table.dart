import 'package:flutter/material.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/json.dart';
import 'package:theia_flutter/utils/color.dart';

class TableNode extends BlockNode {
  TableNode(super.json);

  List<TableRowNode>? _rows;

  List<TableRowNode> get rows {
    _rows ??= children.whereType<TableRowNode>().toList();
    return _rows ?? [];
  }

  List<NodeJson>? _columns;

  List<NodeJson> get columns {
    _columns ??= (json[JsonKey.columns] as List<dynamic>)
        .map((element) => element as NodeJson)
        .toList();
    return _columns ?? [];
  }

  List<double>? _columnsWidth;

  List<double> get columnsWidth {
    _columnsWidth ??= [];
    if (columns.isNotEmpty) {
      _columnsWidth = columns
          .map((column) => (column[JsonKey.width] as num).toDouble())
          .toList();
    } else {
      int columnsCount = 0;
      if (rows.isNotEmpty) {
        columnsCount = rows.first.cells.length;
      }
      double columnWidth = 710 / columnsCount;
      _columnsWidth = List.filled(columnsCount, columnWidth);
    }
    return _columnsWidth ?? [];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rowWidgets = [];
    for (int index = 0; index < rows.length; index++) {
      final row = rows[index];
      rowWidgets.add(
        IntrinsicHeight(
          child: Builder(builder: (context) {
            return row.buildByTable(context, this);
          }),
        ),
      );
    }
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                  bottom: BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                ),
              ),
              child: Column(children: rowWidgets),
            ),
          ),
        ),
      ),
    );
  }
}

class TableRowNode extends BlockNode {
  TableRowNode(super.json);

  List<TableCellNode>? _cells;

  List<TableCellNode> get cells {
    _cells ??= children.whereType<TableCellNode>().toList();
    return _cells ?? [];
  }

  Widget buildByTable(BuildContext context, TableNode tableNode) {
    List<Widget> cellWidgets = [];
    for (int cellIndex = 0; cellIndex < cells.length; cellIndex++) {
      final cell = cells[cellIndex];
      cellWidgets.add(
        Builder(builder: (context) {
          return Container(
            width: tableNode.columnsWidth[cellIndex],
            constraints: BoxConstraints(
              minHeight: (json[JsonKey.height] as num?)?.toDouble() ?? 41,
            ),
            decoration: BoxDecoration(
              border: const Border(
                top: BorderSide(color: Color(0xFFDDDDDD), width: 1),
                right: BorderSide(color: Color(0xFFDDDDDD), width: 1),
              ),
              color: (json[JsonKey.header] as bool?) == true
                  ? const Color(0xFFF3F3F3)
                  : null,
            ),
            child: cell.build(context),
          );
        }),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cellWidgets,
    );
  }

  /// use [buildByTable]
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TableCellNode extends BlockNode {
  TableCellNode(super.json);

  @override
  Widget build(BuildContext context) {
    List<Widget> childrenWidgets = [];
    for (var child in children) {
      if (child is BlockNode) {
        childrenWidgets.add(Builder(builder: (context) {
          return child.build(context);
        }));
      }
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: (json[JsonKey.tableCellBackgroundColor] as String?).toColor(),
      child: IntrinsicHeight(
        child: Column(
          children: childrenWidgets,
        ),
      ),
    );
  }
}
