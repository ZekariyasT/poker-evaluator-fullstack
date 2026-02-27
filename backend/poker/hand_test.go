package poker

import (
	"testing"
)

// ─────────────────────────────────────────────────────────────────────────────
// Helper to build a hand from strings (panics on bad input — test only)
// ─────────────────────────────────────────────────────────────────────────────

func mustCards(ss ...string) []Card {
	cards, err := ParseCards(ss)
	if err != nil {
		panic(err)
	}
	return cards
}

func mustFive(ss ...string) []Card {
	c := mustCards(ss...)
	if len(c) != 5 {
		panic("need exactly 5 cards")
	}
	return c
}

// ─────────────────────────────────────────────────────────────────────────────
// EvaluateFive – hand category tests
// ─────────────────────────────────────────────────────────────────────────────

func TestRoyalFlush(t *testing.T) {
	cards := mustFive("HA", "HK", "HQ", "HJ", "HT")
	score, name := EvaluateFive(cards)
	if score[0] != RoyalFlush {
		t.Errorf("expected Royal Flush, got %s (score %v)", name, score)
	}
}

func TestStraightFlush(t *testing.T) {
	cards := mustFive("S9", "S8", "S7", "S6", "S5")
	score, name := EvaluateFive(cards)
	if score[0] != StraightFlush {
		t.Errorf("expected Straight Flush, got %s (score %v)", name, score)
	}
}

func TestFourOfAKind(t *testing.T) {
	cards := mustFive("HA", "SA", "CA", "DA", "HK")
	score, name := EvaluateFive(cards)
	if score[0] != FourOfAKind {
		t.Errorf("expected Four of a Kind, got %s (score %v)", name, score)
	}
}

func TestFullHouse(t *testing.T) {
	cards := mustFive("HK", "SK", "CK", "HA", "SA")
	score, name := EvaluateFive(cards)
	if score[0] != FullHouse {
		t.Errorf("expected Full House, got %s (score %v)", name, score)
	}
}

func TestFlush(t *testing.T) {
	cards := mustFive("HK", "H9", "H6", "H4", "H2")
	score, name := EvaluateFive(cards)
	if score[0] != Flush {
		t.Errorf("expected Flush, got %s (score %v)", name, score)
	}
}

func TestStraight(t *testing.T) {
	cards := mustFive("HT", "S9", "C8", "D7", "H6")
	score, name := EvaluateFive(cards)
	if score[0] != Straight {
		t.Errorf("expected Straight, got %s (score %v)", name, score)
	}
}

func TestWheelStraight(t *testing.T) {
	// A-2-3-4-5 — the "wheel" — lowest straight
	cards := mustFive("HA", "S2", "C3", "D4", "H5")
	score, name := EvaluateFive(cards)
	if score[0] != Straight {
		t.Errorf("expected Straight (wheel), got %s (score %v)", name, score)
	}
}

func TestThreeOfAKind(t *testing.T) {
	cards := mustFive("HQ", "SQ", "CQ", "HA", "SK")
	score, name := EvaluateFive(cards)
	if score[0] != ThreeOfAKind {
		t.Errorf("expected Three of a Kind, got %s (score %v)", name, score)
	}
}

func TestTwoPair(t *testing.T) {
	cards := mustFive("HA", "SA", "HK", "SK", "HQ")
	score, name := EvaluateFive(cards)
	if score[0] != TwoPair {
		t.Errorf("expected Two Pair, got %s (score %v)", name, score)
	}
}

func TestOnePair(t *testing.T) {
	cards := mustFive("HA", "SA", "HK", "HQ", "HJ")
	score, name := EvaluateFive(cards)
	if score[0] != OnePair {
		t.Errorf("expected One Pair, got %s (score %v)", name, score)
	}
}

