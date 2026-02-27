package poker

import (
	"fmt"
	"math/rand"
	"time"
)

// ─────────────────────────────────────────────────────────────────────────────
// MonteCarloWinProb estimates the win probability for a player holding
// holeCards against (numPlayers-1) opponents, given 0–5 communityCards
// already dealt.
//
// Algorithm per simulation:
//  1. Build the remaining deck (remove known cards).
//  2. Shuffle it.
//  3. Deal the missing community cards.
//  4. Deal 2 hole cards to each opponent.
//  5. Evaluate all players, count wins (ties split equally — we count a tie as
//     a "win" here for simplicity and call the result win % including splits).
// ─────────────────────────────────────────────────────────────────────────────

const MaxSimulations = 100_000

// MonteCarloWinProb returns the estimated win probability in [0, 1] and the
// number of simulations actually executed.
func MonteCarloWinProb(
	hole [2]Card,
	community []Card, // 0, 3, 4, or 5 cards
	numPlayers int,
	simulations int,
) (float64, int, error) {
	// ── Validate ──────────────────────────────────────────────────────────────
	if numPlayers < 2 || numPlayers > 9 {
		return 0, 0, fmt.Errorf("numPlayers must be between 2 and 9, got %d", numPlayers)
	}
	n := len(community)
	if n != 0 && n != 3 && n != 4 && n != 5 {
		return 0, 0, fmt.Errorf("community cards must be 0, 3, 4, or 5; got %d", n)
	}
	if simulations <= 0 {
		return 0, 0, fmt.Errorf("simulations must be positive")
	}
	if simulations > MaxSimulations {
		simulations = MaxSimulations
	}

	// ── Known cards ───────────────────────────────────────────────────────────
	known := append([]Card{hole[0], hole[1]}, community...)
	if err := validateNoDuplicates(known); err != nil {
		return 0, 0, err
	}

	communityNeeded := 5 - n       // how many more community cards to deal
	opponentHoles := numPlayers - 1 // each opponent gets 2 cards
	cardsPerSim := communityNeeded + opponentHoles*2

	deck := RemainingDeck(known) // 52 − len(known) cards
	if len(deck) < cardsPerSim {
		return 0, 0, fmt.Errorf("not enough cards in deck (%d) for %d players and %d community cards needed",
			len(deck), numPlayers, communityNeeded)
	}

	rng := rand.New(rand.NewSource(time.Now().UnixNano()))

	wins := 0
	ties := 0

	for sim := 0; sim < simulations; sim++ {
		// Shuffle remaining deck each iteration.
		d := make([]Card, len(deck))
		copy(d, deck)
		Shuffle(d, rng)

		// Deal missing community cards.
		fullCommunity := make([]Card, 5)
		copy(fullCommunity, community)
		for i := 0; i < communityNeeded; i++ {
			fullCommunity[n+i] = d[i]
		}
		offset := communityNeeded

		// Evaluate our hand.
		var comm5 [5]Card
		copy(comm5[:], fullCommunity)
		ourScore, _, _ := BestFiveFrom7(append([]Card{hole[0], hole[1]}, comm5[:]...))

		// Evaluate each opponent.
		wonThis := true
		tiedThis := false
		for op := 0; op < opponentHoles; op++ {
			oppH1 := d[offset+op*2]
			oppH2 := d[offset+op*2+1]
			oppScore, _, _ := BestFiveFrom7([]Card{oppH1, oppH2,
				comm5[0], comm5[1], comm5[2], comm5[3], comm5[4]})
			if oppScore.GreaterThan(ourScore) {
				wonThis = false
				tiedThis = false
				break
			}
			if oppScore.Equal(ourScore) {
				tiedThis = true
			}
		}

		if wonThis && !tiedThis {
			wins++
		} else if wonThis && tiedThis {
			ties++
		}
	}

	// Win probability: outright wins + half of ties.
	prob := (float64(wins) + float64(ties)*0.5) / float64(simulations)
	return prob, simulations, nil
}
