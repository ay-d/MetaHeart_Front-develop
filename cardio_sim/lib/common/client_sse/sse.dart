library flutter_client_sse;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

part 'sse_event_model.dart';

class SSEClient {
  static http.Client _client = http.Client();
  static Stream<SSEModel> subscribeToSSE({
    required String url,
    required Map<String, String> header,void Function()? onDone,
    }) {
    // ignore: close_sinks
    StreamController<SSEModel> streamController = StreamController();
    var request = http.Request("GET", Uri.parse(url));
    header.forEach((key, value) => request.headers[key] = value);

    print("--SUBSCRIBING TO SSE---");

    _client = http.Client();
    Future<http.StreamedResponse> response = _client.send(request);

    var lineRegex = RegExp(r'^([^:]*):? ?(.*)?$');
    var currentSSEModel = SSEModel(data: '', id: '', event: '');

    ///Adding headers to the request

    ///Listening to the response as a stream
    response.asStream().listen((streamedResponse) {
      ///Applying transforms and listening to it
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
