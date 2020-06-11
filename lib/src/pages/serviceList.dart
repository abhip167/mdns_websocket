import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdns_websocket/src/bloc/app.dart';
import 'package:mdns_websocket/src/pages/service_list.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // CONSTRUCTORS ///////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
  }

  // METHODS ////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      if (state is AppStateUninitialized) {
        return Placeholder();
      } else {
        return ServiceList();
      }
    });
  }
}
