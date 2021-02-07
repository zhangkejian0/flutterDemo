import 'package:flutter/material.dart';
import 'package:flutterDemo/MyApp.dart';
import 'package:flutterDemo/config.dart';
void main() {
  MyAppConfig().setMode('develop');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}