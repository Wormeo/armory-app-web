import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum ThemeCategory { simple, anemone, premium, neon}

class ArmoryTheme {
  final String id;
  final String name;
  final ThemeCategory category;
  final ThemeData themeData;
  final String backgroundUrl;
  final bool hasAnimatedBorder;
  final bool useWhiteSearch;
  final bool isHolographic;
  final bool isReactive;
  final bool isCustom;
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
    this.isReactive = false,
    this.isCustom = false,
    this.refractionColors = const [],
  });
}

class ArmoryText extends StatelessWidget {
  final String text;
  final double baseFontSize;
  final double baseStrokeWidth;
  final ThemeController themeController;
  final Color color;
  final Color overrideStrokeColor;
  final TextAlign textAlign;
  final bool allowWrap;

  final double? overrideFontSize;
  final double? overrideStrokeWidth;
  final double? letterSpacing;
  final String? overrideFontFamily;
  final double? lineHeight;

  const ArmoryText(this.text, {
    super.key,
    required this.themeController,
    this.baseFontSize = 18.0,
    this.baseStrokeWidth = 2.5,
    this.color = Colors.white,
    this.textAlign = TextAlign.start,
    this.allowWrap = false,
    this.overrideFontSize,
    this.overrideStrokeWidth,
    this.overrideFontFamily,
    this.letterSpacing,
    this.lineHeight,
    this.overrideStrokeColor = Colors.black
  });

  @override
  Widget build(BuildContext context) {
    final fontName = overrideFontFamily ?? themeController.activeFont;
    final specs = ThemeController.fontConfigs[fontName] ?? const FontSpecs();

    final double finalSize = overrideFontSize ?? (baseFontSize * specs.sizeScale);
    final double finalStroke = overrideStrokeWidth ?? (baseStrokeWidth * specs.strokeScale);
    
    final double baseSpacing = letterSpacing ?? specs.spacingAdd;
    final double finalSpacing = baseSpacing * specs.sizeScale;

    final sharedStrut = StrutStyle(
      fontFamily: fontName,
      fontSize: finalSize,
      height: lineHeight,
      forceStrutHeight: true,
    );

    Widget textStack = Stack(
      children: [
        if (finalStroke > 0)
          Text(
            text,
            textAlign: textAlign,
            softWrap: allowWrap,
            strutStyle: sharedStrut,
            style: TextStyle(
              fontFamily: fontName,
              fontSize: finalSize,
              height: lineHeight,
              letterSpacing: finalSpacing,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = finalStroke
                ..strokeCap = StrokeCap.round
                ..strokeJoin = StrokeJoin.round
                ..color = overrideStrokeColor,
            ),
          ),
        Text(
          text,
          textAlign: textAlign,
          softWrap: allowWrap,
          strutStyle: sharedStrut,
          style: TextStyle(
            fontFamily: fontName,
            fontSize: finalSize,
            height: lineHeight,
            letterSpacing: finalSpacing,
            color: color,
          ),
        ),
      ],
    );

    if (allowWrap) {
      return Container(
        width: double.infinity,
        alignment: textAlign == TextAlign.center 
            ? Alignment.center 
            : (textAlign == TextAlign.end ? Alignment.centerRight : Alignment.centerLeft),
        child: textStack,
      );
    }

    return FittedBox(
      fit: BoxFit.scaleDown, 
      alignment: textAlign == TextAlign.center 
          ? Alignment.center 
          : (textAlign == TextAlign.end ? Alignment.centerRight : Alignment.centerLeft),
      child: textStack,
    );
  }
}

class ArmorySelectableText extends StatelessWidget {
  final String text;
  final double baseFontSize;
  final ThemeController themeController;
  final Color color;
  final double? letterSpacing;

  const ArmorySelectableText(this.text, {
    super.key,
    required this.themeController,
    this.baseFontSize = 12.0,
    this.color = Colors.white,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: ArmoryText(
        text,
        themeController: themeController,
        baseFontSize: baseFontSize,
        color: color,
        letterSpacing: letterSpacing,
        baseStrokeWidth: 0,
      ),
    );
  }
}

class FontSpecs {
  final double sizeScale;
  final double strokeScale;
  final double spacingAdd;
  
  const FontSpecs({
    this.sizeScale = 1.0, 
    this.strokeScale = 1.0, 
    this.spacingAdd = 0.0,
  });
}

