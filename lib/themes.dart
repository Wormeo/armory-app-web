import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeCategory { simple, anemone, premium }

class ArmoryTheme {
  final String id;
  final String name;
  final ThemeCategory category;
  final ThemeData themeData;
  final String backgroundUrl;
  final bool hasAnimatedBorder;
  final bool useWhiteSearch;
  final bool isHolographic;
  final List<Color> refractionColors;
  final List<Color> borderGradient;
  final Color pickerBoxColor;
  final Color pickerBorderColor;
  final Color pickerTextColor;
  final List<Color>? pickerGradient;

  ArmoryTheme({
    required this.id,
    required this.name,
    this.pickerBoxColor = const Color(0xFF1A1A1A), 
    this.pickerBorderColor = Colors.white10,
    this.pickerTextColor = Colors.white54,
    this.pickerGradient,
    required this.category,
    required this.themeData,
    required this.backgroundUrl,
    this.useWhiteSearch = false,
    this.hasAnimatedBorder = false,
    this.borderGradient = const [],
    this.isHolographic = false, 
    this.refractionColors = const [],
  });
}

class ThemeController extends ChangeNotifier {
  static const String _storageKey = 'selected_armory_theme_id';

  ArmoryTheme _activeTheme = allThemes.first; 
  ArmoryTheme get activeTheme => _activeTheme;

