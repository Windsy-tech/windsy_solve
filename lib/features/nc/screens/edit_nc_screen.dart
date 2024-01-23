import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/constants/constants.dart';

class NCEditScreen extends ConsumerWidget {
  const NCEditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Non-Conformity: "),
        leading: IconButton(
          onPressed: () {
            Routemaster.of(context).push(Constants.rReportsNC);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: const Center(
        child: Text("Edit NC"),
      ),
    );
  }
}
