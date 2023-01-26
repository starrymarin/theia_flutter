enum InputActionType {
  delete
}

class InputAction {
  const InputAction({required this.type});

  final InputActionType type;
}

class InputDeleteAction extends InputAction {
  InputDeleteAction() : super(type: InputActionType.delete);
}