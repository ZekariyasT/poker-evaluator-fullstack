package main

import (
	"context"
	"log"
	"net"
	"net/http"

	"github.com/improbable-eng/grpc-web/go/grpcweb"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/reflection"
	"google.golang.org/grpc/status"

	"texsas/backend/poker"
	pb "texsas/proto"
)

// ─────────────────────────────────────────────────────────────────────────────
// gRPC server implementation
// ─────────────────────────────────────────────────────────────────────────────

type pokerServer struct {
	pb.UnimplementedPokerEvaluatorServer
}

// EvaluateHand — best 5-card hand from 2 hole + 5 community cards.
func (s *pokerServer) EvaluateHand(
	_ context.Context, req *pb.EvaluateHandRequest,
) (*pb.EvaluateHandResponse, error) {
	if len(req.HoleCards) != 2 {
		return nil, status.Errorf(codes.InvalidArgument, "hole_cards must have exactly 2 cards, got %d", len(req.HoleCards))
	}
	if len(req.CommunityCards) != 5 {
		return nil, status.Errorf(codes.InvalidArgument, "community_cards must have exactly 5 cards, got %d", len(req.CommunityCards))
	}

	hole, err := poker.ParseCards(req.HoleCards)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "hole_cards: %v", err)
	}
	comm, err := poker.ParseCards(req.CommunityCards)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "community_cards: %v", err)
	}

	all := append(hole, comm...)
	_, bestFive, handName := poker.BestFiveFrom7(all)

	bestStrings := make([]string, len(bestFive))
	for i, c := range bestFive {
		bestStrings[i] = c.String()
	}
	return &pb.EvaluateHandResponse{
		BestHand: bestStrings,
		HandName: handName,
	}, nil
}

// CompareHands — head-to-head for two players.
func (s *pokerServer) CompareHands(
	_ context.Context, req *pb.CompareHandsRequest,
) (*pb.CompareHandsResponse, error) {
	if len(req.Player1Hole) != 2 {
		return nil, status.Errorf(codes.InvalidArgument, "player1_hole must have exactly 2 cards")
	}
	if len(req.Player2Hole) != 2 {
		return nil, status.Errorf(codes.InvalidArgument, "player2_hole must have exactly 2 cards")
	}
	if len(req.CommunityCards) != 5 {
		return nil, status.Errorf(codes.InvalidArgument, "community_cards must have exactly 5 cards")
	}

	p1Hole, err := poker.ParseCards(req.Player1Hole)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "player1_hole: %v", err)
	}
	p2Hole, err := poker.ParseCards(req.Player2Hole)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "player2_hole: %v", err)
	}
	comm, err := poker.ParseCards(req.CommunityCards)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "community_cards: %v", err)
	}

	var p1H, p2H [2]poker.Card
	var c5 [5]poker.Card
	copy(p1H[:], p1Hole)
	copy(p2H[:], p2Hole)
	copy(c5[:], comm)

	r1, r2, winner, err := poker.CompareTwo(p1H, p2H, c5)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "%v", err)
	}

	toStrings := func(cards []poker.Card) []string {
		ss := make([]string, len(cards))
		for i, c := range cards {
			ss[i] = c.String()
		}
		return ss
	}

	return &pb.CompareHandsResponse{
		Player1BestHand: toStrings(r1.BestFive),
		Player1HandName: r1.HandName,
		Player2BestHand: toStrings(r2.BestFive),
		Player2HandName: r2.HandName,
		Winner:          winner,
	}, nil
}

// MonteCarloWinProb — Monte Carlo simulation.
func (s *pokerServer) MonteCarloWinProb(
	_ context.Context, req *pb.MonteCarloRequest,
) (*pb.MonteCarloResponse, error) {
	if len(req.HoleCards) != 2 {
		return nil, status.Errorf(codes.InvalidArgument, "hole_cards must have exactly 2 cards")
	}
	n := len(req.CommunityCards)
	if n != 0 && n != 3 && n != 4 && n != 5 {
		return nil, status.Errorf(codes.InvalidArgument, "community_cards must be 0, 3, 4, or 5 cards, got %d", n)
	}

	hole, err := poker.ParseCards(req.HoleCards)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "hole_cards: %v", err)
	}
	comm, err := poker.ParseCards(req.CommunityCards)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "community_cards: %v", err)
	}

	var h2 [2]poker.Card
	copy(h2[:], hole)

	prob, simsRun, err := poker.MonteCarloWinProb(h2, comm, int(req.NumPlayers), int(req.Simulations))
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "%v", err)
	}

	return &pb.MonteCarloResponse{
		WinProbability: prob,
		SimulationsRun: int32(simsRun),
	}, nil
}

// ─────────────────────────────────────────────────────────────────────────────
// main
// ─────────────────────────────────────────────────────────────────────────────

func main() {
	grpcServer := grpc.NewServer()
	pb.RegisterPokerEvaluatorServer(grpcServer, &pokerServer{})
	reflection.Register(grpcServer)

	lis, err := net.Listen("tcp", ":9090")
	if err != nil {
		log.Fatalf("failed to listen on :9090: %v", err)
	}
	go func() {
		log.Println("native gRPC listening on :9090")
		if err := grpcServer.Serve(lis); err != nil {
			log.Fatalf("gRPC server error: %v", err)
		}
	}()

	// gRPC-Web wrapper — browsers use XMLHttpRequest (HTTP/1.1), not HTTP/2.
	wrappedGrpc := grpcweb.WrapServer(
		grpcServer,
		grpcweb.WithOriginFunc(func(origin string) bool { return true }),
	)

	httpServer := &http.Server{
		Addr: ":8080",
		Handler: http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			if wrappedGrpc.IsGrpcWebRequest(r) || wrappedGrpc.IsAcceptableGrpcCorsRequest(r) {
				wrappedGrpc.ServeHTTP(w, r)
				return
			}
			http.NotFound(w, r)
		}),
	}

	log.Println("gRPC-Web listening on :8080")
	if err := httpServer.ListenAndServe(); err != nil {
		log.Fatalf("HTTP server error: %v", err)
	}
}
