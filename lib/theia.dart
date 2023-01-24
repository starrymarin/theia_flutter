import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theia_flutter/constants.dart';
import 'package:theia_flutter/node/json.dart';
import 'package:theia_flutter/node/node.dart';
import 'package:theia_flutter/node/text.dart';
import 'package:theia_flutter/node/transform.dart';

TheiaConfiguration theiaConfiguration(BuildContext context) {
  return TheiaConfiguration.of(context);
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
  final _TheiaTextInputClient _textInputClient = _TheiaTextInputClient();

  void showKeyboard(TextNode textNode) {
    _textInputClient._showKeyboard(textNode);
  }

  void setEditingState(TextEditingValue value) {
    _textInputClient._setEditingState(value);
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollNotification) {
          if (scrollNotification is UserScrollNotification) {
            _textInputClient.connectionClosed();
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
                  children: widget.document
                      .map((nodeJson) => nodeJson.toNode(widget.nodePlugins))
                      .whereType<BlockNode>()
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
    required this.theiaKey,
    required super.child,
  });

  final bool readOnly;

  final GlobalKey theiaKey;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class _TheiaTextInputClient with TextInputClient {
  TextInputConnection? _textInputConnection;
  TextEditingValue? _textEditingValue;
  TextNode? _editingTextNode;

  void _openTextInputConnect() {
    TextInput.ensureInitialized();
    _textInputConnection = TextInput.attach(
      this,
      const TextInputConfiguration(),
    );
  }

  void _showKeyboard(TextNode textNode) {
    if (_textInputConnection == null) {
      _openTextInputConnect();
    }
    _textInputConnection?.show();
    _editingTextNode = textNode;
  }

  void _setEditingState(TextEditingValue value) {
    _textEditingValue = value;
    _textInputConnection?.setEditingState(value);
  }

  @override
  void connectionClosed() {
    _textInputConnection?.close();
    _textInputConnection = null;
    _editingTextNode = null;
  }

  @override
  AutofillScope? get currentAutofillScope => null;

  @override
  TextEditingValue? get currentTextEditingValue => _textEditingValue;

  @override
  void performAction(TextInputAction action) {}

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) {}

  @override
  void showAutocorrectionPromptRect(int start, int end) {}

  @override
  void updateEditingValue(TextEditingValue value) {
    _textEditingValue = value;
    _editingTextNode?.json[JsonKey.text] = value.text;
    _editingTextNode?.update();
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {}
}
