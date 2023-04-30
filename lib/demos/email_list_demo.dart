import 'package:flutter/material.dart';
import 'package:gmail/demos/demo_scaffold.dart';
import 'package:gmail/email_composition/email_list.dart';

class EmailListDemo extends StatelessWidget {
  const EmailListDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      background: const Color(0xFF222222),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const EmailList(),
      ),
    );
  }
}
