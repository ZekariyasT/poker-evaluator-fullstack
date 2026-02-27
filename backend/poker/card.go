package poker

import (
	"fmt"
	"math/rand"
	"sort"
	"strings"
)

// ─────────────────────────────────────────────────────────────────────────────
// Card
// ─────────────────────────────────────────────────────────────────────────────

// Rank constants (index 0=2, 1=3, … 8=T, 9=J, 10=Q, 11=K, 12=A).
const ranks = "23456789TJQKA"

// Suit constants.
const suits = "HSCD"

// Card represents a playing card.
type Card struct {
	Suit byte // 'H', 'S', 'C', or 'D'
	Rank byte // '2'-'9', 'T', 'J', 'Q', 'K', 'A'
}

// String returns the canonical 2-char form (suit first).
func (c Card) String() string {
	return string([]byte{c.Suit, c.Rank})
}

// RankIndex returns 0 for '2' through 12 for 'A'.
func RankIndex(r byte) int {
	return strings.IndexByte(ranks, r)
}

// ParseCard parses a 2-character card string like "HA" or "S7".
// Suit is the first character (H/S/C/D), rank is the second (A/2-9/T/J/Q/K).
func ParseCard(s string) (Card, error) {
	if len(s) != 2 {
		return Card{}, fmt.Errorf("invalid card %q: must be exactly 2 characters", s)
	}
	suit := s[0]
	rank := s[1]
	if !strings.ContainsRune(suits, rune(suit)) {
		return Card{}, fmt.Errorf("invalid suit %q in card %q: must be H, S, C, or D", string(suit), s)
	}
	if RankIndex(rank) < 0 {
		return Card{}, fmt.Errorf("invalid rank %q in card %q: must be 2-9, T, J, Q, K, or A", string(rank), s)
	}
	return Card{Suit: suit, Rank: rank}, nil
}

// ParseCards parses a slice of card strings.
func ParseCards(ss []string) ([]Card, error) {
	cards := make([]Card, 0, len(ss))
	seen := map[string]bool{}
	for _, s := range ss {
		s = strings.ToUpper(strings.TrimSpace(s))
		if seen[s] {
			return nil, fmt.Errorf("duplicate card %q", s)
		}
		seen[s] = true
		c, err := ParseCard(s)
		if err != nil {
			return nil, err
		}
		cards = append(cards, c)
	}
	return cards, nil
}

// ─────────────────────────────────────────────────────────────────────────────
// Deck
// ─────────────────────────────────────────────────────────────────────────────

// NewDeck returns all 52 cards in a deterministic order.
func NewDeck() []Card {
	deck := make([]Card, 0, 52)
	for _, s := range suits {
		for _, r := range ranks {
			deck = append(deck, Card{Suit: byte(s), Rank: byte(r)})
		}
	}
	return deck
}

// RemainingDeck returns all 52 cards minus the ones already in use.
func RemainingDeck(used []Card) []Card {
	usedSet := make(map[Card]bool, len(used))
	for _, c := range used {
		usedSet[c] = true
	}
	deck := NewDeck()
	remaining := deck[:0]
	for _, c := range deck {
		if !usedSet[c] {
			remaining = append(remaining, c)
		}
	}
	return remaining
}

// Shuffle randomises a slice of cards in-place using the provided rng.
func Shuffle(cards []Card, rng *rand.Rand) {
	rng.Shuffle(len(cards), func(i, j int) {
		cards[i], cards[j] = cards[j], cards[i]
	})
}

// ─────────────────────────────────────────────────────────────────────────────
// Combinations helper
// ─────────────────────────────────────────────────────────────────────────────

// Combinations yields all k-element subsets of src.
func Combinations(src []Card, k int) [][]Card {
	n := len(src)
	if k > n {
		return nil
	}
	result := [][]Card{}
	combo := make([]int, k)
	for i := range combo {
		combo[i] = i
	}
	for {
		// Collect current combination.
		c := make([]Card, k)
		for i, idx := range combo {
			c[i] = src[idx]
		}
		result = append(result, c)

		// Advance.
		i := k - 1
		for i >= 0 && combo[i] == i+n-k {
			i--
		}
		if i < 0 {
			break
		}
		combo[i]++
		for j := i + 1; j < k; j++ {
			combo[j] = combo[j-1] + 1
		}
	}
	return result
}

// ─────────────────────────────────────────────────────────────────────────────
// Sort helpers
// ─────────────────────────────────────────────────────────────────────────────

// SortByRankDesc sorts cards in descending rank order (highest first).
func SortByRankDesc(cards []Card) []Card {
	out := make([]Card, len(cards))
	copy(out, cards)
	sort.Slice(out, func(i, j int) bool {
		return RankIndex(out[i].Rank) > RankIndex(out[j].Rank)
	})
	return out
}
