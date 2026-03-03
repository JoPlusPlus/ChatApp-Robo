import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  /// Core brand colors
  static const Color _primaryLight = Color(0xFF6C63FF);
  static const Color _primaryDark = Color(0xFF8B83FF);
  static const Color _primaryAccent = Color(0xFF8379F5);

  /// Light palette
  static const Color _lightBg = Color(0xFFF5F6FA);
  static const Color _lightSurface = Colors.white;
  static const Color _lightCard = Colors.white;
  static const Color _lightFormBg = Colors.white;
  static const Color _lightInputFill = Color(0xFFF0F0F5);
  static const Color _lightDivider = Color(0xFFE0E0E0);
  static const Color _lightShadow = Color(0x1A000000);
  static const Color _lightTextPrimary = Color(0xFF1A1A2E);
  static const Color _lightTextSecondary = Color(0xFF666680);
  static const Color _lightTextHint = Color(0xFF9FA6B2);
  static const Color _lightUnselected = Color(0xFF9E9E9E);

  /// Dark palette
  static const Color _darkBg = Color(0xFF16161F);
  static const Color _darkSurface = Color(0xFF1E1E2C);
  static const Color _darkCard = Color(0xFF2A2A3C);
  static const Color _darkFormBg = Color(0xFF1E1E2C);
  static const Color _darkInputFill = Color(0xFF2A2A3C);
  static const Color _darkDivider = Color(0xFF3A3A4C);
  static const Color _darkShadow = Color(0x40000000);
  static const Color _darkTextPrimary = Color(0xFFE8E8F0);
  static const Color _darkTextSecondary = Color(0xFF9E9EAE);
  static const Color _darkTextHint = Color(0xFF6E6E80);
  static const Color _darkUnselected = Color(0xFF6E6E80);

  /// Semantic colors
  static const Color success = Color(0xFF34A853);
  static const Color error = Color(0xFFEA4335);
  static const Color warning = Color(0xFFFBBC05);
  static const Color info = Color(0xFF4285F4);
  static const Color tagGreen = Color(0xFF60BD60);

  /// Google brand colors (for social login buttons)
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleRed = Color(0xFFEA4335);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleGreen = Color(0xFF34A853);

  /// Shorthand to check dark mode: `AppTheme.isDark(context)`
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// Primary color that adapts to current theme
  static Color primary(BuildContext context) =>
      isDark(context) ? _primaryDark : _primaryLight;

  /// Primary accent
  static Color accent(BuildContext context) => _primaryAccent;

  /// Scaffold / page background
  static Color background(BuildContext context) =>
      isDark(context) ? _darkBg : _lightBg;

  /// Surface (app bars, nav bars, dialogs)
  static Color surface(BuildContext context) =>
      isDark(context) ? _darkSurface : _lightSurface;

  /// Card backgrounds
  static Color card(BuildContext context) =>
      isDark(context) ? _darkCard : _lightCard;

  /// Form / sheet backgrounds
  static Color formBackground(BuildContext context) =>
      isDark(context) ? _darkFormBg : _lightFormBg;

  /// Input field fill color
  static Color inputFill(BuildContext context) =>
      isDark(context) ? _darkInputFill : _lightInputFill;

  /// Divider / border color
  static Color divider(BuildContext context) =>
      isDark(context) ? _darkDivider : _lightDivider;

  /// Shadow color
  static Color shadow(BuildContext context) =>
      isDark(context) ? _darkShadow : _lightShadow;

  /// Primary text
  static Color textPrimary(BuildContext context) =>
      isDark(context) ? _darkTextPrimary : _lightTextPrimary;

  /// Secondary / muted text
  static Color textSecondary(BuildContext context) =>
      isDark(context) ? _darkTextSecondary : _lightTextSecondary;

  /// Hint / placeholder text
  static Color textHint(BuildContext context) =>
      isDark(context) ? _darkTextHint : _lightTextHint;

  /// Unselected / inactive icons
  static Color unselected(BuildContext context) =>
      isDark(context) ? _darkUnselected : _lightUnselected;

  /// Primary brand gradient (profile avatar ring, decorative elements)
  static LinearGradient primaryGradient(BuildContext context) {
    final p = primary(context);
    return LinearGradient(
      colors: [p, _primaryAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// THEME DATA — LIGHT

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryLight,
        brightness: Brightness.light,
        primary: _primaryLight,
        surface: _lightSurface,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: _lightBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightSurface,
        foregroundColor: _lightTextPrimary,
        shadowColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: _lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _lightSurface,
        selectedItemColor: _primaryLight,
        unselectedItemColor: _lightUnselected,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightInputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primaryLight, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        hintStyle: const TextStyle(color: _lightTextHint),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(color: _lightDivider),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryLight,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        backgroundColor: _lightSurface,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _primaryLight;
          return _lightUnselected;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryLight.withValues(alpha: 0.4);
          }
          return _lightDivider;
        }),
      ),
      dividerColor: _lightDivider,
      dividerTheme: const DividerThemeData(color: _lightDivider, thickness: 1),
    );
  }

  /// THEME DATA — DARK

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryDark,
        brightness: Brightness.dark,
        primary: _primaryDark,
        surface: _darkSurface,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: _darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: _darkTextPrimary,
        shadowColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: _darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _darkSurface,
        selectedItemColor: _primaryDark,
        unselectedItemColor: _darkUnselected,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkInputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primaryDark, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        hintStyle: const TextStyle(color: _darkTextHint),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(color: _darkDivider),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryDark,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        backgroundColor: _darkCard,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _primaryDark;
          return _darkUnselected;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryDark.withValues(alpha: 0.4);
          }
          return _darkDivider;
        }),
      ),
      dividerColor: _darkDivider,
      dividerTheme: const DividerThemeData(color: _darkDivider, thickness: 1),
    );
  }
}
