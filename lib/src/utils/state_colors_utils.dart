import 'package:flutter/material.dart';

class StateColors {
  static Color? stateColors(String state) {
    final Map<String, Color?> colors = {
      'pendiente': Colors.blue,
      'rechazado': Colors.red,
      'cancelado': Colors.orange,
      'aceptado': Colors.green,
    };

    if (colors[state] != null) return colors[state];

    return Colors.blueAccent;
  }

  static Color? badgeStateColor(String state) {
    final Map<String, Color?> colores = {
      'pendiente': Colors.blue[800],
      'rechazado': Colors.red[800],
      'cancelado': Colors.orange[800],
      'aceptado': Colors.green[800],
    };

    if (colores[state] != null) return colores[state];

    return Colors.blue;
  }
}
