import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:tugas_harian_app/model/user_model.dart';
import 'package:tugas_harian_app/services/db_auth_service.dart';
import 'package:toastification/toastification.dart';

class UserProvider with ChangeNotifier {
  final DBAuthService _dbService = DBAuthService();
  UserModel? _user;
  String? _loginErrorMessage;
  String? _registErrorMessage;
  bool? _isConnected;

  UserModel? get user => _user;
  String? get loginErrorMessage => _loginErrorMessage;
  String? get registErrorMessage => _registErrorMessage;
  bool? get isConnected => _isConnected;

  UserProvider() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result[0] == ConnectivityResult.none) {
        debugPrint('No internet connection');
        _isConnected = false;
        notifyListeners();
      } else {
        debugPrint('Connected');
        _isConnected = true;
        notifyListeners();
      }
    });
  }

  void resetErrorMessage() {
    _loginErrorMessage = null;
    _registErrorMessage = null;
    notifyListeners();
  }

  Future<bool> register(
      BuildContext context, String email, String password) async {
    if (_isConnected!) {
      try {
        UserModel newUser = UserModel(email: email, password: password);
        await _dbService.registerUser(newUser);
        toastification.show(
            context: context,
            title: const Text('Succes'),
            description: const Text('Succes Create Account'),
            type: ToastificationType.success,
            showProgressBar: false,
            closeOnClick: true,
            dragToClose: true,
            dismissDirection: DismissDirection.horizontal,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        return true;
      } catch (e) {
        _registErrorMessage = 'Email already In Use';
        toastification.show(
            context: context,
            title: const Text('Failed'),
            description: const Text('Email Already In Use'),
            type: ToastificationType.error,
            showProgressBar: false,
            closeOnClick: true,
            dragToClose: true,
            dismissDirection: DismissDirection.horizontal,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        notifyListeners();
        return false;
      }
    } else {
      toastification.show(
          context: context,
          title: const Text('Failed'),
          description: const Text('No internet connection'),
          type: ToastificationType.error,
          showProgressBar: false,
          closeOnClick: true,
          dragToClose: true,
          dismissDirection: DismissDirection.horizontal,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
      _registErrorMessage = 'No internet connection';
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(
      BuildContext context, String email, String password) async {
    if (_isConnected!) {
      try {
        UserModel? user = await _dbService.loginUser(email, password);
        if (user != null) {
          _user = user;
          _loginErrorMessage = null;
          notifyListeners();
          return true;
        } else {
          _loginErrorMessage = 'Invalid email or password';
          notifyListeners();
          toastification.show(
              context: context,
              title: const Text('Failed'),
              description: const Text('Invalid email or password'),
              type: ToastificationType.error,
              showProgressBar: false,
              closeOnClick: true,
              dragToClose: true,
              dismissDirection: DismissDirection.horizontal,
              autoCloseDuration: const Duration(seconds: 3),
              style: ToastificationStyle.fillColored);
          return false;
        }
      } catch (e) {
        _loginErrorMessage = 'Login failed: ${e.toString()}';
        toastification.show(
            context: context,
            title: const Text('Failed'),
            description: Text('Something went wrong $e'),
            type: ToastificationType.error,
            showProgressBar: false,
            closeOnClick: true,
            dragToClose: true,
            dismissDirection: DismissDirection.horizontal,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        notifyListeners();
        return false;
      }
    } else {
      toastification.show(
          context: context,
          title: const Text('Failed'),
          description: const Text('No internet connection'),
          type: ToastificationType.error,
          showProgressBar: false,
          closeOnClick: true,
          dragToClose: true,
          dismissDirection: DismissDirection.horizontal,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
      _loginErrorMessage = 'No internet connection';
      notifyListeners();
      return false;
    }
  }
}
