import 'package:flutter/material.dart';
import './screens/random_words.dart';
import './theme/style.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: appTheme(),
        home: RandomWords(),
    );
  }
}
