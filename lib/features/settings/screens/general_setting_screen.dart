import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/widgets/label_widget.dart';
import 'package:windsy_solve/core/constants/constants.dart';
import 'package:windsy_solve/theme/color_palette.dart';
import 'package:windsy_solve/theme/provider/theme_provider.dart';

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
    final themeMode = ref.watch(themeNotifierProvider.notifier).mode;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile Screen'),
        leading: IconButton(
          onPressed: () => navigateToSettingsPage(context),
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: theme.brightness == Brightness.dark
              ? ColorPalette.darkSurface
              : ColorPalette.lightSurface,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const LabelWidget("Theme"),
                  trailing: Switch.adaptive(
                    value: themeMode == ThemeMode.dark ? true : false,
                    onChanged: (val) {
                      toggleTheme(ref);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
