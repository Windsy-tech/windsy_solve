import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/nc/delegates/nc_windfarm_search_delegate.dart';
import 'package:windsy_solve/models/windfarm_model.dart';
import 'package:windsy_solve/utils/text_utils.dart';

import '../../../core/common/widgets/wind_farm_listtile.dart';

class NCWindFarm extends ConsumerStatefulWidget {
  final WindFarmModel? initialValue;
  final Function(WindFarmModel) onSelected;

  const NCWindFarm(this.initialValue, {super.key, required this.onSelected});

  @override
  ConsumerState<NCWindFarm> createState() => _CreateConsumerNCWindFarmState();
}

class _CreateConsumerNCWindFarmState extends ConsumerState<NCWindFarm> {
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
      delegate: NCWindFarmSearchDelegate(
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Wind Farm Details'),
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
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
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
