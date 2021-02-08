# flutter版本的事件总线(EventBus)

## 实现目标
1. 发布者/订阅者模式
2. 集中式通信
3. 低耦合，简化组件通信

## 自定义EventBus

1. 定义 EventBus

```
// 订阅者回调签名
typedef void EventCallback(arg);

class EventBus {
  // 私有构造函数
  EventBus._internal();

  // 保存单例
  static EventBus _singleton = EventBus._internal();

  // 工厂构造函数
  factory EventBus()=> _singleton;

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  Map _emap = Map<String, List<EventCallback>>();

  // 添加订阅者
  void on(String eventName, EventCallback f) {
    if (eventName == null || f == null) return;
    _emap[eventName] ??= List<EventCallback>();
    // 防止重复监听
    for(int i=0; i<_emap[eventName].length; i++){
      if(_emap[eventName][i] == f){
        return;
      }else{
        // 覆盖监听
        _emap[eventName][i] = f;
        return;
      }
    }
    _emap[eventName].add(f);
  }

  // 移除订阅者
  void off(String eventName, [EventCallback f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  // 触发事件，事件触发后该事件所有订阅者会被调用
  void emit(String eventName, [arg]) {
    var list = _emap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}

EventBus bus = EventBus();
```

2. 举个栗子

```
    
main(List<String> args) {
  fn(arg){
    print('fn触发');
    print(arg);
  }

  fn2(arg){
    print('fn2触发');
    print(arg);
  }

  bus.on('fn', fn);
  bus.on('fn2', fn2);
  bus.emit('fn', [1,2,3,4]); // fn触发 [1, 2, 3, 4]
  bus.emit('fn2', [1,2,3,4]); // fn2触发 [1, 2, 3, 4]
  bus.off('fn'); 
  bus.emit('fn', [1,2,3,4]); // 
}
```