import 'package:flutter/material.dart';
import 'package:windsy_solve/features/home/screens/home_analytics.dart';
import 'package:windsy_solve/features/home/screens/home_navigations.dart';

class HomeMainScreen extends StatelessWidget {
  const HomeMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            HomeNavigations(),
            SizedBox(height: 16.0),
            HomeAnalytics(),
          ],
        ),
      ),
    );
  }
}
