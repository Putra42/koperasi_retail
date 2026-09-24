import 'package:flutter/material.dart';
import 'data/auth_database.dart';
import 'pages/home_screen.dart';
import 'pages/welcome_screen.dart';
import 'pages/main_screen.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Koperasi Retail Sembako',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00940F)),
      useMaterial3: true,
    ),
    home: const _StartupScreen(),
  );
}

class _StartupScreen extends StatelessWidget {
  const _StartupScreen();

  @override
  Widget build(BuildContext context) => FutureBuilder<AppUser?>(
    future: AuthDatabase.instance.activeUser(),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFF00940F)),
          ),
        );
      }
      final user = snapshot.data;
      return user == null ? const WelcomeScreen() : MainScreen(user: user);
    },
  );
}
