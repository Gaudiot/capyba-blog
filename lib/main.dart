import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:capyba_blog/routes/home/home.route.dart';
import 'package:capyba_blog/routes/sign_in/sign_in.route.dart';
import 'package:capyba_blog/routes/sign_up/sign_up.route.dart';
import 'package:capyba_blog/shared/components/base_layout.dart';
import 'package:capyba_blog/routes/welcome/welcome.dart';
import 'package:capyba_blog/routes/profile/profile.route.dart';
import 'package:capyba_blog/routes/restricted/restricted.route.dart';
import 'package:capyba_blog/services/firebase/ifirebase_service.dart';
import 'package:capyba_blog/services/firebase/implementations/firebase_service.dart';

// ignore: unused_import
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
            path: '/welcome', name: 'welcome', builder: (context, state) => const BaseLayout(child: Welcome()),
          ),
          GoRoute(
            path: '/signup', name: 'signup', builder: (context, state) => const BaseLayout(child: SignUpRoute()),
          ),
          GoRoute(
            path: '/signin', name: 'signin', builder: (context, state) => BaseLayout(child: SignInRoute()),
          ),
          GoRoute(
            path: '/home', name: 'home', builder: (context, state) => const BaseLayout(child: HomeRoute()),
          ),
          GoRoute(
            path: '/restricted', name: 'restricted', builder: (context, state) => const BaseLayout(child: RestrictedRoute()),
          ),
          GoRoute(
            path: '/profile', name: 'profile', builder: (context, state) => const BaseLayout(child: ProfileRoute()),
          )
        ]
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({super.key});

  Future<bool> isLoggedIn() async{
    final IFirebaseService firebaseService = FirebaseService();
    final isUserLoggedIn = await firebaseService.isLoggedIn();
    return isUserLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isLoggedIn(), 
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }

        final isUserLoggedIn = snapshot.data!;
        FlutterNativeSplash.remove();

        if(isUserLoggedIn){
          return const BaseLayout(child: HomeRoute());
        }
        return const BaseLayout(child: Welcome());
      },
    );
  }
}