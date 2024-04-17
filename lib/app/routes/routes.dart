import 'package:flutter/material.dart';

import '../pages/public/login/screens/loginScreen.dart';
import '../pages/public/splash/screens/splashScreen.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'loading': (_) => const SplashScreen(),
  'login': (_) => const LoginScreen(),
};
