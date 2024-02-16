import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/features/auth/screens/login_screen.dart';
import 'package:windsy_solve/features/home/screens/home_screen.dart';
import 'package:windsy_solve/features/home/screens/pending_sync/pending_sync.dart';
import 'package:windsy_solve/features/inspection/screens/check_list/check_list_screen.dart';
import 'package:windsy_solve/features/inspection/screens/create_inspection_screen.dart';
import 'package:windsy_solve/features/inspection/screens/edit_inspection_screen.dart';
import 'package:windsy_solve/features/inspection/screens/inspection_section_list.dart';
import 'package:windsy_solve/features/nc/screens/create_nc_screen.dart';
import 'package:windsy_solve/features/nc/screens/edit_nc_screen.dart';
import 'package:windsy_solve/features/nc/screens/nc_add_actions_taken_screen.dart';
import 'package:windsy_solve/features/reports_dashboard/inspection/inspection_reports.dart';
import 'package:windsy_solve/features/reports_dashboard/nc/nc_reports.dart';
import 'package:windsy_solve/features/settings/screens/general_setting_screen.dart';
import 'package:windsy_solve/features/settings/screens/settings_screen.dart';
import 'package:windsy_solve/features/settings/user_profile/screens/edit_profile_screen.dart';
import 'package:windsy_solve/features/settings/user_profile/screens/user_profile_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: HomeScreen(),
        ),
    '/settings': (_) => const MaterialPage(
          child: Settings(),
        ),
    '/user-profile/:uid': (routeData) => MaterialPage(
          child: UserProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    '/edit-profile/:uid': (routeData) => MaterialPage(
          child: EditProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    '/general-settings': (_) => const MaterialPage(
          child: GeneralSettings(),
        ),
    '/pending-sync': (_) => const MaterialPage(
          child: PendingSync(),
        ),
    '/report-nc/new': (_) => const MaterialPage(
          child: ReportNCScreen(),
        ),
    '/non-conformity/:id/': (routeData) {
      return MaterialPage(
        child: NCEditScreen(
          routeData.pathParameters['id']!,
        ),
      );
    },
    '/report-nc/add-action-taken': (routeData) => MaterialPage(
          child: AddNCActionTaken(
            ncId: routeData.pathParameters['id']!,
          ),
        ),
    '/reports-nc': (_) => const MaterialPage(
          child: NCReports(),
        ),
    '/inspection/new': (routeData) {
      return MaterialPage(
        child: PerformInspectionScreen(
          title: routeData.queryParameters['title']!,
          type: routeData.queryParameters['type']!,
          templateName: routeData.queryParameters['templateName']!,
        ),
      );
    },
    '/inspection/:id/': (routeData) => MaterialPage(
          child: EditInspectionScreen(
            inspectionId: routeData.pathParameters['id']!,
          ),
        ),
    '/inspection/section/:sectionname': (routeData) {
      return MaterialPage(
        child: InspectionSectionList(
          inspectionId: routeData.queryParameters['id']!,
          sectionName: routeData.pathParameters['sectionname']!,
        ),
      );
    },
    'check/:checkid': (routeData) {
      return MaterialPage(
        child: CheckListScreen(
          inspectionId: routeData.queryParameters['inspectionId']!,
          checkId: routeData.pathParameters['checkid']!,
          section: routeData.queryParameters['section']!,
        ),
      );
    },
    '/reports-inspection': (_) => const MaterialPage(
          child: InspectionReports(),
        ),
  },
);
