import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/features/auth/screens/login_screen.dart';
import 'package:windsy_solve/features/home/screens/home_screen.dart';
import 'package:windsy_solve/features/nc/screens/create_nc_screen.dart';
import 'package:windsy_solve/features/nc/screens/edit_nc_screen.dart';
import 'package:windsy_solve/features/nc/screens/nc_add_actions_taken_screen.dart';
import 'package:windsy_solve/features/reports_dashboard/nc/nc_reports.dart';
import 'package:windsy_solve/features/settings/screens/settings_screen.dart';
import 'package:windsy_solve/features/settings/user_profile/screens/edit_profile_screen.dart';
import 'package:windsy_solve/features/settings/user_profile/screens/user_profile_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/settings': (_) => const MaterialPage(child: Settings()),
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
  '/report-nc': (_) => const MaterialPage(child: ReportNCScreen()),
  '/report-nc/:id/': (_) => const MaterialPage(child: NCEditScreen()),
  '/report-nc//add-action-taken': (routeData) => MaterialPage(
        child: AddNCActionTaken(
          ncId: routeData.pathParameters['id']!,
        ),
      ),
  '/reports-nc': (_) => const MaterialPage(child: NCReports()),
});
