import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_harian_app/provider/todo_provider.dart';
import 'package:tugas_harian_app/provider/user_auth_provider.dart';
import 'package:tugas_harian_app/services/db_auth_service.dart';
import 'package:tugas_harian_app/services/db_todo_service.dart';
import 'package:tugas_harian_app/view/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBAuthService().initializeDB();
  await TodoDBService().db;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()..loadTodos())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Daily Notes App',
        home: LoginView(),
        theme: ThemeData.dark(
          useMaterial3: true,
        ).copyWith(
            textButtonTheme: const TextButtonThemeData(
                style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white))),
            elevatedButtonTheme: const ElevatedButtonThemeData(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 32, 144, 179)),
                    foregroundColor: MaterialStatePropertyAll(Colors.white)))),
      ),
    );
  }
}
