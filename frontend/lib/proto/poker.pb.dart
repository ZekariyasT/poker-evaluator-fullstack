// This is a generated file - do not edit.
//
// Generated from poker.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class EvaluateHandRequest extends $pb.GeneratedMessage {
  factory EvaluateHandRequest({
    $core.Iterable<$core.String>? holeCards,
    $core.Iterable<$core.String>? communityCards,
  }) {
    final result = create();
    if (holeCards != null) result.holeCards.addAll(holeCards);
    if (communityCards != null) result.communityCards.addAll(communityCards);
    return result;
  }

  EvaluateHandRequest._();

  factory EvaluateHandRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EvaluateHandRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvaluateHandRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'poker'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'holeCards')
    ..pPS(2, _omitFieldNames ? '' : 'communityCards')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateHandRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateHandRequest copyWith(void Function(EvaluateHandRequest) updates) =>
      super.copyWith((message) => updates(message as EvaluateHandRequest))
          as EvaluateHandRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EvaluateHandRequest create() => EvaluateHandRequest._();
  @$core.override
  EvaluateHandRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EvaluateHandRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvaluateHandRequest>(create);
  static EvaluateHandRequest? _defaultInstance;

  /// Exactly 2 hole cards for the player.
  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get holeCards => $_getList(0);

  /// Exactly 5 community cards.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get communityCards => $_getList(1);
}

class EvaluateHandResponse extends $pb.GeneratedMessage {
  factory EvaluateHandResponse({
    $core.Iterable<$core.String>? bestHand,
    $core.String? handName,
  }) {
    final result = create();
    if (bestHand != null) result.bestHand.addAll(bestHand);
    if (handName != null) result.handName = handName;
    return result;
  }

  EvaluateHandResponse._();

  factory EvaluateHandResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EvaluateHandResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvaluateHandResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'poker'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'bestHand')
    ..aOS(2, _omitFieldNames ? '' : 'handName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateHandResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateHandResponse copyWith(void Function(EvaluateHandResponse) updates) =>
      super.copyWith((message) => updates(message as EvaluateHandResponse))
          as EvaluateHandResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EvaluateHandResponse create() => EvaluateHandResponse._();
  @$core.override
  EvaluateHandResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EvaluateHandResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvaluateHandResponse>(create);
  static EvaluateHandResponse? _defaultInstance;

  /// The best 5-card hand picked from hole + community.
  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get bestHand => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get handName => $_getSZ(1);
  @$pb.TagNumber(2)
  set handName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHandName() => $_has(1);
  @$pb.TagNumber(2)
  void clearHandName() => $_clearField(2);
}

class CompareHandsRequest extends $pb.GeneratedMessage {
  factory CompareHandsRequest({
    $core.Iterable<$core.String>? player1Hole,
    $core.Iterable<$core.String>? player2Hole,
    $core.Iterable<$core.String>? communityCards,
  }) {
    final result = create();
    if (player1Hole != null) result.player1Hole.addAll(player1Hole);
    if (player2Hole != null) result.player2Hole.addAll(player2Hole);
    if (communityCards != null) result.communityCards.addAll(communityCards);
    return result;
  }

  CompareHandsRequest._();

  factory CompareHandsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompareHandsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompareHandsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'poker'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'player1Hole')
    ..pPS(2, _omitFieldNames ? '' : 'player2Hole')
    ..pPS(3, _omitFieldNames ? '' : 'communityCards')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareHandsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareHandsRequest copyWith(void Function(CompareHandsRequest) updates) =>
      super.copyWith((message) => updates(message as CompareHandsRequest))
          as CompareHandsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompareHandsRequest create() => CompareHandsRequest._();
  @$core.override
  CompareHandsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompareHandsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompareHandsRequest>(create);
  static CompareHandsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get player1Hole => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get player2Hole => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get communityCards => $_getList(2);
}

class CompareHandsResponse extends $pb.GeneratedMessage {
  factory CompareHandsResponse({
    $core.Iterable<$core.String>? player1BestHand,
    $core.String? player1HandName,
    $core.Iterable<$core.String>? player2BestHand,
    $core.String? player2HandName,
    $core.String? winner,
  }) {
    final result = create();
    if (player1BestHand != null) result.player1BestHand.addAll(player1BestHand);
    if (player1HandName != null) result.player1HandName = player1HandName;
    if (player2BestHand != null) result.player2BestHand.addAll(player2BestHand);
    if (player2HandName != null) result.player2HandName = player2HandName;
    if (winner != null) result.winner = winner;
    return result;
  }

  CompareHandsResponse._();

