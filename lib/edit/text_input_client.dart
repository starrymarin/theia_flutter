import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:theia_flutter/edit/input_action.dart';

/// [TextInputConnection]中的editingState包含[_kDeleteLabel]，[ValueNotifier]中
/// 的value不包含[_kDeleteLabel]，这个值将被用来显示和绘制光标等
abstract class TheiaTextInputClient extends ValueNotifier<TextEditingValue>
    with TextInputClient {
  static const _kDeleteLabel = "\u200b";
  static const deleteLabelLength = _kDeleteLabel.length;

  static TextEditingValue _makeGuessDeletableEditingValue(
      TextEditingValue value) {
    return TextEditingValue(
      text: "$_kDeleteLabel${value.text}",
      selection: value.selection.copyWith(
        baseOffset: value.selection.baseOffset + deleteLabelLength,
        extentOffset: value.selection.extentOffset + deleteLabelLength,
      ),
    );
  }

  TheiaTextInputClient(
    super.value, {
    TextInputConfiguration configuration = const TextInputConfiguration(),
  }) {
    _openConnection(configuration: configuration);
    _connection?.show();
    TextEditingValue editingState = _makeGuessDeletableEditingValue(value);
    _currentEditingState = editingState;
    _connection?.setEditingState(editingState);
    addListener(() {
      update(value);
    });
  }

  TextInputConnection? _connection;

  TextEditingValue? _currentEditingState;

  void _openConnection({
    TextInputConfiguration configuration = const TextInputConfiguration(),
  }) {
    TextInput.ensureInitialized();
    _connection = TextInput.attach(this, configuration);
  }

  void closeConnection() {
    _connection?.close();
    _connection = null;
  }

  void update(TextEditingValue value);

  /// 处理action，return true 表示已处理，false 表示未处理
  bool handleInputAction(InputAction action) {
    return false;
  }

  @override
  void connectionClosed() {
    closeConnection();
  }

  @override
  AutofillScope? get currentAutofillScope => null;

  @override
  TextEditingValue? get currentTextEditingValue => value;

  @override
  void performAction(TextInputAction action) {}

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) {}

  @override
  void showAutocorrectionPromptRect(int start, int end) {}

  @override
  void updateEditingValue(TextEditingValue value) {
    if (value.text.length >= deleteLabelLength) {
      this.value = TextEditingValue(
        text: value.text.substring(deleteLabelLength),
        selection: value.selection.copyWith(
          baseOffset: value.selection.baseOffset - deleteLabelLength,
          extentOffset: value.selection.extentOffset - deleteLabelLength,
        ),
      );
    } else {
      this.value = value;
    }
    bool guessDelete =
        _currentEditingState?.text == _kDeleteLabel && value.text.isEmpty;
    if (guessDelete) {
      debugPrint("delete");
      if (!handleInputAction(InputDeleteAction())) {
        TextEditingValue editingState = _makeGuessDeletableEditingValue(value);
        _connection?.setEditingState(editingState);
        _currentEditingState = editingState;
        return;
      }
    }
    _currentEditingState = value;
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {}
}
