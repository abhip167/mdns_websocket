import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mdns_websocket/src/utils/constants.dart';
import 'package:mdns_websocket/src/widgets/appBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mdns_websocket/src/utils/globals.dart' as globals;

// TAKEN FROM HERE
//https://github.com/MarcusNg/flutter_login_ui

Future<Settings> createSettings(
    String ssid, String password, String hostName) async {
  Map<String, String> data = {
    "ssid": ssid.trim(),
    "password": password.trim(),
    "hostName": hostName.trim()
  };
  print(globals.currentService.hostName.toString());
  final http.Response response = await http.post(
    'http://${globals.currentService.hostName}/settings',
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(data),
  );

  print(response);
  print(response.body);
  if (response.statusCode == 200) {
    return Settings.fromJson(json.decode(response.body));
  } else {
    print(response);
    return Settings.fromJson(json.decode(response.body));
    // throw Exception('Failed to create album.');
  }
}

class Settings {
  final String ssid;
  final String password;
  final String hostName;
  final String error;

  Settings({this.ssid, this.password, this.hostName, this.error});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
        ssid: json['ssid'],
        password: json['password'],
        hostName: json['hostName'],
        error: json['error']);
  }
}

class WifiSettings extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<WifiSettings> {
  // bool _rememberMe = false;
  final TextEditingController _ssidcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _hostNamecontroller = TextEditingController();
  Future<Settings> _futureSettings;
  final _formKey = GlobalKey<FormState>();

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'SSID',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            controller: _ssidcontroller,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.wifi,
                color: Colors.white,
              ),
              hintText: 'Enter your Wifi Name',
              hintStyle: kHintTextStyle,
            ),
            textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            controller: _passwordcontroller,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
            textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Device Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            controller: _hostNamecontroller,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.bubble_chart,
                color: Colors.white,
              ),
              hintText: 'Booth 1 or Booth 2',
              hintStyle: kHintTextStyle,
            ),
            textInputAction: TextInputAction.done,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          if (_ssidcontroller.text.isNotEmpty &&
              _passwordcontroller.text.isNotEmpty &&
              _hostNamecontroller.text.isNotEmpty) {
            setState(() {
              _futureSettings = createSettings(_ssidcontroller.text,
                  _passwordcontroller.text, _hostNamecontroller.text);
            });

            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Please Wait while we change Network.')));
          } else if (_ssidcontroller.text.isEmpty ||
              _passwordcontroller.text.isEmpty ||
              _hostNamecontroller.text.isEmpty) {
            _showMyDialog('Wait', 'Please Fill Up All The Details', 'Okay');
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Please Fill Up All The Details')));
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'CONNECT',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(
      String title, String message, String button) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              elevation: 5.0,
              onPressed: () {
                Navigator.of(context).pop();
              },
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              child: Text(
                'Okay',
                style: TextStyle(
                  color: Color(0xFF527DAA),
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          elevation: 5.0,
          backgroundColor: Colors.blueAccent[100],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: appBar(),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 100.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Change Wifi Network',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0)),
                        SizedBox(height: 20.0),
                        _buildEmailTF(),
                        SizedBox(
                          height: 25.0,
                        ),
                        _buildPasswordTF(),
                        SizedBox(
                          height: 25.0,
                        ),
                        _buildDeviceNameTF(),
                        _buildLoginBtn(),
                        Container(
                          child: (_futureSettings == null)
                              ? Text('')
                              : FutureBuilder<Settings>(
                                  future: _futureSettings,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(snapshot.data.ssid);
                                    } else if (snapshot.hasError) {
                                      return Text("${snapshot.error}");
                                    }

                                    return CircularProgressIndicator();
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
