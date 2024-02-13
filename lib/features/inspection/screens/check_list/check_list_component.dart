import 'package:flutter/material.dart';

class CheckListComponent extends StatelessWidget {
  const CheckListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Component'),
      ),
      body: const Center(
        child: Text('Component'),
      ),
    );
  }
}
