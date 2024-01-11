import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/features/auth/screens/login_screen.dart';
import 'package:windsy_solve/features/home/screens/home_screen.dart';
import 'package:windsy_solve/features/nc/screens/create_nc_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/report-nc': (_) => const MaterialPage(child: ReportNC()),
});
