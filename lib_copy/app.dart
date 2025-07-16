import 'presentation/screens/auth/welcome.dart';
import 'resources/themes/theme.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: TAppTheme.lightTheme,
      themeMode: ThemeMode.system,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const Welcome(),
    );
  }
}
