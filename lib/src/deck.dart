// Gage Swenson
// 21 June 2022

import 'card.dart';

class Deck {

  final _nshuffles = 4;
  
  final int _ndecks;
  final List<Card> _deck;
  final List<Card> _discarded;
  
  bool get isEmpty => _deck.isEmpty;
  Card get top => _deck.last;
  int get decks => _ndecks;
  double get decks_remaining => _deck.length / 52;
  int get burned => _discarded.length;
  int get length => _deck.length + this.burned;
  
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
  
  int get count_hilo {
    int count = 0;
    _discarded.forEach((card) => count += card.count_hilo);
    return count;
  }
  
  double get count_wonghalves {
    double count = 0.0;
    _discarded.forEach((card) => count += card.count_wonghalves);
    return count;
  }
  
  int get count_hiopti {
    int count = 0;
    _discarded.forEach((card) => count += card.count_hiopti);
    return count;
  }
  
  int get count_hioptii {
    int count = 0;
    _discarded.forEach((card) => count += card.count_hioptii);
    return count;
  }
  
  int get count_omegaii {
    int count = 0;
    _discarded.forEach((card) => count += card.count_omegaii);
    return count;
  }
  
  int get count_zen {
    int count = 0;
    _discarded.forEach((card) => count += card.count_zen);
    return count;
  }
  
  int get count_red7 {
    int count = -2 * _ndecks;
    _discarded.forEach((card) => count += card.count_red7);
    return count;
  }
  
  int get count_ko {
    int count = -4 * (_ndecks - 1);
    _discarded.forEach((card) => count += card.count_ko);
    return count;
  }
}
