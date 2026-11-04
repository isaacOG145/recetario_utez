import 'package:dio/dio.dart';
import 'package:recetario_utez/datos/bitacora_interceptor.dart';

const urlDummyJson = 'https://dummyjson.com';

Dio crearDioRecetas({
  String baseUrl = urlDummyJson,
  List<Interceptor> interceptores = const [],
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(BitacoraInterceptor());
  dio.interceptors.addAll(interceptores);

  return dio;
}