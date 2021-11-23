import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'dart:async';
import 'dart:convert';

import 'package:vanish_native/ui/todo_edit_view.dart';

class TodoDetail extends StatelessWidget {
  TodoDetail(this.todoId);

  final String todoId;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of(context, listen: false);
    return ReactiveForm(
      formGroup: viewModel.form,
      child: Column(
        children: [
          ReactiveTextField(
            formControlName: 'nickName',
          ),
          ReactiveFormConsumer(
            builder: (context, form, child) {
              return ElevatedButton(
                child: Text('Submit'),
                //if the form is valid, sign-in or whatever you need to do with the form data (I have used signIn)
                onPressed: form.valid ? viewModel.signIn : null,
              );
            },
          ),
        ],
      ),
    );
    // _TodoDetailState createState() => _TodoDetailState();
  }
}

// class _TodoDetailState extends State<TodoDetail> {
//
//   Map data;
//   Map result;
//
//   Future getTodoDetail(String todoId) async {
//     http.Response response = await http.get("http://localhost:8080/api/v1/todo/$todoId");
//     data = json.decode(utf8.decode(response.bodyBytes));
//     setState(() {
//       result = data["data"];
//       print(result);
//     });
//   }
//   @override
//   void initState() {
//     super.initState();
//     String todoId = widget.todoId;
//     getTodoDetail(todoId);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {},
//           icon: Icon(Icons.miscellaneous_services),
//         ),
//         title: Text('TODO詳細'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(builder: (context) {
//                   return TodoEdit(result["todoId"]);
//                 }),
//               );
//             },
//             icon: Icon(Icons.mode_edit),
//           ),
//         ],
//       ),
//       body: (
//         child: Column(
//           children: <Widget>[
//             Container(
//               child: Text(result["title"]),
//             ),
//             Container(
//               child: Text(result["startDate"]),
//             ),
//             Container(
//               child: Text(result["endDate"]),
//             ),
//             Container(
//               child: Text(result["note"]),
//             ),
//             Container(
//               child: Text(result["tags"].toString()),
//             ),
//             Container(
//               child: Text(result["status"].toString()),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
