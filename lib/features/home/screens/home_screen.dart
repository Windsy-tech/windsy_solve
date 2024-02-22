import 'package:flutter/material.dart';
import 'package:windsy_solve/core/common/widgets/connectivity_status.dart';
import 'package:windsy_solve/features/home/drawer/drawer_widget.dart';
import 'package:windsy_solve/features/home/screens/home_actions.dart';
import 'package:windsy_solve/features/home/screens/home_analytics.dart';
import 'package:windsy_solve/features/home/screens/home_generated_reports.dart';
import 'package:windsy_solve/features/home/screens/home_main_screen.dart';
import 'package:windsy_solve/features/home/screens/pending_sync/pending_sync_badge.dart';
import 'package:windsy_solve/theme/color_palette.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
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
          switch (_currentIndex) {
            0 => 'Solve',
            1 => 'Actions',
            2 => 'Analytics',
            _ => 'Reports'
          },
          style: theme.textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          PendingSyncBadge(),
          ConnectivityStatus(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: theme.colorScheme.surface,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.secondaryContainer,
        selectedLabelStyle: theme.textTheme.labelSmall,
        unselectedLabelStyle: theme.textTheme.labelSmall,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rounded),
            label: 'Actions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_rounded),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download_rounded),
            label: 'Reports',
          ),
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: theme.brightness == Brightness.dark
              ? ColorPalette.darkSurface
              : ColorPalette.lightSurface,
        ),
        child: SafeArea(
          child: switch (_currentIndex) {
            0 => const HomeMainScreen(),
            1 => const HomeActions(),
            2 => const HomeAnalytics(),
            _ => const HomeGeneratedReports()
          },
        ),
      ),
    );
  }
}
