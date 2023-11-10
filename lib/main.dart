import 'package:capyba_blog/routes/home.route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:capyba_blog/routes/sign_in.route.dart';
import 'package:capyba_blog/routes/sign_up.route.dart';

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
            path: '/', name: 'loading', builder: (context, state) => const _BaseLayout(_Loading()),
          ),
          GoRoute(
            path: '/home', name: 'home', builder: (context, state) => const HomeRoute(),
          ),
          GoRoute(
            path: '/signup', name: 'signup', builder: (context, state) => _BaseLayout(SignUpRoute()),
          ),
          GoRoute(
            path: '/signin', name: 'signin', builder: (context, state) => _BaseLayout(SignInRoute()),
          )
        ]
      ),
    );
  }
}

class _BaseLayout extends StatelessWidget {
  final Widget child;
  const _BaseLayout(this.child);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({super.key});

  Future<bool> _isLoggedIn() async{
    await Future.delayed(const Duration(seconds: 3));
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
          return _BaseLayout(SignUpRoute());
        }
        return const _BaseLayout(HomeRoute());
      },
    );
  }
}