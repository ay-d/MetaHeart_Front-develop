library flutter_client_sse;

import 'dart:async';
import 'dart:convert';
import 'package:cardio_sim/simulation/model/entity/input_deck_data.dart';
import 'package:http/http.dart' as http;
import 'package:fetch_client/fetch_client.dart';

part 'sse_event_model.dart';

class SSEClient {
  static FetchClient _client = FetchClient(mode: RequestMode.cors);

  static Stream<SSEModel> subscribeToSSE({
    required String url,
    required Map<String, String> header,
    void Function()? onDone,
  }) {
    StreamController<SSEModel> streamController = StreamController();

    var request = http.Request("GET", Uri.parse(url));
    header.forEach((key, value) => request.headers[key] = value);

    //print(request.body);

    _client = FetchClient(mode: RequestMode.cors);
    final Future<FetchResponse> response = _client.send(request);

    var lineRegex = RegExp(r'^([^:]*):? ?(.*)?$');
    var currentSSEModel = SSEModel(data: '', id: '', event: '');

    response.asStream().listen((streamedResponse) {
      streamedResponse.stream
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen(
        (data) async {
          if (data.isEmpty) {
            ///This means that the complete event set has been read.
            ///We then add the event to the stream
            streamController.add(currentSSEModel);
            currentSSEModel = SSEModel(data: '', id: '', event: '');
            return;
          }

          ///Get the match of each line through the regex
          Match match = lineRegex.firstMatch(data)!;
          var field = match.group(1);
          if (field!.isEmpty) return;

          var value =
              field == 'data' ? data.substring(5) : match.group(2) ?? '';
          switch (field) {
            case 'event':
              currentSSEModel.event = value;
              break;
            case 'data':
              currentSSEModel.data = '${currentSSEModel.data ?? ''}$value';
              break;
            case 'id':
              currentSSEModel.id = value;
              break;
            case 'retry':
              break;
          }
        },
        onDone: onDone,
      );
    });

    return streamController.stream;
  }

  static void unsubscribeFromSSE() {
    _client.close();
  }

  static void connectSSE({
    required String url,
    String? path,
    Map<String, String>? header,
    Function(String?)? onData,
    Function()? onDone,
  }) {
    unsubscribeFromSSE();
    subscribeToSSE(
      url: "$url$path",
      header: {
        "Accept": "text/event-stream",
        "Content-Type" : "application/json",
        "Cache-Control": "no-cache",
      }..addAll(header ?? {}),
      onDone: onDone,
    ).listen(
      (event) => onData?.call(event.data),
    );
  }
}