class ThemeController extends ChangeNotifier {
  static const String _storageKey = 'selected_armory_theme_id';
  static const String _fontKey = 'selected_armory_font';
  static const String _colorKey = 'custom_neon_color';

  ArmoryTheme _activeTheme = allThemes.first; 
  ArmoryTheme get activeTheme => _activeTheme;

  Color _customColor = const Color(0xFF00FFCC); 
  Color get customColor => _customColor;

  String _activeFont = 'Stock';
  String get activeFont => _activeFont;

  String _lastViewedPatchDate = "";
  bool _hasNewPatch = false;
  Map<String, dynamic>? _currentPatchData;

  bool get hasNewPatch => _hasNewPatch;
  Map<String, dynamic>? get currentPatchData => _currentPatchData;

Future<void> syncPatchNotes(String serverUrl) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    _lastViewedPatchDate = prefs.getString('last_viewed_patch_date') ?? "";

    final response = await http.get(Uri.parse("$serverUrl/cdn/hotfixes.json")); 
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _currentPatchData = data;
      
      String serverDate = data['patch_date'] ?? "";

      if (serverDate != _lastViewedPatchDate) {
        _hasNewPatch = true;
      }
      notifyListeners();
    }
  } catch (e) {
    debugPrint("Patch Sync Error: $e");
  }
}

Future<void> markPatchRead() async {
  if (_currentPatchData == null) return;
  
  final prefs = await SharedPreferences.getInstance();
  String serverDate = _currentPatchData!['patch_date'];
  
  await prefs.setString('last_viewed_patch_date', serverDate);
  _hasNewPatch = false;
  notifyListeners();
}

  Future<void> resetToDefault() async {
    _activeTheme = allThemes.first; 
    _activeFont = 'Stock';
    _customColor = const Color(0xFF00FFCC);

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, 'stock');
    await prefs.setString(_fontKey, 'Stock');
    await prefs.remove(_colorKey);
  }

  Color get activeAccentColor {
    if (_activeTheme.isCustom) {
      return _customColor;
    }
    return _activeTheme.themeData.colorScheme.primary;
  }

  Future<void> updateCustomColor(Color newColor) async {
    _customColor = newColor;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorKey, newColor.toARGB32());
  }

