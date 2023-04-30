import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeleteAwareTextField extends StatefulWidget {
  const DeleteAwareTextField({Key? key}) : super(key: key);

  @override
  _DeleteAwareTextFieldState createState() => _DeleteAwareTextFieldState();
}

class _DeleteAwareTextFieldState extends State<DeleteAwareTextField> implements TextInputClient {
  @override
  void connectionClosed() {
    // TODO: implement connectionClosed
  }

  @override
  TextEditingValue? get currentTextEditingValue => throw UnimplementedError();

  @override
  AutofillScope? get currentAutofillScope => null;

  @override
  void updateEditingValue(TextEditingValue value) {
    // TODO: implement updateEditingValue
  }

  @override
  void performAction(TextInputAction action) {
    // TODO: implement performAction
  }

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) {
    // TODO: implement performPrivateCommand
  }

  @override
  void showAutocorrectionPromptRect(int start, int end) {
    // TODO: implement showAutocorrectionPromptRect
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {
    // TODO: implement updateFloatingCursor
  }

  @override
  void didChangeInputControl(TextInputControl? oldControl, TextInputControl? newControl) {
    // TODO: implement didChangeInputControl
  }

  @override
  void insertTextPlaceholder(Size size) {
    // TODO: implement insertTextPlaceholder
  }

  @override
  void performSelector(String selectorName) {
    // TODO: implement performSelector
  }

  @override
  void removeTextPlaceholder() {
    // TODO: implement removeTextPlaceholder
  }

  @override
  void showToolbar() {
    // TODO: implement showToolbar
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
