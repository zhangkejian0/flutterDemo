import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterDemo/config.dart';
import 'package:flutterDemo/utils/globalNavigatorServer.dart';
import 'package:flutterDemo/utils/routeflu.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:flutterDemo/utils/application.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    initPlugin(context);
    print('==========当前环境配置参数=================');
    print(MyAppConfig().getCofig());
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeModel())
      ],
      child: Consumer<ThemeModel>(
        builder: (BuildContext context, themeModel, Widget child){
          return RefreshConfiguration(
            headerBuilder: ()=>  WaterDropHeader(
                refresh: CupertinoActivityIndicator(),
                complete: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.grey,
                        size: 15,
                      ),
                      Container(
                        width: 3.0,
                      ),
                      Text('刷新成功', style: TextStyle(color: Colors.grey))
                    ]),
                failed: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.cancel,
                        color: Colors.grey,
                        size: 15,
                      ),
                      Container(
                        width: 3.0,
                      ),
                      Text('加载失败', style: TextStyle(color: Colors.grey))
                    ]),
            ), // 配置默认头部指示器,假如你每个页面的头部指示器都一样的话,你需要设置这个
            footerBuilder: () => CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("上拉加载");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("加载失败！");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("释放刷新!");
                } else if (mode == LoadStatus.noMore) {
                  body = Text("没有更多数据了!");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ), 
            child: KeyboardDismissOnTap(
              child: MaterialApp(
                debugShowCheckedModeBanner: false, //不要显示右侧顶部bug调试
                navigatorKey: Application.navigatorKey,
                onGenerateRoute: Application.router.generator,
                navigatorObservers: [GLObserver()], //全局路由跳转监听
              ),
            ),
          );
        }
      ),
    );
  }

  initPlugin(context) async {
    // 初始化路由
    final router = FluroRouter();
    configureRoutes(router);
    Application.router = router;
    //jpush
    // final JPush jpush = new JPush();
    // Application.jpush = jpush;
  }
}


class ThemeModel extends ChangeNotifier {
  
}