import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/providers/workout_provider.dart';
import 'pages/workout_history_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WorkoutProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      home: const WorkoutHistoryPage(),
    );
  }
}
