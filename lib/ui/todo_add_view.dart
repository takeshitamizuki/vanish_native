import 'package:flutter/material.dart';

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
        title: Text('リスト追加'),
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
  String _todo = '';
  String _startDay = '';
  String _endDay = '';
  String _note = '';
  List tags = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: "やること：",
              hintText: '',
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
              _todo = value;
            },
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year),
                lastDate: DateTime(DateTime.now().year + 1),
                locale: const Locale('ja'),
              );

              if (selectedDate != null) {
                // do something
              }
            },
          ),
          TextFormField(
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  this._formKey.currentState.save();
                }
              },
              child: Text('Submit'),
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