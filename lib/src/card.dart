// Gage Swenson
// 21 June 2022

enum Suit { clubs, diamonds, hearts, spades }
enum Face { ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king }

class Card {
  
  final Face _face;
  final Suit _suit;
  
  Card([this._face = Face.ace, this._suit = Suit.spades]);
  
  String get png_name => _face.name + '_of_' + _suit.name + '.png';
  
  int get count {
    switch (_face) {
      case Face.two:
      case Face.three:
      case Face.four:
      case Face.five:
      case Face.six:
        return 1;
      case Face.ten:
      case Face.jack:
      case Face.queen:
      case Face.king:
      case Face.ace:
        return -1;
    }
    return 0;
  }
}
