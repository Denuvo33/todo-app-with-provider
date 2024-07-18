import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:tugas_harian_app/model/todo_model.dart';
import 'package:tugas_harian_app/services/db_todo_service.dart';

class TodoProvider with ChangeNotifier {
  final TodoDBService _dbService = TodoDBService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<TodoModel> _todos = [];
  DateTime selectedDateTime = DateTime.now();

  void changeDate(date) {
    selectedDateTime = date;
    notifyListeners();
  }

  TodoProvider() {
    _initializeNotifications();
  }

  List<TodoModel> get todos => _todos;

  Future<void> loadTodos() async {
    _todos = await _dbService.getTodos();
    notifyListeners();
  }

  Future<void> addTodo(TodoModel todo) async {
    int id = await _dbService.insertTodo(todo);
    if (todo.scheduledTime != null) {
      _scheduleNotification(id, todo);
    }
    await loadTodos();
  }

  Future<void> clearAllTodo() async {
    await _dbService.clearAllTodos();
    await loadTodos();
  }

  Future<void> updateTodo(TodoModel todo) async {
    await _dbService.updateTodo(todo);
    if (todo.scheduledTime != null) {
      _scheduleNotification(todo.id!, todo);
    }
    await loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await _dbService.deleteTodo(id);
    flutterLocalNotificationsPlugin.cancel(id);
    await loadTodos();
  }

  void toogleTodos(TodoModel todo) {
    todo.isDone = !todo.isDone;
    notifyListeners();
  }

  Future<void> _initializeNotifications() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      '2', // id
      'task notif', // name
      description: 'desc', // description
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _scheduleNotification(int id, TodoModel todo) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '2', // id
      'task notif', // name
      channelDescription: 'desc', // description
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'You got task to do',
      todo.title,
      tz.TZDateTime.from(todo.scheduledTime!, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
