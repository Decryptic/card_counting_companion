// Gage Swenson
// 20 June 2022

import 'package:flutter/material.dart' hide Card;
//import 'package:flutter_svg/flutter_svg.dart';

import 'src/card.dart';
import 'src/deck.dart';

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
  bool _new_deck = true;
  
  @override
  void initState() {
    super.initState();
    
    _deck.shuffle();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            Expanded(
              flex: 8,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (!_new_deck) {
                      _deck.pop();
                      if (_deck.isEmpty) {
                        _deck.shuffle();
                        _new_deck = true;
                      }
                    }
                    else _new_deck = false;
                  });
                },
                child: Image.asset('assets/cards/' + (_new_deck ? 'back.png' : _deck.top.png_name)),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
