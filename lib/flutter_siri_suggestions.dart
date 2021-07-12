import 'dart:async';
import 'package:flutter/services.dart';

typedef Future<dynamic> MessageHandler(Map<String, dynamic>? message);

class FlutterSiriActivity {
  const FlutterSiriActivity(this.title, this.key,
      {this.contentDescription, this.isEligibleForSearch = true, this.isEligibleForPrediction = true, this.suggestedInvocationPhrase})
      : assert(title != null),
        assert(key != null),
        super();

  final String title;
  final String key;
  final String? contentDescription;
  final bool isEligibleForSearch;
  final bool isEligibleForPrediction;
  final String? suggestedInvocationPhrase;
}

class FlutterSiriSuggestions {
  FlutterSiriSuggestions._();

  /// Singleton of [FlutterSiriSuggestions].
  static final FlutterSiriSuggestions instance = FlutterSiriSuggestions._();

  // FlutterSiriShortcuts(this.title, this.key,
  //     {this.contentDescription,
  //     this.isEligibleForSearch = true,
  //     this.isEligibleForPrediction = true,
  //     this.suggestedInvocationPhrase})
  //     : assert(title != null),
  //       super();

  MessageHandler? _onLaunch;

  static const MethodChannel _channel = const MethodChannel('flutter_siri_suggestions');

  Future<String?> buildActivity(FlutterSiriActivity activity) async {
    return await _channel.invokeMethod('becomeCurrent', <String, Object?>{
      'title': activity.title,
      'key': activity.key,
      'contentDescription': activity.contentDescription,
      'isEligibleForSearch': activity.isEligibleForSearch,
      'isEligibleForPrediction': activity.isEligibleForPrediction,
      'suggestedInvocationPhrase': activity.suggestedInvocationPhrase ?? ""
    });
  }

  void configure({MessageHandler? onLaunch}) {
    _onLaunch = onLaunch;
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onLaunch":
        return _onLaunch!(call.arguments.cast<String, dynamic>());
      default:
        throw UnsupportedError("Unrecognized JSON message");
    }
  }
}
