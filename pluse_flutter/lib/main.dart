import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluse_client/pluse_client.dart';

import 'package:pluse_flutter/app/appshell.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'package:the_responsive_builder/the_responsive_builder.dart';

late Client client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  const String serverUrl = 'SERVER_URL';
  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  runApp(
    ProviderScope(
      child: TheResponsiveBuilder(
        builder: (context, orientation, screenType) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VIDEO CALL APP',
       theme: ThemeData(fontFamily: 'GoogleSans', useMaterial3: true),
      home: AppShell(),
    );
  }
}