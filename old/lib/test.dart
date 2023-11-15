import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Test();
  }
}

class _Test extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Bar"),
      ),
      body: Scaffold(
        bottomNavigationBar: TextField(
          decoration: InputDecoration(hintText: "Search bar"),
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  child: Text("$index"),
                  padding: EdgeInsets.all(8),
                );
              }, childCount: 200),
            )
          ],
        ),
      ),
    );
  }
}