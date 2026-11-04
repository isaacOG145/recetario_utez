// lib/datos/recetas_json.dart
import 'package:recetario_utez/dominio/receta.dart';

Dificultad dificultadDesdeTexto(Object? valor) {
  if (valor is! String){
    return Dificultad.desconocida;
  }

  return switch (valor){
    'Easy' => Dificultad.facil,
    'Medium' => Dificultad.media,
    'Hard' => Dificultad.dificil,
    _ => Dificultad.desconocida,
  };
}

/// Convierte un mapa JSON en una instancia de [Receta].
/// Lanza [FormatException] si los campos obligatorios o los tipos son invalidos.
Receta recetaDesdeJson(Map<String, dynamic> json) {
  if (json case {
  'id': final int id,
  'name': final String nombre,
  'cuisine': final String cocina,
  'prepTimeMinutes': final int prepTimeMinutes,
  'cookTimeMinutes': final int cookTimeMinutes,
  'servings': final int porciones,
  'rating': final num calificacion,
  }) {
    // Procesamiento directo de etiquetas (tags)
    final tagsRaw = json['tags'];
    final List<String> etiquetas;
    if (tagsRaw == null) {
      etiquetas = const [];
    } else if (tagsRaw is List) {
      etiquetas = <String>[];
      for (final elemento in tagsRaw) {
        if (elemento is! String) {
          throw const FormatException('Los elementos de "tags" deben ser texto.');
        }
        etiquetas.add(elemento);
      }
    } else {
      throw const FormatException('El campo "tags" debe ser una lista.');
    }

    // Procesamiento directo de ingredientes (ingredients)
    final ingredientsRaw = json['ingredients'];
    final List<String> ingredientes;
    if (ingredientsRaw == null) {
      ingredientes = const [];
    } else if (ingredientsRaw is List) {
      ingredientes = <String>[];
      for (final elemento in ingredientsRaw) {
        if (elemento is! String) {
          throw const FormatException('Los elementos de "ingredients" deben ser texto.');
        }
        ingredientes.add(elemento);
      }
    } else {
      throw const FormatException('El campo "ingredients" debe ser una lista.');
    }

    return Receta(
      id: id,
      nombre: nombre,
      cocina: cocina,
      dificultad: dificultadDesdeTexto(json['difficulty']),
      minutosPreparacion: prepTimeMinutes,
      minutosCoccion: cookTimeMinutes,
      porciones: porciones,
      calificacion: calificacion.toDouble(),
      etiquetas: etiquetas,
      ingredientes: ingredientes,
    );
  }

  throw const FormatException('JSON de receta inválido o con campos obligatorios faltantes.');
}

/// Convierte un mapa JSON en una instancia de [PaginaRecetas].
/// Lanza [FormatException] si faltan las llaves o la estructura es invalida.
PaginaRecetas paginaDesdeJson(Map<String, dynamic> json) {
  if (json case {
  'recipes': final List<dynamic> recetasRaw,
  'total': final int total,
  }) {
    final recetas = <Receta>[];

    for (final elemento in recetasRaw) {
      if (elemento is! Map<String, dynamic>) {
        throw const FormatException('Cada elemento de "recipes" debe ser un mapa JSON.');
      }
      recetas.add(recetaDesdeJson(elemento));
    }

    return PaginaRecetas(
      recetas: recetas,
      total: total,
    );
  }

  throw const FormatException('JSON de página de recetas inválido.');
}