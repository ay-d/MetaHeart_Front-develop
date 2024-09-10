import 'package:cardio_sim/common/client_sse/flutter_client_sse.dart';
import 'package:cardio_sim/common/dio/dio.dart';
import 'package:cardio_sim/common/local_storage/local_storage.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';


part 'simulation_repository.g.dart';

final simulationRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  // return SimulationRepositoryStub();
  return SimulationRepository(dio);
});

@RestApi()
abstract class SimulationRepository {
  factory SimulationRepository(Dio dio, {String baseUrl}) =
      _SimulationRepository;

  @GET('/executions/input')
  @Headers({'accessToken': 'true'})
  Future<String> getInputDeck(@Query('type') String type);

  @POST('/executions/input')
  @Headers({'accessToken': 'true'})
  Future setInputDeck(
    @Query('type') String type,
    @Body() Map<String, dynamic> inputData,
  );

  @POST('/executions/file')
  @Headers({'accessToken': 'true'})
  Future uploadInputFile(
    @Query('type') String type,
    @Query('name') String name,
    @Body() FormData formData,
  );
}

extension SimulationRepositorySSE on SimulationRepository {
  Future executions(
    String type,
    Function(String?)? onData,
    Function()? onDone,
  ) async {
    final baseUrl = dotenv.get("IP");
    final LocalStorage storage = LocalStorage();
    final token = await storage.read(key: dotenv.get('ACCESS_TOKEN_KEY'));

    if (token == null) return;
    SSEClient.connectSSE(
      url: baseUrl,
      path: "/executions?type=$type",
      header: {'authorization': 'Bearer $token'},
      onData: onData,
      onDone: onDone,
    );
  }
}
