import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:theia_flutter/node.dart';
import 'package:theia_flutter/theia.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   // This method is rerun every time setState is called, for instance as done
  //   // by the _incrementCounter method above.
  //   //
  //   // The Flutter framework has been optimized to make rerunning build methods
  //   // fast, so that you can just rebuild anything that needs updating rather
  //   // than having to individually change instances of widgets.
  //   return Scaffold(
  //     appBar: AppBar(
  //       // Here we take the value from the MyHomePage object that was created by
  //       // the App.build method, and use it to set our appbar title.
  //       title: Text(widget.title),
  //     ),
  //     body: Center(
  //       // Center is a layout widget. It takes a single child and positions it
  //       // in the middle of the parent.
  //       child: Column(
  //         // Column is also a layout widget. It takes a list of children and
  //         // arranges them vertically. By default, it sizes itself to fit its
  //         // children horizontally, and tries to be as tall as its parent.
  //         //
  //         // Invoke "debug painting" (press "p" in the console, choose the
  //         // "Toggle Debug Paint" action from the Flutter Inspector in Android
  //         // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
  //         // to see the wireframe for each widget.
  //         //
  //         // Column has various properties to control how it sizes itself and
  //         // how it positions its children. Here we use mainAxisAlignment to
  //         // center the children vertically; the main axis here is the vertical
  //         // axis because Columns are vertical (the cross axis would be
  //         // horizontal).
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           const Text(
  //             'You have pushed the button this many times:',
  //           ),
  //           Text(
  //             '$_counter',
  //             style: Theme.of(context).textTheme.headline4,
  //           ),
  //         ],
  //       ),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: _incrementCounter,
  //       tooltip: 'Increment',
  //       child: const Icon(Icons.add),
  //     ), // This trailing comma makes auto-formatting nicer for build methods.
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    List<dynamic> document = jsonDecode("[{\"children\": [{\"text\": \"222222222\"},{\"text\": \"22222\",\"background-color\": \"#FF0100\"},{\"text\": \"2222222\"},{\"type\": \"inline-code\",\"children\": [{ \"text\": \"a\"}],\"key\": \"mBcTi\"},{\"text\": \"\"}],\"type\": \"paragraph\",\"key\": \"YftEY\"},{\"children\": [{\"text\": \"333333333333333333333\"}],\"type\": \"paragraph\",\"key\": \"cmSDw\"}]");
    return Scaffold(
      body: Theia(
        document: document.map((e) => e as NodeJson).toList(),
      ),
    );
  }
}

class TestTextEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    return TextSpan(
      children: [
        WidgetSpan(child: Icon(Icons.flutter_dash)),
        TextSpan(text: value.text)
      ]
    );
  }
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const TestHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class TestHomePage extends StatefulWidget {
  const TestHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TestHomePage> createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  GlobalKey<State<TextField>> firstTextFieldKey = GlobalKey();

  TextSelectionControls _createSelectionControls(BuildContext context) {
    var theme = Theme.of(context);
    switch(theme.platform) {
      case TargetPlatform.iOS:
        return TextSelectionControlsDelegate(cupertinoTextSelectionControls);
      case TargetPlatform.macOS:
        return TextSelectionControlsDelegate(cupertinoDesktopTextSelectionControls);
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return TextSelectionControlsDelegate(materialTextSelectionControls);
      case TargetPlatform.linux:
        return TextSelectionControlsDelegate(desktopTextSelectionControls);
      case TargetPlatform.windows:
        return TextSelectionControlsDelegate(desktopTextSelectionControls);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TheiaWidget(
            child: TextField(
              key: firstTextFieldKey,
              controller: EditingController(firstTextFieldKey),
              selectionControls: _createSelectionControls(context),
            ),
          ),
          TheiaWidget(
            child: TextField(),
          ),
        ],
      )
    );
  }
}

class TextSelectionControlsDelegate implements TextSelectionControls {
  TextSelectionControlsDelegate(this.controls);

  final TextSelectionControls controls;

  @override
  Widget buildHandle(BuildContext context, TextSelectionHandleType type, double textLineHeight, [ui.VoidCallback? onTap]) {
    var handle = controls.buildHandle(context, type, textLineHeight, onTap);
    return GestureDetector(
      child: handle,
      onPanUpdate: (details) {
        print(details);
      },
    );
  }

  @override
  Widget buildToolbar(BuildContext context, Rect globalEditableRegion, double textLineHeight, Offset position, List<TextSelectionPoint> endpoints, TextSelectionDelegate delegate, ClipboardStatusNotifier? clipboardStatus, Offset? lastSecondaryTapDownPosition) {
    return controls.buildToolbar(context, globalEditableRegion, textLineHeight, position, endpoints, delegate, clipboardStatus, lastSecondaryTapDownPosition);
  }

