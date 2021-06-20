import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoAdd extends StatefulWidget {
  @override
  _TodoAddState createState() => _TodoAddState();
}
class _TodoAddState extends State<TodoAdd> {

  // データを元に表示するWidget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO登録'),
      ),
      body: FormGroup()
    );
  }
}

class FormGroup extends StatefulWidget {
  @override
  _FormGroupState createState() => _FormGroupState();
}
class _FormGroupState extends State<FormGroup> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _startDay = '';
  String _endDay = '';
  String _note = '';
  List _tags = [];

  void _post() async {
    final url = "http://localhost:8080/api/v1/todo";
    Map res;
    Map requestBody =
    {
      "todoId": null,
      "userId": "12345678",
      "title": "test",
      "startDate": "2021/06/16",
      "endDate": "2021/06/20",
      "registeredAt": "2021/06/16",
      "updateAt": "2021/06/16",
      "completedAt": "",
      "deletedAt": "",
      "latitude": "",
      "longitude": "",
      "note": "test",
      "tags": ["仕事"],
      "todaySequences": "1",
      "status": "ture",
    };
    String body = json.encode(requestBody);
    http.Response response = await http.post(url, body: body);
    res = json.decode(utf8.decode(response.bodyBytes));
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: "やること：",
                hintText: '',
                border: OutlineInputBorder(),
              ),
              autovalidate: false,
              validator: (value) {
                if (value.isEmpty) {
                  return 'やることを入力してください';
                }
                return null;
              },
              onSaved: (value) => () {
                print('$value');
                _title = value;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime
                      .now()
                      .year),
                  lastDate: DateTime(DateTime
                      .now()
                      .year + 1),
                  locale: const Locale('ja'),
                );

                if (selectedDate != null) {
                  // do something
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "ノート：",
                hintText: '',
              ),
              autovalidate: false,
              validator: (value) {
                if (value.isEmpty) {
                  return '期限を入力してください';
                }
                return null;
              },
              onSaved: (value) => () {
                print('$value');
                _note = value;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "タグ：",
                hintText: '',
              ),
              autovalidate: false,
              validator: (value) {
                if (value.isEmpty) {
                  return 'タグを入力してください';
                }
                return null;
              },
              onSaved: (value) => () {
                print('$value');
                _tags.add(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  this._formKey.currentState.save();
                  this._post();
                }
              },
              child: Text('登録'),
            ),
          ),
        ],
      ),
    );
  }
}

Widget textFormField(String label, String errorMsg) {
  return TextFormField(
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: '$label：',
      hintText: '',
    ),
    autovalidate: false,
    validator: (value) {
      if (value.isEmpty) {
        return errorMsg;
      }
      return null;
    },
  );
}