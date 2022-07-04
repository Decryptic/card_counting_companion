// Gage Swenson
// 21 June 2022

enum Suit { clubs, diamonds, hearts, spades }
enum Face { ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king }

class Card {
  
  final Face _face;
  final Suit _suit;
  
  Card([this._face = Face.ace, this._suit = Suit.spades]);
  
  String get png_name => _face.name + '_of_' + _suit.name + '.png';
  
  int get count_hilo {
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
  
  double get count_wonghalves {
    switch (_face) {
      case Face.three:
      case Face.four:
      case Face.six:
        return 1.0;
      case Face.two:
      case Face.seven:
        return 0.5;
      case Face.five:
        return 1.5;
      case Face.eight:
        return -0.5;
      case Face.nine:
        return 0;
    }
    return -1;
  }
  
  int get count_hiopti {
    switch (_face) {
      case Face.three:
      case Face.four:
      case Face.five:
      case Face.six:
        return 1;
      case Face.ten:
      case Face.jack:
      case Face.queen:
      case Face.king:
        return -1;
    }
    return 0;
  }
  
  int get count_hioptii {
    switch (_face) {
      case Face.two:
      case Face.three:
      case Face.six:
      case Face.seven:
        return 1;
      case Face.ace:
      case Face.eight:
      case Face.nine:
        return 0;
      case Face.four:
      case Face.five:
        return 2;
    }
    return -2;
  }
  
  int get count_omegaii {
    switch (_face) {
      case Face.two:
      case Face.three:
      case Face.seven:
        return 1;
      case Face.four:
      case Face.five:
      case Face.six:
        return 2;
      case Face.ace:
      case Face.eight:
        return 0;
      case Face.nine:
        return -1;
    }
    return -2;
  }
  
  int get count_zen {
    switch (_face) {
      case Face.two:
      case Face.three:
      case Face.seven:
        return 1;
      case Face.four:
      case Face.five:
      case Face.six:
        return 2;
      case Face.eight:
      case Face.nine:
        return 0;
      case Face.ace:
        return -1;
    }
    return -2;
  }
  
  // Starting count is -2 * _ndecks
  int get count_red7 {
    switch (_face) {
      case Face.two:
      case Face.three:
      case Face.four:
      case Face.five:
      case Face.six:
        return 1;
      case Face.eight:
      case Face.nine:
        return 0;
      case Face.seven:
        if (_suit == Suit.hearts || _suit == Suit.diamonds)
          return 1;
        return 0;
    }
    return -1;
  }
  
  // Starting count is -4 * (_ndecks - 1)
  int get count_ko {
    switch (_face) {
      case Face.ten:
      case Face.jack:
      case Face.queen:
      case Face.king:
      case Face.ace:
        return -1;
      case Face.eight:
      case Face.nine:
        return 0;
    }
    return 1;
  }
}