  @override
  bool canCopy(TextSelectionDelegate delegate) {
    return controls.canCopy(delegate);
  }

  @override
  bool canCut(TextSelectionDelegate delegate) {
    return controls.canCut(delegate);
  }

  @override
  bool canPaste(TextSelectionDelegate delegate) {
    return controls.canPaste(delegate);
  }

  @override
  bool canSelectAll(TextSelectionDelegate delegate) {
    return controls.canSelectAll(delegate);
  }

  @override
  ui.Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    return controls.getHandleAnchor(type, textLineHeight);
  }

  @override
  ui.Size getHandleSize(double textLineHeight) {
    return controls.getHandleSize(textLineHeight);
  }

  @override
  void handleCopy(TextSelectionDelegate delegate, [ClipboardStatusNotifier? clipboardStatus]) {
    controls.handleCopy(delegate, clipboardStatus);
  }

  @override
  void handleCut(TextSelectionDelegate delegate, [ClipboardStatusNotifier? clipboardStatus]) {
    controls.handleCut(delegate, clipboardStatus);
  }

  @override
  Future<void> handlePaste(TextSelectionDelegate delegate) {
    return controls.handlePaste(delegate);
  }

  @override
  void handleSelectAll(TextSelectionDelegate delegate) {
    controls.handleSelectAll(delegate);
  }

}

class TheiaWidget extends SingleChildRenderObjectWidget {
  const TheiaWidget({ Key? key, required Widget child }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderTheiaWidget();
  }

}

class RenderTheiaWidget extends RenderProxyBox {
  @override
  bool hitTest(BoxHitTestResult result, {required ui.Offset position}) {
    hitTestChildren(result, position: position);
    return false;
  }
}



class EditingController extends TextEditingController {
  EditingController(this.textFieldKey) {
    value = value.copyWith(text: "abcddddd");
    Timer(const Duration(seconds: 5), () {
      print("timer");
      var aaa = editableTextState?.renderEditable.selectionStartInViewport;
      if (aaa is ValueNotifier<bool>) {
        aaa.value = false;
      }
      editableTextState?.userUpdateTextEditingValue(
          value.copyWith(selection: const TextSelection(baseOffset: 1, extentOffset: 4)),
          SelectionChangedCause.longPress
      );
    });
  }

  final GlobalKey<State<TextField>> textFieldKey;

  EditableTextState? get editableTextState {
    var textFieldState = textFieldKey.currentState;
    if (textFieldState is TextSelectionGestureDetectorBuilderDelegate) {
      var delegate = textFieldState as TextSelectionGestureDetectorBuilderDelegate;
      return delegate.editableTextKey.currentState;
    }
    return null;
  }
}

class TestWidgetSpan extends WidgetSpan {
  TestWidgetSpan({required super.child});

  @override
  void build(ui.ParagraphBuilder builder, {double textScaleFactor = 1.0, List<PlaceholderDimensions>? dimensions}) {
    super.build(builder, textScaleFactor: textScaleFactor, dimensions: dimensions);
    (child as Text).textSpan?.build(builder);
  }

  @override
  void computeToPlainText(StringBuffer buffer, {bool includeSemanticsLabels = true, bool includePlaceholders = true}) {
    buffer.write("abc");
  }

  @override
  int? codeUnitAt(int index) {
    return (child as Text).textSpan?.codeUnitAt(index);
  }

  @override
  InlineSpan? getSpanForPosition(ui.TextPosition position) {
    return (child as Text).textSpan?.getSpanForPosition(position);
  }
}

class TestPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle())
      ..pushStyle(ui.TextStyle(color: Colors.orange))
      ..addPlaceholder(100, 80, PlaceholderAlignment.top)
      ..addText("明月几时有？把酒问青天⑸。不知天上宫阙⑹，今夕是何年。我欲乘风归去⑺，又恐琼楼玉宇⑻，高处不胜寒⑼。起舞弄清影⑽，何似在人间⑾。转朱阁，低绮户，照无眠⑿。不应有恨，何事长向别时圆⒀？人有悲欢离合，月有阴晴圆缺，此事古难全⒁。但愿人长久⒂，千里共婵娟");
    var paragraph = paragraphBuilder.build()..layout(ui.ParagraphConstraints(width: size.width));
    canvas.drawParagraph(paragraph, const Offset(0, 0));
    print("=====================");
    print(paragraph.getBoxesForRange(0, 1));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}


