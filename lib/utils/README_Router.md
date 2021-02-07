# fluro 路由

## 官网文档传送门
    https://github.com/lukepighetti/fluro


具体api方法有官网，这里再照猫画虎没有意义，通过FlutterDemo只通俗的分步骤讲述在项目中集成fluro做出笔记

## fluro在flutterDemo中的使用
1. 创建routeflu.dart文件 lib/utils/routeflu.dart  
通过configureRoutes(FluroRouter router) 方法配置默认页，404页面，比如

```
    void configureRoutes(FluroRouter router) {
        router.notFoundHandler = Handler(
            handlerFunc: (BuildContext context, Map<String, List<String>> params) {
            return Container(
                child: Text('404'),
            );
        });
        router.define('/', handler: Handler(handlerFunc: (context, params) => DefaultPage()));
    }
```

2. 创建application.dart文件 lib/utils/application.dart

创建Application类，注册FluroRouter

```
    class Application {
        static FluroRouter router; //路由
    }
```

3. 修改MyApp.dart中的MaterialApp配置参数    
    先介绍下配置参数
```
MaterialApp({
  Key key,
  this.title = '', // 设备用于为用户识别应用程序的单行描述
  this.home, // 应用程序默认路由的小部件,用来定义当前应用打开的时候，所显示的界面
  this.color, // 在操作系统界面中应用程序使用的主色。
  this.theme, // 应用程序小部件使用的颜色。
  this.routes = const <String, WidgetBuilder>{}, // 应用程序的顶级路由表
  this.navigatorKey, // 在构建导航器时使用的键。
  this.initialRoute, // 如果构建了导航器，则显示的第一个路由的名称
  this.onGenerateRoute, // 应用程序导航到指定路由时使用的路由生成器回调
  this.onUnknownRoute, // 当 onGenerateRoute 无法生成路由(initialRoute除外)时调用
  this.navigatorObservers = const <NavigatorObserver>[], // 为该应用程序创建的导航器的观察者列表
  this.builder, // 用于在导航器上面插入小部件，但在由WidgetsApp小部件创建的其他小部件下面插入小部件，或用于完全替换导航器
  this.onGenerateTitle, // 如果非空，则调用此回调函数来生成应用程序的标题字符串，否则使用标题。
  this.locale, // 此应用程序本地化小部件的初始区域设置基于此值。
  this.localizationsDelegates, // 这个应用程序本地化小部件的委托。
  this.localeListResolutionCallback, // 这个回调负责在应用程序启动时以及用户更改设备的区域设置时选择应用程序的区域设置。
  this.localeResolutionCallback, // 
  this.supportedLocales = const <Locale>[Locale('en', 'US')], // 此应用程序已本地化的地区列表 
  this.debugShowMaterialGrid = false, // 打开绘制基线网格材质应用程序的网格纸覆盖
  this.showPerformanceOverlay = false, // 打开性能叠加
  this.checkerboardRasterCacheImages = false, // 打开栅格缓存图像的棋盘格
  this.checkerboardOffscreenLayers = false, // 打开渲染到屏幕外位图的图层的棋盘格
  this.showSemanticsDebugger = false, // 打开显示框架报告的可访问性信息的覆盖
  this.debugShowCheckedModeBanner = true, // 在选中模式下打开一个小的“DEBUG”横幅，表示应用程序处于选中模式
}) 
```
通过 onGenerateRoute 参数配置路由表

```
    MaterialApp(
        onGenerateRoute: Application.router.generator,
    )
```

至此整个fluro基本使用完毕，具体路由跳转这里贴上一个案例  
由'/'路由页面跳至 '/login' 页，可使用

```
Application.router.navigateTo(context, '/login');
```


## fluro的传参

在第一次使用fluro的时候采用的，fluro: 1.6.3版本，那时候传参是在路由地址上的，比如A--->B页面我要穿一个id，那么路由要在地址上传参 '/b?key=value', 而往往传递一个object对象才更符合开发需求，不知道为何在那1.6.3的那个版本，作者并没有开放arguments，然而arguments是RouteSettings上的flutter原生方法，弄清楚原理后，在1.6.3的版本上进行了部分重写

