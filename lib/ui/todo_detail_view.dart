import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class TodoDetail extends StatefulWidget {
  TodoDetail(this.id);
  int id;

  @override
  _TodoDetailState createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {

  Map data;
  Map result;

  Future getTodoDetail(int id) async {
    http.Response response = await http.get("http://localhost:8080/api/v1/todo/$id");
    data = json.decode(utf8.decode(response.bodyBytes));
    setState(() {
      result = data["data"];
      print(result);
    });
  }
  @override
  void initState() {
    super.initState();
    int id = widget.id;
    getTodoDetail(id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.miscellaneous_services),
        ),
        title: Text('TODO詳細'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.mode_edit),
          ),
        ],
      ),
      body: Center(
        child: Row(
          children: <Widget>[
            Container(
              child: Text(data["endDate"]),
            ),
          ],
        ),
      ),
    );
  }
}