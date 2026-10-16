import 'package:flutter/material.dart';

class NeoColors {
  NeoColors._();

  // Основной фон и поверхности (Строгое равенство цвета элемента и фона для неоморфизма)
  static const Color surface = Color(0xFFEBECF0);
  static const Color surfaceAlt = Color(0xFFF3F0EB);

  // Дуальные тени для эффекта выдавливания (без обводок)
  static const Color shadowLight = Color(0xFFFFFFFF);
  static const Color shadowDark = Color(0xFFBABECC);

  // Контрастная типографика (WCAG AA > 7:1)
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textTertiary = Color(0xFFA0AEC0);

  // Пастельные акценты
  static const Color sage = Color(0xFFE2EBD8);
  static const Color sageDark = Color(0xFF5A7E4A);

  static const Color lavender = Color(0xFFE6E6FA);
  static const Color lavenderDark = Color(0xFF6B65A6);

  static const Color peach = Color(0xFFFDE2D6);
  static const Color peachDark = Color(0xFFC86040);

  static const Color rose = Color(0xFFF7D6D8);
  static const Color roseDark = Color(0xFFB8535C);
}

class NeoRadius {
  NeoRadius._();

  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double full = 999.0;

  static BorderRadius get smBorder => BorderRadius.circular(sm);
  static BorderRadius get mdBorder => BorderRadius.circular(md);
  static BorderRadius get lgBorder => BorderRadius.circular(lg);
  static BorderRadius get xlBorder => BorderRadius.circular(xl);
  static BorderRadius get fullBorder => BorderRadius.circular(full);
}

class NeoSpacing {
  NeoSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

class NeoShadows {
  NeoShadows._();

  // Выпуклая тень малая (Кнопки, чипсы, мелкие контролы)
  static List<BoxShadow> raisedSm({Color? lightColor, Color? darkColor}) {
    return [
      BoxShadow(
        color: lightColor ?? NeoColors.shadowLight,
        offset: const Offset(-4, -4),
        blurRadius: 8,
      ),
      BoxShadow(
        color: darkColor ?? NeoColors.shadowDark,
        offset: const Offset(4, 4),
        blurRadius: 8,
      ),
    ];
  }

  // Выпуклая тень средняя (Карточки, панели, модальные окна)
  static List<BoxShadow> raisedMd({Color? lightColor, Color? darkColor}) {
    return [
      BoxShadow(
        color: lightColor ?? NeoColors.shadowLight,
        offset: const Offset(-8, -8),
        blurRadius: 16,
      ),
      BoxShadow(
        color: darkColor ?? NeoColors.shadowDark,
        offset: const Offset(8, 8),
        blurRadius: 16,
      ),
    ];
  }

  // Выпуклая тень крупная (Hover состояния, парящие блоки)
  static List<BoxShadow> raisedLg({Color? lightColor, Color? darkColor}) {
    return [
      BoxShadow(
        color: lightColor ?? NeoColors.shadowLight,
        offset: const Offset(-12, -12),
        blurRadius: 24,
      ),
      BoxShadow(
        color: darkColor ?? NeoColors.shadowDark,
        offset: const Offset(12, 12),
        blurRadius: 24,
      ),
    ];
  }
}
