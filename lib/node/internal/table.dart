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
  NodeWidget build(BuildContext context) {
    return TableNodeWidget(node: this);
  }
}

class TableNodeWidget extends NodeWidget<TableNode> {
  const TableNodeWidget({super.key, required super.node});

  @override
  NodeWidgetState<NodeWidget<Node>> createState() {
    return TableNodeWidgetState();
  }
}

class TableNodeWidgetState extends NodeWidgetState<TableNodeWidget> {
  List<TableRowNode> get rows => widget.node.rows;

  @override
  Widget build(BuildContext context) {
    List<Widget> rowWidgets = [];
    for (int index = 0; index < rows.length; index++) {
      final row = rows[index];
      row.tableNode = widget.node;
      rowWidgets.add(
        IntrinsicHeight(
          child: Builder(builder: (context) {
            return row.build(context);
          }),
        ),
      );
    }
    return Center(
      key: nodeKey,
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

  late TableNode tableNode;

  List<TableCellNode>? _cells;

  List<TableCellNode> get cells {
    _cells ??= children.whereType<TableCellNode>().toList();
    return _cells ?? [];
  }

  @override
  NodeWidget build(BuildContext context) {
    return TableRowNodeWidget(node: this);
  }
}

class TableRowNodeWidget extends NodeWidget<TableRowNode> {
  const TableRowNodeWidget({super.key, required super.node});

  @override
  NodeWidgetState<NodeWidget<Node>> createState() {
    return TableRowNodeWidgetState();
  }
}

class TableRowNodeWidgetState extends NodeWidgetState<TableRowNodeWidget> {
  List<TableCellNode> get cells => widget.node.cells;

  @override
  Widget build(BuildContext context) {
    List<Widget> cellWidgets = [];
    for (int cellIndex = 0; cellIndex < cells.length; cellIndex++) {
      final cell = cells[cellIndex];
      cellWidgets.add(
        Builder(builder: (context) {
          return Container(
            width: widget.node.tableNode.columnsWidth[cellIndex],
            constraints: BoxConstraints(
              minHeight:
                  (widget.node.json[JsonKey.height] as num?)?.toDouble() ?? 41,
            ),
            decoration: BoxDecoration(
              border: const Border(
                top: BorderSide(color: Color(0xFFDDDDDD), width: 1),
                right: BorderSide(color: Color(0xFFDDDDDD), width: 1),
              ),
              color: (widget.node.json[JsonKey.header] as bool?) == true
                  ? const Color(0xFFF3F3F3)
                  : null,
            ),
            child: cell.build(context),
          );
        }),
      );
    }
    return Row(
      key: nodeKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cellWidgets,
    );
  }
}

class TableCellNode extends BlockNode {
  TableCellNode(super.json);

  @override
  NodeWidget build(BuildContext context) {
    return TableCellNodeWidget(node: this);
  }
}

class TableCellNodeWidget extends NodeWidget<TableCellNode> {
  const TableCellNodeWidget({super.key, required super.node});

  @override
  NodeWidgetState<NodeWidget<Node>> createState() {
    return TableCellNodeWidgetState();
  }
}

class TableCellNodeWidgetState extends NodeWidgetState<TableCellNodeWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> childrenWidgets = [];
    for (var child in widget.node.children) {
      if (child is BlockNode) {
        childrenWidgets.add(Builder(builder: (context) {
          return child.build(context);
        }));
      }
    }
    return Container(
      key: nodeKey,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: (widget.node.json[JsonKey.tableCellBackgroundColor] as String?)
          .toColor(),
      child: IntrinsicHeight(
        child: Column(
          children: childrenWidgets,
        ),
      ),
    );
  }
}
