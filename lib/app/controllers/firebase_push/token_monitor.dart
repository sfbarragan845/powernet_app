import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '/app/models/share_preferences.dart';

/// Manages & returns the users FCM token.
///
/// Also monitors token refreshes and updates state.
class TokenMonitor extends StatefulWidget {
  // ignore: public_member_api_docs
  const TokenMonitor(this._builder);

  final Widget Function(String? token) _builder;

  @override
  State<StatefulWidget> createState() => _TokenMonitor();
}

class _TokenMonitor extends State<TokenMonitor> {
  String? _token;
  late Stream<String> _tokenStream;

  void setToken(String? token) {
    print('FCM Token: $token');
    setState(() {
      _token = token;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken(vapidKey: 'BBNEPXbzpbJeiOwbL_6O3oTxv7XUPCuP4CfRZI_Qb3jz1exte7GVX6nWVfNDqIuvD37nvrSqH2PTTndAt0RtUzc').then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
  }

  @override
  Widget build(BuildContext context) {
    return widget._builder(_token);
  }
}

class PushNotificationProvider {
  initNotifications() async {
    FirebaseMessaging _messaging = FirebaseMessaging.instance;
    print("_______________________________________________________________");
    _messaging.getToken().then((token) {
      print("FCM TOKEN: ");
      print(token);
      Preferences.idDispositivo = token.toString();
    });
  }
}
