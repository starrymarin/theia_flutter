import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

abstract class TheiaTextInputClient extends ValueNotifier<TextEditingValue>
    with TextInputClient {

  TheiaTextInputClient(
    super.value, {
    TextInputConfiguration configuration = const TextInputConfiguration(),
  }) {
    _openConnection(configuration: configuration);
    _connection?.show();
    _connection?.setEditingState(value);
    addListener(() {
      update(value);
    });
  }

  TextInputConnection? _connection;

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
    this.value = value;
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {}
}
