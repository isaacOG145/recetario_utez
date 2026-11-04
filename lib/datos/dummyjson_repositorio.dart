import 'package:dio/dio.dart';
import 'package:recetario_utez/datos/recetas_json.dart';
import 'package:recetario_utez/datos/recetas_repositorio.dart';
import 'package:recetario_utez/datos/traducir_error.dart';
import 'package:recetario_utez/dominio/falla_red.dart';
import 'package:recetario_utez/dominio/receta.dart';

const recetasPorPagina = 10;

class DummyJsonRepositorio implements RecetasRepositorio {
  DummyJsonRepositorio(this._dio);

  final Dio _dio;

  @override
  Future<PaginaRecetas> buscar({String texto = ''}) async {
    final textoLimpio = texto.trim();
    final String path;
    final Map<String, dynamic> queryParameters;

    if (textoLimpio.isEmpty) {
      path = '/recipes';
      queryParameters = {'limit': recetasPorPagina};
    } else {
      path = '/recipes/search';
      queryParameters = {
        'q': textoLimpio,
        'limit': recetasPorPagina,
      };
    }

    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const RespuestaInvalida();
      }

      return paginaDesdeJson(data);
    } on DioException catch (e) {
      throw traducirError(e);
    } on FormatException {
      throw const RespuestaInvalida();
    }
  }
