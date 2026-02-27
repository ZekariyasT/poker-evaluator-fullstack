// This is a generated file - do not edit.
//
// Generated from poker.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use evaluateHandRequestDescriptor instead')
const EvaluateHandRequest$json = {
  '1': 'EvaluateHandRequest',
  '2': [
    {'1': 'hole_cards', '3': 1, '4': 3, '5': 9, '10': 'holeCards'},
    {'1': 'community_cards', '3': 2, '4': 3, '5': 9, '10': 'communityCards'},
  ],
};

/// Descriptor for `EvaluateHandRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evaluateHandRequestDescriptor = $convert.base64Decode(
    'ChNFdmFsdWF0ZUhhbmRSZXF1ZXN0Eh0KCmhvbGVfY2FyZHMYASADKAlSCWhvbGVDYXJkcxInCg'
    '9jb21tdW5pdHlfY2FyZHMYAiADKAlSDmNvbW11bml0eUNhcmRz');

@$core.Deprecated('Use evaluateHandResponseDescriptor instead')
const EvaluateHandResponse$json = {
  '1': 'EvaluateHandResponse',
  '2': [
    {'1': 'best_hand', '3': 1, '4': 3, '5': 9, '10': 'bestHand'},
    {'1': 'hand_name', '3': 2, '4': 1, '5': 9, '10': 'handName'},
  ],
};

/// Descriptor for `EvaluateHandResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evaluateHandResponseDescriptor = $convert.base64Decode(
    'ChRFdmFsdWF0ZUhhbmRSZXNwb25zZRIbCgliZXN0X2hhbmQYASADKAlSCGJlc3RIYW5kEhsKCW'
    'hhbmRfbmFtZRgCIAEoCVIIaGFuZE5hbWU=');

@$core.Deprecated('Use compareHandsRequestDescriptor instead')
const CompareHandsRequest$json = {
  '1': 'CompareHandsRequest',
  '2': [
    {'1': 'player1_hole', '3': 1, '4': 3, '5': 9, '10': 'player1Hole'},
    {'1': 'player2_hole', '3': 2, '4': 3, '5': 9, '10': 'player2Hole'},
    {'1': 'community_cards', '3': 3, '4': 3, '5': 9, '10': 'communityCards'},
  ],
};

/// Descriptor for `CompareHandsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compareHandsRequestDescriptor = $convert.base64Decode(
    'ChNDb21wYXJlSGFuZHNSZXF1ZXN0EiEKDHBsYXllcjFfaG9sZRgBIAMoCVILcGxheWVyMUhvbG'
    'USIQoMcGxheWVyMl9ob2xlGAIgAygJUgtwbGF5ZXIySG9sZRInCg9jb21tdW5pdHlfY2FyZHMY'
    'AyADKAlSDmNvbW11bml0eUNhcmRz');

@$core.Deprecated('Use compareHandsResponseDescriptor instead')
const CompareHandsResponse$json = {
  '1': 'CompareHandsResponse',
  '2': [
    {'1': 'player1_best_hand', '3': 1, '4': 3, '5': 9, '10': 'player1BestHand'},
    {'1': 'player1_hand_name', '3': 2, '4': 1, '5': 9, '10': 'player1HandName'},
    {'1': 'player2_best_hand', '3': 3, '4': 3, '5': 9, '10': 'player2BestHand'},
    {'1': 'player2_hand_name', '3': 4, '4': 1, '5': 9, '10': 'player2HandName'},
    {'1': 'winner', '3': 5, '4': 1, '5': 9, '10': 'winner'},
  ],
};

/// Descriptor for `CompareHandsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compareHandsResponseDescriptor = $convert.base64Decode(
    'ChRDb21wYXJlSGFuZHNSZXNwb25zZRIqChFwbGF5ZXIxX2Jlc3RfaGFuZBgBIAMoCVIPcGxheW'
    'VyMUJlc3RIYW5kEioKEXBsYXllcjFfaGFuZF9uYW1lGAIgASgJUg9wbGF5ZXIxSGFuZE5hbWUS'
    'KgoRcGxheWVyMl9iZXN0X2hhbmQYAyADKAlSD3BsYXllcjJCZXN0SGFuZBIqChFwbGF5ZXIyX2'
    'hhbmRfbmFtZRgEIAEoCVIPcGxheWVyMkhhbmROYW1lEhYKBndpbm5lchgFIAEoCVIGd2lubmVy');

@$core.Deprecated('Use monteCarloRequestDescriptor instead')
const MonteCarloRequest$json = {
  '1': 'MonteCarloRequest',
  '2': [
    {'1': 'hole_cards', '3': 1, '4': 3, '5': 9, '10': 'holeCards'},
    {'1': 'community_cards', '3': 2, '4': 3, '5': 9, '10': 'communityCards'},
    {'1': 'num_players', '3': 3, '4': 1, '5': 5, '10': 'numPlayers'},
    {'1': 'simulations', '3': 4, '4': 1, '5': 5, '10': 'simulations'},
  ],
};

/// Descriptor for `MonteCarloRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List monteCarloRequestDescriptor = $convert.base64Decode(
    'ChFNb250ZUNhcmxvUmVxdWVzdBIdCgpob2xlX2NhcmRzGAEgAygJUglob2xlQ2FyZHMSJwoPY2'
    '9tbXVuaXR5X2NhcmRzGAIgAygJUg5jb21tdW5pdHlDYXJkcxIfCgtudW1fcGxheWVycxgDIAEo'
    'BVIKbnVtUGxheWVycxIgCgtzaW11bGF0aW9ucxgEIAEoBVILc2ltdWxhdGlvbnM=');

@$core.Deprecated('Use monteCarloResponseDescriptor instead')
const MonteCarloResponse$json = {
  '1': 'MonteCarloResponse',
  '2': [
    {'1': 'win_probability', '3': 1, '4': 1, '5': 1, '10': 'winProbability'},
    {'1': 'simulations_run', '3': 2, '4': 1, '5': 5, '10': 'simulationsRun'},
  ],
};

/// Descriptor for `MonteCarloResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List monteCarloResponseDescriptor = $convert.base64Decode(
    'ChJNb250ZUNhcmxvUmVzcG9uc2USJwoPd2luX3Byb2JhYmlsaXR5GAEgASgBUg53aW5Qcm9iYW'
    'JpbGl0eRInCg9zaW11bGF0aW9uc19ydW4YAiABKAVSDnNpbXVsYXRpb25zUnVu');
