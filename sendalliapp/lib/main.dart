import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style for seamless edge-to-edge status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const SendalliApp());
}

class SendalliApp extends StatelessWidget {
  const SendalliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sendalli',
      debugShowCheckedModeBanner: true,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
