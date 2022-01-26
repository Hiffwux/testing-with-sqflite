import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_1/model/todo_model.dart';
import '../db.dart';

class TodoMain extends StatefulWidget {
  const TodoMain({Key? key}) : super(key: key);

  @override
  _TodoMainState createState() => _TodoMainState();
}

class _TodoMainState extends State<TodoMain> {
  late List<TodoModel> listOfTodos;
  bool isLoading = false;
  final TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getListOfTodos();
  }

  Future getListOfTodos() async {
    setState(() {
      isLoading = true;
    });
    listOfTodos = await DB.instance.retrieveTodo();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    DB.instance.closeDB();
    super.dispose();
    getListOfTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Hiffer'),
        actions: [
          IconButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                getListOfTodos();
                DB.instance.insertTodo(const TodoModel(
                    title: 'Привет',
                    desc: 'Lorem ipsum dolor sit amet,'
                        'consectetur adipiscing elit.'
                        'Suspendisse gravida lobortis'
                        ' lacus, ut finibus lectus luctus non. '
                        'Quisque sed odio.',
                    subtitle: '<Тестовый подзаголовок>'));
                setState(() {
                  isLoading = false;
                });
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
          child: isLoading == true
              ? const CircularProgressIndicator()
              : listOfTodos.isEmpty
                  ? const Text('Пусто', style: TextStyle(fontSize: 24),)
                  : buildList()),
    );
  }

  Widget buildList() {
    return RefreshIndicator(

      onRefresh: () async{
        setState(() {
          isLoading = true;
        });
        getListOfTodos();
        setState(() {
          isLoading = false;
        });
        },
      child: ListView.builder(
          itemCount: listOfTodos.length,
          itemBuilder: (context, index) {
            final todo = listOfTodos[index];
            return Dismissible(
              onDismissed: (direction) async{
                await DB.instance.deleteTodo(listOfTodos[index].id!);
                getListOfTodos();
              },
              key: ValueKey(todo),
              child: InkWell(
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(todo.title,style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
                      Text(todo.subtitle == null
                          ? '<Без описания>'
                          : todo.subtitle!,style: const TextStyle(color: Colors.grey)),
                      Text(todo.desc),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future<Object?> addTodo() {
    return showGeneralDialog(
        context: context,
        pageBuilder: (context, animFirst, animSecond) {
          return Scaffold(
            body: Form(
                child: Column(
              children: [
                TextFormField(controller: titleController),
              ],
            )),
          );
        });
  }
}
