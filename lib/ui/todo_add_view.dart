import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

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
  var _textFieldFocusNode;
  var _inputController = TextEditingController();
  var _chipList = List<Chip>();
  var _keyNumber = 0;
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _startDay = '';
  String _endDay = '';
  String _note = '';
  List _tags = [];

  @override
  void initState() {
    _textFieldFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  void _onSubmitted(String text) {
    setState(() {
      _inputController.text = '';
      _addChip(text);
      FocusScope.of(context).requestFocus(_textFieldFocusNode);
    });
  }

  void _addChip(String text) {
    var chipKey = Key(text);
    _keyNumber++;

    _chipList.add(
      Chip(
        key: chipKey,
        label: Text(text),
        onDeleted: () => _deleteChip(chipKey),
      ),
    );
  }

  void _deleteChip(Key chipKey) {
    setState(() => _chipList.removeWhere((Widget w) => w.key == chipKey));
  }

  void _post() async {
    final url = "http://localhost:8080/api/v1/todo";
    Map res;
    print(_chipList[0].label.toStringShallow().split(" ").last);
    List<String> list;
    for (var key in _chipList) {
      list.add(key.label.toStringShallow().split(" ").last.toString());
    }
    Map requestBody =
    {
      "todoId": null,
      "userId": "12345678",
      "title": _title,
      "startDate": "2021-06-16 12:00:00",
      "endDate": "2021-06-20 12:00:00",
      "registeredAt": "2021-06-16 12:00:00",
      "updateAt": "2021-06-16 12:00:00",
      "completedAt": null,
      "deletedAt": null,
      "latitude": null,
      "longitude": null,
      "note": _note,
      "tags": list,
      "todaySequences": "1",
      "status": "true",
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json'
    };
    String body = json.encode(requestBody);
    http.Response response = await http.post(url, body: body, headers: headers);
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
              onSaved: (value) => setState(() {
                _title = value;
              }),
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
              onSaved: (value) => setState(() {
                _note = value;
              }),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextField(
                  focusNode: _textFieldFocusNode,
                  autofocus: true,
                  controller: _inputController,
                  decoration: const InputDecoration(
                    labelText: "タグ：",
                    hintText: '',
                  ),
                  onSubmitted: _onSubmitted,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 8.0,
                        runSpacing: 0.0,
                        direction: Axis.vertical,
                        children: _chipList,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('キャンセル'),
                ),
              ),
              Container(
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