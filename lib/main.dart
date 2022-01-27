import 'package:flutter/material.dart';
import 'package:sqlite_1/pages/add_edit_todo.dart';
import 'package:sqlite_1/pages/todo_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      TodoMain.routeName: (ctx) => const TodoMain(),
      TodoAddEdit.routeName: (ctx) => const TodoAddEdit(),
    };
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: getRoutes(),
      initialRoute: TodoMain.routeName,
    );
  }
}

