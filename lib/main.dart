import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdns_websocket/src/pages/BoothDataPage.dart';
import 'package:mdns_websocket/src/pages/serviceList.dart';

import 'package:mdns_websocket/src/pages/service_list.dart';
import 'package:mdns_websocket/src/bloc/app.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mdns_websocket/src/pages/wifiSettings.dart';

void main() => runApp(BlocProvider<AppBloc>(
    builder: (context) {
      return AppBloc()..dispatch(AppEventStart());
    },
    child: MainPage()));

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Tutorial',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Montserrat',
        ),
        home: HomePage());
  }
}

int _page = 1;
GlobalKey _bottomNavigationKey = GlobalKey();

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  static List<Widget> _widgetOptions = <Widget>[
    MyApp(),
    BoothDataPage(),
    // BoothDataPage(),
    WifiSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
      // appBar: AppBar(
      //   title: Text('Abhishek'),
      // ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 1,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.add, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.compare_arrows, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Color(0xFF21BFBD),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            //  _page.animateToPage(index,
            //   duration: Duration(milliseconds: 500), curve: Curves.easeOut);
            _page = index;
          });
        },
      ),
      body: Container(
        child: _widgetOptions.elementAt(_page),
      ),
    );
  }
}

// class _HomePageState extends State<HomePage> {
//   int currentIndex = 0;
//    MotionTabController _tabController;
//   @override
//   void initState() {
//     super.initState();
//      _tabController = new MotionTabController(vsync: this);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _tabController.dispose();
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return WillPopScope(
//   //       onWillPop: () {
//   //         return;
//   //       },
//   //       child: Scaffold(
//   //           body: PageView(
//   //               controller: _tabController,
//   //               children: <Widget>[
//   //                 MyApp(),
//   //                 BoothDataPage(),
//   //                 Container(child: SafeArea(child: Text('3'))),
//   //                 Container(child: SafeArea(child: Text('4'))),
//   //                 Container(child: SafeArea(child: Text('5'))),
//   //               ],
//   //               onPageChanged: (int index) {
//   //                 setState(() {
//   //                   currentIndex = index;
//   //                 });
//   //               }),
//   //           bottomNavigationBar: bottomItems()));
//   // }

//   // BottomNavigationBar bottomItems() {
//   //   return BottomNavigationBar(
//   //       selectedItemColor: Colors.blue,
//   //       onTap: (int index) {
//   //         setState(() {
//   //           currentIndex = index;
//   //         });
//   //         pageController.animateToPage(
//   //           index,
//   //           duration: Duration(
//   //             milliseconds: 200,
//   //           ),
//   //           curve: Curves.easeIn,
//   //         );
//   //       },
//   //       currentIndex: currentIndex,
//   //       type: BottomNavigationBarType.fixed,
//   //       items: <BottomNavigationBarItem>[
//   //         BottomNavigationBarItem(
//   //             icon: Icon(Icons.home), title: SizedBox.shrink()),
//   //         BottomNavigationBarItem(
//   //             icon: Icon(Icons.search), title: SizedBox.shrink()),
//   //         BottomNavigationBarItem(
//   //             icon: Icon(Icons.add_circle, size: 35.0),
//   //             title: SizedBox.shrink()),
//   //         BottomNavigationBarItem(
//   //             icon: Icon(Icons.notifications), title: SizedBox.shrink()),
//   //         BottomNavigationBarItem(
//   //             icon: Icon(Icons.supervised_user_circle),
//   //             title: SizedBox.shrink())
//   //       ]);
//   // }

// }
