package poker

import (
	"sort"
)

// ─────────────────────────────────────────────────────────────────────────────
// Hand categories (0 = lowest, 9 = highest)
// ─────────────────────────────────────────────────────────────────────────────

const (
	HighCard     = 0
	OnePair      = 1
	TwoPair      = 2
	ThreeOfAKind = 3
	Straight     = 4
	Flush        = 5
	FullHouse    = 6
	FourOfAKind  = 7
	StraightFlush = 8
	RoyalFlush   = 9
)

var handNames = [10]string{
	"High Card",
	"One Pair",
	"Two Pair",
	"Three of a Kind",
	"Straight",
	"Flush",
	"Full House",
	"Four of a Kind",
	"Straight Flush",
	"Royal Flush",
}

// ─────────────────────────────────────────────────────────────────────────────
// Score — a comparable 6-element array.
// score[0] = hand category (0–9)
// score[1..5] = tiebreaker ranks (descending importance)
//
// Norvig's key insight: sort groups by (count desc, rank desc), then flatten
// the ranks. This automatically handles all tiebreak cases.
// ─────────────────────────────────────────────────────────────────────────────

type Score [6]int

// Higher score wins.
func (a Score) GreaterThan(b Score) bool {
	for i := range a {
		if a[i] != b[i] {
			return a[i] > b[i]
		}
	}
	return false
}

func (a Score) Equal(b Score) bool {
	return a == b
}

// ─────────────────────────────────────────────────────────────────────────────
// EvaluateFive evaluates exactly 5 cards and returns a Score + hand name.
// ─────────────────────────────────────────────────────────────────────────────

func EvaluateFive(cards []Card) (Score, string) {
	if len(cards) != 5 {
		panic("EvaluateFive requires exactly 5 cards")
	}

	// ── Rank indices for each card ────────────────────────────────────────────
	idxs := make([]int, 5)
	for i, c := range cards {
		idxs[i] = RankIndex(c.Rank)
	}

	// ── Count occurrences of each rank ────────────────────────────────────────
	rankCount := [13]int{}
	for _, i := range idxs {
		rankCount[i]++
	}

	// ── Build groups: (count, rank) pairs, sorted by count desc, rank desc ────
	type group struct{ count, rank int }
	groups := make([]group, 0, 5)
	for rank, count := range rankCount {
		if count > 0 {
			groups = append(groups, group{count, rank})
		}
	}
	sort.Slice(groups, func(i, j int) bool {
		if groups[i].count != groups[j].count {
			return groups[i].count > groups[j].count
		}
		return groups[i].rank > groups[j].rank
	})

	// ── Tiebreaker ranks in group order ───────────────────────────────────────
	tbRanks := make([]int, 0, 5)
	for _, g := range groups {
		for k := 0; k < g.count; k++ {
			tbRanks = append(tbRanks, g.rank)
		}
	}

	// ── Flush detection ───────────────────────────────────────────────────────
	isFlush := cards[0].Suit == cards[1].Suit &&
		cards[1].Suit == cards[2].Suit &&
		cards[2].Suit == cards[3].Suit &&
		cards[3].Suit == cards[4].Suit

	// ── Straight detection ────────────────────────────────────────────────────
	sorted := make([]int, len(idxs))
	copy(sorted, idxs)
	sort.Sort(sort.Reverse(sort.IntSlice(sorted)))

	isStraight := false
	// Normal straight: five consecutive ranks.
	if sorted[0]-sorted[4] == 4 && len(uniqueInts(sorted)) == 5 {
		isStraight = true
	}
	// Wheel: A-2-3-4-5 (ace plays low: indices 12,0,1,2,3 → sorted 12,3,2,1,0)
	isWheel := sorted[0] == 12 && sorted[1] == 3 && sorted[2] == 2 &&
		sorted[3] == 1 && sorted[4] == 0

	if isWheel {
		isStraight = true
		// In a wheel the 5 is the high card for tiebreak purposes.
		tbRanks = []int{3, 2, 1, 0, 12} // 5-4-3-2-A
	}

	// ── Determine category ────────────────────────────────────────────────────
	counts := []int{groups[0].count}
	if len(groups) > 1 {
		counts = append(counts, groups[1].count)
	}

	var category int
	switch {
	case isStraight && isFlush && sorted[0] == 12 && !isWheel:
		category = RoyalFlush
	case isStraight && isFlush:
		category = StraightFlush
	case counts[0] == 4:
		category = FourOfAKind
	case counts[0] == 3 && len(counts) > 1 && counts[1] == 2:
		category = FullHouse
	case isFlush:
		category = Flush
	case isStraight:
		category = Straight
	case counts[0] == 3:
		category = ThreeOfAKind
	case counts[0] == 2 && len(counts) > 1 && counts[1] == 2:
		category = TwoPair
	case counts[0] == 2:
		category = OnePair
	default:
		category = HighCard
	}

	// ── Build score ───────────────────────────────────────────────────────────
	var score Score
	score[0] = category
	for i := 1; i < 6 && i-1 < len(tbRanks); i++ {
		score[i] = tbRanks[i-1]
	}

	return score, handNames[category]
}

// ─────────────────────────────────────────────────────────────────────────────
// BestFiveFrom7 — choose the best 5-card hand from 7 cards (C(7,5)=21 combos).
// Returns (best score, best 5 cards, hand name).
// ─────────────────────────────────────────────────────────────────────────────

func BestFiveFrom7(all []Card) (Score, []Card, string) {
	combos := Combinations(all, 5)
	var bestScore Score
	var bestFive []Card
	var bestName string
	for i, combo := range combos {
		s, name := EvaluateFive(combo)
		if i == 0 || s.GreaterThan(bestScore) {
			bestScore = s
			bestFive = combo
			bestName = name
		}
	}
	return bestScore, bestFive, bestName
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper
// ─────────────────────────────────────────────────────────────────────────────

func uniqueInts(s []int) []int {
	seen := map[int]bool{}
	out := []int{}
	for _, v := range s {
		if !seen[v] {
			seen[v] = true
			out = append(out, v)
		}
	}
	return out
}
