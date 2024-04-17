import 'package:flutter/material.dart';

class BNavigator extends StatefulWidget {
  const BNavigator({Key? key}) : super(key: key);

  @override
  _BNavigatorState createState() => _BNavigatorState();
}

class _BNavigatorState extends State<BNavigator> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Historia'
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people),
          label: 'Nuestra Gente')
      ]);
  }
}
