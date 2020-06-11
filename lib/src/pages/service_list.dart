/*
  mDNS Plugin Example
  Flutter client demonstrating browsing for Chromecasts
  on your local network
  Copyright (c) David Thorpe 2019
  Please see the LICENSE file for licensing information
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mdns_websocket/src/bloc/app.dart';
import 'package:mdns_websocket/src/widgets/appBar.dart';
import 'package:mdns_websocket/src/widgets/service_tile.dart';

/////////////////////////////////////////////////////////////////////
class ServiceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
      body: BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          if (state is AppUpdated && state.action == AppStateAction.ShowToast) {
            Scaffold.of(context).showSnackBar(snackBarWithText("Rescanning"));
          }
        },
        child: Column(
          children: <Widget>[
            SizedBox(height: 24.0),
            appBar(),
            SizedBox(height: 25.0),
            Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Row(
                children: <Widget>[
                  Text('Available',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0)),
                  SizedBox(width: 10.0),
                  Text('Devices',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 25.0))
                ],
              ),
            ),
            SizedBox(height: 40.0),
            infoWidget(context),
            listWidget(context)
          ],
        ),
      ),
    );
  }

  Widget snackBarWithText(String text) {
    return SnackBar(content: Text(text), duration: Duration(seconds: 1));
  }

  Widget listWidget(BuildContext context) => BlocBuilder(
      bloc: BlocProvider.of<AppBloc>(context),
      builder: (BuildContext context, AppState state) {
        if (state is AppUpdated && state.services.count > 0) {
          print(state.services.count);
          return Expanded(
              flex: 3,
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(seconds: 2),
                child: ListView.builder(
                    itemCount: state.services.count,
                    itemBuilder: (BuildContext context, int index) =>
                        ServiceTile(state.services.itemAtIndex(index))),
              ));
        } else {
          return Expanded(child: Center(child: Text("No Booths Found.")));
        }
      });

  Widget infoWidget(BuildContext context) => BlocBuilder(
      bloc: BlocProvider.of<AppBloc>(context),
      builder: (BuildContext context, AppState state) {
        final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
        return Card(
            margin: new EdgeInsets.only(
                left: 20.0, right: 20.0, top: 8.0, bottom: 5.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 4.0,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              SizedBox(height: 6.0),
              ListTile(
                  title: Text('Found Sanitaization Booths',
                      style: TextStyle(
                        color: Color(0xFF21BFBD),
                        fontWeight: FontWeight.w900,
                      )),
                  subtitle: Text(
                      "The following devices were found on your local network")),
              ButtonBar(children: <Widget>[
                RaisedButton(
                  child: const Text('Rescan',
                      style: TextStyle(
                        color: Color(0xFF21BFBD),
                        fontWeight: FontWeight.w800,
                      )),
                  onPressed: () => appBloc.dispatch(
                    AppEventDiscovery(AppEventDiscoveryState.Restart),
                  ),
                ),
              ])
            ]));
      });
}
