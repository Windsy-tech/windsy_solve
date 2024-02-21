import 'package:flutter/material.dart';
import 'package:windsy_solve/core/common/widgets/connectivity_status.dart';
import 'package:windsy_solve/features/home/drawer/drawer_widget.dart';
import 'package:windsy_solve/features/home/screens/home_analytics.dart';
import 'package:windsy_solve/features/home/screens/home_navigations.dart';
import 'package:windsy_solve/features/home/screens/pending_sync/pending_sync_badge.dart';
import 'package:windsy_solve/theme/color_palette.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: const DrawerWidget(),
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Solve',
          style: theme.textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          PendingSyncBadge(),
          ConnectivityStatus(),
        ],
      ),
      body: Container(
        height: size.height,
        decoration: BoxDecoration(
          gradient: theme.brightness == Brightness.dark
              ? ColorPalette.darkSurface
              : ColorPalette.lightSurface,
        ),
        child: const SafeArea(
            child: SingleChildScrollView(
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
        )),
      ),
    );
  }
}
