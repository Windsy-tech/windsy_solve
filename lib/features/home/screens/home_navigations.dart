import "package:flutter/material.dart";
import "package:routemaster/routemaster.dart";
import "package:windsy_solve/core/common/widgets/home_navigation_button.dart";
import "package:windsy_solve/core/constants/constants.dart";

class HomeNavigations extends StatelessWidget {
  const HomeNavigations({super.key});

  void navigateToNCReportsPage(BuildContext context) {
    Routemaster.of(context).push(Constants.rReportsNC);
  }

  void navigateTo8DReportsPage(BuildContext context) {
    Routemaster.of(context).push(Constants.rReportsNC);
  }

  void navigateToInspectionReportsPage(BuildContext context) {
    Routemaster.of(context).push(Constants.rReportsNC);
  }

  void navigateToSafetyReportsPage(BuildContext context) {
    Routemaster.of(context).push(Constants.rReportsNC);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                count: 10,
              ),
              const SizedBox(
                width: 8,
              ),
              HomeNavigationButton(
                title: "8D",
                icon: Constants.i8DReports,
                onTap: () => navigateTo8DReportsPage(context),
                count: 4,
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
                count: 3,
                onTap: () => navigateToNCReportsPage(context),
              ),
              const SizedBox(
                width: 8,
              ),
              HomeNavigationButton(
                title: "Safety",
                icon: Constants.iSafetyReports,
                count: 8,
                onTap: () => navigateTo8DReportsPage(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
