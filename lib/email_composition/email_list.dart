import 'package:flutter/material.dart';

class EmailList extends StatefulWidget {
  const EmailList({Key? key}) : super(key: key);

  @override
  _EmailListState createState() => _EmailListState();
}

class _EmailListState extends State<EmailList> {
  void _requestFocus() {
    // TODO: move focus to the text input for this list
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _requestFocus,
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: const [
          EmailChip(
            contact: Contact(
              avatarColor: Colors.yellow,
              name: "SuperDeclarative!",
              email: "",
            ),
          ),
          EmailChip(
            contact: Contact(
              avatarColor: Colors.red,
              name: "Flutter Bounty Hunters",
              email: "",
            ),
          ),
          EmailChip(
            contact: Contact(
              avatarColor: Colors.blueAccent,
              name: "Flutter Clone Wars",
              email: "",
            ),
          ),
          // DeleteAwareTextField(),
        ],
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
      return SizedBox(
        height: double.infinity,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: ClipOval(
            child: Image.asset(
              contact.avatarAssetPath!,
            ),
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
          color: contact.avatarColor,
        ),
        child: Center(
          child: Text(
            contact.name != null ? contact.name![0].toUpperCase() : contact.email[0].toUpperCase(),
            style: TextStyle(
              color: labelColor,
              fontSize: 14,
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
          fontSize: 12,
        ),
      ),
    );
  }
}

class Contact {
  const Contact({
    this.avatarAssetPath,
    required this.avatarColor,
    this.name,
    required this.email,
  });

  /// Asset path to an image that represents the user.
  final String? avatarAssetPath;

  /// The color associated with this user, used when no avatar
  /// image is available.
  final Color avatarColor;

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
