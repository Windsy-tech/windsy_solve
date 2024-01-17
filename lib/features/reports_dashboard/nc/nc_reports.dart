import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/nc/controller/nc_controller.dart';

class NCReports extends ConsumerWidget {
  const NCReports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;
    print("User: ${user.uid} Email: ${user.email}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("NC Reports"),
      ),
      body: ref.watch(getUserNCProvider(user.uid)).when(
            data: (ncs) => ListView.builder(
              itemCount: ncs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(ncs[index].title),
                  subtitle: Text(ncs[index].windFarm),
                );
              },
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
          ),
    );
  }
}
