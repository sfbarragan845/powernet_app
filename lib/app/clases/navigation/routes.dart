import 'package:powernet/app/pages/public/home/screens/home.dart';
import 'package:flutter/material.dart';


class Routes {
  static const root = '/';
  static const providerExample = '/providerExample';
  static const blocExample = '/blocExample';

  static Route routes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case root:
        return _buildRoute(const HomeApp());
      case blocExample:
      // return _buildRoute(ClientesOverviewScreen.create());
      default:
        throw Exception('Route does not exists');
    }
  }

  static MaterialPageRoute _buildRoute(Widget widget) => MaterialPageRoute(builder: (_) => widget);
}
