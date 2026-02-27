// This is a generated file - do not edit.
//
// Generated from poker.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'poker.pb.dart' as $0;

export 'poker.pb.dart';

@$pb.GrpcServiceName('poker.PokerEvaluator')
class PokerEvaluatorClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  PokerEvaluatorClient(super.channel, {super.options, super.interceptors});

  /// Given 2 hole cards + 5 community cards, return the best 5-card hand.
  $grpc.ResponseFuture<$0.EvaluateHandResponse> evaluateHand(
    $0.EvaluateHandRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$evaluateHand, request, options: options);
  }

  /// Given 2 players (each with 2 hole cards) + 5 community cards, declare winner.
  $grpc.ResponseFuture<$0.CompareHandsResponse> compareHands(
    $0.CompareHandsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$compareHands, request, options: options);
  }

  /// Monte Carlo win-probability for 2 hole cards + 0–5 community cards.
  $grpc.ResponseFuture<$0.MonteCarloResponse> monteCarloWinProb(
    $0.MonteCarloRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$monteCarloWinProb, request, options: options);
  }

  // method descriptors

  static final _$evaluateHand =
      $grpc.ClientMethod<$0.EvaluateHandRequest, $0.EvaluateHandResponse>(
          '/poker.PokerEvaluator/EvaluateHand',
          ($0.EvaluateHandRequest value) => value.writeToBuffer(),
          $0.EvaluateHandResponse.fromBuffer);
  static final _$compareHands =
      $grpc.ClientMethod<$0.CompareHandsRequest, $0.CompareHandsResponse>(
          '/poker.PokerEvaluator/CompareHands',
          ($0.CompareHandsRequest value) => value.writeToBuffer(),
          $0.CompareHandsResponse.fromBuffer);
  static final _$monteCarloWinProb =
      $grpc.ClientMethod<$0.MonteCarloRequest, $0.MonteCarloResponse>(
          '/poker.PokerEvaluator/MonteCarloWinProb',
          ($0.MonteCarloRequest value) => value.writeToBuffer(),
          $0.MonteCarloResponse.fromBuffer);
}

@$pb.GrpcServiceName('poker.PokerEvaluator')
abstract class PokerEvaluatorServiceBase extends $grpc.Service {
  $core.String get $name => 'poker.PokerEvaluator';

  PokerEvaluatorServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.EvaluateHandRequest, $0.EvaluateHandResponse>(
            'EvaluateHand',
            evaluateHand_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.EvaluateHandRequest.fromBuffer(value),
            ($0.EvaluateHandResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CompareHandsRequest, $0.CompareHandsResponse>(
            'CompareHands',
            compareHands_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CompareHandsRequest.fromBuffer(value),
            ($0.CompareHandsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MonteCarloRequest, $0.MonteCarloResponse>(
        'MonteCarloWinProb',
        monteCarloWinProb_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MonteCarloRequest.fromBuffer(value),
        ($0.MonteCarloResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.EvaluateHandResponse> evaluateHand_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.EvaluateHandRequest> $request) async {
    return evaluateHand($call, await $request);
  }

  $async.Future<$0.EvaluateHandResponse> evaluateHand(
      $grpc.ServiceCall call, $0.EvaluateHandRequest request);

  $async.Future<$0.CompareHandsResponse> compareHands_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CompareHandsRequest> $request) async {
    return compareHands($call, await $request);
  }

  $async.Future<$0.CompareHandsResponse> compareHands(
      $grpc.ServiceCall call, $0.CompareHandsRequest request);

  $async.Future<$0.MonteCarloResponse> monteCarloWinProb_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MonteCarloRequest> $request) async {
    return monteCarloWinProb($call, await $request);
  }

  $async.Future<$0.MonteCarloResponse> monteCarloWinProb(
      $grpc.ServiceCall call, $0.MonteCarloRequest request);
}
