import 'package:flutter/material.dart';
import 'package:theia_flutter/constants.dart';
import 'package:theia_flutter/edit/text_input_client.dart';
import 'package:theia_flutter/node/json.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/text.dart';
import 'package:theia_flutter/node/transform.dart';

TheiaConfiguration theiaConfiguration(BuildContext context) {
  return TheiaConfiguration.of(context);
}

TheiaState? theiaState(BuildContext context) {
  State? state = theiaConfiguration(context)._theiaKey.currentState;
  if (state is TheiaState) {
    return state;
  }
  return null;
}

class Theia extends StatefulWidget {
  Theia({
    super.key,
    List<NodeJson>? document,
    this.readOnly = true,
    List<NodePlugin>? nodePlugins,
  }) : _document = document {
    nodePlugins?.forEach((plugin) => {this.nodePlugins[plugin.type] = plugin});
  }

  final List<NodeJson>? _document;

  List<NodeJson> get document =>
      _document ??
      [
        {
          JsonKey.type: NodeType.paragraph,
          JsonKey.children: [
            {JsonKey.text: "\u200b"}
          ]
        },
      ];

  final bool readOnly;

  final Map<String, NodePlugin> nodePlugins = {};

  @override
  State<StatefulWidget> createState() {
    return _TheiaStateDelegate();
  }
}

class _TheiaStateDelegate extends State<Theia> {
  final GlobalKey theiaKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return TheiaConfiguration(
      readOnly: widget.readOnly,
      theiaKey: theiaKey,
      child: _Theia(
        key: theiaKey,
        document: widget.document,
        nodePlugins: widget.nodePlugins,
      ),
    );
  }
}

class _Theia extends StatefulWidget {
  const _Theia({
    required super.key,
    required this.document,
    required this.nodePlugins,
  });

  final List<NodeJson> document;

  final Map<String, NodePlugin>? nodePlugins;

  @override
  State<StatefulWidget> createState() {
    return TheiaState();
  }
}

class TheiaState extends State<_Theia> {
  TheiaTextInputClient? _currentTextInputClient;

  Iterable<BlockNode> get nodes => widget.document
      .map((nodeJson) => nodeJson.toNode(widget.nodePlugins))
      .whereType<BlockNode>();

  void useTextInputClient(TheiaTextInputClient textInputClient) {
    _currentTextInputClient?.closeConnection();
    _currentTextInputClient = textInputClient;
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollNotification) {
          if (scrollNotification is UserScrollNotification) {
            _currentTextInputClient?.connectionClosed();
          }
          return false;
        },
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: InheritedTextTheme(
                textStyle: const TextStyle(
                  fontSize: defaultFontSize,
                  color: Color(0xFF333333),
                  height: 1.6,
                ),
                child: Column(
                  children: nodes
                      .map((node) =>
                          Builder(builder: (context) => node.build(context)))
                      .whereType<Widget>()
                      .toList(growable: false),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TheiaConfiguration extends InheritedWidget {
  static TheiaConfiguration of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TheiaConfiguration>()!;
  }

  const TheiaConfiguration({
    super.key,
    required this.readOnly,
    required GlobalKey theiaKey,
    required super.child,
  }) : _theiaKey = theiaKey;

  final bool readOnly;

  final GlobalKey _theiaKey;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
