import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tugas_harian_app/provider/todo_provider.dart';
import 'package:tugas_harian_app/view/create_task.dart';
import 'package:tugas_harian_app/view/login_view.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDateTime;

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Todo List'),
          backgroundColor: const Color.fromARGB(1000, 109, 165, 192)),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(1000, 109, 165, 192),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(200),
                        bottomRight: Radius.circular(200))),
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'Today:  ${DateFormat('d MMMM').format(DateTime.now())}',
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text('Logout'),
                                      content:
                                          const Text('Are you sure want to logout?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No')),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (ctx) =>
                                                          LoginView()));
                                            },
                                            child: const Text('Yes'))
                                      ],
                                    ));
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 30,
                          ))
                    ],
                  ),
                ),
              ),
              if (todoProvider.todos.isNotEmpty)
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content:
                                    const Text('Are You Sure To Clear All Task?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('No')),
                                  ElevatedButton(
                                      onPressed: () {
                                        todoProvider.clearAllTodo();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Yes'))
                                ],
                              ));
                    },
                    child: const Text('Clear All Task')),
              Visibility(
                visible: todoProvider.todos.isNotEmpty,
                replacement: Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            width: 400,
                            height: 400,
                            child: RiveAnimation.asset(
                              'assets/task.riv',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const Text('You Dont Have Any Tasks'),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => CreateTaskPage()));
                              },
                              child: const Text('Create Task'))
                        ],
                      ),
                    ),
                  ),
                ),
                child: Expanded(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ListView.builder(
                        itemCount: todoProvider.todos.length,
                        itemBuilder: (context, index) {
                          final todo = todoProvider.todos[index];
                          return Dismissible(
                            key: Key(todo.id.toString()),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) {
                              todoProvider.deleteTodo(todo.id!);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => CreateTaskPage(
                                                todo: todo,
                                              )));
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        if (todo.scheduledTime != null)
                                          Text(
                                              style: TextStyle(
                                                decoration: todo.isDone
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                              ),
                                              DateFormat('d MMMM').format(todo
                                                          .scheduledTime!) ==
                                                      DateFormat('d MMMM')
                                                          .format(
                                                              DateTime.now())
                                                  ? DateFormat('H:mm').format(
                                                      todo.scheduledTime!)
                                                  : '${DateFormat('d MMMM').format(todo.scheduledTime!)}\n${DateFormat('H:mm').format(todo.scheduledTime!)}'),
                                        const SizedBox(
                                          height: 50,
                                          child: VerticalDivider(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            todo.title,
                                            style: TextStyle(
                                                decoration: todo.isDone
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                        Checkbox(
                                            value: todo.isDone,
                                            activeColor: const Color.fromRGBO(
                                                112, 191, 233, 1),
                                            onChanged: (value) {
                                              Provider.of<TodoProvider>(context,
                                                      listen: false)
                                                  .toogleTodos(todo);
                                            })
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.all(30),
                        child: FloatingActionButton(
                          backgroundColor: const Color.fromRGBO(64, 157, 207, 1),
                          foregroundColor: Colors.white,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => CreateTaskPage()));
                          },
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
