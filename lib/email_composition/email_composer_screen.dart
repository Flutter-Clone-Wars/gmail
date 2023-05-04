import 'package:flutter/material.dart';
import 'package:gmail/email_composition/_email_list.dart';

class EmailComposerScreen extends StatelessWidget {
  const EmailComposerScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: _buildAppBar(),
      body: IconTheme(
        data: const IconThemeData(
          color: Color(0xFFBBBBBB),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildToField(),
            _buildDivider(),
            _buildFromField(),
            _buildDivider(),
            _buildSubjectField(),
            _buildDivider(),
            Expanded(
              child: _buildBodyEditor(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: Color(0xFFBBBBBB),
      ),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.attachment),
          onPressed: () {},
        ),
        const IconButton(
          icon: Icon(Icons.send),
          onPressed: null,
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildToField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            "To",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color(0xFFBBBBBB),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: EmailList(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Icon(
            Icons.keyboard_arrow_down,
          ),
        ),
      ],
    );
  }

  Widget _buildFromField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: const [
          Text(
            "From",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color(0xFFBBBBBB),
            ),
          ),
          Spacer(),
          Icon(
            Icons.keyboard_arrow_down,
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectField() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        "Subject",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Color(0xFFBBBBBB),
        ),
      ),
    );
  }

  Widget _buildBodyEditor() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        "Compose",
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Color(0xFF444444));
  }
}
