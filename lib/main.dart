import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:capyba_blog/routes/home/home.route.dart';
import 'package:capyba_blog/routes/sign_in/sign_in.route.dart';
import 'package:capyba_blog/routes/sign_up/sign_up.route.dart';
import 'package:capyba_blog/shared/components/base_layout.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/', name: 'loading', builder: (context, state) => const BaseLayout(child: _Loading()),
          ),
          GoRoute(
            path: '/home', name: 'home', builder: (context, state) => const BaseLayout(child: HomeRoute()),
          ),
          GoRoute(
            path: '/signup', name: 'signup', builder: (context, state) => const BaseLayout(child: SignUpRoute()),
          ),
          GoRoute(
            path: '/signin', name: 'signin', builder: (context, state) => BaseLayout(child: SignInRoute()),
          )
        ]
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({super.key});

  Future<bool> _isLoggedIn() async{
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _isLoggedIn(), 
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }

        final data = snapshot.data!;
        FlutterNativeSplash.remove();

        if(data){
          return const BaseLayout(child: SignUpRoute());
        }
        return const BaseLayout(child: HomeRoute());
      },
    );
  }
}