import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool isTokenValid = false;
  final List<Tab> myTabs = <Tab>[
    Tab(
      icon: Icon(
        Icons.map,
      ),
    ),
    Tab(
      icon: Icon(
        Icons.web,
      ),
    ),
    Tab(
      icon: Icon(
        Icons.account_box,
      ),
    ),
  ];

  TabController _tabController;
  Completer<WebViewController> _webViewController =
      Completer<WebViewController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      length: myTabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  _launchURL() async {
    const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Scaffold renderLoginView() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  print(value);
                },
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                onChanged: (value) {
                  print(value);
                },
                obscureText: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    isTokenValid = true;
                  });
                },
                color: Colors.lightBlueAccent,
                elevation: 5.0,
                child: Text(
                  'Login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Scaffold renderMainHomeView() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        bottom: TabBar(
          tabs: myTabs,
          controller: _tabController,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isTokenValid = false;
                  _tabController.index = 0;
                });
              },
              child: Icon(
                Icons.power_settings_new,
              ),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Icon(Icons.map),
          /*Center(
            child: RaisedButton(
              onPressed: () {
                _launchURL();
              },
              child: Text('Show flutter homepage'),
            ),
          ),*/
          Scaffold(
            appBar: AppBar(
              title: Text(
                'In App Browser',
              ),
              backgroundColor: Colors.green,
            ),
            body: WebView(
              initialUrl: 'https://google.com.vn/',
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController.complete(webViewController);
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(
                  Icons.account_box,
                  size: 50.0,
                ),
                Text(
                  'Hoang.NM',
                  textAlign: TextAlign.center,
                ),
                Text(
                  'iOS Developer',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isTokenValid ? renderMainHomeView() : renderLoginView();
  }
}
