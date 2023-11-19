import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  const BaseLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff00e963),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold
            )
          )
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            textStyle: const TextStyle(
              decoration: TextDecoration.underline
            )
          )
        ),

        dividerTheme: const DividerThemeData(
          color: Colors.black,
          thickness: 1,
          indent: 25,
          endIndent: 25,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(child: child),
      ),
    );
  }
}