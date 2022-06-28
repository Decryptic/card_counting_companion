// Gage Swenson
// 20 June 2022

import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';

import 'src/card.dart';
import 'src/deck.dart';

void main() => runApp(const MyApp());

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

class _MyHomePageState extends State<MyHomePage>
  with SingleTickerProviderStateMixin {

  var _deck = Deck();
  Card? _card;
  
  final _cards_path = 'assets/cards/';
  final _textFieldController = TextEditingController();
  
  late final AnimationController _controller;
  late Animation<Alignment> _animation;
  var _alignment = Alignment.center;
  bool _swiped = false;
  
  @override
  void initState() {
    super.initState();
    _deck.shuffle();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    
    _controller.addListener(() {
      setState(() {
        _alignment = _animation.value;
      });
    });
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_swiped) {
          setState(() {
            _drawCard();
            _alignment = Alignment.center;
          });
        }
        
        _swiped = false;
      }
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _drawCard() {
    if (_deck.isEmpty) {
      _deck.shuffle();
      _card = null;
    }
    else _card = _deck.pop();
  }
  
  void _runAnimation(Offset pps, Size size) { // pps -> pixels per second
  
    // ups -> units per second
    final upsX = pps.dx / size.width;
    final upsY = pps.dy / size.height;
    final ups = Offset(upsX, upsY);
    final velocity = ups.distance;
    
    _swiped = velocity > 2;
    _animation = _controller.drive(
      AlignmentTween(
        begin: _alignment,
        end: !_swiped ? Alignment.center : Alignment(
          upsX * 3,
          upsY * 3,
        ),
      ),
    );
    
    _controller.reset();
    _controller.forward();
  }
  
  void _showAlertDialog(String title, String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(title),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
  
  void _showDecksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Number of Decks:'),
          content: TextField(
            controller: _textFieldController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(hintText: 'from 1 to 1000'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                int i = int.parse(_textFieldController.text);
                if (1 <= i && i <= 1000) {
                  if (_deck.decks != i) {
                    _deck = Deck(i);
                    _deck.shuffle();
                    setState(() {
                      _card = null;
                    });
                  }
                  Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
  
  void _handleSelection(String select, BuildContext context) {
    switch (select) {
      case 'Decks':
        _textFieldController.text = _deck.decks.toString();
        _showDecksDialog(context);
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
        final msg = _deck.burned.toString() + ' / ' + _deck.length.toString();
        _showAlertDialog(select, msg, context);
        break;
      case 'Count':
        _showAlertDialog(select, _deck.count.toString(), context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
  
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => _handleSelection(value, context),
            itemBuilder: (BuildContext ctx) {
              return { 'Decks', 'Reset', 'Shuffle', 'Place', 'Count' }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              _cards_path + (_deck.isEmpty ? 'back.png' : _deck.top.png_name),
              width: size.width * 3 / 4,
              height: size.height * 3 / 4,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _drawCard();
              });
            },
            onPanDown: (details) {
              _controller.stop();
            },
            onPanUpdate: (details) {
              setState(() {
                _alignment += Alignment(
                  details.delta.dx / (size.width / 8),
                  details.delta.dy / (size.height / 8),
                );
              });
            },
            onPanEnd: (details) {
              _runAnimation(details.velocity.pixelsPerSecond, size);
            },
            child: Align(
              alignment: _alignment,
              child: Image.asset(
                  _cards_path + (_card?.png_name ?? 'back.png'),
                  width: size.width * 3 / 4,
                  height: size.height * 3 / 4,
                ),
            ),
          ),
        ],
      ),
    );
  }
}
