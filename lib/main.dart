import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:freshly/services/auth.dart';
import 'package:provider/provider.dart';
import 'landing_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
