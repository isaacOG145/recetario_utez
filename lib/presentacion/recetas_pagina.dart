import 'package:flutter/material.dart';
import 'package:recetario_utez/presentacion/recetas_view_model.dart';
import 'package:recetario_utez/presentacion/tarjeta_receta.dart';

class RecetasPagina extends StatefulWidget {
  const RecetasPagina({super.key, required this.vm});

  final RecetasViewModel vm;

  @override
  State<RecetasPagina> createState() => _RecetasPaginaState();
}

class _RecetasPaginaState extends State<RecetasPagina> {
  late final TextEditingController _controlador;

  @override
  void initState() {
    super.initState();
    _controlador = TextEditingController();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _ejecutarBusqueda() {
    widget.vm.buscar(_controlador.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetario UTEZ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('busqueda'),
                    controller: _controlador,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _ejecutarBusqueda(),
                    decoration: const InputDecoration(
                      labelText: 'Buscar recetas',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ListenableBuilder(
                  listenable: widget.vm,
                  builder: (context, _) {
                    return FilledButton(
                      key: const Key('buscar'),
                      onPressed: widget.vm.cargando ? null : _ejecutarBusqueda,
                      child: const Text('Buscar recetas'),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.vm,
                builder: (context, _) {
                  final estado = widget.vm.estado;

                  return switch (estado) {
                    RecetasInicial() => const Center(
                      child: Text(
                        'Escribe una receta o déjalo vacío y toca Buscar recetas.',
                      ),
                    ),
                    RecetasCargando() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    RecetasVacias(busqueda: final b) => Center(
                      child: Text(
                        b.isEmpty
                            ? 'No hay recetas disponibles.'
                            : 'No encontramos recetas para "$b".',
                      ),
                    ),
                    RecetasFallidas(mensaje: final m) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(m),
                          const SizedBox(height: 8),
                          FilledButton(
                            onPressed: () => widget.vm.reintentar(),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    ),
                    RecetasListas(recetas: final lista, total: final total) =>
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mostrando ${lista.length} de $total recetas · Rápidas: ${widget.vm.rapidas}',
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: ListView.builder(
                                itemCount: lista.length,
                                itemBuilder: (context, index) {
                                  return TarjetaReceta(receta: lista[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}