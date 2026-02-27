package poker

import (
	"testing"
)

// community5 builds a [5]Card from strings (test helper).
func community5(ss ...string) [5]Card {
	cards := mustCards(ss...)
	var c [5]Card
	copy(c[:], cards)
	return c
}

func hole2(s1, s2 string) [2]Card {
	cards := mustCards(s1, s2)
	return [2]Card{cards[0], cards[1]}
}

// ─────────────────────────────────────────────────────────────────────────────
// CompareTwo tests
// ─────────────────────────────────────────────────────────────────────────────

func TestP1WinsFlushVsPair(t *testing.T) {
	// P1 has a flush in hearts; P2 has one pair of aces.
	p1   := hole2("HA", "HK")
	p2   := hole2("SA", "CA")
	comm := community5("HQ", "H9", "H4", "D3", "C7")

	_, _, winner, err := CompareTwo(p1, p2, comm)
	if err != nil {
		t.Fatal(err)
	}
	if winner != "Player 1" {
		t.Errorf("expected Player 1 to win (flush vs pair), got %q", winner)
	}
}

func TestP2WinsThreeOfAKindVsTwoPair(t *testing.T) {
	// P2 gets three of a kind; P1 only gets two pair.
	p1   := hole2("HK", "HQ")   // KK QQ from community → two pair
	p2   := hole2("SA", "CA")   // AAA → three of a kind
	comm := community5("DA", "HK", "CQ", "D2", "H3")

	_, _, winner, err := CompareTwo(p1, p2, comm)
	if err != nil {
		t.Fatal(err)
	}
	if winner != "Player 2" {
		t.Errorf("expected Player 2 to win (trips vs two pair), got %q", winner)
	}
}

func TestTieIdenticalCommunity(t *testing.T) {
	// Both players' best hand is entirely in the community (royal flush on board).
	comm := community5("HA", "HK", "HQ", "HJ", "HT")
	p1   := hole2("S2", "C3")
	p2   := hole2("D4", "S5")

	_, _, winner, err := CompareTwo(p1, p2, comm)
	if err != nil {
		t.Fatal(err)
	}
	if winner != "Tie" {
		t.Errorf("expected Tie (royal flush on board), got %q", winner)
	}
}

func TestAceHighStraightBeatsKingHighCompare(t *testing.T) {
	// P1: A-K-Q-J-T straight; P2: K-Q-J-T-9.
	p1   := hole2("HA", "HK")
	p2   := hole2("S9", "C9") // pair of 9s — not a straight
	comm := community5("SQ", "DJ", "CT", "H2", "D3")
	// P1 has A-K-Q-J-T straight; P2 has a pair of 9s.

	_, _, winner, err := CompareTwo(p1, p2, comm)
	if err != nil {
		t.Fatal(err)
	}
	if winner != "Player 1" {
		t.Errorf("expected Player 1 to win (straight vs pair), got %q", winner)
	}
}

func TestDuplicateCardError(t *testing.T) {
	p1   := hole2("HA", "HK")
	p2   := hole2("HA", "SK") // HA is duplicated
	comm := community5("SQ", "DJ", "CT", "H2", "D3")

	_, _, _, err := CompareTwo(p1, p2, comm)
	if err == nil {
		t.Error("expected error for duplicate card, got none")
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// EvaluatePlayer tests
// ─────────────────────────────────────────────────────────────────────────────

func TestEvaluatePlayerBestHandIsFourOfAKind(t *testing.T) {
	h    := hole2("HA", "SA")
	comm := community5("CA", "DA", "HK", "H2", "H3")
	r := EvaluatePlayer(h, comm)
	if r.Score[0] != FourOfAKind {
		t.Errorf("expected Four of a Kind, got %s", r.HandName)
	}
}

func TestEvaluatePlayerBestHandIsStraightFlush(t *testing.T) {
	h    := hole2("H9", "H8")
	comm := community5("H7", "H6", "H5", "DA", "SK")
	r := EvaluatePlayer(h, comm)
	if r.Score[0] != StraightFlush {
		t.Errorf("expected Straight Flush, got %s", r.HandName)
	}
}
