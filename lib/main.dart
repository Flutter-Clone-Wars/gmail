import 'package:flutter/material.dart';
import 'package:gmail/demos/demo_scaffold.dart';
import 'package:gmail/demos/email_list_demo.dart';
import 'package:gmail/email_composition/email_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GMail Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DemoScaffold(
        background: Colors.white,
        child: EmailListDemo(),
      ),
    );

    // return const Scaffold(
    //   body: Center(
    //     child: EmailListDemo(),
    //   ),
    // );
  }
}
