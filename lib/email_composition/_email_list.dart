import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:super_editor/super_editor.dart';

import '_deletion_aware_text_controller.dart';

/// A list of e-mail contacts, which grows as the user enters new addresses.
///
/// Each time the user enters a space " ", the upstream token is converted to
/// an chip.
class EmailList extends StatefulWidget {
  const EmailList({Key? key}) : super(key: key);

  @override
  _EmailListState createState() => _EmailListState();
}

class _EmailListState extends State<EmailList> {
  final _contacts = <Contact>[];
  int? _focusedContact;

  late final FocusNode _emailInputFocus;
  late final DeletionAwareImeTextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _emailInputFocus = FocusNode();
    _textController = DeletionAwareImeTextEditingController(
      onDeletionAtBeginning: _deleteLastContact,
    ) //
      ..addListener(_onTextControllerChange);
  }

  @override
  void dispose() {
    _emailInputFocus.dispose();
    super.dispose();
  }

  void _focusTextField() {
    _emailInputFocus.requestFocus();
  }

  void _onTextControllerChange() {
    if (_textController.text.text.isNotEmpty && _focusedContact != null) {
      setState(() {
        _focusedContact = null;
      });
    }

    if (!_textController.text.text.endsWith(" ")) {
      return;
    }

    final token = _textController.extractLeadingToken();
    if (token.isEmpty) {
      return;
    }

    setState(() {
      _contacts.add(
        Contact(
          avatarBackgroundColor: HSVColor.fromAHSV(1.0, Random().nextDouble() * 360, 1.0, 1.0).toColor(),
          email: token,
        ),
      );
    });
  }

  void _deleteLastContact() {
    if (_contacts.isEmpty) {
      return;
    }

    if (_focusedContact == null) {
      setState(() {
        _focusedContact = _contacts.length - 1;
      });
      return;
    }

    setState(() {
      _contacts.removeLast();
      _focusedContact = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _focusTextField,
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: TagList(
          tagSpacing: 8,
          rowSpacing: 4,
          children: [
            for (final contact in _contacts) //
              EmailChip(
                contact: contact,
                backgroundColor: _focusedContact != null && _contacts[_focusedContact!] == contact
                    ? Colors.white.withOpacity(0.2)
                    : Colors.transparent,
              ),
            _buildTextInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return TagListFillRemainingSpace(
      child: SizedBox(
        height: 26,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 100),
          child: Center(
            child: IntrinsicHeight(
              child: SuperTextField(
                focusNode: _emailInputFocus,
                textController: _textController,
                maxLines: null,
                // textInputAction: TextInputAction.next,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmailChip extends StatelessWidget {
  const EmailChip({
    Key? key,
    required this.contact,
    this.borderColor = const Color(0xFF444444),
    this.labelColor = Colors.white,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  final Contact contact;
  final Color borderColor;
  final Color labelColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: StadiumBorder(
          side: BorderSide(width: 1, color: borderColor),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatar(),
          _buildLabel(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (contact.avatarAssetPath != null) {
      // When an avatar asset is available, show the avatar image.
      return AspectRatio(
        aspectRatio: 1.0,
        child: ClipOval(
          child: Image.asset(
            contact.avatarAssetPath!,
          ),
        ),
      );
    }

    // When no avatar image is available, show a letter with a
    // color behind it.
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: contact.avatarBackgroundColor,
        ),
        child: Center(
          child: Text(
            contact.name != null ? contact.name![0].toUpperCase() : contact.email[0].toUpperCase(),
            style: TextStyle(
              color: contact.avatarForegroundColor,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 12),
      child: Text(
        contact.name ?? contact.email,
        style: TextStyle(
          color: labelColor,
          fontSize: 10,
        ),
      ),
    );
  }
}

class Contact {
  const Contact({
    this.avatarAssetPath,
    required this.avatarBackgroundColor,
    this.avatarForegroundColor = Colors.white,
    this.name,
    required this.email,
  });

  /// Asset path to an image that represents the user.
  final String? avatarAssetPath;

  /// The color associated with this user, used when no avatar
  /// image is available.
  final Color avatarBackgroundColor;

  /// A color that contrasts with the [avatarBackgroundColor], used to
  /// display text on top of the [avatarBackgroundColor].
  final Color avatarForegroundColor;

  /// The user's full name.
  final String? name;

  /// The user's email.
  final String email;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contact &&
          runtimeType == other.runtimeType &&
          avatarAssetPath == other.avatarAssetPath &&
          name == other.name &&
          email == other.email;

  @override
  int get hashCode => avatarAssetPath.hashCode ^ name.hashCode ^ email.hashCode;
}

class TagList extends MultiChildRenderObjectWidget {
  TagList({
    Key? key,
    this.tagSpacing = 0,
    this.rowSpacing = 0,
    super.children,
  }) : super(key: key);

  final double tagSpacing;
  final double rowSpacing;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderTagList(
      tagSpacing: tagSpacing,
      rowSpacing: rowSpacing,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderTagList renderObject) {
    renderObject
      ..tagSpacing = tagSpacing
      ..rowSpacing = rowSpacing;
  }
}

class RenderTagList extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, ContainerBoxParentData<RenderBox>>,
        RenderBoxContainerDefaultsMixin<RenderBox, ContainerBoxParentData<RenderBox>> {
  RenderTagList({
    double tagSpacing = 0.0,
    double rowSpacing = 0.0,
  })  : _tagSpacing = tagSpacing,
        _rowSpacing = rowSpacing;

  double _tagSpacing;
  set tagSpacing(double newValue) {
    if (newValue == _tagSpacing) {
      return;
    }

    _tagSpacing = newValue;
    markNeedsLayout();
  }

  double _rowSpacing;
  set rowSpacing(double newValue) {
    if (newValue == _rowSpacing) {
      return;
    }

    _rowSpacing = newValue;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    child.parentData = RenderTagListParentData();
  }

  double maxWidth = 0;
  double remainingWidth = 0;
  double rowHeight = 0;
  double x = 0;
  double y = 0;

  @override
  void performLayout() {
    maxWidth = constraints.maxWidth;

    final children = getChildrenAsList();

    remainingWidth = maxWidth;
    rowHeight = 0;
    x = 0;
    y = 0;
    for (int i = 0; i < children.length; i += 1) {
      final child = children[i];

      final childParentData = child.parentData as RenderTagListParentData;
      if (childParentData.useRemainingRowSpace && maxWidth == double.infinity) {
        throw Exception("Tried to use all remaining row space in a RenderTagList with infinite width.");
      }

      if (!childParentData.useRemainingRowSpace) {
        _layoutIntrinsicSizeChild(child, childParentData);
      } else {
        _layoutRemainingSpaceChild(child, childParentData);
      }

      // Move to the start of the next child.
      x += child.size.width + _tagSpacing;
      remainingWidth -= child.size.width + _tagSpacing;

      // Track the tallest item in the row, which determines the height of the whole row.
      rowHeight = max(rowHeight, child.size.height);
    }

    size = Size(maxWidth, y + rowHeight);
  }

  void _layoutIntrinsicSizeChild(RenderBox child, RenderTagListParentData childParentData) {
    child.layout(
      const BoxConstraints(),
      parentUsesSize: true,
    );

    if (child.size.width >= remainingWidth) {
      // There's not enough remaining room in this row to fit this child. Create a
      // new row.
      _startNewRow();
    }

    childParentData.offset = Offset(x, y);
  }

  void _layoutRemainingSpaceChild(RenderBox child, RenderTagListParentData childParentData) {
    final childMaxWidth = child.getMaxIntrinsicWidth(double.infinity);
    if (childMaxWidth > remainingWidth) {
      // There's not enough remaining room in this row to fit this child. Create a
      // new row.
      _startNewRow();
    }

    childParentData.offset = Offset(x, y);
    child.layout(
      BoxConstraints(minWidth: remainingWidth, maxWidth: remainingWidth, minHeight: rowHeight),
      parentUsesSize: true,
    );
  }

  void _startNewRow() {
    y += rowHeight + _rowSpacing;
    x = 0;
    rowHeight = 0;
    remainingWidth = maxWidth;
  }

  @override
  bool hitTest(HitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(
      BoxHitTestResult.wrap(result),
      position: position,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}

class TagListFillRemainingSpace extends ParentDataWidget<RenderTagListParentData> {
  const TagListFillRemainingSpace({
    super.key,
    required super.child,
  });

  @override
  void applyParentData(RenderObject renderObject) {
    renderObject.parentData = RenderTagListParentData(
      useRemainingRowSpace: true,
    );
  }

  @override
  Type get debugTypicalAncestorWidgetClass => TagList;
}

class RenderTagListParentData extends ContainerBoxParentData<RenderBox> {
  RenderTagListParentData({
    this.useRemainingRowSpace = false,
  });

  final bool useRemainingRowSpace;
}
