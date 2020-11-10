import 'package:flutter/material.dart';
import 'package:battery/battery.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textStyle = const TextStyle(fontSize: 60.0,color: Color(0xffffffff));
  final light =  const IconData(0xf3e6,
      fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage);
  var _batteryLevel = 0;
  var _imageUrl = 'static/images/chargeMode1/1.png';
  var _battery = Battery();
  Timer _countdownTimer;
  var _countdownNum = 50;
  Future<int> _getBatteryLevel() async {
    return  await _battery.batteryLevel;
  }
  _setBatteryLevel() {
    _getBatteryLevel().then((value){
      setState(() {
        _batteryLevel = value;
      });
    });
  }
  _onBatteryStateChange() {
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      // Do something with new state
      print(state);
    });
  }
  void reGetCountdown() {
    setState(() {
      if (_countdownTimer != null) {
        return;
      }
      _countdownTimer =
      new Timer.periodic(new Duration(milliseconds: 100), (timer) {
        setState(() {
          if (_countdownNum > 0) {
            _imageUrl = 'static/images/chargeMode1/${50 - _countdownNum + 1}.png';
            _countdownNum--;
          } else {
            _countdownNum = 50;
            reGetCountdown();
          }
        });
      });
    });
  }
  @override
  void initState() {
    super.initState();
    reGetCountdown();
    _setBatteryLevel();
    _onBatteryStateChange();
  }
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //充满屏幕
        constraints: new BoxConstraints.expand(
          height:double.infinity,
          width:double.infinity,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_imageUrl),
            fit: BoxFit.contain,
          ),
            gradient: LinearGradient(colors: [Color(0xff94515f), Color(0xff73698f), Color(0xff49799a), Color(0xff719eaa)], begin: FractionalOffset(0, 1), end: FractionalOffset(1, 0))
        ),
        padding: EdgeInsets.only(bottom: 100.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(light,size: 60,color: Color(0xffffffff)),
            Text(
            '$_batteryLevel'+ '%',
              style: textStyle,
            )
          ]
        ),
      ),
    );
  }
}
