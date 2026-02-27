package poker

import (
	"fmt"
)

// ─────────────────────────────────────────────────────────────────────────────
// CompareResult holds one player's evaluated best hand.
// ─────────────────────────────────────────────────────────────────────────────

type CompareResult struct {
	Score    Score
	BestFive []Card
	HandName string
}

// ─────────────────────────────────────────────────────────────────────────────
// EvaluatePlayer evaluates the best 5-card hand for a player given 2 hole
// cards and 5 community cards (7 total).
// ─────────────────────────────────────────────────────────────────────────────

func EvaluatePlayer(hole [2]Card, community [5]Card) CompareResult {
	all := make([]Card, 0, 7)
	all = append(all, hole[0], hole[1])
	all = append(all, community[:]...)
	score, best, name := BestFiveFrom7(all)
	return CompareResult{Score: score, BestFive: best, HandName: name}
}

// ─────────────────────────────────────────────────────────────────────────────
// CompareTwo runs head-to-head for two players.
// Returns (p1 result, p2 result, winner string: "Player 1"/"Player 2"/"Tie")
// ─────────────────────────────────────────────────────────────────────────────

func CompareTwo(
	p1Hole [2]Card, p2Hole [2]Card, community [5]Card,
) (CompareResult, CompareResult, string, error) {
	// Validate no duplicate cards.
	all := []Card{
		p1Hole[0], p1Hole[1],
		p2Hole[0], p2Hole[1],
		community[0], community[1], community[2], community[3], community[4],
	}
	if err := validateNoDuplicates(all); err != nil {
		return CompareResult{}, CompareResult{}, "", err
	}

	r1 := EvaluatePlayer(p1Hole, community)
	r2 := EvaluatePlayer(p2Hole, community)

	var winner string
	switch {
	case r1.Score.GreaterThan(r2.Score):
		winner = "Player 1"
	case r2.Score.GreaterThan(r1.Score):
		winner = "Player 2"
	default:
		winner = "Tie"
	}

	return r1, r2, winner, nil
}

// ─────────────────────────────────────────────────────────────────────────────
// validateNoDuplicates checks all cards are distinct.
// ─────────────────────────────────────────────────────────────────────────────

func validateNoDuplicates(cards []Card) error {
	seen := map[Card]bool{}
	for _, c := range cards {
		if seen[c] {
			return fmt.Errorf("duplicate card: %s", c)
		}
		seen[c] = true
	}
	return nil
}