当时在Routes类继承Router（import 'package:flutter/material.dart' hide Router;）上做修改
```
class Routes extends Router {
  /// 本来只打算重写navigateTo
  /// 发现navigateTo引用了route的一个私有方法，只能抄一遍了，除了名字什么也没改
  Route<Null> notFoundRoute(BuildContext context, String path) {
    RouteCreator<Null> creator =
        (RouteSettings routeSettings, Map<String, List<String>> parameters) {
      return MaterialPageRoute<Null>(
          settings: routeSettings,
          builder: (BuildContext context) {
            return notFoundHandler.handlerFunc(context, parameters);
          });
    };
    return creator(RouteSettings(name: path), null);
  }

  /// 重写navigateTo新增arguments参数，因为fluro的传参我实在看不下去
  /// matchRoute接收routeSettings参数
  /// 子页面获取参数 Map aaa = ModalRoute.of(context).settings.arguments;
  @override
  Future navigateTo(BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      TransitionType transition = TransitionType.cupertino,
      Map<String, dynamic> arguments,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder}) {
    RouteSettings routeSettings =
        RouteSettings(name: path, arguments: arguments);
    RouteMatch routeMatch = matchRoute(context, path,
        routeSettings: routeSettings,
        transitionType: transition,
        transitionsBuilder: transitionBuilder,
        transitionDuration: transitionDuration);
    Route<dynamic> route = routeMatch.route;
    Completer completer = Completer();
    Future future = completer.future;
    if (routeMatch.matchType == RouteMatchType.nonVisual) {
      completer.complete("Non visual route type.");
    } else {
      if (route == null && notFoundHandler != null) {
        route = kelenotFoundRoute(context, path);
      }
      if (route != null) {
        if (clearStack) {
          future =
              Navigator.pushAndRemoveUntil(context, route, (check) => false);
        } else {
          future = replace
              ? Navigator.pushReplacement(context, route)
              : Navigator.push(context, route);
        }
        completer.complete();
      } else {
        String error = "No registered route was found to handle '$path'.";
        completer.completeError(RouteNotFoundException(error, path));
      }
    }
    return future;
  }
}
```
在整理笔记时，fluro已更新至 fluro: ^1.7.8, 并且在1.7.0的版本上增加了该方法，竟然一模一样，哈哈哈

除此以外还新增了 maintainState to FluroRouter.navigateTo 的方法

## maintainState的使用

maintainState：默认情况下，当入栈一个新路由时，原来的路由仍然会被保存在内存中，如果想在路由没用的时候释放其所占用的所有资源，可以设置maintainState为false。

这里创建Page1 Page2 Page3三个页面

```
class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page1'),
      ),
      body: Column(
        children: [
          MaterialButton(
            child: Text('page1'),
            onPressed: (){
              Application.router.navigateTo(context, '/page2', maintainState: true);
            },
          )
        ],
      ),
    );
  }
}

class Page2 extends StatefulWidget {
  final Map arguments;
  Page1(this.arguments);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {

  num count;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    count = 0;
    print('page2 --- initState');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page2'),
      ),
      body: Column(
        children: [
          Container(
            child: MaterialButton(
                child: Text(count.toString()),
                onPressed: (){
                  setState(() {
                    count = count + 1;
                  });
                },
              ),
          ),
          MaterialButton(
            child: Text('page2'),
            onPressed: (){
              Application.router.navigateTo(context, '/page3', maintainState: true);
            },
          )
        ],
      ),
    );
  }

  ...page3
}
```
在测试中发现，maintainState：false时，在page3返回page2后，计数count会被重置，Page2生命周期会重新执行。适用场景在于详情页-编辑页等类似案例中


## Flutter开发之导航与路由管理
    转载网友的优秀文章  

[Flutter开发之导航与路由管理](https://zhuanlan.zhihu.com/p/76496801?from_voters_page=true)
