class MyAppConfig {
  static String _mode = 'develop';
  void setMode(String mode) => _mode = mode;
  getCofig(){
    Map<String,dynamic> config = {
      'baseUrl': '开发地址',
      'other': '其他配置'
    };
    switch(_mode){
      case 'develop':
      break;
      case 'test': {
        config = {
          'baseUrl': '测试地址',
          'other': '其他配置'
        };
      }
      break;
      case 'product': {
        config = {
          'baseUrl': '生产地址',
          'other': '其他配置'
        };
      }
      break;
    }

    return config;
  }
}