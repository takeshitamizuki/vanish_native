import 'package:flutter/material.dart';
import 'package:vanish_native/ui/todo_add_view.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  // Todoリストのデータ
  Map data;
  List todoList = [];
  int totalCount = 0;

  Future getTodoList() async {
    http.Response response = await http.get("http://localhost:8080/api/v1/todolist");
    data = json.decode(utf8.decode(response.bodyBytes));
    setState(() {
      todoList = data["data"]["todoList"];
      totalCount = data["data"]["totalCount"];
      print(todoList);
    });
  }

  @override
  void initState() {
    super.initState();
    getTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('リスト一覧'),
      ),
      body: ListView.builder(
        itemCount: totalCount,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(left: 60, top: 10, right: 10, bottom: 10),
            child: Container(
              margin: EdgeInsets.all(10),
              width: 300,
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Text(todoList[index]["title"]),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        child: Text(todoList[index]["endDate"].split(" ")[0]),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Text(todoList[index]["tags"][0]),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(todoList[index]["tags"][1]),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 30),
            child: FloatingActionButton(
              heroTag: 'addTodoLeft',
              child: Icon(Icons.add),
              onPressed: () async {
                // "push"で新規画面に遷移
                // リスト追加画面から渡される値を受け取る
                final newListText = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    // 遷移先の画面としてリスト追加画面を指定
                    return TodoAdd();
                  }),
                );
                if (newListText != null) {
                  // キャンセルした場合は newListText が null となるので注意
                  setState(() {
                    todoList.add(newListText);
                  });
                }
              },
            ),
          ),
          Container(
            child: FloatingActionButton(
              heroTag: 'addTodoRight',
              child: Icon(Icons.add),
              onPressed: () async {
                // "push"で新規画面に遷移
                // リスト追加画面から渡される値を受け取る
                final newListText = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    // 遷移先の画面としてリスト追加画面を指定
                    return TodoAdd();
                  }),
                );
                if (newListText != null) {
                  // キャンセルした場合は newListText が null となるので注意
                  setState(() {
                    todoList.add(newListText);
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}