  Future<void> setTheme(ArmoryTheme theme) async {
    if (_activeTheme.id != theme.id) {
      _activeTheme = theme;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, theme.id);
    }
  }

  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedId = prefs.getString(_storageKey);

    if (savedId != null) {
      try {
        final savedTheme = allThemes.firstWhere((t) => t.id == savedId);
        _activeTheme = savedTheme;
        notifyListeners();
      } catch (e) {
        debugPrint("Theme persistence error: $e");
      }
    }
  }

  static final List<ArmoryTheme> allThemes = [

    // SIMPLE

    ArmoryTheme(
      id: 'stock',
      name: 'ARMORY CLASSIC',
      pickerBoxColor: Color.fromARGB(255, 10, 14, 17),
      pickerBorderColor: Color.fromRGBO(55, 87, 193, 1),
      pickerTextColor: Colors.white,
      useWhiteSearch: true,
      category: ThemeCategory.simple,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771364267/f03dc6e1fcf5539b14a839785426f924_rmzmzh.jpg',
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(55, 87, 193, 1),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(55, 87, 193, 1),
          surface: Color.fromARGB(255, 10, 14, 17)
        ),
        useMaterial3: true,
        fontFamily: 'Days One'
      ),
    ),

    ArmoryTheme(
      id: 'dusk',
      name: 'DUSK',
      pickerBoxColor: Color.fromRGBO(22, 22, 22, 1),
      pickerBorderColor: Color.fromRGBO(122, 111, 194, 1),
      pickerTextColor: Colors.white,
      useWhiteSearch: true,
      category: ThemeCategory.simple,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771371000/d8e46cd77b9723f2e0734fd347286705_pemq60.jpg',
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(122, 111, 194, 1),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(122, 111, 194, 1),
          surface: Color.fromRGBO(22, 22, 22, 1),
        ),
        useMaterial3: true,
        fontFamily: 'Days One'
      ),
    ),

    ArmoryTheme(
      id: 'slate',
      name: 'SLATE',
      pickerBoxColor: Color.fromRGBO(22, 22, 22, 1),
      pickerBorderColor: Color.fromRGBO(158, 158, 158, 1),
      pickerTextColor: Colors.white,
      useWhiteSearch: true,
      category: ThemeCategory.simple,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771371000/0b8795eae0bacf1cc087055709d45732_fjvlx6.jpg',
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(158, 158, 158, 1),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(158, 158, 158, 1),
          surface: Color.fromRGBO(22, 22, 22, 1),
        ),
        useMaterial3: true,
        fontFamily: 'Days One'
      ),
    ),

    ArmoryTheme(
      id: 'royalty',
      name: 'ROYALTY',
      pickerBoxColor: Color.fromRGBO(10, 17, 26, 1),
      pickerBorderColor: Color.fromRGBO(185, 155, 115, 1),
      pickerTextColor: Colors.white,
      useWhiteSearch: true,
      category: ThemeCategory.simple,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771371000/3fa70d0f61c7eb24cca9657cec742f06_nudrjp.jpg',
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(185, 155, 115, 1),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(226, 185, 132, 1),
          surface: Color.fromRGBO(10, 17, 26, 1),
        ),
        useMaterial3: true,
        fontFamily: 'Days One'
      ),
    ),

    ArmoryTheme(
      id: 'rose',
      name: 'SCARLET ROSE',
      pickerBoxColor: Color.fromRGBO(25, 20, 26, 1),
      pickerBorderColor: Color.fromRGBO(164, 92, 109, 1),
      pickerTextColor: Colors.white,
      useWhiteSearch: true,
      category: ThemeCategory.simple,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771413039/b7b9b87c2a2e41f71295a5a17fc62d0a_fk5rmu.jpg',
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 228, 118, 144),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(232, 46, 90, 1),
          surface: Color.fromRGBO(25, 20, 26, 1),
        ),
        useMaterial3: true,
        fontFamily: 'Days One'
      ),
    ),

    ArmoryTheme(
      id: 'coffee',
      name: 'COFFEE',
      pickerBoxColor: Color.fromRGBO(18, 3, 2,1),
      pickerBorderColor: Color.fromRGBO(220, 208, 202, 1),
      pickerTextColor: Colors.white,
      useWhiteSearch: true,
      category: ThemeCategory.simple,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771413039/coffee_xs6lgs.jpg',
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 242, 220, 209),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(220, 208, 202, 1),
          surface: Color.fromRGBO(18, 3, 2,1),
        ),
        useMaterial3: true,
        fontFamily: 'Days One'
      ),
    ),

    // ANEMONE

    ArmoryTheme(
      id: 'anemone_pink',
      name: 'SHERBET',
      pickerGradient: [
        const Color(0xFFF1BCBE),
        const Color.fromRGBO(27, 24, 62, 1)
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.anemone,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771364267/Wallpaper-in-red-topography-for-iPhone_isvkgw.png',
      borderGradient: [
        const Color(0xFFF1BCBE),
        const Color.fromRGBO(27, 24, 62, 1)
      ],

      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFF1BCBE),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF1BCBE),
          surface: Color.fromARGB(255, 23, 16, 20),
        ),
        useMaterial3: true,
        fontFamily: 'Days One'
      ),
    ),

  ArmoryTheme(
      id: 'anemone_ghost',
      name: 'GHOST',
      pickerGradient: [
        const Color.fromRGBO(217, 218, 232, 1),
        const Color.fromRGBO(27, 24, 62, 1)
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.anemone,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771371000/c3471ffb785c870da69f4137684ae07b_bpu1pq.jpg',
      borderGradient: [
        const Color.fromRGBO(217, 218, 232, 1),
        const Color.fromRGBO(27, 24, 62, 1)
      ],

      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(217, 218, 232, 1),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(217, 218, 232, 1),
          surface: Color.fromRGBO(20, 19, 31, 1)
        ),
        useMaterial3: true,
        fontFamily: 'Days One'
      ),
    ),

    ArmoryTheme(
      id: 'anemone_chameleon',
      name: 'CHAMELEON',
      pickerGradient: [
        const Color.fromRGBO(112, 185, 173, 1),
        const Color.fromRGBO(79, 156, 185, 1),
        const Color.fromRGBO(42, 38, 85, 1)
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.anemone,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771371000/a0d65ac6d774ba4e1a23c8e60ebb28a0_jewktk.jpg',
      borderGradient: [
        const Color.fromRGBO(112, 185, 173, 1),
        const Color.fromRGBO(79, 156, 185, 1),
        const Color.fromRGBO(42, 38, 85, 1)
      ],

      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(112, 185, 173, 1),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(112, 185, 173, 1),
          surface: Color.fromRGBO(18, 25, 31, 1)
        ),
        useMaterial3: true,
        fontFamily: 'Days One'
      ),
    ),

    ArmoryTheme(
      id: 'anemone_toxin',
      name: 'TOXIN',
      pickerGradient: [
        const Color.fromRGBO(168, 192, 177, 1),
        const Color.fromRGBO(63, 101, 92, 1),
        const Color.fromRGBO(31, 28, 39, 1)
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.anemone,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771371000/8c372e4607ff66fd539278111e16cb8b_lr25am.jpg',
      borderGradient: [
        const Color.fromRGBO(168, 192, 177, 1),
        const Color.fromRGBO(63, 101, 92, 1),
        const Color.fromRGBO(31, 28, 39, 1)
      ],

      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(168, 192, 177, 1),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(168, 192, 177, 1),
          surface: Color.fromRGBO(10, 15, 11, 1)
        ),
        useMaterial3: true,
        fontFamily: 'Days One'
      ),
    ),

    ArmoryTheme(
      id: 'anemone_system',
      name: 'SYSTEM SHOCK',
      pickerGradient: [
        const Color.fromRGBO(131, 247, 250, 1),
        const Color.fromRGBO(97, 118, 251, 1),
        const Color.fromRGBO(227, 129, 251, 1),
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.anemone,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771413039/960ebac8fe9de855d9cd58c423fe7f25_agtxuo.jpg',
      borderGradient: [
        const Color.fromRGBO(131, 247, 250, 1),
        const Color.fromRGBO(97, 118, 251, 1),
        const Color.fromRGBO(227, 129, 251, 1),
      ],

      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(168, 192, 177, 1),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(168, 182, 192, 1),
          surface: Color.fromRGBO(30, 34, 47, 1)
        ),
        useMaterial3: true,
        fontFamily: 'Days One'
      ),
    ),

    ArmoryTheme(
      id: 'anemone_kuromi',
      name: 'KU-R0Mx1',
      pickerGradient: [
        const Color.fromRGBO(242, 182, 214, 1),
        const Color.fromRGBO(191, 170, 229, 1),
        const Color.fromRGBO(148, 124, 208, 1),
        const Color.fromRGBO(84, 78, 82, 1),
        const Color.fromRGBO(50, 47, 40, 1),
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.anemone,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771371001/e44f0a59b6aa023cd1c7985094879b95_s1m0v3.jpg',
      borderGradient: [
        const Color.fromRGBO(242, 182, 214, 1),
        const Color.fromRGBO(191, 170, 229, 1),
        const Color.fromRGBO(148, 124, 208, 1),
        const Color.fromRGBO(84, 78, 82, 1),
        const Color.fromRGBO(50, 47, 40, 1),
      ],

      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(168, 192, 177, 1),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(191, 170, 229, 1),
          surface: Color.fromRGBO(30, 34, 47, 1)
        ),
        useMaterial3: true,
        fontFamily: 'Days One'
      ),
    ),

    ArmoryTheme(
      id: 'anemone_arctis',
      name: 'COLD SNAP',
      pickerGradient: [
        const Color.fromRGBO(100, 225, 242, 1),
        const Color.fromRGBO(43, 100, 115, 1),
        const Color.fromRGBO(0, 0, 0, 1),
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.anemone,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771413039/058a0385fd3579c8a45d7037cc8cd6f4_wotzzz.jpg',
      borderGradient: [
        const Color.fromRGBO(100, 225, 242, 1),
        const Color.fromRGBO(43, 100, 115, 1),
        const Color.fromRGBO(0, 0, 0, 1),
      ],

      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(168, 192, 177, 1),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(43, 100, 115, 1),
          surface: Color.fromRGBO(30, 34, 47, 1)
        ),
        useMaterial3: true,
        fontFamily: 'Days One'
      ),
    ),

    // HOLOGRAPHIC

    ArmoryTheme(
      id: 'holographic_gold',
      name: 'MOLTEN GOLD',
      pickerGradient: [
      Color.fromRGBO(50, 49, 47, 1),
      Color.fromRGBO(236, 185, 43, 1),
      Color.fromRGBO(234, 223, 66, 1),
      Color.fromRGBO(50, 49, 47, 1),
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.premium,
      useWhiteSearch: false,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771371001/9eea698c2daddd935ce121ef15a429e1_syixzn.jpg',
      isHolographic: true,
      borderGradient: [
        const Color.fromRGBO(234, 223, 66, 1),
        const Color.fromRGBO(236, 185, 43, 1),
        ],
      refractionColors: [
      Color.fromRGBO(50, 49, 47, 1),
      Color.fromRGBO(236, 185, 43, 1),
      Color.fromRGBO(234, 223, 66, 1),
      Color.fromRGBO(50, 49, 47, 1),
      ],
      themeData: ThemeData(
        fontFamily: 'Days One',
        colorScheme: ColorScheme.dark(
          primary: Color.fromRGBO(236, 185, 43, 1),
          surface: const Color(0xFF1A1608),
        ),
      ),
    ),

    ArmoryTheme(
      id: 'holographic_iridescent',
      name: 'IRIDESCENT',
      pickerGradient: [
        Color.fromRGBO(249, 219, 208, 1),
        Color.fromRGBO(227, 248, 240, 1),
        Color.fromRGBO(160, 165, 218, 1),
        Color.fromRGBO(129, 186, 231, 1),
        Color.fromRGBO(40, 250, 245, 1),
        Color.fromRGBO(245, 126, 230, 1),
        Color.fromRGBO(249, 219, 208,1),
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.premium,
      isHolographic: true,
      refractionColors: [
        Color.fromRGBO(249, 219, 208, 1),
        Color.fromRGBO(227, 248, 240, 1),
        Color.fromRGBO(160, 165, 218, 1),
        Color.fromRGBO(129, 186, 231, 1),
        Color.fromRGBO(40, 250, 245, 1),
        Color.fromRGBO(245, 126, 230, 1),
        Color.fromRGBO(249, 219, 208,1),
      ],
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771371001/025da0ca4d85151d9d2b52c9c1cadd29_ivwjlk.jpg',
      borderGradient: [Colors.purple, Colors.black],
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 255, 255, 255),
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF0A050A),
        ),
        useMaterial3: true,
        fontFamily: 'Days One',
      ),
    ),

    ArmoryTheme(
      id: 'holographic_rainbow',
      name: 'RAINBOW',
      pickerGradient: [
        Colors.redAccent,
        Colors.orangeAccent,
        Colors.yellowAccent,
        Colors.greenAccent,
        Colors.blueAccent,
        Colors.indigoAccent,
        Colors.deepPurpleAccent
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.premium,
      isHolographic: true,
      refractionColors: [
        Colors.deepPurpleAccent,
        Colors.indigoAccent,
        Colors.blueAccent,
        Colors.greenAccent,
        Colors.yellowAccent,
        Colors.orangeAccent,
        Colors.redAccent,
        Colors.deepPurpleAccent
      ],
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771371000/76e42e833496c016282c91ac2ca87c53_cfon1b.jpg',
      borderGradient: [const Color.fromARGB(255, 255, 255, 255), Colors.black],
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 255, 255, 255),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 255, 255, 255),
          surface: Color.fromARGB(255, 15, 15, 15),
        ),
        useMaterial3: true,
        fontFamily: 'Days One',
      ),
    ),

    ArmoryTheme(
      id: 'holographic_viper',
      name: 'VIPER',
      pickerGradient: [
      Color.fromRGBO(77, 193, 122, 1), 
      Color.fromRGBO(94, 208, 231, 1),
      Color.fromRGBO(85, 44, 162, 1),
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.premium,
      isHolographic: true,
      refractionColors: [
        Color.fromRGBO(77, 193, 122, 1),
        Color.fromRGBO(94, 208, 231, 1),
        Color.fromRGBO(85, 44, 162, 1),
        Color.fromRGBO(77, 193, 122, 1),
      ],
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771371001/9463336756f165c7a67575e8f7a9fac5_czjp2e.jpg',
      borderGradient: [Colors.purple, Colors.black],
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 67, 29, 174),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(85, 44, 162, 1),
          surface: Color(0xFF0A050A),
        ),
        useMaterial3: true,
        fontFamily: 'Days One',
      ),
    ),

    ArmoryTheme(
      id: 'holographic_nebula',
      name: 'NEBULA',
      pickerGradient: [
        Color.fromRGBO(236, 250, 254, 1),
        Color.fromRGBO(118, 220, 231, 1),
        Color.fromRGBO(57, 113, 160, 1),
        Color.fromRGBO(58, 134, 139, 1),
        Color.fromRGBO(102, 224, 171, 1),
        Color.fromRGBO(4, 3, 18, 1),
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.premium,
      isHolographic: true,
      refractionColors: [
        Color.fromRGBO(236, 250, 254, 1),
        Color.fromRGBO(118, 220, 231, 1),
        Color.fromRGBO(57, 113, 160, 1),
        Color.fromRGBO(58, 134, 139, 1),
        Color.fromRGBO(102, 224, 171, 1),
        Color.fromRGBO(236, 250, 254, 1),
      ],
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771413039/ade6702fc19c272f571c699d5ac57590_gfeshi.jpg',
      borderGradient: [const Color.fromARGB(255, 255, 255, 255), Colors.black],
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 35, 243, 222),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(61, 236, 221, 1),
          surface: Color.fromARGB(255, 12, 12, 12),
        ),
        useMaterial3: true,
        fontFamily: 'Days One',
      ),
    ),

    ArmoryTheme(
      id: 'holographic_strawberry',
      name: 'STRAWBERRY',
      pickerGradient: [
        Color.fromRGBO(241, 173, 191, 1),
        Color.fromRGBO(250, 242, 245, 1),
        Color.fromRGBO(168, 76, 98, 1),
        Color.fromRGBO(122, 40, 58, 1),
        Color.fromRGBO(241, 173, 191, 1),
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.premium,
      isHolographic: true,
      refractionColors: [
        Color.fromRGBO(241, 173, 191, 1),
        Color.fromRGBO(250, 242, 245, 1),
        Color.fromRGBO(168, 76, 98, 1),
        Color.fromRGBO(122, 40, 58, 1),
        Color.fromRGBO(241, 173, 191, 1),
      ],
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771448986/11c7cb1cce6447823770f5127ed76dcf_p8g8xv.jpg',
      borderGradient: [Colors.purple, Colors.black],
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 67, 29, 174),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(168, 76, 98, 1),
          surface: Color.fromRGBO(52, 31, 47, 1),
        ),
        useMaterial3: true,
        fontFamily: 'Days One',
      ),
    ),


  ];
}