import 'package:flutter/material.dart';
import 'package:windsy_solve/features/home/drawer/drawer_widget.dart';
import 'package:windsy_solve/features/home/screens/home_navigations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Solve',
        ),
      ),
      body: const SafeArea(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            HomeNavigations(),
          ],
        ),
      )),
    );
  }
}