  factory CompareHandsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompareHandsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompareHandsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'poker'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'player1BestHand')
    ..aOS(2, _omitFieldNames ? '' : 'player1HandName')
    ..pPS(3, _omitFieldNames ? '' : 'player2BestHand')
    ..aOS(4, _omitFieldNames ? '' : 'player2HandName')
    ..aOS(5, _omitFieldNames ? '' : 'winner')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareHandsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareHandsResponse copyWith(void Function(CompareHandsResponse) updates) =>
      super.copyWith((message) => updates(message as CompareHandsResponse))
          as CompareHandsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompareHandsResponse create() => CompareHandsResponse._();
  @$core.override
  CompareHandsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompareHandsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompareHandsResponse>(create);
  static CompareHandsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get player1BestHand => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get player1HandName => $_getSZ(1);
  @$pb.TagNumber(2)
  set player1HandName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlayer1HandName() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayer1HandName() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get player2BestHand => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get player2HandName => $_getSZ(3);
  @$pb.TagNumber(4)
  set player2HandName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPlayer2HandName() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlayer2HandName() => $_clearField(4);

  /// "Player 1", "Player 2", or "Tie"
  @$pb.TagNumber(5)
  $core.String get winner => $_getSZ(4);
  @$pb.TagNumber(5)
  set winner($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWinner() => $_has(4);
  @$pb.TagNumber(5)
  void clearWinner() => $_clearField(5);
}

class MonteCarloRequest extends $pb.GeneratedMessage {
  factory MonteCarloRequest({
    $core.Iterable<$core.String>? holeCards,
    $core.Iterable<$core.String>? communityCards,
    $core.int? numPlayers,
    $core.int? simulations,
  }) {
    final result = create();
    if (holeCards != null) result.holeCards.addAll(holeCards);
    if (communityCards != null) result.communityCards.addAll(communityCards);
    if (numPlayers != null) result.numPlayers = numPlayers;
    if (simulations != null) result.simulations = simulations;
    return result;
  }

  MonteCarloRequest._();

  factory MonteCarloRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MonteCarloRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MonteCarloRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'poker'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'holeCards')
    ..pPS(2, _omitFieldNames ? '' : 'communityCards')
    ..aI(3, _omitFieldNames ? '' : 'numPlayers')
    ..aI(4, _omitFieldNames ? '' : 'simulations')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MonteCarloRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MonteCarloRequest copyWith(void Function(MonteCarloRequest) updates) =>
      super.copyWith((message) => updates(message as MonteCarloRequest))
          as MonteCarloRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MonteCarloRequest create() => MonteCarloRequest._();
  @$core.override
  MonteCarloRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MonteCarloRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MonteCarloRequest>(create);
  static MonteCarloRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get holeCards => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get communityCards => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get numPlayers => $_getIZ(2);
  @$pb.TagNumber(3)
  set numPlayers($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNumPlayers() => $_has(2);
  @$pb.TagNumber(3)
  void clearNumPlayers() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get simulations => $_getIZ(3);
  @$pb.TagNumber(4)
  set simulations($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSimulations() => $_has(3);
  @$pb.TagNumber(4)
  void clearSimulations() => $_clearField(4);
}

class MonteCarloResponse extends $pb.GeneratedMessage {
  factory MonteCarloResponse({
    $core.double? winProbability,
    $core.int? simulationsRun,
  }) {
    final result = create();
    if (winProbability != null) result.winProbability = winProbability;
    if (simulationsRun != null) result.simulationsRun = simulationsRun;
    return result;
  }

  MonteCarloResponse._();

  factory MonteCarloResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MonteCarloResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MonteCarloResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'poker'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'winProbability')
    ..aI(2, _omitFieldNames ? '' : 'simulationsRun')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MonteCarloResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MonteCarloResponse copyWith(void Function(MonteCarloResponse) updates) =>
      super.copyWith((message) => updates(message as MonteCarloResponse))
          as MonteCarloResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MonteCarloResponse create() => MonteCarloResponse._();
  @$core.override
  MonteCarloResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MonteCarloResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MonteCarloResponse>(create);
  static MonteCarloResponse? _defaultInstance;

  /// Win probability in the range [0, 1].
  @$pb.TagNumber(1)
  $core.double get winProbability => $_getN(0);
  @$pb.TagNumber(1)
  set winProbability($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWinProbability() => $_has(0);
  @$pb.TagNumber(1)
  void clearWinProbability() => $_clearField(1);

  /// Number of simulations that were actually run (may be capped).
  @$pb.TagNumber(2)
  $core.int get simulationsRun => $_getIZ(1);
  @$pb.TagNumber(2)
  set simulationsRun($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSimulationsRun() => $_has(1);
  @$pb.TagNumber(2)
  void clearSimulationsRun() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
