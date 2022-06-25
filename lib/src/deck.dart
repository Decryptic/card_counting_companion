// Gage Swenson
// 21 June 2022

import 'card.dart';

class Deck {

  static const _nshuffles = 4;
  
  final int _ndecks;
  final List<Card> _deck;
  final List<Card> _discarded;
  
  bool get isEmpty => _deck.isEmpty;
  Card get top => _deck.last;
  int get burned => _discarded.length;
  int get pile => _deck.length;
  int get decks => _ndecks;
  
  int get count {
    int count = 0;
    for (var card in _discarded) {
      count += card.count;
    }
    return count;
  }
  
  Deck([this._ndecks = 1]) : _deck = <Card>[], _discarded = <Card>[] {
    for (int i = 0; i < _ndecks; i++) {
      Face.values.forEach((face) {
        Suit.values.forEach((suit) {
          _deck.add(Card(face, suit));
        });
      });
    }
  }
  
  void shuffle() {
    reset();
    for (int i = 0; i < _nshuffles; i++) {
      _deck.shuffle();
    }
  }
  
  void reset() {
    while (!_discarded.isEmpty) {
        _deck.add(_discarded.last);
        _discarded.removeLast();
    }
  }
  
  Card pop() {
    var c = _deck.last;
    _deck.removeLast();
    _discarded.add(c);
    return c;
  }
}
