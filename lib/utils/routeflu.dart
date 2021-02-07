import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutterDemo/page/Home.dart';
import 'package:flutterDemo/page/Login.dart';
import 'package:flutterDemo/page/base/DefaultPage.dart';
void configureRoutes(FluroRouter router) {
  router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return Container();
  });

  router.define('/', handler: Handler(handlerFunc: (context, params) => DefaultPage()));
  router.define('/login', handler: Handler(handlerFunc: (context, params) => Login(ModalRoute.of(context).settings.arguments)));
  router.define('/home', handler: Handler(handlerFunc: (context, params) => Home(ModalRoute.of(context).settings.arguments)));
}
