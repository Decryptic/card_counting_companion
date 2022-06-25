// Gage Swenson
// 20 June 2022

import 'package:flutter/material.dart' hide Card;

import 'src/card.dart';
import 'src/deck.dart';
import 'src/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  static const _title = 'Card Counting Companion';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xff35654d),
      ),
      home: const MyHomePage(title: _title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var _deck = Deck();
  Card? _card;
  
  @override
  void initState() {
    super.initState();
    
    _deck.shuffle();
  }
  
  void _showAlertDialog(String title, String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(message),
        content: Text(title),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
  
  void _handleSelection(String select, BuildContext context) {
    switch (select) {
      case 'Settings':
        Navigator.of(context).push<void>(_settingsRoute());
        break;
      case 'Reset':
        _deck.reset();
        setState(() {
          _card = null;
        });
        break;
      case 'Shuffle':
        _deck.shuffle();
        setState(() {
          _card = null;
        });
        break;
      case 'Place':
        String msg = _deck.burned.toString() + ' / ' + (_deck.pile + _deck.burned).toString();
        _showAlertDialog(select, msg, context);
        break;
      case 'Count':
        _showAlertDialog(select, _deck.count.toString(), context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => _handleSelection(value, context),
            itemBuilder: (BuildContext ctx) {
              return { 'Settings', 'Reset', 'Shuffle', 'Place', 'Count' }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            Expanded(
              flex: 18,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Spacer(),
                  Expanded(
                    flex: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_deck.isEmpty) {
                            _deck.shuffle();
                            _card = null;
                          }
                          else _card = _deck.pop();
                        });
                      },
                      child: Stack(
                        children: <Widget>[
                          Image.asset('assets/cards/' + (_deck.pile == 0 ? 'back.png' : _deck.top.png_name)),
                          Image.asset('assets/cards/' + (_card == null ? 'back.png' : _card!.png_name)),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
  
  Route _settingsRoute() {
  return PageRouteBuilder<SlideTransition>(
    pageBuilder: (context, animation, secondaryAnimation) => Settings(),
    transitionsBuilder: (context, animation, secondartAnimation, child) {
      var tween = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      );
      var curveTween = CurveTween(curve: Curves.ease);
      
      return SlideTransition(
        position: animation.drive(curveTween).drive(tween),
        child: child,
      );
    },
  );
}
}
