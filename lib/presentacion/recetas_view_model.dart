import 'package:flutter/foundation.dart';
import 'package:recetario_utez/datos/recetas_repositorio.dart';
import 'package:recetario_utez/dominio/falla_red.dart';
import 'package:recetario_utez/dominio/receta.dart';
import 'package:recetario_utez/presentacion/mensajes.dart';

sealed class EstadoRecetas {
  const EstadoRecetas();
}

final class RecetasInicial extends EstadoRecetas {
  const RecetasInicial();
}

final class RecetasCargando extends EstadoRecetas {
  const RecetasCargando();
}

final class RecetasListas extends EstadoRecetas {
  const RecetasListas(this.recetas, this.total);
  final List<Receta> recetas;
  final int total;
}

final class RecetasVacias extends EstadoRecetas {
  const RecetasVacias(this.busqueda);
  final String busqueda;
}

final class RecetasFallidas extends EstadoRecetas {
  const RecetasFallidas(this.mensaje);
  final String mensaje;
}

class RecetasViewModel extends ChangeNotifier {
  RecetasViewModel(this._repositorio);

  final RecetasRepositorio _repositorio;

  EstadoRecetas _estado = const RecetasInicial();
  EstadoRecetas get estado => _estado;

  String _ultimaBusqueda = '';
  String get ultimaBusqueda => _ultimaBusqueda;

  bool _disposed = false;

  bool get cargando => _estado is RecetasCargando;

  int get rapidas {
    return switch (_estado) {
      RecetasListas(recetas: final lista) =>
      lista.where((r) => r.esRapida).length,
      _ => 0,
    };
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> buscar(String texto) async {
    if (cargando) return;

    _ultimaBusqueda = texto.trim();
    _estado = const RecetasCargando();
    notifyListeners();

    try {
      final pagina = await _repositorio.buscar(texto: _ultimaBusqueda);

      if (pagina.recetas.isEmpty) {
        _estado = RecetasVacias(_ultimaBusqueda);
      } else {
        _estado = RecetasListas(pagina.recetas, pagina.total);
      }
    } on FallaRed catch (falla) {
      _estado = RecetasFallidas(mensajePara(falla));
    } catch (_) {
      _estado = const RecetasFallidas(mensajeInesperado);
    } finally {
      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  Future<void> reintentar() async {
    await buscar(_ultimaBusqueda);
  }
}