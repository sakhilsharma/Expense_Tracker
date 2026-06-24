import 'package:flutter/material.dart';
import './utils/theme.dart';
import './screens/dashboard_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './services/storage_services.dart';
import './providers/expense_provider.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //-->Prepare Flutter engine before using plugins.
  await Hive.initFlutter();//takes time
  //open expense box from hive--> locally stored
  await StorageService.openBox();

  runApp(
    ChangeNotifierProvider(
      create: (_) {
        final provider = ExpenseProvider();
        provider.init();
        return provider;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
      false,
      theme: AppTheme.darkTheme,
      home: DashboardScreen(),
    );
  }
}
