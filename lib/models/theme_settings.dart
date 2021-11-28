class ThemeSettings {
  ThemeSettings({required this.darkMode, required this.accentColor});

  final bool darkMode;
  final String accentColor;

  factory ThemeSettings.fromMap(Map<String, dynamic>? data) {
    if (data != null) {
      return ThemeSettings(
        darkMode: data['darkMode'],
        accentColor: data['accentColor'],
      );
    }
    else {
      return ThemeSettings(darkMode: false, accentColor: '0xFFE53935');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'darkMode': darkMode,
      'accentColor': accentColor,
    };
  }
}
