import 'package:flutter/material.dart';
import 'package:lol_champions/presentation/admin/layout/drawer_widget.dart';

class Layout extends StatelessWidget {
  final Widget child;
  final String title;
  const Layout({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const DrawerWidget(),
      body: child,
    );
  }
}
