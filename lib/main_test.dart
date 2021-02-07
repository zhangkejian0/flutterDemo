import 'package:flutter/material.dart';
import 'package:flutterDemo/MyApp.dart';
import 'package:flutterDemo/config.dart';
void main() {
  MyAppConfig().setMode('test');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}