static const Map<String, FontSpecs> fontConfigs = {
  'Black Ops One': FontSpecs(sizeScale: 1.05, strokeScale: 0.8, spacingAdd: 0.5),
  'Braah One': FontSpecs(sizeScale: 1.2, strokeScale: 0.9, spacingAdd: 0.0),
  'Bungee': FontSpecs(sizeScale: 1.0, strokeScale: 0.7, spacingAdd: 0.2),
  'Stock': FontSpecs(sizeScale: 1.1, strokeScale: 1.0, spacingAdd: 0.0),
  'Fugaz One': FontSpecs(sizeScale: 1.1, strokeScale: 1.0, spacingAdd: 0.0),
  'Germania One': FontSpecs(sizeScale: 1.2, strokeScale: 1.0, spacingAdd: 0.0),
  'Kaushan Script': FontSpecs(sizeScale: 1.1, strokeScale: 0.8, spacingAdd: 0.0),
  'Orbitron': FontSpecs(sizeScale: 0.9, strokeScale: 1.0, spacingAdd: 1.2),
  'Permanent Marker': FontSpecs(sizeScale: 1.1, strokeScale: 0.8, spacingAdd: 0.0),
  'Quantico': FontSpecs(sizeScale: 1.1, strokeScale: 1.0, spacingAdd: 0.8),
  'Racing Sans': FontSpecs(sizeScale: 1.2, strokeScale: 1.0, spacingAdd: 0.0),
  'Silkscreen': FontSpecs(sizeScale: 1, strokeScale: 0.5, spacingAdd: 0.0),
  'Vast Shadow': FontSpecs(sizeScale: 0.85, strokeScale: 0.6, spacingAdd: 0.1),
};

  static const List<String> availableFonts = [
    'Stock',
    'Black Ops One',
    'Braah One',
    'Bungee',
    'Fugaz One',
    'Germania One',
    'Kaushan Script',
    'Orbitron',
    'Permanent Marker',
    'Quantico',
    'Racing Sans',
    'Silkscreen',
    'Vast Shadow',
  ];

  Future<void> setFont(String fontFamily) async {
    if (_activeFont != fontFamily) {
      _activeFont = fontFamily;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_fontKey, fontFamily);
    }
  }

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
    _activeFont = prefs.getString(_fontKey) ?? 'Stock';

    final int? savedColor = prefs.getInt(_colorKey);
    if (savedColor != null) {
      _customColor = Color(savedColor);
    }

    final String? savedId = prefs.getString(_storageKey);
    if (savedId != null) {
      try {
        _activeTheme = allThemes.firstWhere((t) => t.id == savedId);
      } catch (e) {
        debugPrint("Theme persistence error: $e");
      }
    }
    notifyListeners(); 
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
          surface: Color.fromARGB(255, 6, 8, 10)
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

    ArmoryTheme(
      id: 'lavender',
      name: 'LAVENDER',
      pickerBoxColor: Color.fromRGBO(62, 67, 142, 1),
      pickerBorderColor: Color.fromRGBO(169, 166, 240, 1),
      pickerTextColor: Colors.white,
      useWhiteSearch: true,
      category: ThemeCategory.simple,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1775037164/0e6fade917607899390658ea1dd92ff7_nsgwnr.jpg',
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 209, 216, 242),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(169, 166, 240, 1),
          surface: Color.fromRGBO(46, 53, 93, 1),
        ),
        useMaterial3: true,
        fontFamily: 'Days One'
      ),
    ),

    ArmoryTheme(
      id: 'pastel',
      name: 'PASTEL',
      pickerBoxColor: Color.fromRGBO(248, 199, 233, 1),
      pickerBorderColor: Color.fromRGBO(199, 146, 198, 1),
      pickerTextColor: Colors.white,
      useWhiteSearch: true,
      category: ThemeCategory.simple,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1775037164/10b73edae925923deb995ac672377b07_ubtq9e.jpg',
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 242, 209, 237),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(255, 198, 238, 1),
          surface: Color.fromRGBO(89, 65, 85, 1)
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
        primaryColor: const Color.fromRGBO(131, 247, 250, 1),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(131, 247, 250, 1),
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
        primaryColor: const Color.fromRGBO(191, 170, 229, 1),
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
        primaryColor: const Color.fromRGBO(100, 225, 242, 1),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(100, 225, 242, 1),
          surface: Color.fromRGBO(30, 34, 47, 1)
        ),
        useMaterial3: true,
        fontFamily: 'Days One'
      ),
    ),

    ArmoryTheme(
      id: 'anemone_magma',
      name: 'MAGMA',
      pickerGradient: [
        const Color.fromRGBO(249, 129, 46, 1),
        const Color.fromRGBO(239, 117, 42, 1),
        const Color.fromRGBO(59, 54, 50, 1),
        const Color.fromARGB(255, 12, 13, 18),
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.anemone,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771474845/6ddf9604cce49a7365fb18ba38049c9b_va0juo.jpg',
      borderGradient: [
        const Color.fromRGBO(249, 129, 46, 1),
        const Color.fromRGBO(239, 117, 42, 1),
        const Color.fromRGBO(59, 54, 50, 1),
        const Color.fromARGB(255, 12, 14, 19),
      ],

      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(249, 129, 46, 1),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(249, 129, 46, 1),
          surface: Color.fromRGBO(22, 17, 13, 1)
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
      Color.fromRGBO(255, 249, 237, 1),
      Color.fromRGBO(234, 223, 66, 1),
      Color.fromRGBO(236, 185, 43, 1),
      Color.fromRGBO(225, 132, 26, 1),
      Color.fromRGBO(255, 249, 237, 1),
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
      Color.fromRGBO(255, 249, 237, 1),
      Color.fromRGBO(234, 223, 66, 1),
      Color.fromRGBO(236, 185, 43, 1),
      Color.fromRGBO(238, 143, 34, 1),
      Color.fromRGBO(255, 249, 237, 1),
      ],
      themeData: ThemeData(
        fontFamily: 'Days One',
        colorScheme: ColorScheme.dark(
          primary: Color.fromRGBO(236, 185, 43, 1),
          surface: const Color.fromARGB(255, 34, 29, 11),
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
          surface: Color.fromARGB(255, 34, 19, 36),
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
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771474845/57bac4a8159b240cff6ae3f9b941d682_tmm2aj.jpg',
      borderGradient: [const Color.fromARGB(255, 255, 255, 255), Colors.black],
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 255, 255, 255),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 255, 255, 255),
          surface: Color.fromARGB(255, 18, 18, 18),
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
        primaryColor: const Color.fromRGBO(85, 44, 162, 1),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(85, 44, 162, 1),
          surface: Color.fromARGB(255, 17, 13, 26),
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
          surface: Color.fromARGB(255, 6, 32, 27),
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
        primaryColor: const Color.fromRGBO(168, 76, 98, 1),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(168, 76, 98, 1),
          surface: Color.fromRGBO(90, 35, 55, 1),
        ),
        useMaterial3: true,
        fontFamily: 'Days One',
      ),
    ),

    ArmoryTheme(
      id: 'holographic_aether',
      name: 'DARK AETHER',
      pickerGradient: [
        Color.fromRGBO(218, 213, 255, 1),
        Color.fromRGBO(105, 100, 139, 1),
        Color.fromRGBO(138, 129, 207, 1),
        Color.fromRGBO(210, 209, 255, 1),
        Color.fromRGBO(126, 117, 195, 1),
        Color.fromRGBO(113, 107, 152, 1),
        Color.fromRGBO(218, 213, 255, 1),
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.premium,
      isHolographic: true,
      refractionColors: [
        Color.fromRGBO(218, 213, 255, 1),
        Color.fromRGBO(105, 100, 139, 1),
        Color.fromRGBO(138, 129, 207, 1),
        Color.fromRGBO(210, 209, 255, 1),
        Color.fromRGBO(126, 117, 195, 1),
        Color.fromRGBO(113, 107, 152, 1),
        Color.fromRGBO(218, 213, 255, 1),
      ],
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1775037164/95a8ed4b259d0812400456449b1c39da_bzbslk.jpg',
      borderGradient: [Colors.purple, Colors.black],
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(138, 129, 207, 1),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(141, 101, 193, 1),
          surface: Color.fromRGBO(38, 28, 55, 1),
        ),
        useMaterial3: true,
        fontFamily: 'Days One',
      ),
    ),

    ArmoryTheme(
      id: 'holographic_opal',
      name: 'OPAL',
      pickerGradient: [
        Color.fromRGBO(195, 195, 196, 1),
        Color.fromRGBO(247, 225, 144, 1),
        Color.fromRGBO(243, 166, 142, 1),
        Color.fromRGBO(239, 150, 187, 1),
        Color.fromRGBO(167, 152, 247, 1),
        Color.fromRGBO(142, 184, 245, 1),
        Color.fromRGBO(104, 237, 242, 1),
        Color.fromRGBO(168, 253, 179, 1),
        Color.fromRGBO(195, 195, 196, 1),
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.premium,
      isHolographic: true,
      refractionColors: [
        Color.fromRGBO(195, 195, 196, 1),
        Color.fromRGBO(247, 225, 144, 1),
        Color.fromRGBO(243, 166, 142, 1),
        Color.fromRGBO(239, 150, 187, 1),
        Color.fromRGBO(167, 152, 247, 1),
        Color.fromRGBO(142, 184, 245, 1),
        Color.fromRGBO(104, 237, 242, 1),
        Color.fromRGBO(168, 253, 179, 1),
        Color.fromRGBO(195, 195, 196, 1),
      ],
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1775037164/bc5bba399ba21918cdaf1c51e8bdf59b_gihjwe.jpg',
      borderGradient: [Colors.purple, Colors.black],
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(142, 184, 245, 1),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(142, 184, 245, 1),
          surface: Color.fromRGBO(44, 44, 44, 1),
        ),
        useMaterial3: true,
        fontFamily: 'Days One',
      ),
    ),



    // NEON



    ArmoryTheme(
  id: 'neon_custom',
  name: 'NEON',
  category: ThemeCategory.neon,
  isCustom: true,
  backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1772174945/a8fb4ca06a6bc64c917a045cab6d091c_xotol4.jpg', 
  themeData: ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color.fromARGB(255, 0, 0, 0), 
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 0, 0, 0),
      surface: Color.fromARGB(0, 0, 0, 0),
    ),
  ),
),


  ];
}