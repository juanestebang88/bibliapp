import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/localization/app_strings.dart';

/// Text contract of the stats screen (spec 19): duration plural, signed
/// weekly change, one-decimal donut percent.
void main() {
  test('duration days pluralize correctly', () {
    expect(AppStrings.durationDays(0), '0 Días');
    expect(AppStrings.durationDays(1), '1 Día');
    expect(AppStrings.durationDays(2), '2 Días');
    expect(AppStrings.durationDays(13), '13 Días');
  });

  test('weekly change includes the sign only for positive values', () {
    expect(AppStrings.weeklyChange(14), '+14% DESDE LA SEMANA PASADA');
    expect(AppStrings.weeklyChange(0), '0% DESDE LA SEMANA PASADA');
    expect(AppStrings.weeklyChange(-8), '-8% DESDE LA SEMANA PASADA');
  });

  test('overall percent keeps one decimal, including the zero case', () {
    expect(AppStrings.percentOneDecimal(0), '0.0%');
    expect(AppStrings.percentOneDecimal(0.9251), '0.9%');
    expect(AppStrings.percentOneDecimal(100), '100.0%');
  });

  test('yesterday vs today labels expose both counters', () {
    expect(AppStrings.chaptersYesterday(0), 'CAPÍTULOS AYER 0');
    expect(AppStrings.chaptersToday(0), '0 CAPÍTULOS HOY');
  });

  test('reading states use a single canonical wording', () {
    expect(AppStrings.statsNotStarted, 'Sin iniciar');
    expect(AppStrings.bookInProgress, 'En curso');
    expect(AppStrings.statsCompleted, 'Finalizado');
    expect(AppStrings.statsPopupClose, 'Cerrar');
  });
}
