import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:routemaster/routemaster.dart";
import "package:windsy_solve/core/common/widgets/home_navigation_button.dart";
import "package:windsy_solve/core/constants/constants.dart";
import "package:windsy_solve/features/home/controller/home_controller.dart";

class HomeNavigations extends ConsumerWidget {
  const HomeNavigations({super.key});

  void navigateToNCReportsPage(BuildContext context) {
    Routemaster.of(context).push(Constants.rReportsNC);
  }

  void navigateTo8DReportsPage(BuildContext context) {
    Routemaster.of(context).push(Constants.rReportsNC);
  }

  void navigateToInspectionReportsPage(BuildContext context) {
    Routemaster.of(context).push(Constants.rReportsInspection);
  }

  void navigateToSafetyReportsPage(BuildContext context) {
    Routemaster.of(context).push(Constants.rReportsNC);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final ncCount = ref.watch(getNCCountByUserId);
    final inspectionCount = ref.watch(getInspectionCountByUserId);
    final safetyCount = ref.watch(getSafetyCountByUserId);
    final d8Count = ref.watch(get8DCountByUserId);

    return SizedBox(
      width: size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HomeNavigationButton(
                title: "NC",
                icon: Constants.iNCReports,
                onTap: () => navigateToNCReportsPage(context),
                count: ncCount.value ?? 0,
              ),
              const SizedBox(
                width: 8,
              ),
              HomeNavigationButton(
                title: "8D",
                icon: Constants.i8DReports,
                onTap: () => navigateTo8DReportsPage(context),
                count: d8Count.value ?? 0,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HomeNavigationButton(
                title: "Inspection",
                icon: Constants.iInspectionReports,
                count: inspectionCount.value ?? 0,
                onTap: () => navigateToInspectionReportsPage(context),
              ),
              const SizedBox(
                width: 8,
              ),
              HomeNavigationButton(
                title: "Safety",
                icon: Constants.iSafetyReports,
                count: safetyCount.value ?? 0,
                onTap: () => navigateTo8DReportsPage(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
