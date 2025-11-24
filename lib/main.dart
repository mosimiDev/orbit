import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:orbit/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'providers/project_provider.dart';
import 'screens/project_list_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth_wrapper.dart';
import 'screens/ai_assistant_screen.dart';



Future<void> main() async {

    await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

runApp(
ChangeNotifierProvider(
create: (_) => ProjectProvider(),
child: const OrbitApp(),
),
);
}


class OrbitApp extends StatelessWidget {
const OrbitApp({super.key});


@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Orbit Project Manager',
theme: ThemeData(
colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
useMaterial3: true,
),
debugShowCheckedModeBanner: false,
 initialRoute: '/',
 routes: {
 '/': (context) => const OnboardingScreen(),
 '/auth': (context) => const AuthWrapper(),
 '/projects': (context) => const ProjectListScreen(),
 '/ai-assistant': (context) => const AIAssistantScreen(),
 '/login': (context) => const LoginScreen(),
 '/register': (context) => const RegisterScreen(),
 });
}
}