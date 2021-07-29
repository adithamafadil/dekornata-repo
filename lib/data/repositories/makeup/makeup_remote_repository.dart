import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dekornata_test/data/config/api_config.dart';
import 'package:dekornata_test/data/model/makeup/makeup_model.dart';
import 'package:dekornata_test/data/states/fetch_state.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@lazySingleton
class MakeupRepository {
  final http.Client _client;

  MakeupRepository(this._client);

  Future<FetchState<List<ProductModel>>> getData() async {
    try {
      String url = '$API_URL?brand=nyx';

      var response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        List<ProductModel> products = List<ProductModel>.from(
            data.map((product) => ProductModel.fromJson(product)));
        // ignore: avoid_print
        print('Succeed Getting Data!');
        return FetchState.success(products);
      } else {
        // ignore: avoid_print
        print('Something went wrong. Error 2');
        return const FetchState.error();
      }
    } on TimeoutException catch (e, stack) {
      // ignore: avoid_print
      print('Connection Timeout: $e at stack $stack');
      return const FetchState.connectionError();
    } on SocketException catch (e, stack) {
      // ignore: avoid_print
      print('Connection Error: $e at stack $stack');
      return const FetchState.connectionError();
    } catch (e, stack) {
      // ignore: avoid_print
      print('Something went wrong. Error 3 at stack $stack');
      return const FetchState.error();
    }
  }
}
