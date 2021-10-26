import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';

class TodoEdit extends StatefulWidget {
  TodoEdit(this.todoId);

  final String todoId;

  @override
  _TodoEditState createState() => _TodoEditState();
}

class _TodoEditState extends State<TodoEdit> {
  Map data;
  Map result;

  Future getTodoDetail(String todoId) async {
    http.Response response = await http.get(
        "http://localhost:8080/api/v1/todo/$todoId");
    data = json.decode(utf8.decode(response.bodyBytes));
    setState(() {
      result = data["data"];
      print(result);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TODO更新'),
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
  DateTime date = new DateTime.now();
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
    for (var key in _chipList) {
      _tags.add(chipToString(key));
    }
    Map requestBody = {
      "todoId": null,
      "userId": "12345678",
      "title": _title,
      "startDate": _startDay,
      "endDate": _endDay,
      "completedAt": null,
      "deletedAt": null,
      "latitude": null,
      "longitude": null,
      "note": _note,
      "tags": _tags,
      "todaySequences": "1",
      "status": true,
    };
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String body = json.encode(requestBody);
    http.Response response = await http.post(url, body: body, headers: headers);
    res = json.decode(utf8.decode(response.bodyBytes));
  }

  selectDate(BuildContext context, String startOrEnd) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
      locale: const Locale('ja'),
    );
    this.setState(() {
      DateFormat outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      String date = outputFormat.format(selectedDate);
      if (startOrEnd == 'start') {
        this._startDay = date;
      } else if (startOrEnd == 'end') {
        this._endDay = date;
      }
    });
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
            child: Row(
              children: [
                RaisedButton(
                  child: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      this.selectDate(context, 'start');
                    },
                  ),
                ),
                Text(this._startDay)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                RaisedButton(
                  child: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      this.selectDate(context, 'end');
                    },
                  ),
                ),
                Text(this._endDay)
              ],
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
                  child: Text('更新'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String chipToString(Chip chip) {
  Text text = chip.label;
  return text.data;
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
