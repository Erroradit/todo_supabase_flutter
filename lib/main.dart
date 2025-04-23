import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_supabase/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized;
  await Supabase.initialize(
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9rbnZ2cGxxcHNveGJ5bXdkZXJ0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0MTEzMjIsImV4cCI6MjA2MDk4NzMyMn0.OvUu63JDQqXG9JjrSeOL5PvWP_fluNeuMiDiQdB7t6I',
    url: 'https://oknvvplqpsoxbymwdert.supabase.co',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: SplashPage(),
    );
  }
}
