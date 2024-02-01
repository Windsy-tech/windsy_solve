import 'package:flutter/material.dart';

class EditInspectionScreen extends StatelessWidget {
  const EditInspectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Inspection"),
      ),
      body: const Center(
        child: Text("Edit Inspection"),
      ),
    );
  }
}
