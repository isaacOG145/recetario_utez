// lib/presentacion/tarjeta_receta.dart
import 'package:flutter/material.dart';
import 'package:recetario_utez/dominio/receta.dart';

class TarjetaReceta extends StatelessWidget {
  const TarjetaReceta({super.key, required this.receta});

  final Receta receta;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    receta.nombre,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (receta.esRapida)
                  const Chip(
                    label: Text('Rápida'),
                  ),
              ],
            ),
            Text('${receta.cocina} · ${receta.dificultad.etiqueta}'),
            const SizedBox(height: 4),
            Text(
              'Tiempo: ${receta.tiempoTotal} min · Porciones: ${receta.porciones}',
            ),
            Text(
              'Calificación: ${receta.calificacion.toStringAsFixed(1)}',
            ),
          ],
        ),
      ),
    );
  }
}