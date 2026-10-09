import 'package:flutter/material.dart';

class AppTextStyles {
  const AppTextStyles._();

  /// Tamaño de fuente del selector de pasaje (30% mayor que el medio estándar)
  static const double passagePickerFontSize = 21;

  /// Título principal centrado en negrita (para el título del capítulo)
  static const TextStyle chapterTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: 'Georgia',
  );

  /// Texto de versículo principal
  static const TextStyle verseText = TextStyle(
    fontSize: 20,
    fontFamily: 'Georgia',
    color: Colors.black87,
    height: 1.5,
  );

  /// Texto de número de versículo en superíndice (color oro)
  static const TextStyle verseNumber = TextStyle(
    fontSize: 12,
    color: Color(0xFFD4A853),
    fontStyle: FontStyle.italic,
  );

  /// Texto tamaño reducido (A-)
  static const TextStyle textSizeReduced = TextStyle(
    fontSize: 16,
    color: Colors.black87,
    fontFamily: 'Georgia',
  );

  /// Texto tamaño aumentado (A+)
  static const TextStyle textSizeIncreased = TextStyle(
    fontSize: 24,
    color: Colors.black87,
    fontFamily: 'Georgia',
  );

  /// Botón de acción pequeña
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    color: Colors.white,
  );

  /// Label de botón A- (gris claro)
  static const TextStyle labelAMinus = TextStyle(
    fontSize: 14,
    color: Color(0xFFB0B0B0),
  );

  /// Label de botón A+ (gris claro)
  static const TextStyle labelAPlus = TextStyle(
    fontSize: 14,
    color: Color(0xFFB0B0B0),
  );
}
