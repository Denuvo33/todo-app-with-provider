import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_harian_app/provider/user_auth_provider.dart';
import 'package:tugas_harian_app/view/home_page.dart';
import 'package:tugas_harian_app/view/register_view.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo App')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Form(
              key: _formKey,
              child: Card(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(fontSize: 25),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            labelText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                          return userProvider.loginErrorMessage != null
                              ? Text(
                                  userProvider.loginErrorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                )
                              : Container();
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool success = await Provider.of<UserProvider>(
                                    context,
                                    listen: false)
                                .login(context, emailController.text,
                                    passwordController.text);
                            if (success) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => HomePage()));
                            }
                          }
                        },
                        child: const Text('Login'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?'),
                          TextButton(
                            onPressed: () {
                              Provider.of<UserProvider>(context, listen: false)
                                  .resetErrorMessage();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => RegisterView()));
                            },
                            child: const Text('Register'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
