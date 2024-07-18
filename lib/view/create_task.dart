import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:tugas_harian_app/model/todo_model.dart';
import 'package:tugas_harian_app/provider/todo_provider.dart';

// ignore: must_be_immutable
class CreateTaskPage extends StatefulWidget {
  TodoModel? todo;
  CreateTaskPage({super.key, this.todo});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  TextEditingController titleController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DateTime? selectedDateTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.todo != null) {
      selectedDateTime = widget.todo?.scheduledTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.todo?.title ?? '';
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(1000, 109, 165, 192),
          title: Text(widget.todo == null ? 'Add Todo' : 'Edit Todo')),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 100,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(1000, 109, 165, 192),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(200),
                      bottomRight: Radius.circular(200)),
                ),
                child: Center(
                  child: Text(
                    widget.todo == null ? 'New Task' : 'Edit Task',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: titleController,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: widget.todo == null
                              ? 'Task'
                              : titleController.text),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Set Scheduled Time'),
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          showDate(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedDateTime == null
                                  ? 'Date'
                                  : DateFormat('d MMMM yyyy H:mm')
                                      .format(selectedDateTime!)),
                              const Icon(Icons.date_range)
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (widget.todo == null) {
                                Provider.of<TodoProvider>(context,
                                        listen: false)
                                    .addTodo(TodoModel(
                                        title: titleController.text,
                                        scheduledTime: selectedDateTime));
                                Navigator.pop(context);
                                toastification.show(
                                    context: context,
                                    title: const Text('Succes'),
                                    description: const Text('Succes Create New Task'),
                                    type: ToastificationType.info,
                                    showProgressBar: false,
                                    closeOnClick: true,
                                    dragToClose: true,
                                    dismissDirection:
                                        DismissDirection.horizontal,
                                    autoCloseDuration: const Duration(seconds: 3),
                                    style: ToastificationStyle.flat);
                              } else {
                                Provider.of<TodoProvider>(context,
                                        listen: false)
                                    .updateTodo(TodoModel(
                                        title: titleController.text,
                                        id: widget.todo!.id,
                                        scheduledTime: selectedDateTime));
                                Navigator.pop(context);
                                toastification.show(
                                    context: context,
                                    title: const Text('Succes'),
                                    description: const Text('Succes Edit The Task'),
                                    type: ToastificationType.info,
                                    showProgressBar: false,
                                    closeOnClick: true,
                                    dragToClose: true,
                                    dismissDirection:
                                        DismissDirection.horizontal,
                                    autoCloseDuration: const Duration(seconds: 3),
                                    style: ToastificationStyle.flat);
                              }
                            }
                          },
                          child: Text(
                              widget.todo == null ? 'Add Task' : 'Edit Task')),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }
}
