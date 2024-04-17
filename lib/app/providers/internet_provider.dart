// ignore_for_file: avoid_print, empty_catches

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetProvider extends Cubit<ConnectionStatus> with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _connectionSubscription;

  InternetProvider() : super(ConnectionStatus.online) {
    _connectionSubscription = _connectivity.onConnectivityChanged
        .listen((_) => _checkInternetConnection());
    _checkInternetConnection();
  }

  String _conexion = 'conectado';

  String get conexion {
    return _conexion;
  }

  Future<void> _checkInternetConnection() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        emit(ConnectionStatus.online);
        _conexion = 'conectado';
      } else {
        _conexion = 'desconectado';
        emit(ConnectionStatus.offline);
      }
      notifyListeners();
    } on SocketException catch (_) {
      try {
        emit(ConnectionStatus.offline);
      } catch (e) {}
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  @override
  Future<void> close() {
    _connectionSubscription.cancel();
    return super.close();
  }
}

enum ConnectionStatus {
  online,
  offline,
}
