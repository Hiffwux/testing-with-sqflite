import 'package:flutter/material.dart';
import 'package:sqlite_1/model/todo_model.dart';

import '../db.dart';

class TodoAddEdit extends StatefulWidget {
  const TodoAddEdit({Key? key}) : super(key: key);
  static const routeName = '/TodoAddEdit';

  @override
  _TodoAddEditState createState() => _TodoAddEditState();
}

class _TodoAddEditState extends State<TodoAddEdit> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerSubtitle = TextEditingController();
  TextEditingController controllerDesc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая заметка'),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.deepPurple,
        actions: [IconButton(onPressed: addTodo, icon: const Icon(Icons.check))],
      ),
      body: Form(
        key: _formKey,
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: TextFormField(
              validator: (value) {
                if (value?.isEmpty == true) {
                  return 'Поле обязательно';
                }
                return null;
              },
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Заголовок'),
              controller: controllerTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: '<Подзаголовок>'),
              controller: controllerSubtitle,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              validator: (value) {
                if (value?.isEmpty == true) {
                  return 'Поле обязательно';
                }
                return null;
              },
              maxLines: null,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Текст заметки'),
              controller: controllerDesc,
            ),
          )
        ],
      )),
    );
  }

  Future addTodo() async {
    if(_formKey.currentState!.validate() == true){
      final todo = TodoModel(
          title: controllerTitle.text,
          subtitle: controllerSubtitle.text,
          desc: controllerDesc.text);
      await DB.instance.insertTodo(todo).whenComplete(() => Navigator.pop(context));
    } else {
      final snackBar = SnackBar(
        content: const Text('Заполните заголовок или добавтье описание'),
        action: SnackBarAction(
          label: 'Хорошо}',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