func TestHighCard(t *testing.T) {
	cards := mustFive("HA", "SK", "CQ", "DJ", "H9")
	score, name := EvaluateFive(cards)
	if score[0] != HighCard {
		t.Errorf("expected High Card, got %s (score %v)", name, score)
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// Ordering tests: better hands must compare higher
// ─────────────────────────────────────────────────────────────────────────────

func TestStraightFlushBeatsFullHouse(t *testing.T) {
	sf, _ := EvaluateFive(mustFive("C6", "C5", "C4", "C3", "C2"))
	fh, _ := EvaluateFive(mustFive("HK", "SK", "CK", "HA", "SA"))
	if !sf.GreaterThan(fh) {
		t.Error("Straight Flush should beat Full House")
	}
}

func TestFourOfAKindBeatsFullHouse(t *testing.T) {
	foak, _ := EvaluateFive(mustFive("HA", "SA", "CA", "DA", "HK"))
	fh, _   := EvaluateFive(mustFive("HK", "SK", "CK", "HA", "SA"))
	if !foak.GreaterThan(fh) {
		t.Error("Four of a Kind should beat Full House")
	}
}

func TestFlushBeatsStraight(t *testing.T) {
	fl, _ := EvaluateFive(mustFive("HK", "H9", "H6", "H4", "H2"))
	st, _ := EvaluateFive(mustFive("HT", "S9", "C8", "D7", "H6"))
	if !fl.GreaterThan(st) {
		t.Error("Flush should beat Straight")
	}
}

func TestAceHighStraightBeatsKingHigh(t *testing.T) {
	aceHigh,  _ := EvaluateFive(mustFive("HA", "SK", "CQ", "DJ", "HT")) // Broadway
	kingHigh, _ := EvaluateFive(mustFive("HK", "SQ", "CJ", "DT", "H9"))
	if !aceHigh.GreaterThan(kingHigh) {
		t.Error("Ace-high straight should beat king-high straight")
	}
}

func TestWheelLosesToSixHigh(t *testing.T) {
	wheel,   _ := EvaluateFive(mustFive("HA", "S2", "C3", "D4", "H5")) // A-2-3-4-5
	sixHigh, _ := EvaluateFive(mustFive("H6", "S5", "C4", "D3", "H2")) // 2-3-4-5-6
	if !sixHigh.GreaterThan(wheel) {
		t.Error("6-high straight should beat wheel (A-2-3-4-5)")
	}
}

func TestTwoPairTiebreak(t *testing.T) {
	// AA KK vs AA QQ — higher second pair wins
	aaKK, _ := EvaluateFive(mustFive("HA", "SA", "HK", "SK", "HJ"))
	aaQQ, _ := EvaluateFive(mustFive("CA", "DA", "HQ", "SQ", "HJ"))
	if !aaKK.GreaterThan(aaQQ) {
		t.Error("AA KK should beat AA QQ")
	}
}

func TestHighCardTiebreak(t *testing.T) {
	better, _ := EvaluateFive(mustFive("HA", "SK", "CQ", "DJ", "H9"))
	worse,  _ := EvaluateFive(mustFive("HA", "SK", "CQ", "DJ", "H8"))
	if !better.GreaterThan(worse) {
		t.Error("A-K-Q-J-9 should beat A-K-Q-J-8")
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// BestFiveFrom7
// ─────────────────────────────────────────────────────────────────────────────

func TestBestFiveFrom7PicksFlush(t *testing.T) {
	// 7 cards where the best hand is a flush in hearts.
	all := mustCards("HA", "HK", "HQ", "HJ", "H9", "S2", "C3")
	score, _, name := BestFiveFrom7(all)
	if score[0] != Flush {
		t.Errorf("expected Flush from 7 cards, got %s", name)
	}
}

func TestBestFiveFrom7PicksStraight(t *testing.T) {
	all := mustCards("HA", "SK", "CQ", "DJ", "HT", "S2", "C3")
	score, _, name := BestFiveFrom7(all)
	if score[0] != Straight {
		t.Errorf("expected Straight from 7 cards, got %s", name)
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// ParseCard
// ─────────────────────────────────────────────────────────────────────────────

func TestParseCardValid(t *testing.T) {
	cases := []string{"HA", "S7", "CT", "DK", "HJ", "S2"}
	for _, s := range cases {
		if _, err := ParseCard(s); err != nil {
			t.Errorf("ParseCard(%q) unexpected error: %v", s, err)
		}
	}
}

func TestParseCardInvalid(t *testing.T) {
	cases := []string{"", "X7", "H1", "HH", "HAA", "7H"}
	for _, s := range cases {
		if _, err := ParseCard(s); err == nil {
			t.Errorf("ParseCard(%q) expected error, got none", s)
		}
	}
}
