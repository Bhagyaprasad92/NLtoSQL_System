import 'package:flutter/material.dart';
import 'package:frontend/screens/auth_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NL2SQL Auth',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF3F3F3),
        fontFamily: 'Arial',
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const AuthPage(),
    );
  }
}