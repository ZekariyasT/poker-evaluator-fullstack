
import 'package:flutter/material.dart';

enum Suit {
  hearts('H', Colors.red, '♥'),
  diamonds('D', Colors.blue, '♦'),
  clubs('C', Colors.green, '♣'),
  spades('S', Colors.black, '♠');

  final String code;
  final Color color;
  final String symbol;
  const Suit(this.code, this.color, this.symbol);

  static Suit fromCode(String c) {
    return Suit.values.firstWhere((s) => s.code == c);
  }
}

enum Rank {
  two('2', '2'),
  three('3', '3'),
  four('4', '4'),
  five('5', '5'),
  six('6', '6'),
  seven('7', '7'),
  eight('8', '8'),
  nine('9', '9'),
  ten('T', '10'),
  jack('J', 'J'),
  queen('Q', 'Q'),
  king('K', 'K'),
  ace('A', 'A');

  final String code;
  final String label;
  const Rank(this.code, this.label);

  static Rank fromCode(String c) {
    return Rank.values.firstWhere((r) => r.code == c);
  }
  
  int get value => Rank.values.indexOf(this);
}

class PokerCard {
  final Rank rank;
  final Suit suit;

  PokerCard(this.rank, this.suit);

  factory PokerCard.fromString(String s) {
    if (s.length != 2) throw ArgumentError('Invalid card string: $s');
    final sChar = s[0];
    final rChar = s[1];
    return PokerCard(Rank.fromCode(rChar), Suit.fromCode(sChar));
  }

  @override
  String toString() => '${suit.code}${rank.code}';

  String get displayName => '${rank.label}${suit.symbol}';
}
