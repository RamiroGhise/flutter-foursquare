import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venues/bloc/actions.dart';
import 'package:venues/bloc/venues_bloc.dart';
import 'package:venues/presentation/navigation/navigator.dart';
import 'package:venues/services/app_config.dart';
import 'package:venues/views/venues/venues_view.dart';
import 'dart:developer' as devtools show log;

void main() {
  AppConfig().initConfig();
  devtools.log('Running in ${AppConfig.isDeveloperMode ? 'DEV' : 'PROD'} mode');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<VenuesBloc>(
      create: (context) => VenuesBloc()..add(const InitializeBookmarksAction()),
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: AppConfig.isDeveloperMode ? Colors.red : Colors.blue,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const VenuesView();
  }
}
