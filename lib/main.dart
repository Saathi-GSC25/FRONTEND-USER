import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:saathi_user/screens/home_screen.dart';
import 'package:saathi_user/screens/login_screen.dart';
import 'services/auth_service.dart';
import 'screens/auth_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],
      child: const MyApp(),
    ),
  );
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthChecker(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
