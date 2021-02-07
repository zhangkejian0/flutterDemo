# 开发、测试、生产环境配置

1. lib/main_XXX添加入口文件  
这里添加main_develop.dart开发、main_test.dart测试、main_production.dart生产  
在各文件中，通过MyAppConfig().setMode('xxx');方法来修改config配置文件

2. lib/config.dart  
修改 Map<String,dynamic> config对应不同环境参数

3. 不同环境的启动及打包  
通过运行带--target或者-t参数来运行或打包不同的环境（默认会开启R8压缩）    
```
    flutter run -t .\lib\main_xxx.dart // 运行
    flutter build apk -t .\lib\main_xxx.dart // 打包
    flutter build apk --no-shrink -t .\lib\main_xxx.dart // 打包，不压缩打包
```