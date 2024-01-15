import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';

class Settings extends ConsumerWidget {
  const Settings({Key? key}) : super(key: key);

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/user-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          onPressed: () => Routemaster.of(context).push('/'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(children: [
        ListTile(
          onTap: () => navigateToUserProfile(context, user.uid),
          leading: const Icon(Icons.person),
          title: const Text("User Profile"),
        ),
      ]),
    );
  }
}
