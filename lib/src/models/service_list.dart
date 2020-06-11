/*
  mDNS Plugin Example
  Flutter client demonstrating browsing for Chromecasts
  on your local network
  Copyright (c) David Thorpe 2019
  Please see the LICENSE file for licensing information
*/

import 'package:mdns_plugin/mdns_plugin.dart';
import 'package:web_socket_channel/io.dart';
import 'package:mdns_websocket/src/utils/globals.dart' as globals;

/////////////////////////////////////////////////////////////////////
class ServiceList {
  List<MDNSService> _list = List<MDNSService>();
  MDNSService _defaultService;
  var _channel;
  String _batteryLevelandTankLevel;

  // METHODS ////////////////////////////////////////////////////////

  void removeAll() {
    _list.clear();
  }

  void add(MDNSService service) {
    assert(service != null);
    var pos = _indexForItem(service);
    if (pos == -1) {
      _list.add(service);
    } else {
      _list[pos] = service;
    }
  }

  void update(MDNSService service) {
    this.add(service);
  }

  MDNSService remove(MDNSService service) {
    assert(service != null);
    var pos = _indexForItem(service);
    if (pos >= 0) {
      return _list.removeAt(pos);
    } else {
      return null;
    }
  }

  void setNewService(MDNSService service) {
    print("you clicked on a service");
    _defaultService = service;
    _channel.sink.close();
    final String ip = _defaultService.hostName;
    _channel = IOWebSocketChannel.connect("ws://$ip/ws");
    _channel.stream.listen((message) {
      _batteryLevelandTankLevel = message;
      print("From When Button is CLicked");
    });
    globals.currentService = service;
  }

  void setFirstServiceByDefault(MDNSService service) {
    // print(_defaultService);
    if (_list.length > 0) {
      print("First Service in the List is Set to Default");
      _defaultService = _list[0];
      print(_defaultService);
      final String ip = _defaultService.hostName;
      _channel = IOWebSocketChannel.connect("ws://$ip/ws");
      _channel.stream.listen((message) {
        print(message);
        _batteryLevelandTankLevel = message;
        print("From SetFirstDefaultState");
      });
      globals.currentService = service;
    }
    // } else {
    //   print('Je service detect thai aae set kari che.');
    //   _defaultService = service;
    //   print(_defaultService);
    // }
  }

  // PRIVATE METHODS ////////////////////////////////////////////////

  int _indexForItem(MDNSService service) {
    // We key items by their name
    for (int i = 0; i < _list.length; i++) {
      if (_list[i].name == service.name) {
        return i;
      }
    }
    // Return -1 in case name isn't found
    return -1;
  }

  // GETTERS AND SETTERS ////////////////////////////////////////////

  MDNSService itemAtIndex(int index) => _list[index];

  int get count => _list.length;
  MDNSService get defaultService => _defaultService;
  get batteryAndTankLevel => _batteryLevelandTankLevel;
}
