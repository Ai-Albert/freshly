import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:freshly/services/auth.dart';
import 'package:provider/provider.dart';
import 'landing_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: const MaterialApp(
        title: 'freshly',
        home: LandingPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
