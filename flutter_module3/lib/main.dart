import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'circle/AbilityWidget.dart';
import 'circle/AbilityWidget2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: _getWidget(),
    );
  }

  Widget _getWidget()
  {
    if("route1"==window.defaultRouteName)
      {
        return HomePage();

      }
    else if("route2"==window.defaultRouteName)
      {
        return HomePageEvent();

      }
    else if("route3"==window.defaultRouteName)
      {
        return HomePageBasicMessageChannel();
      }
    else if("show_canvas"==window.defaultRouteName)
      {
        var sca = Scaffold(
            body: Center(child: AbilityWidget2(
              ability: Ability(
                  radius: 100,
                  image: AssetImage("images/scenery.jpg"),
                  data: {
                    "攻击力": 70.0,
                    "生命": 90.0,
                    "闪避": 50.0,
                    "暴击": 70.0,
                    "破格": 80.0,
                    "格挡": 100.0,
                  },
                  color: Colors.greenAccent,
                  duration: 2000
              ),
            )),
          );
        return Container(
          color: Colors.white,
          child: sca,
        );
      }
    else
      {
        return Center(
          child: Text("找不到路径"),
        );
      }

  }
}

class HomePageBasicMessageChannel extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return HomePageBasicMessageChannelState();
  }

}

class HomePageBasicMessageChannelState extends State<HomePageBasicMessageChannel>
{
  static const BasicMessageChannel<String> platform = BasicMessageChannel<String>('samples.flutter.io/basic', StringCodec());
  String result;
  String result2;
  Future<String> _handlePlatformIncrement(String message) async {
    //这儿接收Android端发送的消息
    setState(() {
      result=message;
    });
    //这是回传给Android端的，Android可以接收
    return "flutter收到消息了，这是返给你的信息";
  }


  @override
  Widget build(BuildContext context) {
    platform.setMessageHandler(_handlePlatformIncrement);
    return Scaffold(

      body: Center(
        child: Column(
          children: <Widget>[
            Text("接收到Android端发过来的信息：${result}"),
            InkWell(
              child: Text("发送消息"),
              onTap: (){
                //这儿是主动给Android发送消息的代码
                platform.send("flutter主动发送的消息");
              },
            ),
            Text("flutter主动发送消息后，Android给的返回值：${result2}")
          ],
        ),
      ),
    );
  }

}

class HomePageEvent extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return HomePageEventState();
  }

}

class HomePageEventState extends State<HomePageEvent>
{
  static const EventChannel eventChannel = const EventChannel('samples.flutter.io/charging');

  String _chargingStatus;
  @override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  //这儿是接收Android端发送来的消息
  void _onEvent(Object event) {
    setState(() {
//      _chargingStatus =
//      "Battery status: ${event == 'charging' ? '' : 'dis'}charging.";
    _chargingStatus=event.toString();
    });
  }

  void _onError(Object error) {
    setState(() {
      _chargingStatus = 'Battery status: unknown.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("${_chargingStatus}"),
      ),
    );
  }

}

class HomePage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }

}

class _MyHomePageState extends State<HomePage>
{
  MethodChannel  platform = const MethodChannel('samples.flutter.io/battery');
  
  String _batteryLevel = 'Unknown battery level.';

  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }



  Future<dynamic> platformCallHandler(MethodCall call) async {
    //call.method是获取方法名，call.arguments是获取方法参数
    switch (call.method) {
      case "getName":
        return "Hello from Flutter:${call.arguments}";
        break;
    }
  }



  @override
  Widget build(BuildContext context) {
    //为了使原生也可以调用到flutter中的方法
    platform.setMethodCallHandler(platformCallHandler);
    // TODO: implement build
    return Scaffold(
      body: Center(
        child:Column(
          children: <Widget>[
            Text("电量:${_batteryLevel}"),

            IconButton(
                icon: Icon(Icons.ac_unit), onPressed: (){
              _getBatteryLevel();
            },
              tooltip: "获取电量",

            )

          ],
        )

      ),
    );
  }

}


