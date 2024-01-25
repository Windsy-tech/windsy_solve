import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/core/constants/constants.dart';
import 'package:windsy_solve/features/nc/controller/nc_controller.dart';
import 'package:windsy_solve/features/nc/widgets/nc_wind_farm.dart';
import 'package:windsy_solve/models/nc_model.dart';
import 'package:windsy_solve/models/windfarm_model.dart';

class NCEditScreen extends ConsumerStatefulWidget {
  final String ncId;
  const NCEditScreen(this.ncId, {super.key});
  @override
  ConsumerState<NCEditScreen> createState() =>
      _CreateConsumerNCEditScreenState();
}

class _CreateConsumerNCEditScreenState extends ConsumerState<NCEditScreen> {
  final titleController = TextEditingController();
  final problemDescriptionController = TextEditingController();
  List<String> severities = ['Low', 'Medium', 'High'];
  List<String> statuses = ['Open', 'Closed'];
  String severity = '';
  String status = '';
  NCModel ncModel = NCModel(
    id: '',
    title: '',
    problemDescription: '',
    severity: 0,
    status: '',
    windFarm: "",
    assignedTo: [],
    category: '',
    createdAt: DateTime.now(),
    closedAt: DateTime.now(),
    turbineNo: '',
    createdBy: '',
    updatedAt: DateTime.now(),
  );

  @override
  void dispose() {
    titleController.dispose();
    problemDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getNCbyIdProvider(widget.ncId)).when(
          data: (nc) {
            print("rebuilding...");
            if (ncModel.id == "") {
              print("Assinging Data");
              ncModel = nc;
              print(ncModel.id);
              titleController.text = ncModel.title;
              problemDescriptionController.text = ncModel.problemDescription;
              status = ncModel.status;
              severity = severities[ncModel.severity];
            }

            return Scaffold(
              appBar: AppBar(
                title: Text('Non-Conformity: NC-${nc.id}'),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.save),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text("Title"),
                      const SizedBox(height: 4),
                      TextField(
                        controller: titleController,
                        maxLength: 50,
                      ),
                      const SizedBox(height: 8),
                      const Text("Problem Description"),
                      const SizedBox(height: 4),
                      TextField(
                        controller: problemDescriptionController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 8),
/*                   NCWindFarm(
                    '',
                    onSelected: (windFarm) {
                      setState(() {
                        this.windFarm = windFarm;
                      });
                    },
                  ), */
                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(0),
                        trailing: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: status,
                            items: statuses
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                status = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: const Text(
                          'Severity',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        trailing: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: severity,
                            items: severities
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (value) => severity = value!,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      /* const Text('Wind Farm'),
                const SizedBox(height: 4),
                const SizedBox(height: 8), */
                      const SizedBox(height: 8),
/*                   NCAssign(
                    ref: ref,
                    onAssign: (assignedTo) {
                      setState(() {
                        this.assignedTo = assignedTo.toList();
                      });
                    },
                  ), */
                      const SizedBox(height: 8),

                      /* Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Actions Taken'),
                        IconButton(
                          onPressed: () {
                            Routemaster.of(context).push(
                              'add-action-taken',
                            );
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ), */
/*                   const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => createNC(),
                    child: const Text('Create NC'),
                  ), */
                    ],
                  ),
                ),
              ),
            );
          },
          error: (e, s) => ErrorText(error: e.toString()),
          loading: () => const Loader(),
        );
  }
}
