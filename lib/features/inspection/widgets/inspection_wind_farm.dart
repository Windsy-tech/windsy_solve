import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/common/widgets/label_widget.dart';
import 'package:windsy_solve/core/common/widgets/wind_farm_listtile.dart';
import 'package:windsy_solve/features/inspection/delegates/inspection_windfarm_search_delegate.dart';
import 'package:windsy_solve/models/windfarm_model.dart';
import 'package:windsy_solve/utils/text_utils.dart';

class InspectionWindFarm extends ConsumerStatefulWidget {
  final WindFarmModel? initialValue;
  final Function(WindFarmModel) onSelected;

  const InspectionWindFarm(this.initialValue,
      {super.key, required this.onSelected});

  @override
  ConsumerState<InspectionWindFarm> createState() =>
      _CreateConsumerInspectionWindFarmState();
}

class _CreateConsumerInspectionWindFarmState
    extends ConsumerState<InspectionWindFarm> {
  //final WindFarmModel windFarm;
  WindFarmModel windFarm = WindFarmModel();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      windFarm = widget.initialValue!;
    }
  }

  void showSearchDelegate() {
    showSearch(
      context: context,
      delegate: InspectionWindFarmSearchDelegate(
        ref: ref,
        windFarm: windFarm,
        onSelected: (selectedFarm) {
          setState(() {
            windFarm = selectedFarm;
            widget.onSelected(windFarm);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const LabelWidget('Wind Farm Details'),
            IconButton(
              onPressed: () => showSearchDelegate(),
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        const SizedBox(height: 4),
        windFarm.windFarm == null
            ? const SizedBox()
            : Container(
                width: double.infinity,
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(8.0),
                  color: theme.colorScheme.outline,
                ),
                child: Column(
                  children: [
                    CustomListTileWindFarm(
                      title: "Wind Farm",
                      data: TextUtils.capitalizeFirstLetter(windFarm.windFarm!),
                    ),
                    CustomListTileWindFarm(
                      title: "Turbine No",
                      data: windFarm.turbineNo!,
                    ),
                    CustomListTileWindFarm(
                      title: "Platform",
                      data: windFarm.platform!,
                    ),
                    CustomListTileWindFarm(
                      title: "OEM",
                      data: TextUtils.capitalizeFirstLetter(windFarm.oem!),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
