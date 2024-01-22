import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/nc/controller/nc_controller.dart';

class NCReports extends ConsumerWidget {
  const NCReports({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //print("User: ${user.uid} Email: ${user.email}");
    print("ui rebuilt");

    return Scaffold(
      appBar: AppBar(
        title: const Text("NC Reports"),
      ),
      body: ref.watch(getUserNCProvider).when(
            data: (ncs) {
              print("Data: $ncs");
              return ListView.builder(
                itemCount: ncs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(ncs[index].title),
                    subtitle: Text(ncs[index].problemDescription),
                    trailing: Text(ncs[index].status),
                  );
                },
              );
            },
            loading: () => const Loader(),
            error: (e, s) => ErrorText(error: e.toString()),
          ),
    );
  }
}
