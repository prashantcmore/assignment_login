import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'modules/auth.dart';
import 'screens/authentification.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        // create:(ctx)=>AuthScreen(),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          title: 'Assignment',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          home: const Authentification(),
          routes: {HomeScreen.routeName: (ctx) => HomeScreen()},
        ),
      ),
    );
  }
}
