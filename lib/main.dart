import 'package:expense_tracker/providers/theme_provider.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './providers/expense_provider.dart';
import './services/storage_services.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await StorageService.openBox();
 //testing the firebase connection
 try {
  await FirebaseFirestore.instance
      .collection("test")
      .doc("sample")
      .set({
    "name": "Sakhil",
    "time": Timestamp.now(),
  });

  print("✅ Firestore write successful!");
} catch (e, st) {
  print("❌ Firestore error: $e");
  print(st);
}
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()..init()),

        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadTheme()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),

          themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,

          home: const HomeScreen(),
        );
      },
    );
  }
}
