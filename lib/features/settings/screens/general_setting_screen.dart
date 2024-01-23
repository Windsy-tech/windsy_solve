import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/constants/constants.dart';
import 'package:windsy_solve/theme/pallete.dart';

class GeneralSettings extends ConsumerWidget {
  const GeneralSettings({super.key});

  void navigateToSettingsPage(BuildContext context) {
    Routemaster.of(context).push(Constants.rSettings);
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        leading: IconButton(
          onPressed: () => navigateToSettingsPage(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text("Theme"),
                trailing: Switch.adaptive(
                  value: ref.watch(themeNotifierProvider.notifier).mode ==
                      ThemeMode.dark,
                  onChanged: (val) => toggleTheme(ref),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
