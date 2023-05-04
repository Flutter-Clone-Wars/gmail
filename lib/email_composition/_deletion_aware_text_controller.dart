import 'dart:math';

import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

class DeletionAwareImeTextEditingController extends ImeAttributedTextEditingController {
  static const _invisiblePrefix = "&";

  DeletionAwareImeTextEditingController({
    super.controller,
    super.disposeClientController = true,
    super.onIOSFloatingCursorChange,
    super.keyboardAppearance = Brightness.dark,
    super.inputConnectionFactory,
    this.onDeletionAtBeginning,
  }) {
    text = text.insertString(textToInsert: _invisiblePrefix, startOffset: 0);
  }

  final VoidCallback? onDeletionAtBeginning;

  bool get _hasInvisiblePrefix => super.text.text.startsWith(_invisiblePrefix);

  @override
  AttributedText get text => _hasInvisiblePrefix ? _text.copyText(_invisiblePrefix.length) : _text;

  AttributedText get _text => super.text;

  @override
  TextSelection get selection => _hasInvisiblePrefix && _selection.isValid
      ? TextSelection(
          baseOffset: _selection.baseOffset - _invisiblePrefix.length,
          extentOffset: _selection.extentOffset - _invisiblePrefix.length,
        )
      : _selection;

  TextSelection get _selection => super.selection;

  @override
  set selection(TextSelection newValue) {
    print("Setting selection to: $newValue, has prefix? $_hasInvisiblePrefix, is valid? ${newValue.isValid}");

    _hasInvisiblePrefix && newValue.isValid
        ? super.selection = TextSelection(
            baseOffset: newValue.baseOffset + _invisiblePrefix.length,
            extentOffset: newValue.extentOffset + _invisiblePrefix.length,
          )
        : super.selection = newValue.isValid ? newValue : const TextSelection.collapsed(offset: 1);
    print("Now super selection is: ${super.selection}");
  }

  @override
  TextRange get composingRegion => _hasInvisiblePrefix && _composingRegion.isValid
      ? TextRange(
          start: _composingRegion.start - _invisiblePrefix.length,
          end: _composingRegion.end - _invisiblePrefix.length,
        )
      : _composingRegion;

  TextRange get _composingRegion => super.composingRegion;

  @override
  TextEditingValue? get currentTextEditingValue => TextEditingValue(
        text: _text.text,
        selection: _selection,
        composing: _composingRegion,
      );

  String extractLeadingToken() {
    print("extractLeadingToken()");
    if (text.text.isEmpty) {
      return "";
    }

    if (text.text.trim().isEmpty) {
      delete(
        from: _invisiblePrefix.length,
        to: _text.text.length,
        newSelection: const TextSelection.collapsed(offset: 1),
        newComposingRegion: TextRange.empty,
      );
      return "";
    }

    final spaceIndex = _text.text.indexOf(" ");
    if (spaceIndex < 0) {
      return "";
    }

    final token = _text.text.substring(_invisiblePrefix.length, spaceIndex);
    print(" - token: $token");
    update(
      text: _text.removeRegion(startOffset: _invisiblePrefix.length, endOffset: spaceIndex + 1),
      selection: const TextSelection.collapsed(offset: 1),
      composingRegion: TextRange.empty,
    );

    return token;
  }

  @override
  void delete({required int from, required int to, TextSelection? newSelection, TextRange? newComposingRegion}) {
    print("Delete()");
    print(" - from: $from");
    print(" - to: $to");
    print(" - new selection: $newSelection");
    print(" - new composing: $newComposingRegion");
    if (from == 0 || to == 0) {
      onDeletionAtBeginning?.call();
    }

    final adjustedSelection = newSelection != null && newSelection.isValid
        ? TextSelection(
            baseOffset: max(newSelection.baseOffset, _invisiblePrefix.length),
            extentOffset: max(newSelection.extentOffset, _invisiblePrefix.length),
          )
        : null;

    final adjustedComposingRegion = newComposingRegion != null && newComposingRegion.isValid
        ? TextRange(
            start: max(newComposingRegion.start, _invisiblePrefix.length),
            end: max(newComposingRegion.end, _invisiblePrefix.length),
          )
        : null;

    print("Adjusted selection:\n$adjustedSelection");
    print("");
    print("Adjusted composing region:\n$adjustedComposingRegion");

    super.delete(
      from: max(from, _invisiblePrefix.length),
      to: max(to, _invisiblePrefix.length),
      newSelection: adjustedSelection,
      newComposingRegion: adjustedComposingRegion,
    );
  }
}
