import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/core/hive/adapters/inspection_sync_task/inspection_adapter.dart';
import 'package:windsy_solve/core/hive/adapters/inspection_sync_task/inspection_sync_task.dart';
import 'package:windsy_solve/core/hive/adapters/nc_sync_task/nc_adapter.dart';
import 'package:windsy_solve/core/hive/adapters/nc_sync_task/nc_sync_task.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/models/user_model.dart';
import 'package:windsy_solve/router.dart';
import 'package:windsy_solve/theme/provider/theme_provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'firebase_options.dart';

void main() async {
  //Ensure that the WidgetsBinding is initialized before calling Firebase.initializeApp
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Initialize Hive and get the app document directory
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  //Hive.init(appDocumentDirectory.path);
  await Hive.initFlutter(appDocumentDirectory.path);
  Hive.registerAdapter(NCSyncTaskAdapter());
  Hive.registerAdapter(NCModelAdapter());
  Hive.registerAdapter(InspectionSyncTaskAdapter());
  Hive.registerAdapter(InspectionModelAdapter());

  //Wrap the app in a ProviderScope (Riverpod)
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getUserData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;

    ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangesProvider).when(
          data: (user) => MaterialApp.router(
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if (user != null) {
                  getUserData(ref, user);
                  return loggedInRoute;
                } else {
                  return loggedOutRoute;
                }
              },
            ),
            routeInformationParser: const RoutemasterParser(),
            title: 'Solve',
            theme: ref.watch(themeNotifierProvider),
            //theme: AppTheme.lightTheme(),
            //darkTheme: AppTheme.darkTheme(),
          ),
          loading: () => const Loader(),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
        );
  }
}
