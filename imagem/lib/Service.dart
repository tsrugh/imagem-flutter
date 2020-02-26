import 'package:dio/dio.dart';

class Service {
  final Dio dio = Dio();

  buscaImg(String url) async {
    Response resp = await dio.get(url);
    return resp.data;
  }
}
