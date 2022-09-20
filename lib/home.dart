import 'package:app/api.dart';
import 'package:app/future_widget.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FutureWidget(
        future: Api.login,
        widget: Center(child: Icon(Icons.adjust_rounded)),
      ),
    );
  }
}