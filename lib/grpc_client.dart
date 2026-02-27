
import 'package:grpc/grpc_web.dart';
import 'proto/poker.pbgrpc.dart';

class PokerGrpcClient {
  late final PokerEvaluatorClient stub;

  PokerGrpcClient({String baseUrl = 'http://localhost:8080'}) {
    final channel = GrpcWebClientChannel.xhr(Uri.parse(baseUrl));
    stub = PokerEvaluatorClient(channel);
  }

  Future<EvaluateHandResponse> evaluateHand(List<String> hole, List<String> community) async {
    final req = EvaluateHandRequest()
      ..holeCards.addAll(hole)
      ..communityCards.addAll(community);
    return await stub.evaluateHand(req);
  }

  Future<CompareHandsResponse> compareHands(List<String> p1, List<String> p2, List<String> community) async {
    final req = CompareHandsRequest()
      ..player1Hole.addAll(p1)
      ..player2Hole.addAll(p2)
      ..communityCards.addAll(community);
    return await stub.compareHands(req);
  }

  Future<MonteCarloResponse> getProbabilities(List<String> hole, List<String> community, int players, int simulations) async {
    final req = MonteCarloRequest()
      ..holeCards.addAll(hole)
      ..communityCards.addAll(community)
      ..numPlayers = players
      ..simulations = simulations;
    return await stub.monteCarloWinProb(req);
  }
}
