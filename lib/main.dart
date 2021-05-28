import 'package:flutter/material.dart';
import 'package:vanish_native/ui/todo_list_view.dart';

void main() {
  runApp(new MaterialApp(home: new Vanish()));
}

class Vanish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vanish',
      theme: ThemeData(
        primarySwatch:Colors.blue,
      ),
      home: TodoList(),
    );
  }
}
