import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/inspection/controller/check_list_controller.dart';
import 'package:windsy_solve/models/inspection/checklist_model.dart';

// ignore: must_be_immutable
class CheckListRiskPage extends ConsumerStatefulWidget {
  final String checkListId;
  CheckListModel checkList;
  CheckListRiskPage({
    required this.checkListId,
    required this.checkList,
    super.key,
  });

  @override
  ConsumerState<CheckListRiskPage> createState() => _CheckListRiskPageState();
}

class _CheckListRiskPageState extends ConsumerState<CheckListRiskPage> {
  final List<int> risks = [0, 1, 2, 3];

  void updateRisk() {
    ref.read(checkListControllerProvider.notifier).updateCheckList(
          context,
          widget.checkListId,
          widget.checkList,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            updateRisk();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        title: const Text("Risk"),
      ),
      body: Container(
        height: size.height,
        color: theme.colorScheme.surface,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: risks.length,
                    shrinkWrap: true,
                    //separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            widget.checkList = widget.checkList.copyWith(
                              risk: risks[index],
                            );
                          });
                        },
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        title: Text(
                          risks[index].toString(),
                          style: theme.textTheme.bodyLarge,
                        ),
                        trailing: widget.checkList.risk == index
                            ? const Icon(
                                Icons.check,
                                //size: 14,
                              )
                            : const SizedBox(),
                      );
                    },
                  ),
                  const RiskLevelExplanation(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RiskLevelExplanation extends StatelessWidget {
  const RiskLevelExplanation({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: theme.colorScheme.secondaryContainer,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichText(
            text: TextSpan(
              text: 'Level 0: ',
              style: theme.textTheme.labelSmall!.copyWith(
                color: Colors.green,
              ),
              children: const [
                TextSpan(
                  text:
                      'Low risk - Minimal impact and very low likelihood of negative consequences',
                ),
              ],
            ),
          ),
          const Divider(),
          RichText(
            text: TextSpan(
              text: 'Level 1: ',
              style: theme.textTheme.labelSmall!.copyWith(
                color: Colors.yellow,
              ),
              children: const [
                TextSpan(
                  text:
                      'Medium risk - Manageable impact and moderate likelihood of adverse events',
                ),
              ],
            ),
          ),
          const Divider(),
          RichText(
            text: TextSpan(
              text: 'Level 2: ',
              style: theme.textTheme.labelSmall!.copyWith(
                color: Colors.orange,
              ),
              children: const [
                TextSpan(
                  text:
                      'High risk - Significant impact and notable likelihood of adverse consequences',
                ),
              ],
            ),
          ),
          const Divider(),
          RichText(
            text: TextSpan(
              text: 'Level 3: ',
              style: theme.textTheme.labelSmall!.copyWith(
                color: Colors.red,
              ),
              children: const [
                TextSpan(
                  text:
                      'Critical risk - Severe impact and significant likelihood of hazardous situations',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
