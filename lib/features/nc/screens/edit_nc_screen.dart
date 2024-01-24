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
  const NCEditScreen(this.ncId, {Key? key}) : super(key: key);
  static const routeName = '/non-conformity';

  @override
  ConsumerState<NCEditScreen> createState() =>
      _CreateConsumerNCEditScreenState();
}

class _CreateConsumerNCEditScreenState extends ConsumerState<NCEditScreen> {
  final titleController = TextEditingController();
  final problemDescriptionController = TextEditingController();
  List<String> severities = ['Low', 'Medium', 'High'];
  List<String> statuses = ['Open', 'Closed'];
  String? severity;
  String? status;
  WindFarmModel? windFarmModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    problemDescriptionController.dispose();
    super.dispose();
  }

  void updateNC() {}

  @override
  Widget build(BuildContext buildContext) {
    return ref
        .read(ncControllerProvider.notifier)
        .getNCbyId(widget.ncId)
        .then((nc) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Non-Conformity: ${nc.id}"),
          leading: IconButton(
            onPressed: () {
              Routemaster.of(context).push(Constants.rReportsNC);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              onPressed: updateNC,
              icon: const Icon(Icons.save_as_outlined),
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("Title"),
                  const SizedBox(height: 4),
                  TextField(
                    controller: titleController.text == ''
                        ? TextEditingController(text: nc.title)
                        : titleController,
                    maxLength: 50,
                    //onChanged: (value) {},
                  ),
                  const SizedBox(height: 8),
                  const Text("Problem Description"),
                  const SizedBox(height: 4),
                  TextField(
                    controller: problemDescriptionController,
                    maxLines: 3,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: const Text('Severity'),
                    trailing: DropdownButton<String>(
                      value: severities[nc.severity],
                      onChanged: (String? newValue) {
                        setState(() {
                          severity = newValue;
                        });
                      },
                      items: severities
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: const Text('Status'),
                    trailing: DropdownButton<String>(
                      value: nc.status,
                      onChanged: (String? newValue) {
                        setState(() {
                          status = newValue;
                        });
                      },
                      items: statuses
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value.toString(),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  /* NCWindFarm(
                          nc.windFarm,
                          onSelected: (windFarm) {
                            setState(() {
                              windFarmModel = windFarm;
                            });
                          },
                        ), */
                ],
              ),
            ),
          ),
        ),
      );
    }) as Widget;
  }
}
