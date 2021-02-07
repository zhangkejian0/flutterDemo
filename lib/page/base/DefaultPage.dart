import 'package:flutter/material.dart';
import 'package:flutterDemo/utils/application.dart';

class DefaultPage extends StatefulWidget {
  @override
  _DefaultPageState createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {

  num count;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    count = 0;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DefaultPage'),
      ),
      body: Column(
        children: [
          Container(
            child: MaterialButton(
              child: Text('login'),
              onPressed: (){
                Application.router.navigateTo(context, '/login', routeSettings: RouteSettings(
                  arguments: {
                    'test': 'test'
                  }
                ), maintainState: false);
              },
            ),
          ),
          MaterialButton(
            child: Text(count.toString()),
            onPressed: (){
              setState(() {
                count = count + 1;
              });
            },
          )
        ],
      ),
    );
  }
}