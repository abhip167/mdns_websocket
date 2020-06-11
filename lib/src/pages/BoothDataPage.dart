import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdns_plugin/mdns_plugin.dart';
import 'package:mdns_websocket/src/bloc/app.dart';
import 'package:mdns_websocket/src/utils/globals.dart';
import 'package:mdns_websocket/src/widgets/appBar.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BoothDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      bloc: BlocProvider.of<AppBloc>(context),
      builder: (BuildContext context, AppState state) {
        if (state is AppUpdated &&
            state.services.count > 0 &&
            state.services.batteryAndTankLevel != null) {
          print(state.services.defaultService);
          final name = state.services.defaultService.name;
          final _deviceName = state.service.name.substring(0, name.length - 4);
          final _batteryandTankLevel =
              jsonDecode(state.services.batteryAndTankLevel);
          print(_batteryandTankLevel);
          return _boothWidget(
              context, state, _deviceName, _batteryandTankLevel);
        } else {
          return Container(
            child: Center(
              child: Text('No Device Found'),
            ),
          );
        }
      },
    );
  }
}

Widget _boothWidget(BuildContext context, state, String _deviceName,
    Map<String, dynamic> _batteryandTankLevel) {
  return Scaffold(
    backgroundColor: Color(0xFF21BFBD),
    body: ListView(
      children: <Widget>[
        appBar(),
        SizedBox(height: 25.0),
        Padding(
          padding: EdgeInsets.only(left: 40.0),
          child: Row(
            children: <Widget>[
              Text(_deviceName,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0)),
              SizedBox(width: 10.0),
              Text('Data',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 25.0))
            ],
          ),
        ),
        SizedBox(height: 40.0),
        _singleCard('Battery', '${_batteryandTankLevel["battery"]}'),
        SizedBox(height: 40.0),
        _singleCard('Tank', '${_batteryandTankLevel["tank"]}'),
      ],
    ),
  );
}

Widget _singleCard(String key, String value) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
      height: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(55.0),
            topRight: Radius.circular(55.0),
            bottomLeft: Radius.circular(55.0),
            bottomRight: Radius.circular(55.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(key,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600)),
          Row(
            children: <Widget>[
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 50.0,
                ),
              ),
              Text(
                '%',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 30.0,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// class MyHomePage extends StatefulWidget {
//   final String title;
//   final WebSocketChannel channel;

//   MyHomePage({Key key, @required this.title, @required this.channel})
//       : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             StreamBuilder(
//               stream: widget.channel.stream,
//               builder: (context, snapshot) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 24.0),
//                   child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }

//   // void _sendMessage() {
//   //   if (_controller.text.isNotEmpty) {
//   //     widget.channel.sink.add(_controller.text);
//   //   }
//   // }

//   @override
//   void dispose() {
//     widget.channel.sink.close();
//     super.dispose();
//   }
// }
