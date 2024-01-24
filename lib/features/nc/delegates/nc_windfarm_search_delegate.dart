import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/features/nc/controller/nc_controller.dart';
import 'package:windsy_solve/models/windfarm_model.dart';
import 'package:windsy_solve/utils/text_utils.dart';

class NCWindFarmSearchDelegate extends SearchDelegate {
  final WidgetRef ref;
  final WindFarmModel windFarm;
  final Function(WindFarmModel) onSelected;

  NCWindFarmSearchDelegate({
    required this.ref,
    required this.windFarm,
    required this.onSelected,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  void selectWindFarm(BuildContext context, WindFarmModel windFarm) {
    onSelected(windFarm);
    Routemaster.of(context).pop();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(getWindFarmsProvider(query)).when(
          data: (windFarms) => ListView.builder(
            itemCount: windFarms.length,
            itemBuilder: (BuildContext context, int index) {
              final data = windFarms[index];
              return ListTile(
                onTap: () => selectWindFarm(context, data),
                title: Text(
                  //Capitalise the first letter of each word
                  TextUtils.capitalizeFirstLetter(data.windFarm!),
                ),
                subtitle: Text(
                  'Turbine No: ${data.turbineNo}',
                ),
                trailing: data.windFarm == windFarm.windFarm &&
                        data.turbineNo == windFarm.turbineNo
                    ? const Icon(Icons.check)
                    : const SizedBox(),
              );
            },
          ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
