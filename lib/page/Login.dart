import 'package:flutter/material.dart';
import 'package:flutterDemo/utils/application.dart';

class Login extends StatefulWidget {
  final Map arguments;
  Login(this.arguments);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  num count;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    count = 0;
    print('Lgoin --- initState');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
            child: Text('TTTTTT'),
            onPressed: (){
              Application.router.navigateTo(context, '/home', maintainState: true);
            },
          )
        ],
      ),
    );
  }
}