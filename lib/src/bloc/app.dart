/*
  mDNS Plugin Example
  Flutter client demonstrating browsing for Chromecasts
  on your local network
  Copyright (c) David Thorpe 2019
  Please see the LICENSE file for licensing information
*/

import 'package:bloc/bloc.dart';

import 'package:mdns_plugin/mdns_plugin.dart';
import 'package:mdns_websocket/src/models/service_list.dart';

/////////////////////////////////////////////////////////////////////
// EVENT

enum AppEventDiscoveryState { Started, Stopped, Restart }

enum AppEventServiceState {
  Found,
  Resolved,
  Updated,
  Removed,
  setFirstServiceByDefault,
  setNewService
}

abstract class AppEvent {}

class AppEventStart extends AppEvent {
  @override
  String toString() => 'AppEventStart';
}

class AppEventDiscovery extends AppEvent {
  AppEventDiscoveryState state;

  // CONSTRUCTOR ////////////////////////////////////////////////////

  AppEventDiscovery(this.state);

  // GETTERS AND SETTERS ////////////////////////////////////////////

  @override
  String toString() => 'AppEventDiscovery($state)';
}

class AppEventService extends AppEvent {
  AppEventServiceState state;
  MDNSService service;

  // CONSTRUCTOR ////////////////////////////////////////////////////

  AppEventService(this.state, this.service);

  // GETTERS AND SETTERS ////////////////////////////////////////////

  @override
  String toString() => 'AppEventService($state,$service)';
}

/////////////////////////////////////////////////////////////////////
// STATE

enum AppStateAction { ShowToast }

abstract class AppState {}

class AppStateUninitialized extends AppState {
  @override
  String toString() => 'AppStateUninitialized';
}

class AppStarted extends AppState {
  @override
  String toString() => 'AppStarted';
}

class AppUpdated extends AppState {
  ServiceList services;
  MDNSService service;
  AppStateAction action;

  // CONSTRUCTOR ////////////////////////////////////////////////////

  AppUpdated(this.services, {this.service, this.action});

  // GETTERS AND SETTERS ////////////////////////////////////////////

  @override
  String toString() => 'AppUpdated($service,$action)';
}

/////////////////////////////////////////////////////////////////////
// BLOC

class AppBloc extends Bloc<AppEvent, AppState> implements MDNSPluginDelegate {
  final String serviceType = "_sanitaize._tcp";
  MDNSPlugin _mdns;
  ServiceList _services = ServiceList();

  // EVENT MAPPING //////////////////////////////////////////////////

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppEventStart) {
      print(event);
      // Start discovery
      _mdns = MDNSPlugin(this);
      _mdns.startDiscovery(serviceType, enableUpdating: true);
    }

    if (event is AppEventDiscovery) {
      print(event);
      // Remove all services and update the application
      _services.removeAll();
      // If restart then call discovery again
      if (event.state == AppEventDiscoveryState.Restart) {
        _mdns.startDiscovery(serviceType);
        yield AppUpdated(_services, action: AppStateAction.ShowToast);
      } else {
        yield AppUpdated(_services);
      }
    }

    if (event is AppEventService) {
      switch (event.state) {
        case AppEventServiceState.Found:
          // print(event.state);
          // We don't add the service when it's found, but only when
          // it's resolved or updated
          break;
        case AppEventServiceState.Resolved:
          print(event.state);

          _services.update(event.service);
          break;
        case AppEventServiceState.Updated:
          print(event.state);

          _services.update(event.service);
          break;
        case AppEventServiceState.Removed:
          print(event.state);

          _services.remove(event.service);
          break;
        case AppEventServiceState.setFirstServiceByDefault:
          print(event.state);
          _services.setFirstServiceByDefault(event.service);
          break;
        case AppEventServiceState.setNewService:
          print(event.state);

          _services.setNewService(event.service);
          break;
      }
      yield AppUpdated(_services, service: event.service);
      // print(event.state);
    }
  }

  // MDNS PLUGIN DELEGATE  //////////////////////////////////////////

  void onDiscoveryStarted() =>
      this.dispatch(AppEventDiscovery(AppEventDiscoveryState.Started));
  void onDiscoveryStopped() =>
      this.dispatch(AppEventDiscovery(AppEventDiscoveryState.Stopped));
  bool onServiceFound(MDNSService service) {
    this.dispatch(AppEventService(AppEventServiceState.Found, service));
    // Always resolve services which have been found
    return true;
  }

  void onServiceResolved(MDNSService service) {
    this.dispatch(AppEventService(AppEventServiceState.Resolved, service));
    this.dispatch(AppEventService(
        AppEventServiceState.setFirstServiceByDefault, service));
  }

  void onServiceUpdated(MDNSService service) {
    this.dispatch(AppEventService(AppEventServiceState.Updated, service));
    this.dispatch(AppEventService(
        AppEventServiceState.setFirstServiceByDefault, service));
  }

  void onServiceRemoved(MDNSService service) =>
      this.dispatch(AppEventService(AppEventServiceState.Removed, service));

  // GETTERS AND SETTERS ////////////////////////////////////////////

  @override
  AppState get initialState => AppStateUninitialized();
}
