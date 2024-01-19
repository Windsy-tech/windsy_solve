import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/nc/delegates/nc_windfarm_search_delegate.dart';
import 'package:windsy_solve/models/windfarm_model.dart';
import 'package:windsy_solve/utils/text_utils.dart';

class NCWindFarm extends ConsumerStatefulWidget {
  final Function(WindFarmModel) onSelected;

  const NCWindFarm({Key? key, required this.onSelected}) : super(key: key);

  @override
  ConsumerState<NCWindFarm> createState() => _CreateConsumerNCWindFarmState();
}

class _CreateConsumerNCWindFarmState extends ConsumerState<NCWindFarm> {
  //final WindFarmModel windFarm;
  WindFarmModel windFarm = WindFarmModel();

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
                      data: windFarm.oem!,
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

class CustomListTileWindFarm extends StatelessWidget {
  const CustomListTileWindFarm({
    super.key,
    required this.title,
    required this.data,
  });

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            data,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}