import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _body(),
      ],
    ));
  }

  Widget _body() {
    return SliverList.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 300,
            height: 300,
            color: Colors.red,
          );
        });
  }
}
