// ignore_for_file: unused_local_variable, unused_element_parameter, unused_element, non_constant_identifier_names, curly_braces_in_flow_control_structures, use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'package:web/web.dart' as web;
import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
import 'package:armory_app/themes.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:math' as math;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:armory_app/services/purchase_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:armory_app/services/image_cache_service.dart';


const String globalNgrokUrl = "https://cherty-frowningly-rickie.ngrok-free.dev";

const Map<String, String> _legacyArchetypes = {
  // --- MODERN WARFARE (2019) ---
  "AK-47 (MW19)": "Assault Rifle",
  "AN-94": "Assault Rifle",
  "AS VAL (MW19)": "Assault Rifle",
  "AUG (MW19)": "Assault Rifle",
  "CR-56 AMAX (MW19)": "Assault Rifle",
  "FAL": "Battle Rifle",
  "FN SCAR 17": "Assault Rifle",
  "FR 5.56 (MW19)": "Assault Rifle",
  "GRAU 5.56": "Assault Rifle",
  "KILO 141 (MW19)": "Assault Rifle",
  "M13": "Assault Rifle",
  "M4A1 (MW19)": "Assault Rifle",
  "ODEN": "Assault Rifle",
  "RAM-7 (MW19)": "Assault Rifle",
  "SA87": "LMG",
  "CX-9": "SMG",
  "FENNEC (MW19)": "SMG",
  "ISO (MW19)": "SMG",
  "MP5 (MW19)": "SMG",
  "MP7": "SMG",
  "P90": "SMG",
  "PP19 BIZON (MW19)": "SMG",
  "STRIKER 45 (MW19)": "SMG",
  "UZI": "SMG",
  "BRUEN MK9 (MW19)": "LMG",
  "FiNN LMG": "LMG",
  "FINN LMG": "LMG",
  "HOLGER-26 (MW19)": "LMG",
  "M91": "LMG",
  "MG34": "LMG",
  "PKM": "LMG",
  "RAAL MG (MW19)": "LMG",
  "725": "Shotgun",
  "JAK-12": "Shotgun",
  "MODEL 680 (MW19)": "Shotgun",
  "ORIGIN 12": "Shotgun",
  "R9-0": "Shotgun",
  "VLK ROGUE": "Shotgun",
  "CROSSBOW (MW19)": "Marksman Rifle",
  "EBR-14 (MW19)": "Marksman Rifle",
  "KAR98K (MW19)": "Marksman Rifle",
  "MK2 CARBINE": "Marksman Rifle",
  ".50 GS (MW19)": "Pistol",
  "1911 (MW19)": "Pistol",
  "M19": "Pistol",
  "RENETTI (MW19)": "Pistol",
  "SYKOV": "Pistol",
  "X16": "Pistol",
  "MAGNUM (MW19)": "Pistol",

  // --- COLD WAR ---
  "AK-47 (CW)": "Assault Rifle",
  "AK-74U": "SMG",
  "C58": "Assault Rifle",
  "EM2": "Assault Rifle",
  "FARA 83": "Assault Rifle",
  "FFAR 1 (CW)": "Assault Rifle",
  "GRAV": "Assault Rifle",
  "GROZA": "Assault Rifle",
  "KRIG 6 (CW)": "Assault Rifle",
  "QBZ-83": "Assault Rifle",
  "UGR": "SMG",
  "VARGO 52": "Assault Rifle",
  "XM4 (CW)": "Assault Rifle",
  "BULLFROG": "SMG",
  "KSP 45": "SMG",
  "LAPA": "SMG",
  "LC10 (CW)": "SMG",
  "MAC-10": "SMG",
  "MILANO 821": "SMG",
  "MP5 (CW)": "SMG",
  "OTS 9": "SMG",
  "PPSH-41 (CW)": "SMG",
  "TEC-9": "SMG",
  "M60": "LMG",
  "MG 82": "LMG",
  "RPD": "LMG",
  "STONER 63": "LMG",
  "AUG (CW)": "Tactical Rifle",
  "CARV.2": "Tactical Rifle",
  "DMR 14": "Tactical Rifle",
  "M16 (CW)": "Tactical Rifle",
  "TYPE 63": "Tactical Rifle",
  ".410 IRONHIDE": "Shotgun",
  "GALLO SA12": "Shotgun",
  "HAUER 77": "Shotgun",
  "STREETSWEEPER": "Shotgun",
  "LW3 TUNDRA": "Sniper",
  "M82": "Sniper",
  "PELINGTON 703": "Sniper",
  "SWISS K31": "Sniper",
  "ZRG 20MM": "Sniper",
  "1911 (CW)": "Pistol",
  "AMP63": "Pistol",
  "DIAMATTI": "Pistol",
  "MAGNUM (CW)": "Pistol",
  "MARSHAL": "Pistol",
};

Future<String> loadHotfixedJson(String assetPath) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    // Match the storage naming structure used in _syncData
    String keyName = 'cached_file_${assetPath.replaceFirst('assets/', '')}';
    
    if (prefs.containsKey(keyName)) {
      String? cachedData = prefs.getString(keyName);
      if (cachedData != null && cachedData.isNotEmpty) {
        return cachedData;
      }
    }
  } catch (e) {
    debugPrint("⚠️ Web cache read failed, falling back to asset bundle: $e");
  }
  
  // Fallback to embedded web assets if no hotfix is cached
  return await rootBundle.loadString(assetPath);
}

Map<String, Map<String, double>>? minMaxAnchors;
Map<String, String> _archetypeLookup = {};

Future<void> loadMinMaxData(String langCode) async {
  try {
    final String response = await loadHotfixedJson('assets/MinMax.json');
    
    final Map<String, dynamic> data = json.decode(response);
    final List<dynamic> rows = data['MinMax'];

    final minRow = rows.firstWhere((r) => r['id'] == 1);
    final maxRow = rows.firstWhere((r) => r['id'] == 2);
    
    minMaxAnchors = {};
    const categories = ['ar', 'smg', 'lmg', 'marksman', 'battle'];
    
    for (var cat in categories) {
      minMaxAnchors![cat] = {
        'min': double.tryParse(minRow[cat].toString()) ?? 500.0,
        'max': double.tryParse(maxRow[cat].toString()) ?? 1000.0,
      };
    }
  } catch (e) {
    debugPrint("❌ Sync Error: $e");
    minMaxAnchors = {
      "ar": {"min": 588.0, "max": 816.0},
      "smg": {"min": 520.0, "max": 680.0},
      "lmg": {"min": 511.0, "max": 804.0},
      "marksman": {"min": 671.0, "max": 1353.0},
      "battle": {"min": 480.0, "max": 800.0},
    };
  }
}

Future<void> loadArchetypeData() async {
  try {
    final String response = await loadHotfixedJson('assets/archetypes.json');
    final Map<String, dynamic> data = json.decode(response);
    final Map<String, dynamic> archetypes = data['archetypes'];

    Map<String, String> newLookup = {};
    
    archetypes.forEach((category, weapons) {
      if (weapons is List) {
        for (var weapon in weapons) {
          newLookup[weapon.toString().toUpperCase()] = category.toString().toUpperCase();
        }
      }
    });

    _archetypeLookup = newLookup;
    debugPrint("✅ Archetypes Synced: ${newLookup.length} weapons mapped.");
  } catch (e) {
    debugPrint("❌ Archetype Sync Error: $e");
  }
}

final Set<String> _opticDictionary = {"REMUDA MINI REFLEX", "OTERO MICRO DOT", "KEPLER MICROFLEX", "MERLIN MINI",
"PRISMATECH REFLEX", "VOLZHSKIY REFLEX", "MERLIN REFLEX", "REDWELL REFLEX", "DOBRYCH MF REFLEX",
"ACCU-SPOT REFLEX", "K&S RED DOT", "KEPLER RED DOT", "OTERO RED DOT", "OM3 '92 HOLO", "PINPOINT HOLOSCOUT",
"ACCU-SPOT ULTRA HOLO", "JASON ARMORY 2X", "WILLIS 3X", "PRISMATECH 4X", "DOBRYCH 4X", "PINPOINT HYBRID",
"PRISMAPOINT HYBRID", "HAWKER HYBRID", "R&K MULTIZOOM", "REMUDA RANGE FINDER", "VMF VARIABLE SCOPE",
"REDWELL CUSTOM ZOOM", "OTERO THERMAL 2X", "LTI MINI", "VAS MICROFLEX", "LETHAL TOOLS ELO", "EAM MICRO DOT",
"VAS LED", "KEPLER-PRO RED DOT", "LTI REFLEX", "GREAVES RED DOT", "K&S SLIM REFLEX", "EAM XL REFLEX",
"PRISMATECH DIGITAL HOLO", "EMT3 HOLO MK.2", "KEPLER T-RANGE HOLO", "SOLARIS HOLO-IR", "EAM DYAD XL",
"LTI TARGET FINDER V.2", "MILLIMETER SCANNER", "REDWELL 30-S 2X", "GREAVES ACCUSPOT 3X", "KEPLER ULTRA 4X",
"PRISMATECH TURBO 4X", "VAS DUO HYBRID SIGHT", "BOWEN X-25 IR", "EAM DUAL ZOOM", "GREAVES ULTRA ZOOM",
"RISTRAUCH 7X", "VAS STRIX 6X THERMAL", "K&S THERMAL HOLO", "BLANDWELL 7X SCOPE", "REMUDA DUAL ZOOM",
"THERMAL 6X", "KEPLER CUSTOM WVT-08", "CIRCUIT-Z RANGEFINDER", "SLATE REFLECTOR", "NYDAR MODEL 2023",
"MK. 3 REFLECTOR", "JAK BULLSEYE", "JAK GLASSLESS OPTIC", "CRONEN INTLAS MSP-12", "JAK NRG-IV OPTIC",
"TPS INCENDIO RELFEX", "MORS DOT SIGHT", "VLK 3.0X OPTIC", "VLK 4.0 OPTIC", "AIM OP-V4", "CORIO EAGLESEYE 2.5X",
"SOLOZERO NVG ENHANCED", "MERC THERMAL OPTIC", "SNIPER SCOPE", "VARIABLE ZOOM SCOPE", "SP-X 80 6.6X",
"DS FARSIGHT 11 SCOPE", "MCPR-300 9.5X SCOPE", "CORIO 13X VRS", "MILLSTOP REFLEX", "VISIONTECH 2X",
"KOBRA RED DOT", "QUICKDOT LED", "AXIAL ARMS 3X", "SILLIX HOLOSCOUT", "MICROFLEX LED", "HAWKSMOOR",
"LETHAL TOOLS ELO OPTIC", "FANG HOVERPOINT ELO", "VIPER REFLEX", "G.I. MINI REFLEX"};

final RegExp _prestigeRegex = RegExp(r'\s*\(PRESTIGE\)', caseSensitive: false);
final RegExp _akimboRegex = RegExp(r'\s*AKIMBO', caseSensitive: false);
final RegExp _codeRegex = RegExp(r'^[A-Z]\d{2}-');

final ValueNotifier<double> masterBorderNotifier = ValueNotifier(0.0);

class SyncProvider extends StatefulWidget {
  final Widget child;
  const SyncProvider({super.key, required this.child});

  @override
  State<SyncProvider> createState() => _SyncProviderState();
}

class _SyncProviderState extends State<SyncProvider> 
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _controller.addListener(_onTick);
  }

  void _onTick() {
    if (_controller.isAnimating) {
      masterBorderNotifier.value = _controller.value;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  if (kIsWeb) {
    try {
      final storage = web.window.navigator.storage;
      final persisted = await storage.persist().toDart;
      
      debugPrint("Storage persistent: $persisted");
    } catch (e) {
      debugPrint("Could not request persistence: $e");
    }
  }

  if (defaultTargetPlatform != TargetPlatform.linux || kIsWeb) {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      
      // Only set up Crashlytics if we are NOT on the web
      if (!kIsWeb) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      } else {
        debugPrint("🌐 Running on Web: Crashlytics reporting bypassed.");
      }
    } catch (e) {
      debugPrint("Firebase init failed: $e");
    }
  }

  PurchaseService.initialize("guest", (_) {});

  final themeController = ThemeController();
  await themeController.loadSavedTheme();
  
  final aegisArc = AegisArc();
  await aegisArc.loadSavedLanguage();

  await loadMinMaxData(aegisArc.languageCode);
  
  runApp(
    AppRestartWrapper(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: aegisArc),
          ChangeNotifierProvider.value(value: themeController),
        ],
        child: SyncProvider(
          child: MyApp(
            themeController: themeController, 
            allPremiumStats: [],
          ),
        ),
      ),
    ),
  );
}

class CombatRating {
  final String label;
  final String description;

  CombatRating(this.label, this.description);
}

class WeaponBuild {
  final String category;
  final List<String> attachments;
  final List<String> starredAttachments;
  final List<String> buildCodes;
  final String? specialtyValue;
  final String? modName;
  final WeaponStats? stats;
  final WeaponStats? alternativeStats;

  WeaponBuild({
    required this.category,
    required this.attachments,
    required this.starredAttachments,
    required this.buildCodes,
    this.specialtyValue,
    this.modName,
    this.stats,
    this.alternativeStats,
  });
}

class WeaponStats {
  final String ttk1;
  final String? range1;
  final String adsSpeed;
  final String bulletVelocity;
  final String shotsToKill;
  final String ttk2;
  final String range2;
  final String hitscanRange;
  final String? shotRange;
  
  String? archetype;
  CombatRating? combatRating; 

  WeaponStats({
    required this.ttk1,
    required this.range1,
    required this.adsSpeed,
    required this.bulletVelocity,
    required this.shotsToKill,
    required this.ttk2,
    required this.range2,
    required this.hitscanRange,
    this.archetype,
    this.shotRange,
    this.combatRating,
  });
}

class Weapon {
  final String name;
  final String imageUrl;
  final String gameLogoUrl;
  final Map<String, List<WeaponBuild>> builds;

  final int? rank; 
  final String? classType;
  final String? game;

  Weapon({
    required this.name, 
    required this.imageUrl, 
    required this.gameLogoUrl, 
    required this.builds,
    this.rank,
    this.classType,
    this.game,
  });
}

class MetaWeapon {
  final String name;
  final String searchKey;
  final int? rank;
  final String game;
  final String classType;
  final String? weaponImage;
  final String? gameImage;

  MetaWeapon({
    required this.name,
    required this.searchKey,
    this.rank,
    required this.game,
    required this.classType,
    this.weaponImage,
    this.gameImage,
  });

  factory MetaWeapon.fromJson(
    Map<String, dynamic> json, 
    Map<String, dynamic>? imageEntry, 
    {String? searchName}
  ) {
    return MetaWeapon(
      name: json['weapon'] ?? "UNKNOWN",
      searchKey: searchName ?? json['weapon']?.toString().replaceFirst('•', '').trim() ?? "",
      rank: !json['weapon'].toString().startsWith('•') 
          ? int.tryParse(json['weapon'].toString().split('.')[0]) 
          : null,
      game: json['game'] ?? "",
      classType: json['class_type'] ?? "",
      weaponImage: imageEntry?['weapon_image'],
      gameImage: imageEntry?['game_image'],
    );
  }
}

class MyApp extends StatelessWidget {
  final ThemeController themeController;
  const MyApp({super.key, required this.themeController, required List<dynamic> allPremiumStats});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        final baseTheme = themeController.activeTheme.themeData;

        final bool supportsAnalytics = !kIsWeb && 
            (defaultTargetPlatform == TargetPlatform.android || 
            defaultTargetPlatform == TargetPlatform.iOS);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: [
            if (supportsAnalytics)
              FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
          ],
          theme: baseTheme.copyWith(
            textTheme: baseTheme.textTheme.apply(
              fontFamily: themeController.activeFont,
            ),
            primaryTextTheme: baseTheme.primaryTextTheme.apply(
              fontFamily: themeController.activeFont,
            ),
          ),
          home: LoadingScreen(themeController: themeController), 
        );
      },
    );
  }
}

class ArmoryGradientBorder extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;
  final double strokeWidth;
  final double borderRadius;
  final Alignment begin;
  final Alignment end;

  const ArmoryGradientBorder({
    super.key,
    required this.child,
    required this.gradientColors,
    this.strokeWidth = 2.0,
    this.borderRadius = 12.0,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientPainter(
        strokeWidth: strokeWidth,
        radius: borderRadius,
        gradient: LinearGradient(
          colors: gradientColors,
          begin: begin,
          end: end,
        ),
      ),
      child: child,
    );
  }
}

class _GradientPainter extends CustomPainter {
  final double strokeWidth;
  final double radius;
  final Gradient gradient;

  _GradientPainter({required this.strokeWidth, required this.radius, required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..shader = gradient.createShader(rect);

    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LoadingScreen extends StatefulWidget {
  final ThemeController themeController;
  
  const LoadingScreen({super.key, required this.themeController});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  List<Weapon> _loadedWeapons = [];
  bool _dataReady = false;
  bool _isPremiumUser = false;

  @override
  void initState() {
    super.initState();
    _performPreload();
  }

Future<void> _performPreload({bool isLanguageSwitch = false}) async {
    _loadedWeapons.clear();
  setState(() => _dataReady = false);

  final locale = Provider.of<AegisArc>(context, listen: false);
  await locale.loadSavedLanguage();
  await locale.loadMasterDictionary();
  await Future.delayed(const Duration(milliseconds: 100));
  final String code = locale.languageCode;

  try {
    Future<bool>? premiumTask;
    if (!isLanguageSwitch) {
      premiumTask = _verifyPremiumStatus();
    }

    final List<String> buildFiles = [
      'assets/Akimbo.json', 'assets/Cold_War_Akimbo.json',
      'assets/Cold_War_Single.json', 'assets/Endgame_BO7.json',
      'assets/Multiplayer_BO7.json', 'assets/Multiplayer_Cold_War.json',
      'assets/Multiplayer_MW19.json', 'assets/Multiplayer_MW3_BO6.json',
      'assets/REBIRTH.json', 'assets/Single.json',
      'assets/Special.json', 'assets/Warzone_BO6.json',
      'assets/Warzone_BO7.json', 'assets/Warzone_MW3_MW2.json',
      'assets/Zombies_BO7.json', 'assets/Zombies_Cold_War.json',
      'assets/Zombies_MW3_BO6.json',
    ];

    final List<Future<String>> loadFutures = buildFiles.map((path) => loadHotfixedJson(path)).toList();
    loadFutures.add(loadHotfixedJson('assets/Weapon_Names.json'));
    loadFutures.add(loadHotfixedJson('assets/Premium_Stats.json'));
    loadFutures.add(loadHotfixedJson('assets/hotfixes.json'));

    final allRawData = await Future.wait(loadFutures);

    if (premiumTask != null) {
      _isPremiumUser = await premiumTask;
    }

    await Future.delayed(const Duration(milliseconds: 600));
    await loadArchetypeData();

    // Strictly Web: Removed 'await' since _heavyDataProcessing runs synchronously inline
    _loadedWeapons = _heavyDataProcessing({
      'buildJsons': allRawData.sublist(0, buildFiles.length),
      'namesJson': allRawData[allRawData.length - 3],
      'statsJson': allRawData[allRawData.length - 2],
      'filePaths': buildFiles,
      'archetypeLookup': _archetypeLookup,
    });

    if (mounted) {
      setState(() => _dataReady = true);
      _checkTransition();
    }
  } catch (e) { // Removed unused ', stack' parameter
    debugPrint("Background Sync Preload Error: $e");
    if (mounted) {
      setState(() => _dataReady = true);
      _checkTransition();
    }
  }
}

  Future<bool> _verifyPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString('saved_discord_id');
    final savedPin = prefs.getString('saved_pin');
    if (savedId == null || savedPin == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$globalNgrokUrl/verify-premium?user_id=$savedId&pin=$savedPin'),
        headers: {"ngrok-skip-browser-warning": "true"},
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        bool isPrem = data['premium'] == true;
        await prefs.setBool('is_premium_user', isPrem);
        return isPrem;
      }
    } catch (e) {
      debugPrint("Background Premium Check Failed: $e");
    }
    return prefs.getBool('is_premium_user') ?? false;
}

  void _checkTransition() {
    if (_dataReady && mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, anim, secAnim) => MyHomePage(
            preloadedData: _loadedWeapons,
            initialPremiumStatus: _isPremiumUser,
            themeController: widget.themeController,
          ),
          transitionsBuilder: (context, anim, secAnim, child) {
            return FadeTransition(opacity: anim, child: child);
          },
          transitionDuration: const Duration(milliseconds: 250),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 30, height: 30,
          child: CircularProgressIndicator(
            color: Color.fromRGBO(2, 91, 207, 1),
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<Weapon> preloadedData;
  final bool initialPremiumStatus;
  final ThemeController themeController;

  const MyHomePage({
    super.key, 
    required this.preloadedData, 
    required this.initialPremiumStatus,
    required this.themeController,
  });
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum ConnectionStatus { connected, tunnelIssue, offline }
enum AppState { initializing, languageSelect, onboarding, booting, ready }
bool _hasRunBootSequence = false;
StreamSubscription<List<PurchaseDetails>>? _subscription;

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Map<String, dynamic>? _hotfixData;
  bool _hasNewHotfix = false;
  String? _savedDiscordId;
  final FocusNode _searchFocusNode = FocusNode();
  List<Weapon> _loadedWeapons = [];
  List<Weapon> displayList = [];
  bool _isPremiumUser = false;
  bool _initialized = false;
  bool _dataReady = true;
  bool showOnboarding = true;
  bool _hasRunBootSequence = false;
  AppState _currentState = AppState.initializing;
  bool _isManualReplay = false;
  final Set<String> _selectedArchetypes = {};

  bool _hotfixUpdated = false;
  bool _weaponDataUpdated = false;

  final TextEditingController _searchController = TextEditingController();

  ConnectionStatus _connectionStatus = ConnectionStatus.offline;
  Timer? _statusTimer;
  String _activeBaseUrl = "https://wormeo.github.io/armory-data";
  final String _fallbackProdUrl = "https://wormeo.github.io/armory-data";
  final String _devNgrokUrl = "https://cherty-frowningly-rickie.ngrok-free.dev";
  final bool _isDevMode = false; 

  Map<String, String> _getHeaders() {
    return {
      if (_activeBaseUrl.contains("ngrok")) "ngrok-skip-browser-warning": "true",
    };
  }

Future<void> _initializeAegisSource() async {
  if (_isDevMode) {
    _activeBaseUrl = _devNgrokUrl;
    debugPrint("🛠️ Dev Mode Active: Using Local Ngrok");
    return;
  }

  try {
    final response = await http.get(
      Uri.parse("$_fallbackProdUrl/redirector.json?t=${DateTime.now().millisecondsSinceEpoch}")
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      final config = json.decode(response.body);
      _activeBaseUrl = config['active_cdn_url'] ?? _fallbackProdUrl;
      debugPrint("🚀 Aegis Source Set: $_activeBaseUrl");
    }
  } catch (e) {
    debugPrint("⚠️ Redirector failed, using fallback: $e");
    _activeBaseUrl = _fallbackProdUrl;
  }
}

  Widget _SearchField({required Function(String) onChanged, required ThemeController themeController, required TextEditingController controller,}) {
  final activeTheme = themeController.activeTheme;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
  final bool isHolographic = activeTheme.isHolographic;
  final bool isCustom = activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;
  final activeFont = themeController.activeFont;
  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final locale = Provider.of<AegisArc>(context);
  final String code = locale.languageCode;
  const String rawHint = "SEARCH WEAPONS OR ARCHETYPES...";

  final String translatedHint = (code != 'en' && uiTranslations[code]?.containsKey(rawHint) == true)
      ? uiTranslations[code]![rawHint]!
      : rawHint;

  final bool hasSpecialWrapper = _isPremiumUser && (isHolographic || isAnemone || isCustom);

  final Color themePrimary = activeTheme.themeData.colorScheme.primary;
  final Color fallbackBorderColor = (themePrimary == Colors.black || themePrimary.opacity < 0.1) 
      ? Colors.white30 
      : themePrimary;

  final Color activeBorderColor = isCustom ? coreColor : fallbackBorderColor;

  Color inputIconColor = (isCustom && _isPremiumUser) 
      ? coreColor 
      : (activeTheme.useWhiteSearch ? Colors.white : fallbackBorderColor);

  Widget textField = TextField(
    controller: controller,
    focusNode: _searchFocusNode,
    onChanged: onChanged,
    autocorrect: true,
    textCapitalization: TextCapitalization.sentences,
    enableSuggestions: true,
    textInputAction: TextInputAction.search,
    onSubmitted: (_) => _searchFocusNode.unfocus(),
    onTapOutside: (event) => _searchFocusNode.unfocus(),
    
    decoration: InputDecoration(
      hintText: translatedHint,
      hintStyle: TextStyle(
        color: Colors.white38,
        fontSize: 11,
        fontFamily: activeFont,
      ),
      suffixIcon: IconButton(
        icon: Icon(Icons.tune, color: inputIconColor, size: 20),
        onPressed: () {
          HapticFeedback.lightImpact();
          _showFilterSheet(themeController);
        },
      ),
      
      filled: true,
      fillColor: isCustom 
          ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.98) 
          : activeTheme.themeData.colorScheme.surface.withOpacity(0.9),
      
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: hasSpecialWrapper 
            ? BorderSide.none 
            : BorderSide(
                color: activeBorderColor.withOpacity(0.5), 
                width: 1.5
              ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: hasSpecialWrapper 
            ? BorderSide.none 
            : BorderSide(
                color: activeBorderColor, 
                width: 2.2
              ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    ),
  );

  Widget finalSearch;
  if (isHolographic && _isPremiumUser) {
    finalSearch = _InternalAnimatedBorder(colors: activeTheme.refractionColors, borderRadius: 18, child: textField);
  } else if (isAnemone && _isPremiumUser) {
    finalSearch = ArmoryGradientBorder(gradientColors: activeTheme.borderGradient, borderRadius: 18, child: textField);
  } else if (isCustom && _isPremiumUser) {
    finalSearch = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: coreColor, width: 2.0),
          boxShadow: [
            BoxShadow(color: accentColor.withOpacity(0.8), blurRadius: 1, spreadRadius: 0.5),
            BoxShadow(color: accentColor.withOpacity(0.3), blurRadius: 15, spreadRadius: 2),
          ],
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(11), child: textField),
    );
  } else {
    finalSearch = textField;
  }

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: finalSearch,
  );
}

void _showFilterSheet(ThemeController themeController) {
  final activeTheme = themeController.activeTheme;
  final bool isCustom = activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final String activeFont = themeController.activeFont;

  final games = ["BO7", "BO6", "CW", "MW3", "MW2", "MW19"];

  final archetypes = [
    "AR", "SMG", "PISTOL", "SHOTGUN", "LMG", 
    "SNIPER", "MARKSMAN RIFLE", "BATTLE RIFLE", "TACTICAL RIFLE", "SPECIAL"
  ];
  
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero), 
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: isCustom ? const Color(0xFF000000) : Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.zero, 
              border: Border(
                top: BorderSide(
                  color: (isCustom ? coreColor : accentColor).withOpacity(
                    Theme.of(context).brightness == Brightness.light ? 0.3 : 1.0
                  ),
                  width: isCustom ? 4.5 : 2.0,
                ),
              ),
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                if (isCustom && Theme.of(context).brightness == Brightness.dark)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: accentColor.withOpacity(0.8), blurRadius: 6, spreadRadius: 2),
                          BoxShadow(color: accentColor.withOpacity(0.4), blurRadius: 25, spreadRadius: 8),
                        ],
                      ),
                    ),
                  ),
                
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ArmoryText(
                        "FILTER BY GAME",
                        themeController: themeController,
                        baseFontSize: 14,
                        baseStrokeWidth: 2.0,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: games.map((game) {
                            bool isSelected = _selectedArchetypes.contains(game); 
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    if (isSelected) {
                                      _selectedArchetypes.remove(game);
                                    } else {
                                      _selectedArchetypes.add(game);
                                    }
                                    search(_searchController.text);
                                  });
                                  setModalState(() {}); 
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? accentColor : Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: isSelected ? Colors.white : Colors.white10,
                                      width: 1.5,
                                    ),
                                    boxShadow: (isSelected && isCustom) ? [
                                      BoxShadow(color: accentColor.withOpacity(0.3), blurRadius: 8)
                                    ] : [],
                                  ),
                                  child: ArmoryText(
                                    game, 
                                    themeController: themeController,
                                    baseFontSize: 13,
                                    color: isSelected ? Colors.white : Colors.white54,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 35),
                      const Divider(color: Colors.white10, thickness: 1, indent: 40, endIndent: 40),
                      const SizedBox(height: 25),

                      ArmoryText(
                        "FILTER BY CATEGORY",
                        themeController: themeController,
                        baseFontSize: 14,
                        baseStrokeWidth: 2.0,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: archetypes.map((arch) {
                            bool isSelected = _selectedArchetypes.contains(arch);
                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  if (isSelected) _selectedArchetypes.remove(arch);
                                  else _selectedArchetypes.add(arch);
                                  search(_searchController.text);
                                });
                                setModalState(() {}); 
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? accentColor : Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(20), 
                                  border: Border.all(
                                    color: isSelected ? Colors.white : Colors.white10,
                                    width: 1.2,
                                  ),
                                ),
                                child: ArmoryText(
                                  arch,
                                  themeController: themeController,
                                  baseFontSize: 11,
                                  color: isSelected ? Colors.white : Colors.white54,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedArchetypes.clear();
                            search(_searchController.text);
                          });
                          setModalState(() {});
                        },
                        child: ArmoryText(
                          "RESET FILTERS",
                          themeController: themeController,
                          baseFontSize: 10,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      );
    },
  );
}

Future<void> _checkOnboardingStatus() async {
  final prefs = await SharedPreferences.getInstance();
  bool needsIntro = prefs.getBool('show_onboarding') ?? true;
  
  if (!mounted) return;

  setState(() {
    if (needsIntro || _isManualReplay) { 
      _currentState = AppState.onboarding;
    } else {
      _currentState = AppState.ready;
      _runBootSequence(); 
    }
    _initialized = true;
  });
}

void _startFirstTimeBootSequence() async {
  setState(() {
    _currentState = AppState.booting;
  });

  await loadArchetypeData();

  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('show_onboarding', false); 

  await _performPreload();
  
  await Future.delayed(const Duration(seconds: 3));

  if (mounted) {
    setState(() {
      _currentState = AppState.ready;
      _initialized = true;
    });
    _startConnectionHeartbeat();
    _runBootSequence(); 
  }
}

void _relaunchOnboarding() {
  HapticFeedback.mediumImpact();
  Navigator.pop(context);
  
  setState(() {
    _currentState = AppState.onboarding;
  });
}

Widget _buildFirstTimeLoadingVisual({Key? key}) {
  final primary = widget.themeController.activeTheme.themeData.colorScheme.primary;
  return Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ArmoryText(
            context.watch<AegisArc>().translateStatic("CONNECTING TO ARMORY CORE..."),
            themeController: widget.themeController,
            baseFontSize: 14,
            baseStrokeWidth: 2.0,
            color: primary,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              color: primary,
              backgroundColor: primary.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 20),
          ArmoryText(
            context.watch<AegisArc>().translateStatic("LOADING DATA FOR FIRST BOOT"),
            themeController: widget.themeController,
            baseFontSize: 10,
            baseStrokeWidth: 1.0,
            color: Colors.white54,
          ),
        ],
      ),
    ),
  );
}

Future<void> _initAppSequence() async {
  try {
    await _initializeAegisSource();
    _startConnectionHeartbeat();
    _checkConnection();

    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('manifest_version_key')) {
      const int shippingVersion = 9;
      await prefs.setInt('manifest_version_key', shippingVersion);
      debugPrint("📦 [AEGIS] Fresh install detected. Setting baseline to Version $shippingVersion");
    }

    bool hasLanguage = prefs.containsKey('selected_language');
    if (!hasLanguage) {
      setState(() {
        _currentState = AppState.languageSelect;
        _initialized = true;
      });
      return; 
    }

    bool needsIntro = prefs.getBool('show_onboarding') ?? true;
    if (needsIntro && !_isManualReplay) {
      setState(() {
        _currentState = AppState.onboarding;
        _initialized = true;
      });
      return; 
    }

    final String? storedId = prefs.getString('saved_discord_id');
    final String? storedPin = prefs.getString('saved_pin');
    final bool isPremium = prefs.getBool('is_premium_user') ?? false;

    setState(() {
      _savedDiscordId = storedId;
      _isPremiumUser = isPremium;
      _idController.text = storedId ?? "";
      _pinController.text = storedPin ?? "";
      _loadedWeapons = widget.preloadedData;
      displayList = List.from(widget.preloadedData);
      _sortDisplayList();
      
      _currentState = AppState.ready;
      _initialized = true;
    });

    if (storedId != null) PurchaseService.updateDiscordId(storedId);

    final aegisArc = Provider.of<AegisArc>(context, listen: false);
    widget.themeController.syncPatchNotes(_activeBaseUrl, aegisArc.languageCode);
    
    _runBootSequence(); 
    _loadFavorites();
    
  } catch (e) {
    debugPrint("Init Error: $e");
    setState(() {
      _currentState = AppState.ready;
      _initialized = true;
    });
  }
}

@override
void initState() {
  super.initState();
  
  WidgetsBinding.instance.addObserver(this);

  final aegisArc = Provider.of<AegisArc>(context, listen: false);

  PurchaseService.initialize(_savedDiscordId ?? "guest", (bool success) {
    if (success) {
      _handlePurchaseSuccess();
    } else { 
      _hideLoadingOverlay(); 
      _showErrorSnackBar("PURCHASE CANCELLED OR FAILED"); 
    }
  });

  _initAppSequence();

  // Guard Connectivity streams for web compatibility
  if (kIsWeb) {
    // Web handles online tracking gracefully via HTML window states
    debugPrint("🌐 Web Target: Using browser window metrics for network updates.");
    if (_activeBaseUrl.isNotEmpty) {
      _checkConnection();
    }
  } else {
    // Mobile platforms can still leverage the native platform channels safely
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.contains(ConnectivityResult.none)) {
        setState(() => _connectionStatus = ConnectionStatus.offline);
      } else {
        if (_activeBaseUrl.isNotEmpty) {
          _checkConnection();
        }
      }
    });
  }
}

Future<void> _performPreload({
  bool isLanguageSwitch = false, 
  String? forcedCode, 
  String? forcedSuffix
  
}) async {
  final locale = Provider.of<AegisArc>(context, listen: false);
  await locale.loadMasterDictionary();

  try {
    final List<String> buildFiles = [
      'assets/Akimbo.json', 'assets/Cold_War_Akimbo.json',
      'assets/Cold_War_Single.json', 'assets/Endgame_BO7.json',
      'assets/Multiplayer_BO7.json', 'assets/Multiplayer_Cold_War.json',
      'assets/Multiplayer_MW19.json', 'assets/Multiplayer_MW3_BO6.json',
      'assets/REBIRTH.json', 'assets/Single.json',
      'assets/Special.json', 'assets/Warzone_BO6.json',
      'assets/Warzone_BO7.json', 'assets/Warzone_MW3_MW2.json',
      'assets/Zombies_BO7.json', 'assets/Zombies_Cold_War.json',
      'assets/Zombies_MW3_BO6.json',
    ];

    final List<Future<String>> loadFutures = buildFiles.map((path) => loadHotfixedJson(path)).toList();
    loadFutures.add(loadHotfixedJson('assets/Weapon_Names.json'));
    loadFutures.add(loadHotfixedJson('assets/Premium_Stats.json'));
    loadFutures.add(loadHotfixedJson('assets/hotfixes.json'));

    final allRawData = await Future.wait(loadFutures);

    if (!isLanguageSwitch) {
      _isPremiumUser = widget.initialPremiumStatus;
    }

    final String hotfixRaw = allRawData.last;
    final Map<String, dynamic> hotfixData = json.decode(hotfixRaw);

    final processedWeapons = await compute(_heavyDataProcessing, {
      'buildJsons': allRawData.sublist(0, buildFiles.length),
      'namesJson': allRawData[allRawData.length - 3],
      'statsJson': allRawData[allRawData.length - 2],
      'filePaths': buildFiles, 
      'archetypeLookup': _archetypeLookup,
    });

    if (mounted) {
    setState(() {
      _loadedWeapons = processedWeapons;
      displayList = List.from(_loadedWeapons); 
      _sortDisplayList();
      _checkHotfixNotification(hotfixData);
      _dataReady = true;
    });
  }
    
    } catch (e, stack) {
    debugPrint("Background Sync Preload Error: $e");
    
    if (displayList.isEmpty && widget.preloadedData.isNotEmpty) {
      setState(() {
        _loadedWeapons = widget.preloadedData;
        displayList = List.from(widget.preloadedData);
      });
    }
    
    // Web Safe Guard: Prevent Crashlytics assertion errors from stopping execution
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Sync Preload Failed');
    }
  }
}

Future<void> refreshLanguageData(String targetCode, String targetSuffix) async {

  await _performPreload(
    isLanguageSwitch: true, 
    forcedCode: targetCode, 
    forcedSuffix: targetSuffix
  );

  await _loadHotfixData();

  await widget.themeController.syncPatchNotes(
    _activeBaseUrl, 
    targetCode, 
    forceRefresh: true
  );
}

void _showAcknowledgePopup() {
  final activeTheme = widget.themeController.activeTheme;
  final bool isNeon = activeTheme.id == 'neon_custom';
  final Color accent = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: AlertDialog(
          backgroundColor: isNeon ? Colors.black : const Color(0xFF0D0D0D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: isNeon ? coreColor : accent.withOpacity(0.5), width: 2),
          ),
          title: ArmoryText(
            "MANIFEST UPDATE",
            themeController: widget.themeController,
            baseFontSize: 14,
            color: accent,
          ),
          content: ArmoryText(
            "New hotfixes and weapon data tunings have been detected. Sync complete.",
            themeController: widget.themeController,
            baseFontSize: 11,
            allowWrap: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.themeController.markPatchRead();
              },
              child: ArmoryText(
                "ACKNOWLEDGE",
                themeController: widget.themeController,
                baseFontSize: 10,
                color: accent,
              ),
            ),
          ],
        ),
      );
    },
  );
}

void _checkHotfixNotification(Map<String, dynamic> hotfixData) async {
  final prefs = await SharedPreferences.getInstance();
  String? lastReadDate = prefs.getString('last_patch_notes_read');
  String currentHotfixDate = hotfixData['date'] ?? "";

  if (lastReadDate != currentHotfixDate) {
    setState(() {
      _hasNewHotfix = true; 
    });
  }
}

Widget _buildStatusIndicator() {
  final activeFont = widget.themeController.activeFont;
  Color statusColor;
  String statusText;
  
  switch (_connectionStatus) {
    case ConnectionStatus.connected:
      statusColor = Colors.greenAccent;
      statusText = "SYSTEM ONLINE";
      break;
    case ConnectionStatus.tunnelIssue:
      statusColor = Colors.amberAccent;
      statusText = "CORE UNREACHABLE";
      break;
    case ConnectionStatus.offline:
      statusColor = Colors.redAccent;
      statusText = "LINK OFFLINE";
      break;
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: statusColor,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: statusColor, blurRadius: 4)],
        ),
      ),
      const SizedBox(width: 8),

      ArmoryText(
        statusText,
        themeController: widget.themeController,
        baseFontSize: 7,
        baseStrokeWidth: 1.2,
        color: statusColor.withOpacity(0.9),
      ),
    ],
  );
}

@override
void dispose() {
  _subscription?.cancel();
  WidgetsBinding.instance.removeObserver(this);
  _connectivitySubscription?.cancel();
  _statusTimer?.cancel();
  _idController.dispose();
  _pinController.dispose();
  _searchFocusNode.dispose();
  super.dispose();
}

@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.resumed) {
    debugPrint("🛰️ [AEGIS] App returned to foreground. Invalidating state and re-verifying connection...");
    
    if (mounted) {
      setState(() {
        _connectionStatus = ConnectionStatus.tunnelIssue; 
      });
    }
    
    _checkConnection();
  }
}

void _startConnectionHeartbeat() {
  _checkConnection();
  _statusTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
    _checkConnection();
  });
}

void _showMetaDashboard() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MetaDashboardScreen(themeController: widget.themeController),
    ),
  );
}

Future<void> _runBootSequence() async {
  if (_hasRunBootSequence) return;

  if (displayList.isEmpty && _loadedWeapons.isNotEmpty) {
    setState(() {
      displayList = List.from(_loadedWeapons);
      _sortDisplayList();
    });
  }

  await Future.delayed(const Duration(milliseconds: 1000));
  if (!mounted) return;

  final themeController = widget.themeController;
  final activeTheme = themeController.activeTheme;
  final isCustom = activeTheme.id == 'neon_custom';
  final isHolographic = activeTheme.isHolographic;
  final isAnemone = activeTheme.category == ThemeCategory.anemone;
  final Color themeAccent = isCustom ? themeController.activeAccentColor : Theme.of(context).colorScheme.primary;
  final Color accent = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;
  final locale = Provider.of<AegisArc>(context, listen: false);

  final statusMessage = ValueNotifier<String>("");
  final statusColor = ValueNotifier<Color>(coreColor);

  void updateSlipstreamUI(String msg, Color color) {
    statusMessage.value = msg;
    statusColor.value = color;
  }

  void initSlipstreamSnack() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final Color neonBorderColor = Color.lerp(themeAccent, Colors.white, 0.35)!;
    Color borderColor = themeAccent.withOpacity(0.5);
    
    if (isHolographic && activeTheme.refractionColors.isNotEmpty) {
      borderColor = activeTheme.refractionColors.first;
    } else if (isAnemone && activeTheme.borderGradient.isNotEmpty) {
      borderColor = activeTheme.borderGradient.first;
    } else if (isCustom) {
      borderColor = neonBorderColor;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isCustom ? Colors.black : Theme.of(context).colorScheme.surface,
        behavior: SnackBarBehavior.fixed,
        elevation: 0,
        duration: const Duration(seconds: 30),
        padding: EdgeInsets.zero,
        shape: Border(
          top: BorderSide(
            color: borderColor,
            width: isCustom ? 2.5 : 1.5,
          ),
        ),
        content: Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: ValueListenableBuilder(
              valueListenable: statusMessage,
              builder: (context, String msg, _) {
                return ValueListenableBuilder(
                  valueListenable: statusColor,
                  builder: (context, Color textColor, _) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: animation.drive(Tween(
                            begin: const Offset(0.0, 0.2), 
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeOutCubic))),
                          child: child,
                        ),
                      ),
                      child: ArmoryText(
                        msg,
                        key: ValueKey(msg),
                        themeController: themeController,
                        baseFontSize: 12,
                        baseStrokeWidth: isCustom ? 2.5 : 1.5,
                        color: textColor,
                        overrideStrokeColor: Colors.black,
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  initSlipstreamSnack();
  updateSlipstreamUI(locale.translateStatic("VERIFYING DATA INTEGRITY..."), coreColor);
  
  await Future.delayed(const Duration(milliseconds: 800));

  await _syncData(onDownloadStarted: () {
    if (mounted) {
      updateSlipstreamUI(locale.translateStatic("DOWNLOADING ASSETS..."), Colors.amberAccent);
    }
  });

  if (_weaponDataUpdated) {
    updateSlipstreamUI(locale.translateStatic("PRELOADING ASSETS..."), Colors.cyanAccent);
    await Future.delayed(const Duration(milliseconds: 200));
    await _performPreload();
    
    updateSlipstreamUI(locale.translateStatic("PATCH APPLIED. RESTARTING..."), coreColor);
    await Future.delayed(const Duration(milliseconds: 2000)); 
    
    if (mounted) {
      AppRestartWrapper.restartApp(context);
    }
    return;
  }

  if (_hotfixUpdated) {
  updateSlipstreamUI(locale.translateStatic("INJECTING HOTFIX DATA..."), Colors.cyanAccent);
  
  await _loadHotfixData(); 

  await widget.themeController.syncPatchNotes(
    _activeBaseUrl, 
    locale.languageCode, 
    forceRefresh: true
  );
  
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  if (mounted) {
    _showHotFixesDialog(context, _hotfixData);
  }
} else {
    await _loadHotfixData();

    if (mounted) {
      final prefs = await SharedPreferences.getInstance();
      bool hasPendingAlert = prefs.getBool('pending_hotfix_alert') ?? false;

      if (hasPendingAlert) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        _showHotFixesDialog(context, _hotfixData);
        await prefs.setBool('pending_hotfix_alert', false);
      } else {
        updateSlipstreamUI("SYSTEM UP TO DATE.", coreColor);
        await Future.delayed(const Duration(seconds: 2));
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      if (displayList.isEmpty) {
        setState(() {
          displayList = List.from(_loadedWeapons);
          _sortDisplayList();
        });
      }
    }
  }
  
  _hasRunBootSequence = true;
}
  
Future<void> _loadHotfixData() async {
  try {
    final String jsonString = await loadHotfixedJson('assets/hotfixes.json');
    final Map<String, dynamic> data = json.decode(jsonString);

    final prefs = await SharedPreferences.getInstance();
    int lastAcknowledgedVersion = prefs.getInt('key_hotfix_acknowledged_version') ?? 0;
    int currentVersion = int.tryParse(data['version']?.toString() ?? "0") ?? 0;

    if (mounted) {
      setState(() {
        _hotfixData = data;
        _hasNewHotfix = currentVersion > lastAcknowledgedVersion;
      });
    }
  } catch (e) {
    debugPrint("Hotfix System Load Error: $e");
  }
}

Future<void> _markHotfixRead() async {
  if (_hotfixData == null) return;
  
  final prefs = await SharedPreferences.getInstance();
  
  await prefs.setString('last_hotfix_date', _hotfixData!['patch_date']);
  await prefs.setBool('pending_hotfix_alert', false);

  setState(() => _hasNewHotfix = false);
  
  debugPrint("✅ Hotfix marked as read and pending flag cleared.");
}

void _showThemePickerDialog() {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "ThemePicker",
    barrierColor: Colors.black.withOpacity(0.8),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return ListenableBuilder(
        listenable: widget.themeController,
        builder: (context, _) {
          final activeTheme = widget.themeController.activeTheme;
          final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
          final bool isHolo = activeTheme.isHolographic;
          final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
          final Color accentColor = widget.themeController.activeAccentColor;

          final Color accent = widget.themeController.activeAccentColor;
          final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;
          final Color primary = Theme.of(context).colorScheme.primary;
          final Color simpleBorderColor = Color.lerp(primary, Colors.white, 0.3)!.withOpacity(1.0);

          const double outerRadius = 28.0;
          const double innerRadius = 28.0; 
          final double borderWidth = (isNeon || isHolo || isAnemone) ? 3.0 : 2.0;
          final Color containerBg = isNeon ? Colors.black : Theme.of(context).colorScheme.surface;

          Widget pickerContent = Container(
            key: const ValueKey("theme_picker_window_content"),
            decoration: BoxDecoration(
              color: containerBg,
              borderRadius: BorderRadius.circular(innerRadius),
              border: (!isHolo && !isAnemone) 
                  ? Border.all(color: isNeon ? coreColor : accentColor, width: borderWidth)
                  : null,
              boxShadow: [
                if (isNeon) BoxShadow(
                  color: accent.withOpacity(0.5),
                  blurRadius: 25,
                  spreadRadius: 2,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(innerRadius),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: ArmoryText(
                      "INTERFACE THEME",
                      themeController: widget.themeController,
                      baseFontSize: 18,
                      baseStrokeWidth: 2.5,
                      color: isNeon ? coreColor : Colors.white,
                    ),
                  ),
                  Expanded(child: _buildThemeCategoryRows()),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(isNeon ? Colors.black : Theme.of(context).colorScheme.surface),
                        side: WidgetStateProperty.all(BorderSide(
                          color: isNeon ? coreColor : simpleBorderColor.withOpacity(0.5),
                          width: isNeon ? 1.5 : 1.0,
                        )),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                        child: ArmoryText(
                          "CLOSE",
                          themeController: widget.themeController,
                          baseFontSize: 12,
                          baseStrokeWidth: 2.0,
                          color: isNeon ? coreColor : Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

          Widget finalWindow;
          if (isHolo) {
            finalWindow = _InternalAnimatedBorder(
              colors: activeTheme.refractionColors,
              useRotation: true,
              borderRadius: outerRadius,
              strokeWidth: borderWidth,
              child: pickerContent,
            );
          } else if (isAnemone) {
            finalWindow = ArmoryGradientBorder(
              gradientColors: activeTheme.borderGradient,
              strokeWidth: borderWidth,
              borderRadius: outerRadius,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              child: pickerContent,
            );
          } else {
            finalWindow = pickerContent;
          }

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: finalWindow,
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
        child: child,
      );
    },
  );
}

Widget _buildFontRow() {
  return SizedBox(
    height: 60,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: ThemeController.availableFonts.length,
      itemBuilder: (context, index) {
        final font = ThemeController.availableFonts[index];
        bool isActive = widget.themeController.activeFont == font;

        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.themeController.setFont(font);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 135,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isActive ? Colors.white.withOpacity(0.1) : Colors.white10,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isActive ? Colors.white : Colors.white12,
                width: isActive ? 2 : 1,
              ),
            ),
            child: Center(
              child: _buildFontPreview(font, isActive),
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildFontPreview(String fontName, bool isActive) {
  return ArmoryText(
    fontName.toUpperCase(),
    themeController: widget.themeController,
    overrideFontFamily: fontName,
    baseFontSize: 11,
    baseStrokeWidth: 1.2,
    color: isActive ? Colors.white : Colors.white38,
    textAlign: TextAlign.center,
  );
}

Widget _buildThemeCategoryRows() {
  return ListView(
    padding: const EdgeInsets.only(bottom: 30),
    children: [
      _buildCategoryHeader("SYSTEM FONT"),
      _buildFontRow(),
      
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: Divider(color: Colors.white10, thickness: 1),
      ),

      _buildCategoryHeader("SIMPLE"),
      _buildThemeRow(ThemeCategory.simple),
      
      const SizedBox(height: 10),
      _buildCategoryHeader("ANEMONE"),
      _buildThemeRow(ThemeCategory.anemone),
      
      const SizedBox(height: 10),
      _buildCategoryHeader("HOLOGRAPHIC"),
      _buildThemeRow(ThemeCategory.premium),

      const SizedBox(height: 10),
      _buildCategoryHeader("NEON"),
      _buildThemeRow(ThemeCategory.neon),
    ],
  );
}

Widget _buildCategoryHeader(String title) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ArmoryText(
        title,
        themeController: widget.themeController,
        baseFontSize: 12,
        baseStrokeWidth: 0,
        color: Colors.white70,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget _buildThemeRow(ThemeCategory category) {
  final activeFont = widget.themeController.activeFont;
  final categoryThemes = ThemeController.allThemes
      .where((t) => t.category == category)
      .toList();

  if (categoryThemes.isEmpty) return const SizedBox.shrink();

  return SizedBox(
    height: 100,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      clipBehavior: Clip.hardEdge,
      itemCount: categoryThemes.length,
      itemBuilder: (context, index) {
        final theme = categoryThemes[index];
        final bool isActive = widget.themeController.activeTheme.id == theme.id;
        final bool isCustomNeon = theme.id == 'neon_custom';
        
        final bool isReactive = theme.id == 'reactive_placeholder'; 

        bool isLocked = (theme.category == ThemeCategory.premium || 
                         isCustomNeon || 
                         isReactive) && !_isPremiumUser;

        final Color neonColor = widget.themeController.activeAccentColor;
        final Color neonCore = Color.lerp(neonColor, Colors.white, 0.35)!;

        return GestureDetector(
          onTap: isLocked ? () {
            HapticFeedback.heavyImpact();
            ScaffoldMessenger.of(context).clearSnackBars(); 

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 2500), 
                behavior: SnackBarBehavior.fixed,
                padding: EdgeInsets.zero,
                backgroundColor: Theme.of(context).colorScheme.surface,
                
                content: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2.0
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  width: double.infinity,
                  child: ArmoryText(
                    "PURCHASE PREMIUM TO ACCESS THIS THEME!",
                    themeController: widget.themeController,
                    baseFontSize: 12,
                    baseStrokeWidth: 1.8,
                    color: Colors.white,
                    overrideStrokeColor: Colors.black,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          } : () {
            HapticFeedback.lightImpact();
            widget.themeController.setTheme(theme);
            
            if (isCustomNeon && isActive) {
              _openColorPickerDialog(context, widget.themeController);
            }
          },
          onLongPress: (isCustomNeon && !isLocked) 
              ? () => _openColorPickerDialog(context, widget.themeController) 
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 105, 
            height: 105,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: isCustomNeon 
                  ? const Color.fromARGB(255, 0, 0, 0).withOpacity(isActive ? 1.0 : 0.6)
                  : (theme.pickerGradient == null 
                      ? (isActive ? theme.themeData.primaryColor.withOpacity(0.4) : theme.pickerBoxColor)
                      : null),
              
              gradient: (theme.pickerGradient != null && !isCustomNeon) 
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isActive 
                          ? theme.pickerGradient!.map((c) => c.withOpacity(0.9)).toList()
                          : theme.pickerGradient!.map((c) => c.withOpacity(isLocked ? 0.1 : 0.3)).toList(),
                    ) 
                  : null,
              
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isCustomNeon
                    ? (isActive ? neonCore : neonColor.withOpacity(0.3))
                    : (isActive ? theme.themeData.primaryColor : theme.pickerBorderColor),
                width: isActive ? 2.5 : 1,
              ),
              boxShadow: isActive ? [
                BoxShadow(
                  color: (isCustomNeon ? neonColor : (theme.pickerGradient?.first ?? theme.themeData.primaryColor)).withOpacity(0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ] : [],
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ArmoryText(
                      theme.name.toUpperCase(),
                      themeController: widget.themeController,
                      baseFontSize: 10,
                      baseStrokeWidth: 1.2,
                      color: isLocked ? Colors.white24 : Colors.white,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                
                if (isLocked)
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.lock_outline, color: Colors.amberAccent, size: 14),
                  )
                else if (isCustomNeon)
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: Icon(Icons.colorize, 
                      color: isActive ? neonCore : Colors.white24, 
                      size: 12
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

void _openColorPickerDialog(BuildContext context, ThemeController controller) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final Color currentColor = controller.customColor;
          final Color dynamicNeonBorder = Color.lerp(currentColor, Colors.white, 0.35)!;

          return Theme(
            data: ThemeData.dark().copyWith(
              canvasColor: Colors.black,
              cardColor: const Color(0xFF1A1A1A),
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
              ),
            ),
            child: AlertDialog(
              backgroundColor: const Color(0xFF0A0A0A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: dynamicNeonBorder, width: 2),
              ),
              title: ArmoryText(
                "CUSTOM NEON ENGINE",
                themeController: controller,
                baseFontSize: 14,
                color: Colors.white,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ColorPicker(
                      pickerColor: currentColor,
                      onColorChanged: (color) {
                        controller.updateCustomColor(color);
                        setState(() {}); 
                      },
                      colorPickerWidth: 300,
                      pickerAreaHeightPercent: 0.7,
                      enableAlpha: false,
                      displayThumbColor: true,
                      showLabel: true, 
                      labelTypes: const [],
                      pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(8)),
                      hexInputBar: true, 
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12, bottom: 12),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: dynamicNeonBorder, 
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: currentColor.withOpacity(0.6),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Text(
                        "DONE",
                        style: TextStyle(
                          color: dynamicNeonBorder,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<bool> _syncData({Function? onDownloadStarted}) async {
  bool performedActualUpdate = false;
  _hotfixUpdated = false;
  _weaponDataUpdated = false;
  Function? notifyUI = onDownloadStarted;

  List<Future<void>> asyncTasks = [];

  try {
    final manifestUri = Uri.parse("$_activeBaseUrl/cdn/manifest.json?t=${DateTime.now().millisecondsSinceEpoch}");
    debugPrint("🛰️ [SLIPSTREAM] Fetching Manifest from: $manifestUri");

    final response = await http.get(
      manifestUri,
      headers: _getHeaders()
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final manifest = json.decode(response.body);
      final int remoteManifestVersion = manifest['version'] ?? 0;
      final remoteFiles = manifest['files'] as Map<String, dynamic>;
      
      final prefs = await SharedPreferences.getInstance();

      int localManifestVersion = prefs.getInt('manifest_version_key') ?? 0;
      bool forceGlobalUpdate = remoteManifestVersion > localManifestVersion;

      for (String fileName in remoteFiles.keys) {
        int remoteFileVersion = int.tryParse(remoteFiles[fileName].toString()) ?? 0;
        String storageKey = 'key_$fileName';
        int localVersion = forceGlobalUpdate ? -1 : (prefs.getInt(storageKey) ?? 0);

        if (remoteFileVersion > localVersion) {
          performedActualUpdate = true;
          if (notifyUI != null) { notifyUI(); notifyUI = null; }

          asyncTasks.add(() async {
            try {
              final fileUri = Uri.parse("$_activeBaseUrl/cdn/$fileName");
              final fileResponse = await http.get(fileUri, headers: _getHeaders());

              if (fileResponse.statusCode == 200) {
                // Strictly Web: Store the raw file payload directly into browser localStorage
                final String webContentString = utf8.decode(fileResponse.bodyBytes);
                String dataStoreKey = 'cached_file_$fileName';
                await prefs.setString(dataStoreKey, webContentString);
                await prefs.setInt(storageKey, remoteFileVersion);

                if (fileName.contains('hotfixes')) {
                  _hotfixUpdated = true;
                  await prefs.setBool('pending_hotfix_alert', true); 

                  String fileLang = 'en';
                  if (fileName.contains('/')) {
                    fileLang = fileName.split('/').first;
                  }

                  await widget.themeController.syncPatchNotes(
                    _activeBaseUrl, 
                    fileLang, 
                    forceRefresh: true
                  );
                  debugPrint("🚀 [SLIPSTREAM] Hot-swapped active cache memory state inside ThemeController for: $fileLang");
                } else {
                  _weaponDataUpdated = true;
                }
              } else {
                debugPrint("❌ [SLIPSTREAM] Failed to download $fileName: ${fileResponse.statusCode}");
              }
            } catch (e) {
              debugPrint("❌ [SLIPSTREAM] Task failed for $fileName: $e");
            }
          }());
        }
      }

      if (asyncTasks.isNotEmpty) {
        await Future.wait(asyncTasks);
        await prefs.setInt('manifest_version_key', remoteManifestVersion);
      } else if (forceGlobalUpdate) {
        await prefs.setInt('manifest_version_key', remoteManifestVersion);
      }

    } else {
      debugPrint("❌ [SLIPSTREAM] Manifest error: Status ${response.statusCode}");
    }
    
    return performedActualUpdate; 
    
  } catch (e) {
    debugPrint("⚠️ [SLIPSTREAM] Exception: $e");
    return false;
  }
}

Future<void> _checkConnection() async {
  try {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      if (mounted) setState(() => _connectionStatus = ConnectionStatus.offline);
      return;
    }

    try {
      final armoryCheck = await http.get(
        Uri.parse("$_activeBaseUrl/redirector.json"),
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 5));

      if (mounted && armoryCheck.statusCode == 200) {
        if (_connectionStatus != ConnectionStatus.connected) {
           setState(() => _connectionStatus = ConnectionStatus.connected);
        }
      } else {
         if (mounted) setState(() => _connectionStatus = ConnectionStatus.tunnelIssue);
      }
    } catch (e) {
      debugPrint("❌ Armory Source Check Failed: $e");
      if (mounted) setState(() => _connectionStatus = ConnectionStatus.tunnelIssue);
    }
  } catch (e) {
    debugPrint("❌ General Network Failure: $e");
    if (mounted) setState(() => _connectionStatus = ConnectionStatus.offline);
  }
}

  final List<String> mainListChips = ["Multiplayer", "Warzone", "Rebirth", "Warzone Prestige", "Special", "Zombies", "Endgame", "Akimbo", "Single"];
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  Set<String> _favorites = {};

void _showPatchNotes(BuildContext context, List<String> notes) {
  final primary = Theme.of(context).colorScheme.primary;

  showDialog(
    context: context,
    builder: (context) {
      final activeTheme = widget.themeController.activeTheme;
      final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
      final Color accent = widget.themeController.activeAccentColor;
      final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;
      final Color effectivePrimary = isNeon ? coreColor : primary;
      final Color primaryFaded = Color.alphaBlend(
        Theme.of(context).colorScheme.surface.withOpacity(0.8), 
        Colors.black
      );

      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: isNeon ? Colors.black : primaryFaded,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
            side: BorderSide(
              color: isNeon ? coreColor : primary.withOpacity(0.8),
              width: 2.0,
            ),
          ),
          title: Column(
            children: [
              ArmoryText(
                "${context.watch<AegisArc>().translateStatic("SYSTEM UPDATES")} | PRE-RELEASE 3.1.0 SOLAR",
                themeController: widget.themeController,
                baseFontSize: 14,
                baseStrokeWidth: isNeon ? 3.0 : 2.5,
                color: effectivePrimary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                height: 1,
                color: isNeon ? accent.withOpacity(0.2) : Colors.white10,
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10),
              itemCount: notes.length,
              itemBuilder: (context, i) {
                String line = notes[i];
                bool isHeader = line.startsWith('!');
                if (isHeader) line = line.substring(1);

                return Padding(
                  padding: EdgeInsets.only(
                    top: isHeader ? 20.0 : 4.0, 
                    bottom: isHeader ? 6.0 : 4.0
                  ),
                  child: ArmoryText(
                    isHeader ? line : "> $line",
                    themeController: widget.themeController,
                    allowWrap: true,
                    textAlign: TextAlign.center,
                    baseFontSize: isHeader ? 12 : 10,
                    baseStrokeWidth: isHeader ? 2.0 : 1.2,
                    color: isHeader ? effectivePrimary : Colors.white.withOpacity(0.8),
                  ),
                );
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 10),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    isNeon ? Colors.black : Colors.transparent
                  ),
                  side: WidgetStateProperty.all(
                    BorderSide(
                      color: isNeon ? coreColor : primary.withOpacity(0.5), 
                      width: isNeon ? 1.5 : 1.0
                    )
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))
                  ),
                  overlayColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.hovered) || 
                          states.contains(WidgetState.pressed)) {
                        return isNeon 
                            ? coreColor.withOpacity(0.15) 
                            : primary.withOpacity(0.1);
                      }
                      return null;
                    },
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ArmoryText(
                    "ACKNOWLEDGE",
                    themeController: widget.themeController,
                    baseFontSize: 10,
                    baseStrokeWidth: 2.0,
                    color: effectivePrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> prepareAndShowPatchNotes(BuildContext context, String langCode) async {
  const String path = 'assets/patch_notes.json';
  final String key = langCode.toLowerCase();

  try {
    final String response = await rootBundle.loadString(path);
    final data = json.decode(response);
    
    final Map<String, dynamic> allNotes = Map<String, dynamic>.from(data['notes']);
    
    final List<String> notes = List<String>.from(allNotes[key] ?? allNotes['en']);

    if (context.mounted && notes.isNotEmpty) {
      _showPatchNotes(context, notes);
    }
  } catch (e) {
    debugPrint("Critical Error: Failed to load patch notes from $path: $e");
  }
}

Future<void> _loadFavorites() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    _favorites = (prefs.getStringList('favorite_weapons') ?? []).toSet();
    _sortDisplayList();
  });
}

void _toggleFavorite(String weaponName) async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    if (_favorites.contains(weaponName)) {
      _favorites.remove(weaponName);
    } else {
      _favorites.add(weaponName);
    }
    prefs.setStringList('favorite_weapons', _favorites.toList());
    _sortDisplayList();
  });
}

void _sortDisplayList() {
  displayList.sort((a, b) {
    bool aFav = _favorites.contains(a.name);
    bool bFav = _favorites.contains(b.name);
    if (aFav && !bFav) return -1;
    if (!aFav && bFav) return 1;
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  });
}

Future<void> _loadStoredCredentials() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    _idController.text = prefs.getString('saved_discord_id') ?? "";
    _pinController.text = prefs.getString('saved_pin') ?? "";
    _isPremiumUser = prefs.getBool('is_premium_user') ?? false;
  });

  if (_idController.text.isNotEmpty) {
    PurchaseService.updateDiscordId(_idController.text);
  }
}

Future<void> _verifyPremium() async {
  final id = _idController.text.trim();
  final pin = _pinController.text.trim();
  if (id.isEmpty || pin.isEmpty) return;

  final themeController = widget.themeController;
  HapticFeedback.mediumImpact();

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 1500),
      behavior: SnackBarBehavior.fixed,
      padding: EdgeInsets.zero,
      backgroundColor: const Color(0xFF1E1E1E),
      content: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF0D47A1), width: 2.5)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: ArmoryText(
          "CONNECTING TO ARMORY CORE...",
          themeController: themeController,
          baseFontSize: 12,
          color: const Color(0xFF448AFF),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );

  try {
    const String ngrokUrl = "https://cherty-frowningly-rickie.ngrok-free.dev";
    final url = Uri.parse('$ngrokUrl/verify-premium?user_id=$id&pin=$pin');

    final response = await http.get(
      url, 
      headers: {"ngrok-skip-browser-warning": "true"},
    ).timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      bool verified = data['premium'] == true;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_discord_id', id);
      await prefs.setString('saved_pin', pin);
      await prefs.setBool('is_premium_user', verified);

      setState(() {
        _isPremiumUser = verified;
        _savedDiscordId = id;
      });
      
      PurchaseService.updateDiscordId(id);
      
      if (verified) {
        HapticFeedback.heavyImpact();
        Navigator.pop(context); 

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.fixed,
            padding: EdgeInsets.zero,
            backgroundColor: Theme.of(context).colorScheme.surface,
            content: Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.greenAccent, width: 2.5)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: ArmoryText(
                "PREMIUM ACCESS GRANTED",
                themeController: themeController,
                baseFontSize: 12,
                color: Colors.greenAccent,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      } else {

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.fixed,
            padding: EdgeInsets.zero,
            backgroundColor: Theme.of(context).colorScheme.surface,
            content: Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.redAccent, width: 2.5)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: ArmoryText(
                "DENIED: ${data['message']?.toUpperCase() ?? 'INVALID ID/PIN'}",
                themeController: themeController,
                baseFontSize: 10,
                color: Colors.redAccent,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }
    }
  } catch (e) {

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.fixed,
        padding: EdgeInsets.zero,
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.orangeAccent, width: 2.5)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: ArmoryText(
            "SERVER UNREACHABLE: VERIFY TUNNEL STATUS",
            themeController: themeController,
            baseFontSize: 10,
            color: Colors.orangeAccent,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

Future<void> _openCommunityLink() async {
  final Uri url = Uri.parse('https://buy.stripe.com/dRm6oH6BFamr8Xe2CddUY00');
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    debugPrint("Could not launch $url");
  }
}

void _handlePremiumPurchase() async {
  final Color coreColor = Color.lerp(
    widget.themeController.activeTheme.themeData.primaryColor, 
    Colors.white, 
    0.35
  )!;
  
  final String? discordId = await _showIdPopup(coreColor);
  if (discordId == null || discordId.isEmpty) return;

  PurchaseService.updateDiscordId(discordId);

  _showLoadingOverlay("SYNCING WITH ARMORY CORE...");

  try {
    await PurchaseService.buyPremium();
  } catch (e) {
    _hideLoadingOverlay();
    _showErrorSnackBar("PURCHASE ERROR: $e");
  }
}

void _handlePurchaseSuccess() async {
  if (_isSyncing) return;
  
  _showLoadingOverlay("FINALIZING WITH ARMORY CORE...");

  bool confirmed = false;
  final stopwatch = Stopwatch()..start();

  try {
    while (stopwatch.elapsed.inSeconds < 7) {
      final result = await PurchaseService.verifyBackendStatus();
      
      if (result == true) {
        confirmed = true;
        break;
      } else if (result == null) {

        break;
      }

      await Future.delayed(const Duration(seconds: 2));
    }
  } catch (e) {
    debugPrint("Polling error: $e");
  } finally {
    stopwatch.stop();
    _hideLoadingOverlay();
  }

  if (confirmed && mounted) {
    _showPurchaseSuccessDialog(
      PurchaseService.verifiedId ?? "Unknown", 
      PurchaseService.verifiedPin ?? "******"
    );
    
    setState(() {
      _idController.text = PurchaseService.verifiedId ?? "";
      _pinController.text = PurchaseService.verifiedPin ?? "";
    });

    _showSuccessSnackBar("PURCHASE VERIFIED. PLEASE LOGIN TO ACTIVATE.");
    
  } else {
    _showErrorSnackBar("SYNC TIMEOUT: PLEASE RE-LOG TO VIEW CREDENTIALS");
  }
}

Future<String?> _showIdPopup(Color coreColor) async {
  final themeController = widget.themeController;
  return await showDialog<String>(
    context: context,
    builder: (context) {
      TextEditingController popupController = TextEditingController();
      return AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: coreColor, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        title: ArmoryText("ENTER DISCORD ID", 
            themeController: themeController, 
            baseFontSize: 14, 
            color: coreColor),
        content: TextField(
          controller: popupController,
          autofocus: true,
          style: TextStyle(color: Colors.white, fontFamily: themeController.activeFont),
          decoration: InputDecoration(
            hintText: "e.g. 1234567890",
            hintStyle: TextStyle(color: Colors.white24, fontSize: 12),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: coreColor.withOpacity(0.5))),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: coreColor)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: ArmoryText("CANCEL", 
              themeController: themeController, 
              baseFontSize: 12, 
              color: Colors.white38),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, popupController.text.trim()),
            child: ArmoryText("PROCEED", 
              themeController: themeController, 
              baseFontSize: 12, 
              color: coreColor),
          ),
        ],
      );
    },
  );
}

void _showPurchaseSuccessDialog(String id, String pin) {
  final themeController = widget.themeController;
  final activeTheme = themeController.activeTheme;
  final Color coreColor = Color.lerp(activeTheme.themeData.primaryColor, Colors.white, 0.35)!;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: coreColor, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      title: ArmoryText("PREMIUM ACTIVATED", 
          themeController: themeController, 
          baseFontSize: 18, 
          color: coreColor),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ArmoryText("Your account credentials have been generated:", 
            themeController: themeController,
            baseFontSize: 12, 
            color: Colors.white70),
          const SizedBox(height: 20),
          _credentialRow("DISCORD ID", id, coreColor),
          const SizedBox(height: 10),
          _credentialRow("ACCESS PIN", pin, coreColor),
          const SizedBox(height: 20),
          ArmoryText("Please save these. You can now log in.", 
            themeController: themeController,
            baseFontSize: 10, 
            color: Colors.white38),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: ArmoryText("PROCEED TO LOGIN", 
            themeController: themeController, 
            baseFontSize: 12, 
            color: coreColor),
        ),
      ],
    ),
  );
}

Widget _credentialRow(String label, String value, Color color) {
  final locale = Provider.of<AegisArc>(context, listen: false);

  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(locale.translateStatic(label), style: const TextStyle(color: Colors.white38, fontSize: 10)),
        Text(locale.translateStatic(value), style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    ),
  );
}

void _showSuccessSnackBar(String message) {
  final themeController = widget.themeController;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.greenAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      content: ArmoryText(
        message.toUpperCase(),
        themeController: themeController,
        baseFontSize: 11,
        color: Colors.greenAccent,
      ),
    ),
  );
}

void _showErrorSnackBar(String message) {
  final themeController = widget.themeController;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      content: ArmoryText(
        message.toUpperCase(),
        themeController: themeController,
        baseFontSize: 11,
        color: Colors.redAccent,
      ),
    ),
  );
}

bool _isSyncing = false;

void _showLoadingOverlay(String message) {
  if (!mounted) return;

  setState(() => _isSyncing = true);
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.8),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Color.lerp(widget.themeController.activeTheme.themeData.primaryColor, Colors.white, 0.35),
            ),
            const SizedBox(height: 20),
            ArmoryText(message.toUpperCase(), 
              themeController: widget.themeController, 
              baseFontSize: 12, 
              color: Colors.white),
          ],
        ),
      ),
    ),
  );
}

void _hideLoadingOverlay() {
  if (!mounted) return;

  if (_isSyncing) {
    Navigator.of(context, rootNavigator: true).pop();
    setState(() => _isSyncing = false);
  }
}

Future<void> _savePremiumStatus(bool status) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('is_premium', status);
}

void search(String query) {
  final queryUpper = query.toUpperCase().trim();
  
  const gameKeywords = {"BO7", "BO6", "CW", "MW3", "MW2", "MW19"};
  const archetypeKeywords = {
    "AR", "SMG", "PISTOL", "SHOTGUN", "LMG", 
    "SNIPER", "MARKSMAN RIFLE", "BATTLE RIFLE", "TACTICAL RIFLE", "SPECIAL"
  };

  bool queryIsFullArch = archetypeKeywords.contains(queryUpper);
  
  final terms = queryUpper.split(RegExp(r'[,\s]+')).where((t) => t.isNotEmpty).toList();

  setState(() {
    displayList = _loadedWeapons.where((weapon) {
      final weaponName = weapon.name.toUpperCase();
      final url = weapon.gameLogoUrl.toUpperCase();

      String weaponGame = "";
      for (var key in gameKeywords) {
        if (url.contains(key)) {
          weaponGame = key;
          break;
        }
        if (url.contains("COLD_WAR")) {
          weaponGame = "CW";
        }
      }

      String weaponArch = "";
      for (var builds in weapon.builds.values) {
        for (var build in builds) {
          if (build.stats?.archetype != null) {
            weaponArch = build.stats!.archetype!.toUpperCase();
            break;
          }
        }
        if (weaponArch.isNotEmpty) break;
      }

      final selectedGames = _selectedArchetypes.where((s) => gameKeywords.contains(s)).toList();
      final typedGames = terms.where((t) => gameKeywords.contains(t)).toList();
      bool matchesGame = (selectedGames.isEmpty && typedGames.isEmpty) || 
                         selectedGames.contains(weaponGame) || 
                         typedGames.contains(weaponGame);

      final selectedArchs = _selectedArchetypes.where((s) => archetypeKeywords.contains(s)).toList();
      final typedArchs = terms.where((t) => archetypeKeywords.contains(t)).toList();
      
      bool matchesArch = (selectedArchs.isEmpty && !queryIsFullArch && typedArchs.isEmpty);
      if (!matchesArch) {
        matchesArch = selectedArchs.contains(weaponArch) || 
                      typedArchs.contains(weaponArch) ||
                      (queryIsFullArch && weaponArch == queryUpper);
      }

      final typedNames = queryIsFullArch ? [] : terms.where((t) => 
        !gameKeywords.contains(t) && !archetypeKeywords.contains(t)
      ).toList();
      
      bool matchesName = typedNames.isEmpty || typedNames.any((name) => weaponName.contains(name));

      return matchesGame && matchesArch && matchesName;
    }).toList();

    displayList.sort((a, b) {
      bool aFav = _favorites.contains(a.name);
      bool bFav = _favorites.contains(b.name);

      if (aFav && !bFav) return -1;
      if (!aFav && bFav) return 1;

      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  });
}

void _showBugReportDialog() {
  final TextEditingController bugController = TextEditingController();
  
  const Color armoryBlue = Color.fromRGBO(55, 87, 193, 1);
  const Color armorySurface = Color.fromARGB(255, 10, 14, 17);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: armorySurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: armoryBlue, width: 1.0),
      ),
      title: Column(
        children: [
          ArmoryText(
            "ARMORY BUG REPORT",
            themeController: widget.themeController,
            baseFontSize: 14,
            baseStrokeWidth: 2.0,
            color: armoryBlue,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: armoryBlue.withOpacity(0.4)),
        ],
      ),
      content: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.white,
            selectionColor: armoryBlue.withOpacity(0.3),
            selectionHandleColor: armoryBlue,
          ),
        ),
        child: TextField(
          controller: bugController,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(
            fontFamily: widget.themeController.activeFont,
            color: Colors.white, 
            fontSize: 13
          ),
          decoration: InputDecoration(
            hintText: context.read<AegisArc>().translateStatic("Describe the issue and how it occurred."),
            hintStyle: TextStyle(
              fontFamily: widget.themeController.activeFont, 
              color: Colors.white38,
              fontSize: 11,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: armoryBlue.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: armoryBlue),
              borderRadius: BorderRadius.circular(24),
            ),
            filled: true,
            fillColor: Colors.black.withOpacity(0.3),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1)),
            side: WidgetStateProperty.all(BorderSide(color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.05), width: 1.0)),
            overlayColor: WidgetStateProperty.all(armoryBlue.withOpacity(0.2)),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ArmoryText(
            "CANCEL",
            themeController: widget.themeController,
            baseFontSize: 10,
            baseStrokeWidth: 0,
            color: Colors.grey,
          ),
        ),
        ),
        
        TextButton(
          onPressed: () async {
            if (bugController.text.isNotEmpty) {
              final prefs = await SharedPreferences.getInstance();
              final String? savedId = prefs.getString('saved_discord_id');

              final String rawNote = bugController.text.trim();
              final String note = rawNote[0].toUpperCase() + rawNote.substring(1);

              try {
                final String webhookUrl = 'https://discord.com/api/webhooks/1497705180471496744/htB2HC48RrtAJ1ZGVOw3INWj80IJV8pFfEK1ao49_lhlCDV6b80fZnOz573JUGKxjIsy';
                
                List<Map<String, dynamic>> embedFields = [];

                if (savedId != null && savedId.isNotEmpty) {
                  embedFields.insert(0, {
                    "name": "User ID",
                    "value": "`$savedId`",
                    "inline": false
                  });
                }

                await http.post(
                  Uri.parse(webhookUrl),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    "embeds": [{
                      "title": "User Report Submitted",
                      "description": "**Report Content:**\n>>> $note",
                      "color": 15158332,
                      "fields": embedFields,
                      "timestamp": DateTime.now().toIso8601String(),
                    }],
                  }),
                );
              } catch (e) {
                debugPrint("Webhook Error: $e");
              }

              if (mounted) {
                Navigator.pop(context);

                final themeController = widget.themeController;
                final activeTheme = themeController.activeTheme;
                final bool isCustom = activeTheme.id == 'neon_custom';

                final Color neonBorderColor = Color.lerp(themeController.activeAccentColor, Colors.white, 0.35)!;
                
                final Color displayColor = isCustom ? neonBorderColor : armoryBlue;

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: isCustom ? Colors.black : const Color.fromARGB(255, 10, 14, 17),
                    behavior: SnackBarBehavior.fixed,
                    elevation: 0,
                    duration: const Duration(seconds: 3),
                    padding: EdgeInsets.zero, 
                    shape: Border(
                      top: BorderSide(
                        color: displayColor, 
                        width: isCustom ? 2.5 : 1.5,
                      ),
                    ),
                    content: Container(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 2.0, left: 15, right: 15),
                      child: ArmoryText(
                        "REPORT TRANSMITTED. THANK YOU.",
                        themeController: themeController,
                        baseFontSize: 12,
                        baseStrokeWidth: isCustom ? 2.5 : 1.5,
                        color: displayColor,
                        overrideStrokeColor: Colors.black,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }
            }
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(armoryBlue.withOpacity(0.1)),
            side: WidgetStateProperty.all(const BorderSide(color: armoryBlue, width: 1.0)),
            overlayColor: WidgetStateProperty.all(armoryBlue.withOpacity(0.2)),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ArmoryText(
              "TRANSMIT",
              themeController: widget.themeController,
              baseFontSize: 10,
              baseStrokeWidth: 2.0,
              color: armoryBlue,
            ),
          ),
        ),
      ],
    ),
  );
}

@override
Widget build(BuildContext context) {
  if (!_initialized) {
    return const Scaffold(backgroundColor: Colors.black);
  }

  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 1000),
    child: _buildCurrentStateUI(),
  );
}

Widget _buildCurrentStateUI() {
  switch (_currentState) {
    case AppState.languageSelect:
      return _buildLanguageSelectionScreen(key: const ValueKey('language_select'));

    case AppState.onboarding:
    case AppState.initializing:
      return ArmoryOnboarding(
        key: const ValueKey('onboarding_screen'),
        themeController: widget.themeController,
        isReplay: _isManualReplay, 
        onComplete: () {
          if (_isManualReplay) {
            setState(() {
              _isManualReplay = false;
              _currentState = AppState.ready;
            });
          } else {
            _startFirstTimeBootSequence();
          }
        }, 
      );

    case AppState.booting:
      return _buildFirstTimeLoadingVisual(key: const ValueKey('booting_visual'));

    case AppState.ready:
      return _buildMainScaffold(key: const ValueKey('main_scaffold'));
  }
}

Widget _buildMainScaffold({Key? key}) {
  double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
  final activeTheme = widget.themeController.activeTheme;
  final themeController = widget.themeController;
  final bool isCustom = activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final locale = Provider.of<AegisArc>(context);

  return Scaffold(
    key: const ValueKey('main_armory_ui'),

    resizeToAvoidBottomInset: false, 
    
    onDrawerChanged: (isOpen) {
      if (isOpen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.edgeToEdge, 
          overlays: SystemUiOverlay.values
        );
      }
    },
    drawer: _buildSettingsDrawer(),
    
    appBar: AppBar(
      backgroundColor: isCustom 
          ? const Color.fromARGB(255, 0, 0, 0) 
          : Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      
      leading: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Center(
          child: SizedBox(
            width: 48,
            height: 48,
            child: Builder(
              builder: (innerContext) => IconButton(
                splashRadius: 24, 
                padding: EdgeInsets.zero,
                icon: Icon(Icons.settings, 
                  color: isCustom ? coreColor : Colors.white70, 
                  size: 26),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  FocusManager.instance.primaryFocus?.unfocus(); 
                  Scaffold.of(innerContext).openDrawer();
                },
              ),
            ),
          ),
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ArmoryText(
            "THE ARMORY",
            themeController: themeController,
            baseFontSize: 20,
            baseStrokeWidth: 3.0,
            color: Colors.white,
            overrideStrokeColor: Colors.black,
          ),
          const SizedBox(height: 4),
          _buildStatusIndicator(),
        ],
      ),
      actions: [
        SizedBox(
          width: 48,
          height: 48,
          child: IconButton(
            splashRadius: 24, 
            padding: EdgeInsets.zero,
            icon: Icon(Icons.palette_outlined, 
              color: isCustom ? coreColor.withOpacity(0.8) : Colors.white70, 
              size: 26),
            onPressed: () {
              HapticFeedback.mediumImpact();
              FocusManager.instance.primaryFocus?.unfocus();
              _showThemePickerDialog();
            },
          ),
        ),
        const SizedBox(width: 4),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2.5),
        child: Container(
          width: double.infinity,
          height: isCustom ? 2.5 : 1.5,
          decoration: BoxDecoration(
            color: isCustom ? coreColor : accentColor,
            boxShadow: isCustom ? [
              BoxShadow(
                color: accentColor.withOpacity(0.8),
                blurRadius: 1,
                spreadRadius: 0.5,
              ),
              BoxShadow(
                color: accentColor.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ] : [],
          ),
        ),
      ),
    ),


    body: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              activeTheme.backgroundUrl,
              fit: BoxFit.cover,
              cacheWidth: 1080, 
              filterQuality: FilterQuality.low,
              color: Colors.black.withOpacity(0.6),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _SearchField(
                  onChanged: search, 
                  themeController: themeController,
                  controller: _searchController,
                ),
                Expanded(
                  child: RepaintBoundary(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: keyboardHeight + 20),
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        return RepaintBoundary(
                          child: WeaponListItem(
                            key: ValueKey(displayList[index].name),
                            weapon: displayList[index], 
                            mainListChips: mainListChips, 
                            isPremium: _isPremiumUser,
                            isFavorite: _favorites.contains(displayList[index].name),
                            themeController: themeController, 
                            onFavorite: () {
                              _toggleFavorite(displayList[index].name);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          if (!_dataReady)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(isCustom ? coreColor : accentColor),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ArmoryText(
                          locale.translateStatic("SYNCHRONIZING DATA..."),
                          themeController: themeController,
                          baseFontSize: 14,
                          baseStrokeWidth: 2.0,
                          color: Colors.white,
                          overrideStrokeColor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _buildSettingsDrawer() {
  final themeController = widget.themeController;
  final activeTheme = themeController.activeTheme;
  final theme = Theme.of(context);
  final bool isCustom = activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;

  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

  return Drawer(
    elevation: 0,
    backgroundColor: Colors.transparent, 
    child: Container(
      decoration: BoxDecoration(
        color: isCustom 
            ? const Color(0xFF000000).withOpacity(0.98) 
            : theme.colorScheme.surface,

        border: Border(
          right: BorderSide(
            color: isCustom ? coreColor : theme.colorScheme.primary.withOpacity(0.8), 
            width: isCustom ? 3.5 : 2.5,
          ),
        ),

        boxShadow: isCustom ? [
          BoxShadow(
            color: accentColor.withOpacity(0.6), 
            blurRadius: 15, 
            spreadRadius: -2
          ),
          BoxShadow(
            color: accentColor.withOpacity(0.2), 
            blurRadius: 40, 
            spreadRadius: 2
          ),
        ] : [],
      ),
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isCustom 
                        ? accentColor.withOpacity(0.5) 
                        : theme.colorScheme.primary.withOpacity(0.1), 
                    width: 1.5
                  )
                ),

                boxShadow: isCustom ? [
                  BoxShadow(
                    color: accentColor.withOpacity(0.05),
                    offset: const Offset(0, 10),
                    blurRadius: 20,
                  )
                ] : [],
              ),
              child: Center(
                child: ArmoryText(
                  "THE ARMORY DRAWER",
                  themeController: themeController,
                  baseFontSize: 16,
                  baseStrokeWidth: isCustom ? 2.8 : 2.5,
                  color: isCustom ? Colors.black : Colors.white,
                  overrideStrokeColor: isCustom ? coreColor : Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
        
        Divider(color: isCustom ? coreColor : Theme.of(context).colorScheme.primary, height: 3, thickness: 1.5,),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              const SizedBox(height: 20),
              _buildAegisBox(activeTheme, theme),
              const SizedBox(height: 15),

              TacticalModuleButton(
                label: "RANDOMIZER",
                icon: Icons.cached_rounded,
                themeController: themeController,
                isPremiumUser: _isPremiumUser,
                onTap: () {
                  final aegisArc = Provider.of<AegisArc>(context, listen: false);

                  Navigator.push(
                    context, 
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      reverseTransitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (context, animation, secondaryAnimation) => RandomLoadoutScreen(
                        themeController: widget.themeController,
                        aegisArc: aegisArc,
                      ),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        var begin = const Offset(1.0, 0.0); 
                        var end = Offset.zero;
                        var curve = Curves.ease; 
                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                }),
              const SizedBox(height: 15),

              TacticalModuleButton(
                label: "AUGMENT TREE",
                icon: Icons.hub_rounded,
                themeController: themeController,
                isPremiumUser: _isPremiumUser,
                onTap: () => Navigator.push(
                  context, 
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    reverseTransitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (context, animation, secondaryAnimation) => 
                        AugmentTreeScreen(themeController: widget.themeController),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {

                      var begin = const Offset(1.0, 0.0); 
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TacticalModuleButton(
                label: "META PICKS",
                icon: Icons.assessment_rounded,
                themeController: themeController,
                isPremiumUser: _isPremiumUser,
                onTap: () => Navigator.push(
                  context, 
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    reverseTransitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (context, animation, secondaryAnimation) => 
                        MetaDashboardScreen(themeController: widget.themeController),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {

                      var begin = const Offset(1.0, 0.0); 
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TacticalModuleButton(
                label: "RANKED PLAY",
                icon: Icons.emoji_events_rounded,
                themeController: themeController,
                isPremiumUser: _isPremiumUser,
                onTap: () => Navigator.push(
                  context, 
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    reverseTransitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (context, animation, secondaryAnimation) => 
                        RankedPlayPage(themeController: widget.themeController, allWeapons: _loadedWeapons),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {

                      var begin = const Offset(1.0, 0.0); 
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TacticalModuleButton(
                label: "ARMORY DELTA",
                icon: Icons.compare_arrows_rounded,
                themeController: themeController,
                isPremiumUser: _isPremiumUser,
                onTap: () {
                  if (_isPremiumUser) {
                    Navigator.push(
                      context, 
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        reverseTransitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (context, animation, secondaryAnimation) => 
                            ComparisonScreen(
                              themeController: widget.themeController, 
                              allWeapons: _loadedWeapons
                            ),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(1.0, 0.0); 
                          var end = Offset.zero;
                          var curve = Curves.ease;
                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  } else {
                    _showPremiumLockDialog(context);
                  }
                },
              ),

              const SizedBox(height: 15),

              TacticalModuleButton(
                label: "${context.watch<AegisArc>().translateStatic("LANGUAGE:")} ${context.watch<AegisArc>().languageCode.toUpperCase()}",
                icon: Icons.language_rounded,
                themeController: themeController,
                isPremiumUser: _isPremiumUser,
                onTap: () {
                  HapticFeedback.mediumImpact(); 
                  
                  final locale = Provider.of<AegisArc>(context, listen: false);
                  final accentColor = themeController.activeAccentColor;
                  final isCustom = themeController.activeTheme.id == 'neon_custom';
                  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

                  final List<Map<String, String>> languages = [
                    {'code': 'en', 'title': 'ENGLISH'},
                    {'code': 'fr', 'title': 'FRANÇAIS'},
                    {'code': 'de', 'title': 'DEUTSCH'},
                    {'code': 'es', 'title': 'ESPAÑOL'},
                    // {'code': 'pt', 'title': 'PORTUGUÊS'},
                    // {'code': 'ru', 'title': 'РУССКИЙ'},
                    {'code': 'zh', 'title': '中文'},
                    // {'code': 'ja', 'title': '日本語'},
                  ];

                  showDialog(
                    context: context,
                    builder: (context) => BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: AlertDialog(
                        backgroundColor: isCustom ? Colors.black : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: isCustom ? BorderSide(color: coreColor, width: 1.5) : BorderSide.none,
                        ),
                        title: ArmoryText(
                          _getDialogTitle(locale.languageCode),
                          themeController: themeController,
                          textAlign: TextAlign.center,
                          baseFontSize: 20,
                        ),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: languages.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final lang = languages[index];
                              final String code = lang['code']!;
                              final bool isSelected = locale.languageCode == code;

                              return _buildLanguageOption(
                                context: context,
                                title: lang['title']!,
                                isSelected: isSelected,
                                  onTap: () async {
                                    if (!isSelected) {
                                      Navigator.pop(context);
                                      
                                      setState(() => _dataReady = false); 
                                    
                                      await locale.setLanguage(code);
                                      
                                      String suffix = (code == 'en') ? '' : '_$code';
                                      
                                      await _performPreload(
                                        isLanguageSwitch: true,
                                        forcedCode: code,
                                        forcedSuffix: suffix,
                                      ); 
                                      
                                      if (mounted) setState(() => _dataReady = true);

                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 15),
              const Divider(color: Colors.white10, thickness: 1),
              const SizedBox(height: 15),

              _isPremiumUser ? _buildPremiumSection() : _buildAuthSection(),
            ],
          ),
        ),

        Divider(color: isCustom ? coreColor : Theme.of(context).colorScheme.primary, height: 1, thickness: 1.5),

        _buildMinorDrawerTile(
          label: "HOTFIXES",
          icon: Icons.terminal_outlined,
          onTap: () async {
            final lang = context.read<AegisArc>().languageCode;
            final themeController = widget.themeController;

            final bool shouldFetch = themeController.currentPatchData == null ||
                                    themeController.currentPatchLang != lang;

            HapticFeedback.mediumImpact();
            _markHotfixRead();

            if (shouldFetch) {
              await themeController.syncPatchNotes(globalNgrokUrl, lang, forceRefresh: true);
              
              if (context.mounted) {
                _showHotFixesDialog(context, null);
              }
            } else {
              // Data is already in memory, show immediately
              _showHotFixesDialog(context, null);
            }
          },
          trailing: _hasNewHotfix
              ? Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
        ),
        _buildMinorDrawerTile(
          label: "PATCH NOTES",
          icon: Icons.terminal_outlined,
          onTap: () {
            HapticFeedback.mediumImpact(); 
            final String currentLang = context.read<AegisArc>().languageCode; 
            prepareAndShowPatchNotes(context, currentLang);
          }
        ),
        _buildMinorDrawerTile(
          label: "REPORT A BUG",
          icon: Icons.bug_report_outlined,
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(context);
            _showBugReportDialog();
          },
        ),
        _buildMinorDrawerTile(
          label: "JOIN THE ARMORY DISCORD SERVER",
          icon: Icons.discord, 
          onTap: () {
            HapticFeedback.mediumImpact(); 
            launchUrl(Uri.parse("https://discord.gg/mE5DRyf2BX"), mode: LaunchMode.externalApplication);
          }
        ),

        _buildMinorDrawerTile(
          label: "TRY ME OUT ON DISCORD",
          icon: Icons.discord_rounded,
          onTap: () { 
            HapticFeedback.mediumImpact(); 
            launchUrl(Uri.parse("https://top.gg/bot/1313580706131087421"), mode: LaunchMode.externalApplication);
          }
        ),
        
        _buildMinorDrawerTile(
          label: "INTRO SCREEN",
          icon: Icons.refresh_rounded,
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(context);
            setState(() {
              _isManualReplay = true;
              _currentState = AppState.onboarding;
            });
          },
        ),
        
        const SizedBox(height: 5), 
      ],
    ),
  ),
  );
}

String _getDialogTitle(String code) {
  switch (code) {
    case 'es': return "SELECCIONAR IDIOMA";
    case 'zh': return "选择语言";
    case 'fr': return "CHOISIR LA LANGUE";
    case 'ja': return "言語を選択";
    case 'de': return "SPRACHE AUSWÄHLEN";
    case 'pt': return "SELECIONAR IDIOMA";
    case 'ru': return "ВЫБОР ЯЗЫКА";
    case 'en':
    default: return "SELECT LANGUAGE";
  }
}

Widget _buildLanguageOption({
  required BuildContext context,
  required String title,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  final themeController = widget.themeController;
  final accentColor = themeController.activeAccentColor;
  final isCustom = themeController.activeTheme.id == 'neon_custom';
  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

  return InkWell(
    onTap: () {
      HapticFeedback.lightImpact();
      onTap();
    },
    borderRadius: BorderRadius.circular(24), 
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCustom ? Colors.black : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? coreColor : accentColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: isSelected ? coreColor : Colors.white38,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
              )),
            ],
          ),
        ],
      ),
    ),
  );
}

void _showPremiumLockDialog(BuildContext context) {
  final accentColor = widget.themeController.activeAccentColor;
  final isCustom = widget.themeController.activeTheme.id == 'neon_custom';
  final coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final locale = Provider.of<AegisArc>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF0D0D0D),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isCustom ? coreColor : accentColor, 
          width: 2
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      title: ArmoryText(
        locale.translateStatic("ACCESS RESTRICTED"),
        themeController: widget.themeController, 
        baseFontSize: 18, 
        color: Colors.white,
        textAlign: TextAlign.center,
      ),
      content: ArmoryText(
        locale.translateStatic("ARMORY DELTA IS A PREMIUM FEATURE.\n PLEASE LOG IN OR PURCHASE PREMIUM TO UNLOCK."),
        themeController: widget.themeController, 
        baseFontSize: 12, 
        color: Colors.white70,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            locale.translateStatic("BACK"),
            style: const TextStyle(color: Colors.white24)
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _openCommunityLink();
          },
          child: ArmoryText(
            locale.translateStatic("UPGRADE"),
            themeController: widget.themeController, 
            baseFontSize: 12, 
            color: isCustom ? coreColor : accentColor
          ),
        ),
      ],
    ),
  );
}

Widget _buildTacticalIcon(IconData icon, Color color, {double strokeSize = 1.0}) {
  return Text(
    String.fromCharCode(icon.codePoint),
    style: TextStyle(
      inherit: false,
      color: color,
      fontSize: 30,
      fontFamily: icon.fontFamily,
      package: icon.fontPackage,
      shadows: [
        Shadow(
          offset: Offset(-strokeSize, -strokeSize), 
          color: Colors.black, 
          blurRadius: 1
        ),
        Shadow(
          offset: Offset(strokeSize, -strokeSize), 
          color: Colors.black, 
          blurRadius: 1
        ),
        Shadow(
          offset: Offset(-strokeSize, strokeSize), 
          color: Colors.black, 
          blurRadius: 1
        ),
        Shadow(
          offset: Offset(strokeSize, strokeSize), 
          color: Colors.black, 
          blurRadius: 1
        ),
      ],
    ),
  );
}

Widget _buildAegisBox(ArmoryTheme activeTheme, ThemeData theme) {
  final bool isCustom = activeTheme.id == 'neon_custom';
  final themeController = widget.themeController;

  Color aegisColor;
  String aegisStatus;
  IconData aegisIcon;

  switch (_connectionStatus) {
    case ConnectionStatus.connected:
      aegisColor = Colors.greenAccent;
      aegisStatus = "ACTIVE";
      aegisIcon = Icons.shield_rounded;
      break;
    case ConnectionStatus.tunnelIssue:
      aegisColor = Colors.amberAccent;
      aegisStatus = "BUSY";
      aegisIcon = Icons.gpp_maybe_rounded;
      break;
    case ConnectionStatus.offline:
      aegisColor = Colors.redAccent;
      aegisStatus = "INACTIVE";
      aegisIcon = Icons.gpp_bad_rounded;
      break;
  }

  final Color coreColor = Color.lerp(aegisColor, Colors.white, 0.35)!;

  Widget boxContent = Container(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface.withOpacity(0.92),
      borderRadius: BorderRadius.circular(24),
      border: !isCustom ? Border.all(
        color: aegisColor,
        width: 2,
      ) : null,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTacticalIcon(
          aegisIcon, 
          isCustom ? coreColor : aegisColor, 
          strokeSize: 0.8
        ),
        const SizedBox(width: 15),

        Expanded(
          child: ArmoryText(
            "AEGIS PROTOCOL : $aegisStatus",
            themeController: themeController,
            baseFontSize: 12,
            baseStrokeWidth: 2.5,
            color: Colors.white,
            overrideStrokeColor: isCustom ? aegisColor.withOpacity(0.5) : Colors.black,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    ),
  );

    if (isCustom) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: coreColor,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: aegisColor.withOpacity(0.8),
            blurRadius: 1,
            spreadRadius: 0.5,
          ),
          BoxShadow(
            color: aegisColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: boxContent,
      ),
    );
  }
  
  return boxContent;
}

Widget _buildMinorDrawerTile({
  required String label, 
  required IconData icon, 
  required VoidCallback onTap,
  Widget? trailing,
}) {
  final themeController = widget.themeController;
  final bool isCustom = themeController.activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

  return ListTile(
    dense: true, 
    visualDensity: const VisualDensity(vertical: -4),
    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
    minVerticalPadding: 0,
    leading: Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: 1.17,
              child: Icon(
                icon,
                size: 16, 
                color: Colors.black,
              ),
            ),
            Icon(
              icon,
              size: 17, 
              color: isCustom ? coreColor : Colors.white54,
            ),
          ],
        ),
      ),
    ),
    title: ArmoryText(
      label,
      themeController: themeController,
      baseFontSize: 8.8,
      baseStrokeWidth: isCustom ? 2.2 : 1.6,
      color: Colors.white,
      overrideStrokeColor: Colors.black,
      letterSpacing: 0.5,
    ),
    trailing: trailing,
    onTap: () {
      HapticFeedback.lightImpact();
      onTap();
    },
  );
}

Widget _buildDrawerButton({
  required String label,
  required IconData icon,
  required VoidCallback onTap,
  required ThemeController themeController,
  Color? customColor,
}) {
  final activeTheme = themeController.activeTheme;
  final theme = Theme.of(context);
  final bool isHolographic = activeTheme.isHolographic;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
  final bool isCustom = activeTheme.id == 'neon_custom';

  final bool canShowEffects = _isPremiumUser; 

  final Color accentColor = themeController.activeAccentColor;
  final Color baseColor = customColor ?? (isCustom && canShowEffects ? accentColor : theme.colorScheme.primary);
  final Color coreColor = Color.lerp(baseColor, Colors.white, 0.35)!;

  Widget boxContent = Container(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    decoration: BoxDecoration(
      color: (isCustom && canShowEffects)
          ? theme.colorScheme.surface.withOpacity(0.92)
          : theme.colorScheme.surface.withOpacity(0.92), 
      borderRadius: BorderRadius.circular(24),
      border: (canShowEffects && (isHolographic || isAnemone || isCustom)) 
          ? null 
          : Border.all(color: baseColor.withOpacity(0.5), width: 1),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, color: (isCustom && canShowEffects) ? coreColor : baseColor, size: 20),
        const SizedBox(width: 15),
        Flexible(
          child: ArmoryText(
            label.toUpperCase(),
            themeController: themeController,
            baseFontSize: 12,
            baseStrokeWidth: 2.5,
            color: Colors.white,
            overrideStrokeColor: (isCustom && canShowEffects) ? baseColor.withOpacity(0.4) : Colors.black,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    ),
  );

  Widget themedButton;
  if (isHolographic && canShowEffects) {
    themedButton = _InternalAnimatedBorder(
      colors: activeTheme.refractionColors,
      child: boxContent,
    );
  } else if (isAnemone && canShowEffects) {
    themedButton = ArmoryGradientBorder(
      gradientColors: activeTheme.borderGradient,
      borderRadius: 12,
      strokeWidth: 2,
      child: boxContent,
    );
  } else if (isCustom && canShowEffects) {
    themedButton = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: coreColor, width: 2.0),
        boxShadow: [
          BoxShadow(color: baseColor.withOpacity(0.8), blurRadius: 1, spreadRadius: 0.5),
          BoxShadow(color: baseColor.withOpacity(0.3), blurRadius: 15, spreadRadius: 2),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: boxContent,
      ),
    );
  } else {
    themedButton = boxContent;
  }

  return GestureDetector(
    onTap: () {
      HapticFeedback.mediumImpact();
      onTap();
    },
    child: themedButton,
  );
}

Widget _buildPremiumSection() {
  final theme = Theme.of(context);
  final themeController = widget.themeController;
  final bool isCustom = themeController.activeTheme.id == 'neon_custom';
  final Color premiumGold = Colors.amberAccent;

  final Color coreColor = Color.lerp(premiumGold, Colors.white, 0.35)!;

  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isCustom ? coreColor : premiumGold.withOpacity(0.3), 
            width: 2.0,
          ),
          boxShadow: isCustom ? [
            BoxShadow(
              color: premiumGold.withOpacity(0.8),
              blurRadius: 1,
              spreadRadius: 0.5,
            ),
            BoxShadow(
              color: premiumGold.withOpacity(0.3),
              blurRadius: 15, 
              spreadRadius: 2,
            ),
          ] : [],
        ),
        child: Row(
          children: [
            _buildTacticalIcon(
              Icons.stars_rounded, 
              isCustom ? coreColor : premiumGold, 
              strokeSize: 0.8
            ),
            const SizedBox(width: 15),
            Flexible(
              child: ArmoryText(
                "PREMIUM STATUS: ACTIVE",
                themeController: themeController,
                baseFontSize: 11,
                baseStrokeWidth: 2.5,
                color: isCustom ? Colors.white : premiumGold,
                overrideStrokeColor: isCustom ? premiumGold.withOpacity(0.5) : Colors.black,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 5),
      
      TextButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          
          await prefs.remove('saved_discord_id');
          await prefs.remove('saved_pin');
          await prefs.setBool('is_premium_user', false);
          await widget.themeController.resetToDefault();

          setState(() {
            _isPremiumUser = false;
            _idController.clear();
            _pinController.clear();
          });
          
          HapticFeedback.heavyImpact();
        },
        child: ArmoryText(
          "TERMINATE SESSION",
          themeController: themeController,
          baseFontSize: 10,
          baseStrokeWidth: 1.8,
          color: Colors.redAccent.withOpacity(0.7), 
          letterSpacing: 1.1,
        ),
      ),
      const SizedBox(height: 12),
    ],
  );
}

Widget _buildAuthSection() {
  final themeController = widget.themeController;
  final bool isCustom = themeController.activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;

  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final Color primaryColor = isCustom ? accentColor : Theme.of(context).colorScheme.primary;

  return Column(
    children: [
      TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: _idController,
        style: TextStyle(
          color: isCustom ? coreColor : primaryColor, 
          fontFamily: themeController.activeFont, 
          fontSize: 13
        ),
        decoration: InputDecoration(
          label: ArmoryText(
            "DISCORD USER ID",
            themeController: themeController,
            baseFontSize: 10,
            baseStrokeWidth: 1.5,
            color: isCustom ? coreColor.withOpacity(0.8) : primaryColor,
            overrideStrokeColor: isCustom ? Colors.black : Colors.black,
          ),

          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: _buildTacticalIcon(
              Icons.person_search, 
              isCustom ? coreColor : primaryColor,
              strokeSize: 0.8
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: isCustom ? coreColor.withOpacity(0.4) : primaryColor.withOpacity(0.3), width: 1.5)
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: isCustom ? coreColor : primaryColor, width: 2.5)
          ),
        ),
      ),

      const SizedBox(height: 15),

      TextField(
        controller: _pinController,
        keyboardType: TextInputType.number, 
        obscureText: true,
        maxLength: 6,
        style: TextStyle(
          color: isCustom ? coreColor : primaryColor, 
          fontFamily: themeController.activeFont, 
          fontSize: 13
        ),
        decoration: InputDecoration(
          label: ArmoryText(
            "SECRET PIN",
            themeController: themeController,
            baseFontSize: 10,
            baseStrokeWidth: 1.5,
            color: isCustom ? coreColor.withOpacity(0.8) : primaryColor,
          ),

          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: _buildTacticalIcon(
              Icons.lock_outline, 
              isCustom ? coreColor : primaryColor,
              strokeSize: 0.8
            ),
          ),
          counterStyle: const TextStyle(color: Colors.white38), 
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: isCustom ? coreColor.withOpacity(0.4) : primaryColor.withOpacity(0.3), width: 1.5)
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: isCustom ? coreColor : primaryColor, width: 2.5)
          ),
        ),
      ),
      
      const SizedBox(height: 8),

      Container(
        decoration: isCustom ? BoxDecoration(
          borderRadius: BorderRadius.circular(25), 
          boxShadow: [
            BoxShadow(color: accentColor.withOpacity(0.8), blurRadius: 1, spreadRadius: 0.5),
            BoxShadow(color: accentColor.withOpacity(0.3), blurRadius: 15, spreadRadius: 2),
          ],
        ) : null,
        child: ElevatedButton(
          onPressed: _verifyPremium,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            side: BorderSide(color: isCustom ? _ArmoryOnboardingState.armoryBlue : _ArmoryOnboardingState.armoryBlue, width: 2.0),
            shape: const StadiumBorder(),
            backgroundColor: isCustom ? const Color.fromARGB(255, 0, 0, 0) : Theme.of(context).colorScheme.surface.withOpacity(0.9), 
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTacticalIcon(
                Icons.login_outlined, 
                isCustom ? _ArmoryOnboardingState.armoryBlue : _ArmoryOnboardingState.armoryBlue,
                strokeSize: 0.8,
              ),

              const SizedBox(width: 12),
        
            ArmoryText(
              "AUTHENTICATE",
              themeController: themeController,
              baseFontSize: 12,
              baseStrokeWidth: 2.5,
              color: Colors.white,
              overrideStrokeColor: isCustom ? accentColor : Colors.black,
              textAlign: TextAlign.center,
            ),
         ],
        ),
      ),
     ),

      const SizedBox(height: 15),

       Container(
        decoration: isCustom ? BoxDecoration(
          borderRadius: BorderRadius.circular(24), 
          boxShadow: [
            BoxShadow(color: Colors.amberAccent.withOpacity(0.8), blurRadius: 1, spreadRadius: 0.5),
            BoxShadow(color: Colors.amberAccent.withOpacity(0.3), blurRadius: 10, spreadRadius: 1),
          ],
        ) : null,
        child: OutlinedButton(
          onPressed: _openCommunityLink, 
          style: OutlinedButton.styleFrom(
            backgroundColor: isCustom ? Colors.black : Theme.of(context).colorScheme.surface.withOpacity(0.9),
            side: BorderSide(
              color: isCustom 
                ? Color.lerp(Colors.amberAccent, Colors.white, 0.35)! 
                : Colors.amberAccent, 
              width: 1.5
            ), 
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTacticalIcon(
                Icons.shop_two_outlined, 
                isCustom ? Colors.white : Colors.amberAccent,
                strokeSize: 0.8
              ),

              const SizedBox(width: 12),

              ArmoryText(
                "PURCHASE PREMIUM",
                themeController: themeController,
                baseFontSize: 10,
                baseStrokeWidth: 1.5,
                color: Colors.white,
                overrideStrokeColor: isCustom ? Colors.amberAccent : Colors.black,
              ),
            ],
          ),
        ),
      ),
      
      const SizedBox(height: 6),
      
      TextButton(
        onPressed: () => _showForgotPinDialog(),
        child: ArmoryText(
          "FORGOT PIN?",
          themeController: widget.themeController,
          baseFontSize: 10,
          color: Colors.white.withOpacity(0.5),
          baseStrokeWidth: 1.8,
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}

void _showForgotPinDialog() {
  HapticFeedback.lightImpact();
  
  final locale = Provider.of<AegisArc>(context, listen: false);
  
  showDialog(
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        backgroundColor: const Color.fromARGB(255, 10, 14, 17),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color.fromRGBO(55, 87, 193, 1), width: 1.5),
        ),
        title: ArmoryText(
          locale.translateStatic("RECOVER YOUR PIN"),
          themeController: widget.themeController,
          baseFontSize: 16,
          color: Colors.white,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                'assets/images/pin.jpg',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: ArmoryText(
                locale.translateStatic(
                  "If you forgot your pin, no sweat. Head on over to a Discord server that Armory Bot is in, and use the /armorypin command. "
                  "This will grab your pin and display it for you to keep in your fancy notebook you definitely remembered you had. And don't worry about someone stealing it, "
                  "the message is only visible to you. Then, just come on back and log in!"
                ),
                themeController: widget.themeController,
                baseFontSize: 12,
                color: Colors.white.withOpacity(0.8),
                textAlign: TextAlign.center,
                allowWrap: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: ArmoryText(
              locale.translateStatic("ACKNOWLEDGED"),
              themeController: widget.themeController,
              baseFontSize: 12,
              color: const Color(0xFF448AFF),
            ),
          ),
        ],
      ),
    ),
  );
}

void _showHotFixesDialog(BuildContext context, Map<String, dynamic>? data) {
  final patchData = widget.themeController.currentPatchData ?? data;
  final aegisArc = Provider.of<AegisArc>(context, listen: false);
  final String lang = aegisArc.languageCode.toLowerCase();

  if (patchData == null) {
    widget.themeController
        .syncPatchNotes(_activeBaseUrl, aegisArc.languageCode)
        .then((_) {
          if (context.mounted) {
            _showHotFixesDialog(context, null);
          }
        });
    return;
  }

  // Extract the notes map and get the list for the current language
  final Map<String, dynamic> notesMap = Map<String, dynamic>.from(patchData['notes'] ?? {});
  final List<String> localizedNotes = List<String>.from(notesMap[lang] ?? notesMap['en'] ?? []);

  final themeController = widget.themeController;
  final activeTheme = themeController.activeTheme;
  final bool isCustom = activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );

  HapticFeedback.lightImpact();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: isCustom ? const Color(0xFF000000) : primaryFaded,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: isCustom ? coreColor : Theme.of(context).colorScheme.primary, 
              width: 1.5
            ),
          ),
          title: Column(
            children: [
              ArmoryText(
                "ARMORY HOTFIXES",
                themeController: themeController,
                baseFontSize: 16,
                color: Colors.white,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              ArmoryText(
                patchData['patch_date'] ?? "LATEST UPDATE",
                themeController: themeController,
                baseFontSize: 10,
                color: Colors.white.withOpacity(0.5),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: localizedNotes.map((note) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ArmoryText(
                      "• $note",
                      themeController: themeController,
                      baseFontSize: 11,
                      color: Colors.white.withOpacity(0.9),
                      textAlign: TextAlign.center,
                      allowWrap: true,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                HapticFeedback.heavyImpact();
                Navigator.pop(context);
                widget.themeController.markPatchRead(); 
                await _markHotfixRead(); 
              },
              child: ArmoryText(
                "ACKNOWLEDGED",
                themeController: themeController,
                baseFontSize: 13,
                color: isCustom ? coreColor : accentColor,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildLanguageSelectionScreen({Key? key}) { 
  final locale = Provider.of<AegisArc>(context, listen: false);
  final theme = widget.themeController;
  const Color armoryBlue = Color.fromRGBO(55, 87, 193, 1);

  final List<Map<String, String>> languages = [
    {'code': 'en', 'title': 'ENGLISH'},
    {'code': 'fr', 'title': 'FRANÇAIS'},
    {'code': 'de', 'title': 'DEUTSCH'},
    {'code': 'es', 'title': 'ESPAÑOL'},
    // {'code': 'pt', 'title': 'PORTUGUÊS'},
    // {'code': 'ru', 'title': 'РУССКИЙ'},
    {'code': 'zh', 'title': '中文'},
    // {'code': 'ja', 'title': '日本語'},
  ];

    return Scaffold(
      key: key,
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ArmoryText(
                  "SYSTEM INITIALIZATION", 
                  themeController: theme, 
                  baseFontSize: 24,
                ),
                const SizedBox(height: 8),
                const Text(
                  "SELECT INTERFACE LANGUAGE",
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 40),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: languages.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final lang = languages[index];
                      return _buildLanguageOption(
                        context: context,
                        title: lang['title']!,
                        isSelected: false,
                        onTap: () async {
                          HapticFeedback.heavyImpact();
                          await locale.setLanguage(lang['code']!);

                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('show_onboarding', true); 

                          setState(() {
                            _currentState = AppState.onboarding;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WeaponListItem extends StatelessWidget {
  final Weapon weapon;
  final List<String> mainListChips;
  final bool isPremium;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final ThemeController themeController;


  const WeaponListItem({
    super.key,
    required this.weapon,
    required this.mainListChips,
    required this.isPremium,
    required this.isFavorite,
    required this.onFavorite,
    required this.themeController,
  });

@override
Widget build(BuildContext context) {
  final activeTheme = themeController.activeTheme;
  final theme = Theme.of(context);
  final Color accentColor = themeController.activeAccentColor;
  final bool isCustom = activeTheme.id == 'neon_custom';

  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.4)!;
  
  String? archetype;

  for (var category in weapon.builds.values) {
    for (var build in category) {
      if (build.stats?.archetype != null) {
        archetype = build.stats!.archetype;
        break;
      }
    }
    if (archetype != null) break;
  }

  if (archetype == null || archetype.isEmpty) {
    archetype = _legacyArchetypes[weapon.name]; 
  }

  Widget cardContent = RepaintBoundary(
    child: Card(
      color: isCustom 
          ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9) 
          : theme.colorScheme.surface.withOpacity(0.7), 
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide.none,
      ),
      child: ListTile(
          onTap: () {
            HapticFeedback.mediumImpact();
            FocusManager.instance.primaryFocus?.unfocus();

            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 400),
                reverseTransitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (context, animation, secondaryAnimation) => DetailScreen(
                  weapon: weapon,
                  isPremiumUser: isPremium,
                  themeController: themeController,
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.easeOutCubic;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
          leading: Container(
            decoration: isCustom ? BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: accentColor.withOpacity(0.4), blurRadius: 10)],
            ) : null,
            child: _SmartImage(url: weapon.gameLogoUrl, width: 40)
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ArmoryText(
                  weapon.name.toUpperCase(),
                  themeController: themeController,
                  baseFontSize: 16,
                  baseStrokeWidth: 3.0,
                  overrideStrokeColor: Colors.black, 
                  color: Colors.white,
                ),
              ),
              if (archetype != null && archetype.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: isCustom ? Colors.black : theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isCustom ? coreColor : theme.colorScheme.primary.withOpacity(0.5),
                      width: 1.2,
                    ),
                  ),
                  child: ArmoryText(
                    archetype.toUpperCase(),
                    themeController: themeController,
                    baseFontSize: 8,
                    baseStrokeWidth: 1.0,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ],
          ),
          subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: mainListChips.where((m) {
                if (weapon.name == "MAGNUM (CW)" && m == "Multiplayer") {
                  return false;
                }
                return true;
              }).map((m) {
                bool isLit = weapon.builds.containsKey(m);
                if (m == "Multiplayer") {
                  isLit = weapon.builds.containsKey("Multiplayer") || 
                          weapon.builds.containsKey("MULTIPLAYER FULL AUTO") || 
                          weapon.builds.containsKey("MULTIPLAYER SEMI AUTO");
                }

                return _StatusChip(
                  label: m,
                  isActive: isLit,
                  themeController: themeController,
                );
              }).toList(),
            ),
          ),
        ),
          trailing: IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : (isCustom ? coreColor.withOpacity(0.5) : Colors.white10),
            ),
            onPressed: () {
              HapticFeedback.mediumImpact();
              onFavorite();
            },
          ),
        ),
      ),
  );

  Widget finalWidget;

  if (activeTheme.isHolographic) {
    finalWidget = _InternalAnimatedBorder(
      colors: activeTheme.refractionColors,
      borderRadius: 24,
      strokeWidth: 3.0,
      child: cardContent,
    );
  } else if (activeTheme.category == ThemeCategory.anemone) {
    finalWidget = RepaintBoundary(
      child: ArmoryGradientBorder(
        gradientColors: activeTheme.borderGradient,
        strokeWidth: 2.5,
        borderRadius: 24,
        child: cardContent,
      ),
    );
  } else if (isCustom) {
    finalWidget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: coreColor, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.8), 
            blurRadius: 1, 
            spreadRadius: 0.5
          ),
          BoxShadow(
            color: accentColor.withOpacity(0.3), 
            blurRadius: 15, 
            spreadRadius: 2
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: cardContent,
      ),
    );
  } 
  else {
    finalWidget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.7), 
          width: 2.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: cardContent,
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    child: finalWidget,
  );
}
}

class DetailScreen extends StatefulWidget {
  final Weapon weapon;
  final bool isPremiumUser;
  final ThemeController themeController;

  const DetailScreen({
    super.key,
    required this.weapon,
    required this.isPremiumUser,
    required this.themeController,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late List<WeaponBuild> flatBuilds;
  late int selectedIndex;
  bool showStats = false;
  bool isFastMode = false;
  Map<String, ArchetypeRank>? archetypeRankings = {};
  bool isRankingLoading = true;
  bool showSpecialCode = false;

  @override
  void initState() {
    super.initState();
    _calculateRankings(widget.weapon.name.toUpperCase().trim());

    final keys = widget.weapon.builds.keys.where((k) {
      if (widget.weapon.name == "MAGNUM (CW)" && k == "Multiplayer") return false;
      return true;
    }).toList();

    const order = {
      "MULTIPLAYER FULL AUTO": 0, "MULTIPLAYER SEMI AUTO": 1, "Multiplayer": 2, 
      "Warzone": 3, "Rebirth": 4, "Warzone Prestige": 5, "Endgame": 6, 
      "Zombies": 7, "Special": 8
    };
    
    keys.sort((a, b) => (order[a] ?? 99).compareTo(order[b] ?? 99));
    
    flatBuilds = [];
    for (var k in keys) { 
      flatBuilds.addAll(widget.weapon.builds[k]!); 
    }
    selectedIndex = 0;
  }

Future<void> _calculateRankings(String targetSearchName) async {
  if (!mounted) return;
  setState(() => isRankingLoading = true);

  try {
    final String statsRaw = await loadHotfixedJson('assets/Premium_Stats.json');
    final String archetypesRaw = await loadHotfixedJson('assets/archetypes.json');
    
    final Map<String, dynamic> statsJson = json.decode(statsRaw);
    final Map<String, dynamic> archetypesJson = json.decode(archetypesRaw);

    final List<dynamic> allStats = statsJson['Premium_Stats'] ?? [];
    final Map<String, dynamic> archetypeMap = archetypesJson['archetypes'] ?? {};

    String searchName = targetSearchName.toUpperCase().trim();

    final currentStatsEntry = allStats.firstWhere(
      (s) => s['weapon_name']?.toString().toUpperCase().trim() == searchName,
      orElse: () => null
    );

    if (currentStatsEntry == null ||
        currentStatsEntry['bullet_velocity'] == "-" || 
        currentStatsEntry['bullet_velocity'] == null) {
      if (mounted) {
        setState(() {
          archetypeRankings = null;
          isRankingLoading = false;
        });
      }
      return;
    }

    String? currentArchetype;
    final String baseLookupName = widget.weapon.name.split(" (")[0].toUpperCase().trim();

    archetypeMap.forEach((type, weapons) {
      if ((weapons as List).any((w) => w.toString().toUpperCase().trim().contains(baseLookupName))) {
        currentArchetype = type;
      }
    });

    if (currentArchetype == null) {
      if (mounted) setState(() => isRankingLoading = false);
      return;
    }

    List<Map<String, dynamic>> peerStatsPool = [];
    List<String> namesInArch = List<String>.from(archetypeMap[currentArchetype]);

    for (var name in namesInArch) {
      final entry = allStats.firstWhere(
        (s) => s['weapon_name']?.toString().toUpperCase().trim() == name.toUpperCase().trim(),
        orElse: () => null
      );
      if (entry != null) {
        peerStatsPool.add(Map<String, dynamic>.from(entry));
      }
    }

    int realTotal = peerStatsPool.length;
    Map<String, ArchetypeRank> results = {};
    Map<String, String> keyMap = {
      'ttkClose': 'ttk1', 
      'ttkFar': 'ttk2', 
      'adsSpeed': 'ads_speed',
      'velocity': 'bullet_velocity', 
      'stk': 'shots_to_kill'
    };

    double clean(dynamic val, String key) {
      if (val == null || val == "-") return (key == 'bullet_velocity') ? 0.0 : 9999.0;
      String s = val.toString().trim();

      if (key == 'shots_to_kill') {
        if (s.contains('-')) {
          List<String> parts = s.split('-');
          double close = double.tryParse(parts[0].replaceAll(RegExp(r'[^0-9.]'), '')) ?? 99.0;
          double far = double.tryParse(parts[1].replaceAll(RegExp(r'[^0-9.]'), '')) ?? 99.0;
          return (close * 100) + far;
        }
        double single = double.tryParse(s.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 99.0;
        return (single * 100) + single;
      }

      String cleaned = s.split('-')[0].replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }

    for (var entry in keyMap.entries) {
      List<Map<String, dynamic>> sortedPool = List.from(peerStatsPool);

      sortedPool.sort((a, b) {
        double vA = clean(a[entry.value], entry.value);
        double vB = clean(b[entry.value], entry.value);
        
        if (entry.value == 'bullet_velocity') {
          if (vA == 0) return 1;
          if (vB == 0) return -1;
          return vB.compareTo(vA);
        } 

        if (vA >= 9999) return 1;
        if (vB >= 9999) return -1;
        
        return vA.compareTo(vB);
      });

      int rankIndex = sortedPool.indexWhere(
        (s) => s['weapon_name']?.toString().toUpperCase().trim() == searchName
      );

      results[entry.key] = ArchetypeRank(rankIndex == -1 ? realTotal : rankIndex + 1, realTotal);
    }

    if (mounted) {
      setState(() {
        archetypeRankings = results;
        isRankingLoading = false;
      });
    }
  } catch (e) {
    debugPrint("Error in _calculateRankings: $e");
    if (mounted) setState(() => isRankingLoading = false);
  }
}

@override
Widget build(BuildContext context) {
  final activeTheme = widget.themeController.activeTheme;
  final theme = Theme.of(context);
  final bool isHolographic = activeTheme.isHolographic;
  final bool isCustom = activeTheme.id == 'neon_custom';
  final Color accentColor = widget.themeController.activeAccentColor;
  final locale = Provider.of<AegisArc>(context);
  final Color primaryBorder = Color.lerp(Theme.of(context).colorScheme.primary, Colors.white, 0.3)!;

  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

  final currentBuild = flatBuilds[selectedIndex];
  final bool canShowStats = (currentBuild.category.toLowerCase().contains('warzone') || 
                              currentBuild.category.toLowerCase() == 'special') && 
                            currentBuild.stats != null;

  String baseWeaponName = widget.weapon.name.split(" - ")[0].toUpperCase();
  String effectiveImageUrl = widget.weapon.imageUrl;
  
  final bool isSokol = baseWeaponName.contains("SOKOL 545");
  final bool isRebirth = currentBuild.category == "Rebirth";

  WeaponStats? displayStats = (isSokol && isFastMode && currentBuild.alternativeStats != null)
      ? currentBuild.alternativeStats
      : currentBuild.stats;

  final bool shouldShowToggle = (currentBuild.category.toLowerCase().contains('warzone') || 
                               currentBuild.category.toLowerCase() == 'special') && 
                               currentBuild.stats != null && 
                               currentBuild.stats!.ttk1 != "-" &&
                               currentBuild.category != "Rebirth";

  return Scaffold(
    backgroundColor: theme.colorScheme.surface,
    extendBodyBehindAppBar: true, 
    appBar: AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ArmoryText(
              widget.weapon.name.toUpperCase(),
              themeController: widget.themeController,
              baseFontSize: 18,
              baseStrokeWidth: 2.5,
              overrideStrokeColor: Colors.black,
            ),
          ),
          
          const SizedBox(width: 10),

          if ((displayStats?.archetype ?? widget.weapon.classType ?? "").isNotEmpty)
            _buildArchetypeBadge(
              displayStats?.archetype ?? widget.weapon.classType ?? "WEAPON", 
              isCustom, 
              coreColor, 
              theme
            ),
        ],
      ),
      backgroundColor: isCustom 
          ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9) 
          : theme.colorScheme.surface.withOpacity(0.8),
      elevation: 0,
      shape: isCustom ? Border(
        bottom: BorderSide(
          color: Color.lerp(accentColor, Colors.white, 0.35)!, 
          width: 2
        ),
      ) : null,
      actions: [
        if (shouldShowToggle && showStats && isSokol) _buildFireModeToggle(),
        if (shouldShowToggle) ...[
          if (widget.isPremiumUser) ...[
            const SizedBox(width: 2),
            Center(
              child: ArmoryText(
                "STATS",
                themeController: widget.themeController,
                baseFontSize: 10,
                baseStrokeWidth: 1.5,
                color: isCustom 
                    ? Color.lerp(accentColor, Colors.white, 0.35)! 
                    : theme.colorScheme.primary,
                letterSpacing: 1.0,
              ),
            ),
            Theme(
              data: theme.copyWith(
                switchTheme: SwitchThemeData(
                  thumbColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) return isCustom ? Colors.white : accentColor;
                    return Colors.white24;
                  }),
                  trackColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) return accentColor.withOpacity(0.5);
                    return Colors.black45;
                  }),
                ),
              ),
              child: Switch(
                value: showStats, 
                onChanged: (v) {
                  HapticFeedback.mediumImpact(); 
                  setState(() => showStats = v);
                },
                activeColor: isCustom ? Color.lerp(accentColor, Colors.white, 0.35)! : theme.colorScheme.primary,
                activeTrackColor: isCustom ? accentColor.withOpacity(0.3) : null,
              ),
            ),
          ] else ...[
              IconButton(
                icon: const Icon(Icons.analytics_outlined, color: Colors.white24, size: 18),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      behavior: SnackBarBehavior.fixed,
                      elevation: 0,
                      shape: Border(
                        top: BorderSide(
                          color: isCustom 
                              ? Color.lerp(accentColor, Colors.white, 0.35)! 
                              : theme.colorScheme.primary.withOpacity(0.5), 
                          width: 2.0,
                        ),
                      ),
                      content: ArmoryText(
                        "PURCHASE PREMIUM TO ACCESS ADVANCED WEAPON STATS",
                        themeController: widget.themeController,
                        baseFontSize: 10,
                        baseStrokeWidth: 1.5,
                        color: Colors.white,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              )
            ]
          ]
        ],
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              activeTheme.backgroundUrl,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(isHolographic ? 0.5 : 0.7),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          SafeArea(
          child: Column(
            children: [
              _ImageHeader(url: effectiveImageUrl),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), 
                child: Wrap(
                  spacing: 8.0, 
                  runSpacing: 8.0, 
                  alignment: WrapAlignment.center,
                  children: List.generate(flatBuilds.length, (index) {
                    final b = flatBuilds[index];
                    bool sel = selectedIndex == index;

                    Color buildAccent = b.category == "Special" 
                    ? Colors.purpleAccent 
                    : (b.category == "Rebirth" 
                        ? Colors.orangeAccent
                        : (b.category.contains("Prestige") ? const Color(0xFFFFD700) : accentColor));
                        

                    final Color coreColor = Color.lerp(buildAccent, Colors.white, 0.35)!;

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact(); 
                        final newBuild = flatBuilds[index];
                        
                        final bool isWarzone = newBuild.category.toLowerCase().contains('warzone');
                        final bool isPrestige = newBuild.category.toLowerCase().contains('prestige');
                        final bool isSpecial = newBuild.category.toLowerCase() == 'special';
                        
                        final bool hasValidStats = (isWarzone || isPrestige || isSpecial) && 
                                                    newBuild.stats != null && 
                                                    newBuild.stats!.ttk1 != "-";

                        setState(() {
                          selectedIndex = index;

                          if (!hasValidStats) {
                            showStats = false; 
                            archetypeRankings = null; 
                            isRankingLoading = false;
                          } else {
                            isRankingLoading = true;
                          }
                        });

                        if (hasValidStats) {
                          String targetSearchName = widget.weapon.name.toUpperCase().trim();
                          if (targetSearchName.contains("SOKOL 545")) {
                            targetSearchName = isFastMode ? "SOKOL 545 (FAST)" : "SOKOL 545 (SLOW)";
                          } else if (isSpecial && newBuild.modName != null) {
                            targetSearchName = "${widget.weapon.name.toUpperCase()} ${newBuild.modName!.toUpperCase()}";
                          } else if (isPrestige) {
                            targetSearchName = "$targetSearchName (PRESTIGE)";
                          }

                          _calculateRankings(targetSearchName);
                        }
                      },

                      // GAME MODE SELECTORS

                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: (isCustom && sel) 
                              ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9)
                              : (sel ? buildAccent : theme.colorScheme.surface.withOpacity(0.9)),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: (isCustom && sel) ? coreColor : (sel ? Colors.white : buildAccent.withOpacity(0.3)),
                            width: sel ? 2 : 1,
                          ),
                          boxShadow: (isCustom && sel) ? [
                            BoxShadow(color: buildAccent.withOpacity(0.8), blurRadius: 1, spreadRadius: 0.5),
                            BoxShadow(color: buildAccent.withOpacity(0.3), blurRadius: 15, spreadRadius: 2),
                          ] : [],
                        ),
                        child: ArmoryText(
                          (b.modName ?? b.category).toUpperCase(),
                          themeController: widget.themeController,
                          baseFontSize: 10,
                          baseStrokeWidth: 1.5,
                          color: (isCustom && sel) ? Colors.white : (sel ? Colors.black : Colors.white),
                          overrideStrokeColor: (isCustom && sel) ? Colors.black : (sel ? Colors.white : Colors.black), 
                        ),
                      ),
                    );
                  }),
                ),
              ),
                
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  children: [
                    if (shouldShowToggle) _CombatRatingDisplay(stats: displayStats, themeController: widget.themeController),
                    if (showStats && widget.isPremiumUser)
                        _PremiumStatCard(
                          stats: displayStats!,
                          themeController: widget.themeController,
                          rankings: archetypeRankings,
                          isLoading: isRankingLoading,
                        ),
                    if (currentBuild.modName != null) 

                      // Special Box

                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 4, right: 10, left: 10), 
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isCustom 
                                ? const Color(0xFF000000) 
                                : theme.colorScheme.surface.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isCustom ? coreColor : primaryBorder, 
                              width: isCustom ? 2.5 : 1.5,
                            ),
                            boxShadow: isCustom ? [

                              BoxShadow(
                                color: accentColor.withOpacity(0.8), 
                                blurRadius: 1, 
                                spreadRadius: 0.5
                              ),

                              BoxShadow(
                                color: accentColor.withOpacity(0.3), 
                                blurRadius: 15, 
                                spreadRadius: 2
                              ),
                            ] : [],
                          ),
                          child: Center(
                            child: ArmoryText(
                              (currentBuild.category == "Special" ? "SPECIAL BUILD" : 
                              currentBuild.category == "Rebirth" ? "REBIRTH BUILD" : 
                              currentBuild.category).toUpperCase(),
                              themeController: widget.themeController,
                              baseFontSize: 14,
                              baseStrokeWidth: isCustom ? 2.5 : 2.0,
                              color: Colors.white,
                              overrideStrokeColor: isCustom ? accentColor.withOpacity(0.6) : Colors.black,
                              letterSpacing: 3.0,
                            ),
                          ),
                        ),
                      ),
                        
                        ...currentBuild.buildCodes.map((c) => _BuildCodeBox(
                      code: c, 
                      weaponName: widget.weapon.name, 
                      mode: currentBuild.category, 
                      themeController: widget.themeController, 
                    )),

                    const SizedBox(height: 10),

                    ...currentBuild.attachments.map((att) => AttachmentTile(
                      text: att,
                      isStarred: currentBuild.starredAttachments.contains(att),
                      themeController: widget.themeController
                    )),

                    if (currentBuild.specialtyValue != null) 
                      _SpecialtyBox(
                        value: currentBuild.specialtyValue!, 
                        themeController: widget.themeController, 
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
}

Widget _ImageHeader({required String url}) {
  final String weaponName = widget.weapon.name;
  
  final ScaleProfile profile = weaponScaleOverrides[weaponName] ?? 
                               const ScaleProfile(scale: 1.0, padding: 26.0);

  return Container(
    height: 160,
    width: double.infinity,
    color: Colors.transparent,
    child: Center(
      child: Padding(
        padding: EdgeInsets.all(profile.padding), 
        child: Transform.scale(
          scale: profile.scale, 
          child: _SmartImage(url: url), 
        ),
      ),
    ),
  );
}

Widget _buildFireModeToggle() {
  final activeTheme = widget.themeController.activeTheme;
  final bool isCustom = activeTheme.id == 'neon_custom';
  final Color fireColor = isFastMode ? Colors.redAccent : Colors.greenAccent;
  final Color coreColor = Color.lerp(fireColor, Colors.white, 0.35)!;

  return Center(
    child: GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        
        final bool nextMode = !isFastMode;

        setState(() {
          isFastMode = nextMode;
          isRankingLoading = true;
        });

        String targetSearchName = widget.weapon.name.toUpperCase().trim();
        
        if (targetSearchName.contains("SOKOL 545")) {
          targetSearchName = nextMode ? "SOKOL 545 (FAST)" : "SOKOL 545 (SLOW)";
        }

        _calculateRankings(targetSearchName);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isCustom 
              ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9) 
              : fireColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isCustom ? coreColor : fireColor,
            width: isCustom ? 1.5 : 1.0,
          ),
          boxShadow: isCustom ? [

            BoxShadow(
              color: fireColor.withOpacity(0.8),
              blurRadius: 1,
              spreadRadius: 0.5,
            ),
            BoxShadow(
              color: fireColor.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ] : [],
        ),
        child: ArmoryText(
          isFastMode ? "FAST FIRE" : "SLOW FIRE",
          themeController: widget.themeController,
          baseFontSize: 9,
          baseStrokeWidth: isCustom ? 2.2 : 2.0,
          color: isCustom ? Colors.white : fireColor,
          overrideStrokeColor: isCustom ? fireColor : Colors.black,
          letterSpacing: 1.0,
        ),
      ),
    ),
  );
}

bool _hasActualData(String? val) => val != null && val != "-" && val.isNotEmpty;

Widget _buildArchetypeBadge(String label, bool isCustom, Color coreColor, ThemeData theme) {
  return Container(
    padding: EdgeInsets.only(top: 2, bottom: 3, left: 6, right: 6),
    decoration: BoxDecoration(
      color: isCustom ? Colors.black : theme.colorScheme.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: isCustom ? coreColor : theme.colorScheme.primary.withOpacity(0.5), width: 1.5),
    ),
    child: ArmoryText(label.toUpperCase(), themeController: widget.themeController, baseFontSize: 9),
  );
}
}

class ScaleProfile {
  final double scale;
  final double padding;
  const ScaleProfile({this.scale = 1.0, this.padding = 15.0});
}

const Map<String, ScaleProfile> weaponScaleOverrides = {
  // --- MODERN WARFARE (2019) ---
  "AK-47 (MW19)": ScaleProfile(scale: 1.5, padding: 10.0),
  "AN-94": ScaleProfile(scale: 1.5, padding: 10.0),
  "AS VAL (MW19)": ScaleProfile(scale: 1.5, padding: 10.0),
  "AUG (MW19)": ScaleProfile(scale: 1.2, padding: 10.0),
  "CR-56 AMAX (MW19)": ScaleProfile(scale: 1.5, padding: 10.0),
  "FAL": ScaleProfile(scale: 1.5, padding: 10.0),
  "FN SCAR 17": ScaleProfile(scale: 1.5, padding: 10.0),
  "FR 5.56 (MW19)": ScaleProfile(scale: 1.3, padding: 10.0),
  "GRAU 5.56": ScaleProfile(scale: 1.3, padding: 10.0),
  "KILO 141 (MW19)": ScaleProfile(scale: 1.4, padding: 10.0),
  "M13": ScaleProfile(scale: 1.4, padding: 10.0),
  "M4A1 (MW19)": ScaleProfile(scale: 1.3, padding: 10.0),
  "ODEN": ScaleProfile(scale: 1.3, padding: 10.0),
  "RAM-7 (MW19)": ScaleProfile(scale: 1.3, padding: 10.0),
  "SA87": ScaleProfile(scale: 1.4, padding: 10.0),
  "CX-9": ScaleProfile(scale: 1.2, padding: 10.0),
  "FENNEC (MW19)": ScaleProfile(scale: 1.0, padding: 10.0),
  "ISO (MW19)": ScaleProfile(scale: 1.1, padding: 10.0),
  "MP5 (MW19)": ScaleProfile(scale: 1.15, padding: 10.0),
  "MP7": ScaleProfile(scale: 1.1, padding: 10.0),
  "P90": ScaleProfile(scale: 1.15, padding: 10.0),
  "PP19 BIZON (MW19)": ScaleProfile(scale: 1.3, padding: 10.0),
  "STRIKER 45 (MW19)": ScaleProfile(scale: 1.0, padding: 10.0),
  "UZI": ScaleProfile(scale: 1.4, padding: 10.0),
  "BRUEN MK9 (MW19)": ScaleProfile(scale: 1.5, padding: 10.0),
  "FiNN LMG": ScaleProfile(scale: 1.5, padding: 10.0),
  "HOLGER-26 (MW19)": ScaleProfile(scale: 1.5, padding: 10.0),
  "M91": ScaleProfile(),
  "MG34": ScaleProfile(scale: 1.5, padding: 10.0),
  "PKM": ScaleProfile(scale: 1.5, padding: 10.0),
  "RAAL MG (MW19)": ScaleProfile(scale: 1.1, padding: 10.0),
  "725": ScaleProfile(scale: 1.5, padding: 10.0),
  "JAK-12": ScaleProfile(scale: 1.25, padding: 10.0),
  "MODEL 680 (MW19)": ScaleProfile(scale: 1.5, padding: 10.0),
  "ORIGIN 12": ScaleProfile(scale: 1.3, padding: 10.0),
  "R9-0": ScaleProfile(scale: 1.3, padding: 10.0),
  "VLK ROGUE": ScaleProfile(scale: 1.4, padding: 10.0),
  "CROSSBOW (MW19)": ScaleProfile(scale: 1.5, padding: 10.0),
  "EBR-14 (MW19)": ScaleProfile(scale: 1.5, padding: 10.0),
  "KAR98K (MW19)": ScaleProfile(scale: 1.5, padding: 10.0),
  "MK2 CARBINE": ScaleProfile(scale: 1.5, padding: 10.0),
  ".50 GS (MW19)": ScaleProfile(),
  "1911 (MW19)": ScaleProfile(),
  "M19": ScaleProfile(),
  "RENETTI (MW19)": ScaleProfile(),
  "SYKOV": ScaleProfile(),
  "X16": ScaleProfile(),
  "MAGNUM (MW19)": ScaleProfile(),

  // --- COLD WAR ---
  "AK-47 (CW)": ScaleProfile(scale: 1.5, padding: 10.0),
  "AK-74U": ScaleProfile(scale: 1.3, padding: 10.0),
  "C58": ScaleProfile(scale: 1.5, padding: 10.0),
  "EM2": ScaleProfile(scale: 1.5, padding: 10.0),
  "FARA 83": ScaleProfile(scale: 1.5, padding: 10.0),
  "FFAR 1 (CW)": ScaleProfile(scale: 1.5, padding: 10.0),
  "GRAV": ScaleProfile(scale: 1.5, padding: 10.0),
  "GROZA": ScaleProfile(scale: 1.2, padding: 10.0),
  "KRIG 6 (CW)": ScaleProfile(scale: 1.5, padding: 10.0),
  "QBZ-83": ScaleProfile(scale: 1.3, padding: 10.0),
  "UGR": ScaleProfile(scale: 1.4, padding: 10.0),
  "VARGO 52": ScaleProfile(scale: 1.5, padding: 10.0),
  "XM4 (CW)": ScaleProfile(scale: 1.4, padding: 10.0),
  "BULLFROG": ScaleProfile(scale: 1.4, padding: 10.0),
  "KSP 45": ScaleProfile(scale: 1.2, padding: 10.0),
  "LAPA": ScaleProfile(scale: 1.1, padding: 10.0),
  "LC10 (CW)": ScaleProfile(scale: 1.3, padding: 10.0),
  "MAC-10": ScaleProfile(scale: 1.0, padding: 10.0),
  "MILANO 821": ScaleProfile(scale: 1.1, padding: 10.0),
  "MP5 (CW)": ScaleProfile(scale: 1.15, padding: 10.0),
  "OTS 9": ScaleProfile(scale: 1.4, padding: 10.0),
  "PPSH-41 (CW)": ScaleProfile(scale: 1.35, padding: 10.0),
  "TEC-9": ScaleProfile(scale: 1.1, padding: 10.0),
  "M60": ScaleProfile(scale: 1.5, padding: 10.0),
  "MG 82": ScaleProfile(scale: 1.5, padding: 10.0),
  "RPD": ScaleProfile(scale: 1.5, padding: 10.0),
  "STONER 63": ScaleProfile(scale: 1.5, padding: 10.0),
  "AUG (CW)": ScaleProfile(scale: 1.4, padding: 10.0),
  "CARV.2": ScaleProfile(scale: 1.2, padding: 10.0),
  "DMR 14": ScaleProfile(scale: 1.5, padding: 10.0),
  "M16 (CW)": ScaleProfile(scale: 1.5, padding: 10.0),
  "TYPE 63": ScaleProfile(scale: 1.5, padding: 10.0),
  ".410 IRONHIDE": ScaleProfile(scale: 1.5, padding: 10.0),
  "GALLO SA12": ScaleProfile(scale: 1.4, padding: 10.0),
  "HAUER 77": ScaleProfile(scale: 1.5, padding: 10.0),
  "STREETSWEEPER": ScaleProfile(scale: 1.5, padding: 10.0),
  "LW3 TUNDRA": ScaleProfile(scale: 1.5, padding: 10.0),
  "M82": ScaleProfile(scale: 1.5, padding: 10.0),
  "PELINGTON 703": ScaleProfile(scale: 1.5, padding: 10.0),
  "SWISS K31": ScaleProfile(scale: 1.5, padding: 10.0),
  "ZRG 20MM": ScaleProfile(scale: 1.5, padding: 10.0),
  "1911 (CW)": ScaleProfile(scale: 1.1, padding: 10.0),
  "AMP63": ScaleProfile(scale: 1.3, padding: 10.0),
  "DIAMATTI": ScaleProfile(scale: 1.1, padding: 10.0),
  "MAGNUM (CW)": ScaleProfile(),
  "MARSHAL": ScaleProfile(),

  // --- MW3/MW2 ---
  "556 ICARUS": ScaleProfile(scale: 0.9, padding: 10.0),
  "9MM DAEMON": ScaleProfile(scale: 1.0, padding: 10.0),
  "AMR9": ScaleProfile(scale: 1.0, padding: 10.0),
  "BAL-27": ScaleProfile(scale: 0.9, padding: 10.0),
  "BAS-B": ScaleProfile(scale: 1.0, padding: 10.0),
  "BAS-P": ScaleProfile(scale: 1.0, padding: 10.0),
  "BASILISK": ScaleProfile(scale: 0.9, padding: 10.0),
  "BP50": ScaleProfile(scale: 1.0, padding: 10.0),
  "BRUEN MK9 (MW3)": ScaleProfile(scale: 1.0, padding: 10.0),
  "BRYSON 890": ScaleProfile(scale: 0.8, padding: 10.0),
  "CARRACK .300": ScaleProfile(scale: 1.0, padding: 10.0),
  "CHIMERA": ScaleProfile(scale: 1.0, padding: 10.0),
  "CRONEN SQUALL": ScaleProfile(scale: 1.1, padding: 10.0),
  "DG-56": ScaleProfile(scale: 1.0, padding: 10.0),
  "DG-58 LSW": ScaleProfile(scale: 1.0, padding: 10.0),
  "DM56": ScaleProfile(scale: 1.0, padding: 10.0),
  "EBR-14 (MW2)": ScaleProfile(scale: 1.0, padding: 10.0),
  "EXPEDITE 12": ScaleProfile(scale: 0.8, padding: 10.0),
  "FENNEC 45": ScaleProfile(scale: 1.0, padding: 10.0),
  "FJX HORUS": ScaleProfile(scale: 1.0, padding: 10.0),
  "FJX IMPERIUM": ScaleProfile(scale: 1.0, padding: 10.0),
  "FR 5.56 (MW3)": ScaleProfile(scale: 1.0, padding: 10.0),
  "FR AVANCER": ScaleProfile(scale: 1.0, padding: 10.0),
  "FSS HURRICANE": ScaleProfile(scale: 1.0, padding: 10.0),
  "FTAC RECON": ScaleProfile(scale: 0.9, padding: 10.0),
  "FTAC SIEGE": ScaleProfile(scale: 1.0, padding: 10.0),
  "GS MAGNA": ScaleProfile(scale: 0.9, padding: 10.0),
  "HAYMAKER": ScaleProfile(scale: 0.9, padding: 10.0),
  "HCR 56": ScaleProfile(scale: 0.9, padding: 10.0),
  "HOLGER 26 (MW3)": ScaleProfile(scale: 1.0, padding: 10.0),
  "HOLGER 556": ScaleProfile(scale: 1.0, padding: 10.0),
  "HRM-9": ScaleProfile(scale: 0.9, padding: 10.0),
  "ISO 45": ScaleProfile(scale: 1.0, padding: 10.0),
  "ISO 9MM": ScaleProfile(scale: 1.0, padding: 10.0),
  "ISO HEMLOCK": ScaleProfile(scale: 1.0, padding: 10.0),
  "KASTOV 545": ScaleProfile(scale: 0.9, padding: 10.0),
  "KASTOV 762": ScaleProfile(scale: 0.9, padding: 10.0),
  "KASTOV-74U": ScaleProfile(scale: 0.9, padding: 10.0),
  "KATT-AMR": ScaleProfile(scale: 1.0, padding: 10.0),
  "KV BROADSIDE": ScaleProfile(scale: 0.9, padding: 10.0),
  "KV INHIBITOR": ScaleProfile(scale: 1.0, padding: 10.0),
  "KVD ENFORCER": ScaleProfile(scale: 0.9, padding: 10.0),
  "LA-B 330": ScaleProfile(scale: 1.0, padding: 10.0),
  "LACHMANN SUB": ScaleProfile(scale: 0.9, padding: 10.0),
  "LACHMANN-556": ScaleProfile(scale: 0.9, padding: 10.0),
  "LACHMANN-762": ScaleProfile(scale: 1.0, padding: 10.0),
  "LM-S": ScaleProfile(scale: 1.0, padding: 10.0),
  "LOCKWOOD 300": ScaleProfile(scale: 0.9, padding: 10.0),
  "LOCKWOOD 680 (MW3)": ScaleProfile(scale: 0.9, padding: 10.0),
  "LONGBOW": ScaleProfile(scale: 1.0, padding: 10.0),
  "M13B": ScaleProfile(scale: 1.1, padding: 10.0),
  "M13C": ScaleProfile(scale: 1.0, padding: 10.0),
  "M4": ScaleProfile(scale: 0.9, padding: 10.0),
  "MCPR-300": ScaleProfile(scale: 1.0, padding: 10.0),
  "MCW": ScaleProfile(scale: 1.0, padding: 10.0),
  "MCW 6.8": ScaleProfile(scale: 1.0, padding: 10.0),
  "MINIBAK": ScaleProfile(scale: 0.9, padding: 10.0),
  "MORS": ScaleProfile(scale: 1.0, padding: 10.0),
  "MTZ INTERCEPTOR": ScaleProfile(scale: 1.0, padding: 10.0),
  "MTZ-556": ScaleProfile(scale: 1.0, padding: 10.0),
  "MTZ-762": ScaleProfile(scale: 1.0, padding: 10.0),
  "MX GUARDIAN": ScaleProfile(scale: 0.8, padding: 10.0),
  "P890": ScaleProfile(scale: 0.9, padding: 10.0),
  "PDSW 528": ScaleProfile(scale: 0.85, padding: 10.0),
  "PULEMYOT 762": ScaleProfile(scale: 1.0, padding: 10.0),
  "RAAL MG (MW2)": ScaleProfile(scale: 1.0, padding: 10.0),
  "RAM-7 (MW3)": ScaleProfile(scale: 1.0, padding: 10.0),
  "RAM-9": ScaleProfile(scale: 1.0, padding: 10.0),
  "RAPP H": ScaleProfile(scale: 0.9, padding: 10.0),
  "RECLAIMER 18": ScaleProfile(scale: 0.85, padding: 10.0),
  "RENETTI (MW3)": ScaleProfile(scale: 0.9, padding: 10.0),
  "RIVAL-9": ScaleProfile(scale: 0.9, padding: 10.0),
  "RIVETER": ScaleProfile(scale: 1.0, padding: 10.0),
  "RPK": ScaleProfile(scale: 1.0, padding: 10.0),
  "SAKIN MG38": ScaleProfile(scale: 0.9, padding: 10.0),
  "SIDEWINDER": ScaleProfile(scale: 1.0, padding: 10.0),
  "SIGNAL 50": ScaleProfile(scale: 1.0, padding: 10.0),
  "SO-14": ScaleProfile(scale: 0.9, padding: 10.0),
  "SO-14 MP - FULL-AUTO": ScaleProfile(scale: 0.9, padding: 10.0),
  "SO-14 MP - SEMI-AUTO": ScaleProfile(scale: 1.0, padding: 10.0),
  "SOA SUBVERTER": ScaleProfile(scale: 0.9, padding: 10.0),
  "SP-R 208 (MW2)": ScaleProfile(scale: 1.0, padding: 10.0),
  "SP-X 80": ScaleProfile(scale: 1.0, padding: 10.0),
  "STATIC-HV": ScaleProfile(scale: 1.0, padding: 10.0),
  "STB 556": ScaleProfile(scale: 0.9, padding: 10.0),
  "STG44": ScaleProfile(scale: 1.2, padding: 10.0),
  "STRIKER": ScaleProfile(scale: 0.9, padding: 10.0),
  "STRIKER 9": ScaleProfile(scale: 1.0, padding: 10.0),
  "SUPERI 46": ScaleProfile(scale: 0.9, padding: 10.0),
  "SVA 545": ScaleProfile(scale: 1.0, padding: 10.0),
  "TAQ ERADICATOR": ScaleProfile(scale: 1.0, padding: 10.0),
  "TAQ-56": ScaleProfile(scale: 0.9, padding: 10.0),
  "TAQ-M": ScaleProfile(scale: 0.9, padding: 10.0),
  "TAQ-V": ScaleProfile(scale: 0.9, padding: 10.0),
  "TEMPUS RAZORBACK": ScaleProfile(scale: 1.0, padding: 10.0),
  "TEMPUS TORRENT": ScaleProfile(scale: 1.0, padding: 10.0),
  "TR-76 GEIST": ScaleProfile(scale: 0.9, padding: 10.0),
  "TYR": ScaleProfile(scale: 0.9, padding: 10.0),
  "VAZNEV-9K": ScaleProfile(scale: 0.9, padding: 10.0),
  "VEL 46": ScaleProfile(scale: 1.0, padding: 10.0),
  "VICTUS XMR": ScaleProfile(scale: 1.0, padding: 10.0),
  "WSP STINGER": ScaleProfile(scale: 1.0, padding: 10.0),
  "WSP SWARM": ScaleProfile(scale: 0.9, padding: 10.0),
  "WSP-9": ScaleProfile(scale: 0.9, padding: 10.0),
  "XRK STALKER": ScaleProfile(scale: 1.0, padding: 10.0),
};

class _PremiumStatCard extends StatelessWidget {
  final WeaponStats stats;
  final ThemeController themeController;
  final Map<String, ArchetypeRank>? rankings;
  final bool isLoading;

  const _PremiumStatCard({
    required this.stats,
    required this.themeController,
    this.rankings,
    required this.isLoading,
  });

  bool _hasData(String? val) {
    if (val == null) return false;
    final v = val.trim();
    return v.isNotEmpty && v != "-" && v.toLowerCase() != "null";
  }

  void _showStatDefinitions(BuildContext context) {
  final bool isCustom = themeController.activeTheme.id == 'neon_custom';
  final Color coreColor = Color.lerp(themeController.activeAccentColor, Colors.white, 0.35)!;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: themeController.activeAccentColor),
      ),
      title: ArmoryText(
        "STAT DEFINITIONS",
        themeController: themeController,
        baseFontSize: 14,
        textAlign: TextAlign.center,
        color:Colors.white,
        overrideStrokeColor: Colors.black,
        baseStrokeWidth: 2.5,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDefinition("• TTK: Time to kill in milliseconds. Lower is better."),
          _buildDefinition("• ADS: Aim Down Sights speed. Lower is better."),
          _buildDefinition("• VELOCITY: Bullet speed. Higher is better."),
          _buildDefinition("• STK: Shots to Kill. Lower is better."),
          _buildDefinition("• HITSCAN: The range at which your bullet will instantly connect with the target. Higher is better."),
        ],
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CLOSE", style: TextStyle(color: Colors.white)),
          ),
        )
      ],
    ),
  );
}

Widget _buildDefinition(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: ArmoryText(
      text,
      themeController: themeController,
      baseFontSize: 10,
      textAlign: TextAlign.center,
      allowWrap: true,
      color: Colors.white70,
      overrideStrokeColor: Colors.black,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final activeTheme = themeController.activeTheme;
    final theme = Theme.of(context);
    final Color accentColor = themeController.activeAccentColor;
    final bool isCustom = activeTheme.id == 'neon_custom';
    final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
    
    final Color ratingColor = _getRatingColor(stats.combatRating?.label);

    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return Container(
          margin: const EdgeInsets.only(top: 6, bottom: 10, left: 10, right: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: isCustom 
                ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9) 
                : theme.colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(18), 
            border: Border.all(
              color: isCustom ? coreColor : accentColor,
              width: 1.5,
            ),
            boxShadow: isCustom ? [
              BoxShadow(color: accentColor.withOpacity(0.8), blurRadius: 1, spreadRadius: 0.5),
              BoxShadow(color: accentColor.withOpacity(0.3), blurRadius: 15, spreadRadius: 2),
            ] : [],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 40), // Offset to counter-balance the button
                    ArmoryText(
                      "ADVANCED WEAPON STATS",
                      themeController: themeController,
                      baseFontSize: 10,
                      baseStrokeWidth: 2.2,
                      color: isCustom ? Colors.black : coreColor,
                      overrideStrokeColor: isCustom ? coreColor : Colors.black,
                      letterSpacing: 2.0,
                    ),
                    IconButton(
                      icon: Icon(Icons.info_outline, size: 16, color: isCustom ? coreColor : accentColor),
                      onPressed: () => _showStatDefinitions(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: isCustom ? accentColor.withOpacity(0.3) : Colors.white10, height: 1),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 10, left: 6, right: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_hasData(stats.ttk1)) _buildExpandedStat("TTK 0-${stats.range1}", stats.ttk1),
                    const SizedBox(width: 2),
                    if (_hasData(stats.ttk2)) _buildExpandedStat((stats.range1 == stats.range2) ? "TTK ${stats.range1}+" : "TTK ${stats.range1}-${stats.range2}", stats.ttk2),
                    const SizedBox(width: 2),
                    _buildExpandedStat("ADS", stats.adsSpeed),
                    _buildExpandedStat("VELOCITY", stats.bulletVelocity),
                    _buildExpandedStat("STK", stats.shotsToKill),
                    if (!_hasData(stats.ttk2) && _hasData(stats.range2)) _buildExpandedStat("DROP", stats.range2),
                    _buildExpandedStat("HITSCAN", stats.hitscanRange),
                    if (stats.shotRange != null && _hasData(stats.shotRange)) _buildExpandedStat("ONE SHOT", stats.shotRange!),
                  ],
                ),
              ),
              
              if (stats.archetype != null && stats.archetype!.isNotEmpty) ...[
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: isCustom ? accentColor.withOpacity(0.3) : Colors.white10, height: 1),
              ),
                const SizedBox(height: 8),
                
                 ArmoryText(
                  "${stats.archetype!.toUpperCase()} RANKING", 
                  themeController: themeController,
                  baseFontSize: 10,
                  baseStrokeWidth: 2.0,
                  color: isCustom ? Colors.black : coreColor,
                  overrideStrokeColor: isCustom ? coreColor : Colors.black,
                ),
                
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.only(bottom: 16, right: 8, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: _buildRankElement("TTK CLOSE", "ttkClose", ratingColor)),
                      Expanded(child: _buildRankElement("TTK FAR", "ttkFar", ratingColor)),
                      Expanded(child: _buildRankElement("ADS", "adsSpeed", ratingColor)), // Abbreviated
                      Expanded(child: _buildRankElement("VELOCITY", "velocity", ratingColor)),
                      Expanded(child: _buildRankElement("STK", "stk", ratingColor)), // Abbreviated
                    ],
                  ),
                ),
              ]
            ],
          ),
        );
      }
    );
  }

  Widget _buildRankElement(String label, String key, Color color) {
    final Color accentColor = themeController.activeAccentColor;
    final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
    final data = rankings?[key];
    final String rankText = isLoading ? "..." : (data != null ? "#${data.rank}" : "-");

    return Column(
      children: [
        _buildRankCircle(rankText, color),
        const SizedBox(height: 6),
        ArmoryText(
              label,
              themeController: themeController,
              baseFontSize: 8,
              baseStrokeWidth: 2.5,
              color: coreColor,
              overrideStrokeColor: Colors.black,
            ),
      ],
    );
  }

  Widget _buildRankCircle(String rankText, Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.2), blurRadius: 4, spreadRadius: 1),
        ],
      ),
      child: Center(
        child: ArmoryText(
              rankText,
              themeController: themeController,
              baseFontSize: 9,
              baseStrokeWidth: 2.0,
              color: color,
              overrideStrokeColor: Colors.black,
            ),
        ),
    );
  }

  Widget _buildExpandedStat(String label, String value, {Color? overrideColor}) {
    final activeTheme = themeController.activeTheme;
    final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
    final Color accent = themeController.activeAccentColor;
    final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;
    final Color finalColor = overrideColor ?? (isNeon ? Colors.white : coreColor);

    return Expanded(
      child: Center(
        child: _StatItem(
          label: label, 
          value: value,
          themeController: themeController,
          color: finalColor,
        )
      )
    );
  }

  Color _getRatingColor(String? label) {
    switch (label?.toUpperCase()) {
      case "S": return Colors.amberAccent;
      case "A": return Colors.greenAccent;
      case "B": return Colors.orangeAccent;
      default: return Colors.redAccent;
    }
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  final ThemeController themeController;
  final Color? color;

  const _StatItem({
    required this.label, 
    required this.value, 
    required this.themeController,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final Color accentColor = themeController.activeAccentColor;
    final bool isCustom = themeController.activeTheme.id == 'neon_custom';
    final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {

        final Color baseDisplayColor = color ?? (isCustom ? coreColor : Theme.of(context).colorScheme.primary);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ArmoryText(
              value,
              themeController: themeController,
              baseFontSize: 11,
              baseStrokeWidth: 3.0,
              color: Colors.white,
              overrideStrokeColor: Colors.black,
            ),
            
            const SizedBox(height: 2),

            ArmoryText(
              label.toUpperCase(),
              themeController: themeController,
              baseFontSize: 7,
              baseStrokeWidth: isCustom ? 2.2 : 1.8,
              color: isCustom ? baseDisplayColor : baseDisplayColor,
              overrideStrokeColor: Colors.black,
              letterSpacing: 0.5,
            ),
          ],
        );
      }
    );
  }
}

class AttachmentTile extends StatelessWidget {
  final String text;
  final bool isStarred;
  final ThemeController themeController;

  const AttachmentTile({
    super.key,
    required this.text,
    this.isStarred = false,
    required this.themeController,
  });

  bool _isMagazinePattern(String text) {
    final regex = RegExp(r'^\d+\s*/\s*\d+');
    return regex.hasMatch(text);
  }

  String getTranslatedSubtitle(String text, AegisArc locale) {
    
    if (_isMagazinePattern(text)) {
      return locale.translate("MAGAZINE").translatedText;
    }

    final parts = text.split('/');
    final translatedParts = parts.map((part) {
      final cleanPart = part.trim();
      final res = locale.translate(cleanPart);
      
      return (res.category == "UNKNOWN" || res.category.isEmpty) ? "" : res.category;
    }).toList();

    final result = translatedParts.where((s) => s.isNotEmpty).join(' / ');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<AegisArc>(context);

    final TranslationResult result = locale.translate(text);
    final bool isMagPattern = _isMagazinePattern(text);

    final String subtitleText = getTranslatedSubtitle(text, locale);
    final bool isWord = result.category.isEmpty;
    final String resolvedCategory = isMagPattern ? "MAGAZINE" : result.category;

    final activeTheme = themeController.activeTheme;
    final theme = activeTheme.themeData;
    final accentColor = themeController.activeAccentColor;
    final coreColor = Color.lerp(accentColor, Colors.white, 0.4)!;
    
    final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
    final bool isHolo = activeTheme.isHolographic;
    final bool isCustom = activeTheme.id == 'neon_custom';
    final bool isNeon = isAnemone || isHolo || isCustom;
        

    final Widget tileContent = ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        color: isCustom ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9) : theme.colorScheme.surface.withOpacity(0.7),
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
          leading: Icon(
            isStarred ? Icons.star : (isWord ? Icons.text_fields : Icons.api_sharp),
            color: isStarred ? Colors.amber : (isCustom ? coreColor.withOpacity(0.5) : theme.colorScheme.primary),
            size: 16,
          ),
          title: ArmoryText(
            result.translatedText.toUpperCase(),
            themeController: themeController,
            baseFontSize: 13,
            baseStrokeWidth: 2.5,
            color: Colors.white,
            overrideStrokeColor: Colors.black,
            letterSpacing: 0.5,
          ),
          subtitle: subtitleText.isEmpty ? null : Padding(
            padding: const EdgeInsets.only(top: 2),
            child: ArmoryText(
              subtitleText.toUpperCase(),
              themeController: themeController,
              baseFontSize: 9,
              baseStrokeWidth: 1.5,
              color: Colors.white.withOpacity(0.7),
              overrideStrokeColor: Colors.black,
            ),
          ),
        ),
      ),
    );

    Widget wrappedTile;
    if (isHolo) {
      wrappedTile = _InternalAnimatedBorder(colors: activeTheme.refractionColors, borderRadius: 24, strokeWidth: 3.0, child: tileContent);
    } else if (isAnemone) {
      wrappedTile = RepaintBoundary(child: ArmoryGradientBorder(gradientColors: activeTheme.borderGradient, borderRadius: 24, strokeWidth: 2.5, child: tileContent));
    } else {
      wrappedTile = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isCustom ? coreColor : theme.colorScheme.primary.withOpacity(0.7), width: 2.0),
          boxShadow: isCustom ? [
            BoxShadow(color: accentColor.withOpacity(0.8), blurRadius: 1, spreadRadius: 0.5),
            BoxShadow(color: accentColor.withOpacity(0.3), blurRadius: 15, spreadRadius: 2),
          ] : [],
        ),
        child: tileContent,
      );
    }

    return Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: wrappedTile);
  }
}

class _SpecialtyBox extends StatelessWidget {
  final String value;
  final ThemeController themeController;

  const _SpecialtyBox({
    super.key,
    required this.value,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    final activeTheme = themeController.activeTheme;
    final theme = Theme.of(context);
    final bool isCustom = activeTheme.id == 'neon_custom';
    final Color accentColor = themeController.activeAccentColor;
    final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCustom 
              ? const Color.fromARGB(255, 0, 0, 0) 
              : theme.colorScheme.surface.withOpacity(0.6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCustom ? coreColor : theme.colorScheme.primary.withOpacity(0.8), 
            width: isCustom ? 2.5 : 1.5,
          ),
          boxShadow: isCustom ? [
            BoxShadow(
              color: accentColor.withOpacity(0.8), 
              blurRadius: 1, 
              spreadRadius: 0.5
            ),
            BoxShadow(
              color: accentColor.withOpacity(0.3), 
              blurRadius: 15, 
              spreadRadius: 2
            ),
          ] : [],
        ),
        child: Center(
          child: ArmoryText(
            value.toUpperCase(),
            themeController: themeController,
            baseFontSize: 14,
            baseStrokeWidth: isCustom ? 2.5 : 2.0,
            color: Colors.white,
            overrideStrokeColor: isCustom ? accentColor.withOpacity(0.6) : Colors.black,
            letterSpacing: 3.0,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label; 
  final bool isActive;
  final ThemeController themeController;

  const _StatusChip({
    required this.label, 
    required this.isActive,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    final activeTheme = themeController.activeTheme;
    final bool isCustom = activeTheme.id == 'neon_custom';
    final Color themeAccent = themeController.activeAccentColor;

    Color chipColor = const Color.fromRGBO(2, 91, 207, 1); 
    if (label == "Special") chipColor = Colors.purpleAccent;
    if (label == "Akimbo") chipColor = Colors.orangeAccent;
    if (label == "Single") chipColor = Colors.greenAccent;
    if (label.contains("Prestige")) chipColor = const Color(0xFFFFD700);

    Color borderColor = isCustom ? themeAccent : chipColor;

    return Container(
      margin: const EdgeInsets.only(right: 6), 
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? chipColor.withOpacity(0.4) : Colors.transparent, 
        borderRadius: BorderRadius.circular(6), 
        border: Border.all(
          color: isActive ? chipColor.withOpacity(0.9) : Colors.white10,
          width: isActive ? 1.5 : 0.5,
        )
      ), 

      child: ArmoryText(
        label.toUpperCase(),
        themeController: themeController,
        baseFontSize: 10,
        baseStrokeWidth: 2.0,
        color: isActive ? Colors.white : Colors.white24,
        overrideStrokeColor: isActive ? Colors.black : Colors.transparent,
      ),
    );
  }
}

class _ImageHeader extends StatelessWidget {
  final String url;
  const _ImageHeader({required this.url});

  @override
  Widget build(BuildContext context) {
    final bool isColdWar = url.contains('COLD_WAR');

    final double scaleFactor = isColdWar ? 1.25 : 1.0;

    return Stack(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          alignment: Alignment.center,
          child: Transform.scale(
            scale: scaleFactor,
            child: _SmartImage(
              url: url,
              width: 300,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent, 
                  Colors.black.withOpacity(0.9)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BuildCodeBox extends StatelessWidget {
  final String code, weaponName, mode;
  final ThemeController themeController;

  const _BuildCodeBox({
    super.key,
    required this.code, 
    required this.weaponName, 
    required this.mode,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    final bool isNeon = themeController.activeTheme.name.toLowerCase().contains('neon') || 
                        themeController.activeTheme.id == 'neon_custom';
    
    final Color accentColor = themeController.activeAccentColor;
    final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
    final Color surfaceBg = Theme.of(context).colorScheme.surface.withOpacity(0.6);
    final Color primaryBorder = Color.lerp(Theme.of(context).colorScheme.primary, Colors.white, 0.3)!;
    final Color activeBorderColor = isNeon ? coreColor : primaryBorder;
    final Color activeContainerColor = isNeon ? Colors.black : surfaceBg;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          HapticFeedback.lightImpact();
          Clipboard.setData(ClipboardData(text: code));
          
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF0D0D0D),
              behavior: SnackBarBehavior.fixed,
              elevation: 0,
              shape: Border(
                top: BorderSide(
                  color: activeBorderColor, 
                  width: isNeon ? 2.5 : 1.5
                ),
              ),
              content: ArmoryText(
                "${weaponName.toUpperCase()} CODE COPIED!",
                themeController: themeController,
                baseFontSize: 11,
                baseStrokeWidth: 1.5,
                color: isNeon ? coreColor : accentColor,
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: activeContainerColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: activeBorderColor,
              width: isNeon ? 2.5 : 1.0,
            ),
            boxShadow: isNeon ? [
              BoxShadow(
                color: accentColor.withOpacity(0.8),
                blurRadius: 1,
                spreadRadius: 0.5,
              ),
              BoxShadow(
                color: accentColor.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.copy_rounded, 
                size: 16, 
                color: activeBorderColor
              ),
              const SizedBox(width: 10),
              
              Flexible(
                child: ArmoryText(
                  code,
                  themeController: themeController,
                  baseFontSize: 14,
                  baseStrokeWidth: isNeon ? 2.5 : 2.0,
                  color: isNeon ? coreColor : Colors.white,
                  letterSpacing: 1.2,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmartImage extends StatelessWidget {
  final String url; 
  final double? width;
  const _SmartImage({required this.url, this.width});
  
  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return Icon(Icons.image_not_supported, color: Colors.white.withOpacity(0.05), size: 100);
    
    final String size = (width != null && width! < 150) ? 'w_300' : 'w_800';
    final String optimizedUrl = url.contains('/upload/') 
        ? url.replaceFirst('/upload/', '/upload/$size,c_limit,f_auto,q_auto/') 
        : url;

    return CachedNetworkImage(
      imageUrl: optimizedUrl,
      cacheManager: AppCacheManager.instance,
      width: width, 
      fit: BoxFit.contain,
      httpHeaders: const {
        "ngrok-skip-browser-warning": "true",
      },
      placeholder: (context, url) => Container(color: Colors.white.withOpacity(0.02)),
      errorWidget: (c, e, s) {
        debugPrint("Image Load Error: $e");
        return const Icon(Icons.error, color: Colors.white10);
      },
    );
  }
}

class RandomLoadoutScreen extends StatefulWidget {
  final ThemeController themeController;
  final AegisArc aegisArc;
  const RandomLoadoutScreen({super.key, required this.themeController, required this.aegisArc});

  @override
  State<RandomLoadoutScreen> createState() => _RandomLoadoutScreenState();
}

class _RandomLoadoutScreenState extends State<RandomLoadoutScreen> with SingleTickerProviderStateMixin {
  final Random _rng = Random(); 
  
  List<dynamic> _allWeaponData = [];
  List<String> _weaponNames = [];
  String? _selectedWeapon;
  bool _isRandomWeapon = false;
  int _amount = 1;
  List<Map<String, dynamic>> _generatedLoadouts = [];
  String _selectedMode = 'WARZONE';
  bool _isExclusionZoneActive = false;
  bool _lockWeapon = false;
  List<String> _excludedGames = [];
  final List<String> _gameKeys = ["MW2", "MW3", "BO6", "BO7", "CW", "MW19"];
  
  String? _selectedCategory; 
  Map<String, List<String>> _archetypeMap = {};

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 450), () {
        if (mounted) {
          _loadSettings();
          _loadCADData();
        }
      });
    });
  }

  Future<void> _loadSettings() async {
  final prefs = await SharedPreferences.getInstance();
  if (mounted) {
    setState(() {
      _isExclusionZoneActive = prefs.getBool('exclusion_active') ?? false;
      _excludedGames = prefs.getStringList('excluded_games') ?? [];
      _validateGameMode(); 
    });
  }
}

bool get _isLegacyOnly {
  if (_selectedWeapon != null) {
    final weapon = _allWeaponData.firstWhere(
      (w) => w['weapon_name'] == _selectedWeapon,
      orElse: () => {},
    );
    if (weapon.isNotEmpty) {
      String g = _getGameFromUrl(weapon['game_image']).toLowerCase();
      if (g == 'mw19' || g == 'cw') return true;
    }
  }

  if (!_isExclusionZoneActive || _excludedGames.isEmpty) return false;
  final wzGames = ["MW2", "MW3", "BO6", "BO7"];
  return wzGames.every((game) => _excludedGames.contains(game));
}

void _showTutorialDialog() {
  final themeController = widget.themeController;
  final bool isCustom = themeController.activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );

  final List<Map<String, String>> tutorialSteps = [
    {
      "title": "RANDOMIZER GUIDE",
      "body": "There is no shortage of options within The Armory's Randomizer. It can be intimidating, so refer back to this handy guide whenever you need a refresher."
    },
    {
      "title": "EXCLUSION ZONE",
      "body": "This is where you tell the engine \"I don't want to see weapons from this game\". Pick as many as you want, but you need at least one. "
    },
    {
      "title": "LOCK WEAPON CHOICE",
      "body": "If you only want to get random attachments for one specific weapon, but don't want to hit the button 4 times to do it, this option is what you need."
    },
    {
      "title": "GAME MODE",
      "body": """Warzone will allow choices to be picked from each game you have allowed from the Exclusion Zone. Multiplayer will utilize the anchor system,
      which is a robust filtering logic that will only choose same-era weapons as the first pick.

      So if you randomly (or manually) select a Black Ops 6 weapon, and you have chosen more than 1 weapon to generate, you will only get Black Ops 6 weapons, ensuring that each pick is usable in the game that you are playing.
      """
    },
    {
      "title": "CATEGORY",
      "body": """If you select RANDOM WEAPON, you will see this new option appear. This will tell the engine that you only want that specific weapon class.
      For legacy categories, the game mode is forced to Multiplayer to utilize the anchor logic and stay accurate, and to elminate overlap if you also allow other non-legacy games. You don't want a Cold War shotgun mixed in with your Black Ops 7 sniper now do you?"""
    },
  ];

  int currentIndex = 0;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setStepState) {
        bool isLastPage = currentIndex == tutorialSteps.length - 1;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            backgroundColor: isCustom ? Colors.black : primaryFaded,
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 12), 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: isCustom ? coreColor : accentColor, width: 1.5),
            ),
            title: Center(
              child: ArmoryText(
                tutorialSteps[currentIndex]['title']!,
                themeController: themeController,
                baseFontSize: 16,
                color: Colors.white,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ArmoryText(
                  tutorialSteps[currentIndex]['body']!,
                  themeController: themeController,
                  baseFontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                  textAlign: TextAlign.center,
                  allowWrap: true,
                ),
                
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(tutorialSteps.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == currentIndex ? coreColor : Colors.white10,
                      ),
                    );
                  }),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              if (currentIndex > 0)
                TextButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setStepState(() => currentIndex--);
                  },
                  child: ArmoryText("BACK", themeController: themeController, baseFontSize: 11, color: Colors.white30),
                )
              else
                const SizedBox(width: 60),

              TextButton(
                onPressed: () {
                  if (isLastPage) {
                    HapticFeedback.heavyImpact();
                    Navigator.pop(context);
                  } else {
                    HapticFeedback.mediumImpact();
                    setStepState(() => currentIndex++);
                  }
                },
                child: ArmoryText(
                  isLastPage ? "I GOT IT" : "NEXT",
                  themeController: themeController,
                  baseFontSize: 12,
                  color: isCustom ? coreColor : accentColor,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

void _validateGameMode() {
  setState(() {

    final bool isLegacyCategory = _selectedCategory == "TACTICAL RIFLE";

    final bool onlyLegacyGames = _isExclusionZoneActive && 
        !_gameKeys.where((g) => !['MW19', 'CW'].contains(g))
                  .any((g) => !_excludedGames.contains(g));

    final bool forceMultiplayer = onlyLegacyGames || isLegacyCategory;

    if (forceMultiplayer) {
      _selectedMode = 'MULTIPLAYER';
    }
  });
}

void _validateCategory() {
  setState(() {

    final List<String> available = _getAvailableCategories();

    if (_selectedCategory != null && !available.contains(_selectedCategory)) {
      _selectedCategory = "ALL";
    }
    
    if (!_isRandomWeapon) {
      _selectedCategory = null;
    }
  });
}

Future<void> _saveSettings() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('exclusion_active', _isExclusionZoneActive);
  await prefs.setStringList('excluded_games', _excludedGames);
}

  String _getGameFromUrl(String? url) {
    if (url == null || url.isEmpty) return 'unknown';
    final String u = url.toUpperCase();
    if (u.contains('BO7')) return 'bo7';
    if (u.contains('BO6')) return 'bo6';
    if (u.contains('COLD_WAR')) return 'cw';
    if (u.contains('MW3')) return 'mw3';
    if (u.contains('MW2')) return 'mw2';
    if (u.contains('MW19')) return 'mw19';
    if (u.contains('WARZONE')) return 'warzone';
    return 'unknown';
  }

  Future<void> _loadCADData() async {
    final String cadResponse = await rootBundle.loadString('assets/CAD.json');
    final Map<String, dynamic> cadJson = json.decode(cadResponse);
    final List<dynamic> cadList = cadJson['CAD'];

    final String namesResponse = await rootBundle.loadString('assets/Weapon_Names.json');
    final Map<String, dynamic> namesJson = json.decode(namesResponse);
    final List<dynamic> namesData = namesJson['Weapon_Names'] ?? [];
    final String archResponse = await rootBundle.loadString('assets/archetypes.json');
    final Map<String, dynamic> archJson = json.decode(archResponse);

    List<dynamic> enrichedPool = cadList.map((cadWeapon) {
      final metadata = namesData.firstWhere(
        (n) => n['weapon_name'].toString().trim().toLowerCase() == 
               cadWeapon['weapon_name'].toString().trim().toLowerCase(),
        orElse: () => null,
      );
      return {
        ...cadWeapon,
        'game_image': metadata != null ? metadata['game_image'] : '',
      };
    }).toList();

    setState(() {
      _allWeaponData = enrichedPool;
      _weaponNames = _allWeaponData.map((w) => w['weapon_name'].toString()).toList()..sort();
      _archetypeMap = (archJson['archetypes'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<String>.from(value))
      );
    });
}

Future<void> _generate() async {
  final aegisArc = Provider.of<AegisArc>(context, listen: false);
  ScaffoldMessenger.of(context).clearSnackBars();

  if (!_isRandomWeapon && _selectedWeapon == null) {
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent.withOpacity(0.95),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: Colors.black, width: 1.5),
        ),
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.black, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: ArmoryText(
                "PLEASE SELECT A LOOKUP SYSTEM",
                themeController: widget.themeController,
                baseFontSize: 11.5,
                baseStrokeWidth: 0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
    return;
  }

  if (_allWeaponData.isEmpty) return;

  HapticFeedback.heavyImpact();
  List<Map<String, dynamic>> tempResults = [];
  final int timestamp = DateTime.now().millisecondsSinceEpoch;

  List<Map<String, dynamic>> allowedPool = _allWeaponData.where((w) {
    String g = _getGameFromUrl(w['game_image']).toLowerCase();
    String weaponName = w['weapon_name'].toString().toUpperCase();

    if (_isExclusionZoneActive && _excludedGames.isNotEmpty) {
      bool isExcluded = _excludedGames.any((excluded) => excluded.toLowerCase() == g);
      if (isExcluded) return false;
    }

    if (_selectedMode == 'WARZONE') {
      if (g == 'mw19' || g == 'cw') return false;
      if (!['bo7', 'bo6', 'mw3', 'mw2'].contains(g)) return false;
    } else {
      if (!['bo7', 'bo6', 'mw3', 'mw2', 'cw', 'mw19'].contains(g)) return false;
    }

    if (_isRandomWeapon && _selectedCategory != null && _selectedCategory != "ALL") {
      List<String> validForCategory = _archetypeMap[_selectedCategory] ?? [];
      if (!validForCategory.contains(weaponName)) return false;
    }

    return true;
  }).map((w) => Map<String, dynamic>.from(w)).toList();

  if (allowedPool.isEmpty) {
    ScaffoldMessenger.of(context).clearSnackBars();
    HapticFeedback.heavyImpact();
    setState(() => _generatedLoadouts = []);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent.withOpacity(0.95),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: Colors.black, width: 1.5),
        ),
        content: Row(
          children: [
            const Icon(Icons.gpp_maybe_outlined, color: Colors.black, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: ArmoryText(
                "ALLOWED GAMES LIST EMPTY",
                themeController: widget.themeController,
                baseFontSize: 11,
                baseStrokeWidth: 0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
    return;
  }

  var anchorWeapon = _isRandomWeapon 
      ? allowedPool[_rng.nextInt(allowedPool.length)]
      : allowedPool.firstWhere(
          (w) => w['weapon_name'] == _selectedWeapon,
          orElse: () => allowedPool[_rng.nextInt(allowedPool.length)],
        );
  
  String anchorGame = _getGameFromUrl(anchorWeapon['game_image']);

  for (int i = 0; i < _amount; i++) {
    Map<String, dynamic>? weapon;
    
    if (_lockWeapon && !_isRandomWeapon) {
      weapon = anchorWeapon;
    } else {
      if (i == 0) {
        weapon = anchorWeapon;
      } else {
        List<Map<String, dynamic>> constraintPool = [];
        if (_selectedMode == 'MULTIPLAYER') {
          if (anchorGame == 'mw3') {
            constraintPool = allowedPool.where((w) {
              String g = _getGameFromUrl(w['game_image']);
              return g == 'mw3' || g == 'mw2';
            }).toList();
          } else if (anchorGame == 'mw2') {
            constraintPool = allowedPool.where((w) => _getGameFromUrl(w['game_image']) == 'mw2').toList();
          } else {
            constraintPool = allowedPool.where((w) => _getGameFromUrl(w['game_image']) == anchorGame).toList();
          }
        }
        
        if (constraintPool.isEmpty) constraintPool = List.from(allowedPool);
        weapon = constraintPool[_rng.nextInt(constraintPool.length)];
      }
    }

    List<String> categories = ['barrel', 'stock', 'muzzle', 'rear grip', 'optic', 'underbarrel', 'magazine', 'laser', 'comb', 'trigger action', 'guard', 'bolt', 'arm', 'rail', 'carry handle', 'lever', 'loader', 'wire', 'sling', 'fire mod', 'perk', 'pumps', 'pump grip', 'ammunition'];
    categories.shuffle();
    Map<String, String> picks = {};
    int count = 0;
    
    for (var cat in categories) {
      if (count >= 5) break;
      String? options = weapon[cat]; 
      if (options != null && options.trim().isNotEmpty) {
        var list = options.split(',').map((e) => e.trim()).toList();
        String rawAttachment = list[_rng.nextInt(list.length)];
        
        final translatedCat = aegisArc.translate(cat).translatedText;
        final translatedAttachment = aegisArc.translate(rawAttachment).translatedText;
        
        picks[translatedCat.toUpperCase()] = translatedAttachment;
        count++;
      }
    }

    String weaponName = weapon['weapon_name'].toString().toUpperCase();

    String foundArchetype = _archetypeMap.entries
        .firstWhere(
          (entry) => entry.value.contains(weaponName),
          orElse: () => const MapEntry("UNKNOWN", []),
        )
        .key;

    final weaponNameRes = widget.aegisArc.translate(weapon['weapon_name']);

    tempResults.add({
      'id': 'gen_${timestamp}_$i', 
      'weapon_name': weaponNameRes.translatedText,
      'archetype': widget.aegisArc.translateStatic(foundArchetype),
      'game': _getGameFromUrl(weapon['game_image']).toUpperCase(), 
      'attachments': picks
    });

  setState(() {
    _generatedLoadouts = tempResults;
  });
}
}

List<String> _getAvailableCategories() {
  Set<String> categories = {"ALL"};

  List<String> activeGames = _gameKeys.where((g) {
    String gameLow = g.toLowerCase();
    if (_isExclusionZoneActive && _excludedGames.any((ex) => ex.toLowerCase() == gameLow)) {
      return false;
    }
    return true;
  }).toList();

  for (var game in activeGames) {
    String g = game.toLowerCase();
    categories.addAll(["AR", "SMG", "SHOTGUN", "LMG", "MARKSMAN RIFLE", "SNIPER", "PISTOL"]);
    
    if (g == 'mw2' || g == 'mw3') {
      categories.add("BATTLE RIFLE");
    }
    if (g == 'cw') {
      categories.add("TACTICAL RIFLE");
    }
  }

  var list = categories.toList()..sort();
  return list;
}

@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final activeTheme = widget.themeController.activeTheme;
  final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
  final Color accent = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;
  final Color scaffoldBg = isNeon ? Colors.black : theme.colorScheme.surface;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );

  return Scaffold(
    backgroundColor: primaryFaded,
    resizeToAvoidBottomInset: false, 
    appBar: AppBar(
      backgroundColor: primaryFaded,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: ArmoryText(
        "MODULE: RANDOMIZER",
        themeController: widget.themeController,
        baseFontSize: 14,
        baseStrokeWidth: isNeon ? 2.5 : 2.0,
        color: Colors.white,
        letterSpacing: 1.5,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 20, 
            
            hoverColor: (isNeon ? coreColor : accent).withOpacity(0.15),
            highlightColor: (isNeon ? coreColor : accent).withOpacity(0.3),

            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: (isNeon ? coreColor : accent),
              fixedSize: const Size(40, 40),
            ),
            
            icon: Icon(
              Icons.info_outline,
              size: 24,
              color: (isNeon ? coreColor : accent),
            ),
            onPressed: () {
              HapticFeedback.selectionClick();
              _showTutorialDialog();
            },
          ),
        ),
      ],
      leading: IconButton(
        splashColor: isNeon ? coreColor.withOpacity(0.1) : null,
        highlightColor: Colors.transparent,
        hoverColor: isNeon ? Colors.white.withOpacity(0.05) : null,
        icon: Icon(
          Icons.arrow_back_ios, 
          color: isNeon ? coreColor : theme.colorScheme.primary, 
          size: 18
        ),
        onPressed: () => Navigator.pop(context),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2.0),
        child: Container(
          height: 1.0,
          color: isNeon 
              ? coreColor 
              : Theme.of(context).colorScheme.primary,
        ),
      ),
    ),

    body: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          _buildStatusHeader(theme),
          const SizedBox(height: 15),
          Expanded(
            child: ListView(
              controller: _scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              children: [
                _buildOptimizedSearch(theme),

                const SizedBox(height: 10),

                _buildControlTile(
                  "EXCLUSION ZONE",
                  Switch(
                    value: _isExclusionZoneActive,
                    activeColor: Colors.amberAccent,
                    onChanged: (v) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _isExclusionZoneActive = v;
                        _validateGameMode();
                      });
                      _saveSettings();
                    },
                  ),
                  theme,
                ),
                if (_isExclusionZoneActive) _buildExclusionDropdown(theme),
                
                const SizedBox(height: 10),
                
                _buildControlTile(
                  "RANDOM WEAPON",
                  Switch(
                    value: _isRandomWeapon,
                    activeColor: isNeon ? coreColor : theme.colorScheme.primary,
                    onChanged: (v) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _isRandomWeapon = v;
                        if (v) _selectedWeapon = null;
                      });
                    },
                  ),
                  theme,
                ),

                if (_isRandomWeapon) ...[
                  const SizedBox(height: 10),
                  _buildControlTile("CATEGORY", _buildCategoryDropdown(), theme),
                ] else ...[
                  const SizedBox(height: 10),
                  _buildControlTile(
                    "LOCK WEAPON CHOICE",
                    Switch(
                      value: _lockWeapon,
                      activeColor: isNeon ? coreColor : theme.colorScheme.primary,
                      onChanged: (v) {
                        HapticFeedback.selectionClick();
                        setState(() => _lockWeapon = v);
                      },
                    ),
                    theme,
                  ),
                ],

                const SizedBox(height: 10),
                _buildControlTile("GAME MODE", _buildModeDropdown(), theme),
                const SizedBox(height: 10),
                _buildControlTile("QUANTITY", _buildQuantityDropdown(), theme),
                const SizedBox(height: 30),
                
                _buildInitializeButton(activeTheme, theme),
                
                const SizedBox(height: 30),
                ..._generatedLoadouts.asMap().entries.map((entry) {
                  return GlitchedResultCard(
                    key: ValueKey("loadout_slot_${entry.key}"), 
                    loadout: entry.value,
                    themeController: widget.themeController,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildCategoryDropdown() {
  final themeController = widget.themeController;
  final bool isCustom = themeController.activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;
  
  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final Color primaryColor = isCustom ? coreColor : Theme.of(context).colorScheme.primary;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );

  final List<String> dynamicCategories = _getAvailableCategories();

  return DropdownButton<String>(
    value: dynamicCategories.contains(_selectedCategory) ? _selectedCategory : "ALL",
    onChanged: (v) {
      HapticFeedback.selectionClick();
      setState(() {
        _selectedCategory = v;
        _validateGameMode();
      });
    },

    dropdownColor: isCustom ? const Color.fromARGB(255, 0, 0, 0) : primaryFaded,
    borderRadius: BorderRadius.circular(12),
    underline: const SizedBox(),
    alignment: AlignmentDirectional.centerEnd,
    hint: Container(
      alignment: Alignment.centerRight,
      child: ArmoryText(
        "ALL CLASSES",
        themeController: themeController,
        baseFontSize: 11,
        color: Colors.white38,
      ),
    ),
    icon: Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Icon(
        Icons.expand_more, 
        color: isCustom ? coreColor.withOpacity(0.5) : primaryColor.withOpacity(0.5), 
        size: 16
      ),
    ),
    items: dynamicCategories.map((cat) => DropdownMenuItem(
      value: cat, 
      child: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ArmoryText(
          cat.toUpperCase(),
          themeController: themeController,
          baseFontSize: 11,
          baseStrokeWidth: isCustom ? 1.8 : 1.8,
          color: coreColor,
          letterSpacing: 1.2,
          overrideStrokeColor: isCustom ? Colors.black : Colors.black,
        ),
      )
    )).toList(),
  );
}

Widget _buildTacticalOverlay({required Widget child}) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;
  
  return Stack(
    children: [
      child,
      IgnorePointer(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 20,
            itemBuilder: (context, index) {
              return Container(
                height: 1,
                color: Colors.black.withOpacity(isDark ? 0.03 : 0.01),
              );
            },
          ),
        ),
      ),
    ],
  );
}

Widget _buildOptimizedSearch(ThemeData theme) {
  final themeController = widget.themeController;
  final activeTheme = themeController.activeTheme;
  final bool isNeon = activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );

  return GestureDetector(
    onTap: () => _showWeaponSearchSheet(context, theme),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isNeon ? const Color.fromARGB(255, 0, 0, 0) : primaryFaded,
        border: Border.all(
          color: isNeon ? coreColor.withOpacity(0.4) : theme.colorScheme.primary.withOpacity(0.4),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            _selectedWeapon != null ? Icons.check_circle_outline : Icons.search,
            size: 22,
            color: isNeon ? coreColor.withOpacity(0.6) : coreColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ArmoryText(
              _selectedWeapon?.toUpperCase() ?? "SEARCH ARMORY...",
              themeController: themeController,
              baseFontSize: 11,
              color: _selectedWeapon != null ? Colors.white : Colors.white30,
            ),
          ),
          if (_selectedWeapon != null)
            GestureDetector(
              onTap: () {
                setState(() => _selectedWeapon = null);
                HapticFeedback.selectionClick();
              },
              child: Icon(Icons.close, size: 20, color: coreColor),
            ),
        ],
      ),
    ),
  );
}

void _showWeaponSearchSheet(BuildContext context, ThemeData theme) {
  final aegisArc = Provider.of<AegisArc>(context, listen: false);
  final themeController = widget.themeController;
  final bool isNeon = themeController.activeTheme.id == 'neon_custom';
  final Color coreColor = Color.lerp(themeController.activeAccentColor, Colors.white, 0.35)!;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );

  String clean(String s) => s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  
  final List<MapEntry<String, String>> searchableWeapons = _weaponNames
      .map((name) => MapEntry(name, clean(name)))
      .toList();

  String searchQuery = "";

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: isNeon ? Colors.black : primaryFaded,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          final String cleanQuery = clean(searchQuery);
          
          final filteredOptions = searchableWeapons.where((entry) {
            if (cleanQuery.isEmpty) return false;
            return entry.value.contains(cleanQuery);
          }).map((entry) => entry.key).toList();

          return Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: context.watch<AegisArc>().translateStatic("TYPE WEAPON NAME..."),
                      hintStyle: const TextStyle(color: Colors.white30),
                      prefixIcon: Icon(Icons.search, color: coreColor),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: coreColor, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: coreColor.withOpacity(0.4)),
                      ),
                    ),
                    onChanged: (val) => setSheetState(() => searchQuery = val),
                  ),
                ),
                Flexible(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollStartNotification && notification.dragDetails != null) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                      return false;
                    },
                    child: filteredOptions.isEmpty && searchQuery.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: ArmoryText(
                              "NO MATCHES FOUND",
                              themeController: themeController,
                              baseFontSize: 12,
                              color: Colors.white24,
                            ),
                          )
                        : ListView.builder(
                            itemExtent: 50, 
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: filteredOptions.length,
                            itemBuilder: (context, index) {
                              final option = filteredOptions[index];
                              return ListTile(
                                title: ArmoryText(
                                  option.toUpperCase(),
                                  themeController: themeController,
                                  baseFontSize: 12,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  final weaponData = _allWeaponData.firstWhere(
                                    (w) => w['weapon_name'] == option,
                                    orElse: () => {},
                                  );

                                  setState(() {
                                    _selectedWeapon = option;
                                    if (weaponData.isNotEmpty) {
                                      String g = _getGameFromUrl(weaponData['game_image']).toLowerCase();
                                      if (g == 'mw19' || g == 'cw') {
                                        _selectedMode = 'MULTIPLAYER';
                                      }
                                    }
                                  });

                                  Navigator.pop(context);
                                  HapticFeedback.lightImpact();
                                },
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildStatusHeader(ThemeData theme) {
  final themeController = widget.themeController;
  final bool isCustom = themeController.activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );
  
  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final Color primaryColor = isCustom ? coreColor : theme.colorScheme.primary;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        const SizedBox(height: 20), 

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isCustom ? const Color.fromARGB(255, 0, 0, 0) : primaryFaded,
            border: Border.all(
              color: isCustom ? coreColor.withOpacity(0.4) : primaryColor.withOpacity(0.6),
              width: isCustom ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isCustom ? [
              BoxShadow(color: accentColor.withOpacity(0.1), blurRadius: 10, spreadRadius: -2)
            ] : null,
          ),
          child: Row(
            children: [
              Icon(Icons.bolt, color: isCustom ? coreColor : coreColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: ArmoryText(
                  "SYSTEM READY: SELECT PARAMETERS",
                  themeController: themeController,
                  baseFontSize: 12,
                  baseStrokeWidth: isCustom ? 2.0 : 1.8,
                  color: isCustom ? coreColor : coreColor,
                ),
              ),
            ],
          ),
        ),
        
        if (_isExclusionZoneActive) ...[
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCustom ? const Color.fromARGB(255, 0, 0, 0) : Colors.amberAccent.withOpacity(0.05),
              border: Border.all(
                color: Colors.amberAccent.withOpacity(isCustom ? 0.5 : 0.2),
                width: isCustom ? 1.5 : 1.0,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: Colors.amberAccent, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ArmoryText(
                          "ALLOWED GAMES:",
                          themeController: themeController,
                          baseFontSize: 10,
                          baseStrokeWidth: 1.8,
                          color: Colors.amberAccent,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text("|", style: TextStyle(color: Colors.white24, fontSize: 10)),
                        ),
                        ArmoryText(
                          (_gameKeys.where((g) => !_excludedGames.contains(g)).toList()..sort()).join(" | "),
                          themeController: themeController,
                          baseFontSize: 11,
                          baseStrokeWidth: 1.8,
                          color: isCustom ? coreColor : coreColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    ),
  );
}

Widget _buildExclusionDropdown(ThemeData theme) {
final themeController = widget.themeController;
final bool isCustom = themeController.activeTheme.id == 'neon_custom';
final Color accentColor = themeController.activeAccentColor;
final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );

final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

  return Container(
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: BoxDecoration(
      color: isCustom ? const Color.fromARGB(255, 0, 0, 0) : primaryFaded,
      border: Border.all(
        color: isCustom ? Colors.amberAccent.withOpacity(0.3) : Theme.of(context).colorScheme.primary.withOpacity(0.6)
      ),
      borderRadius: BorderRadius.circular(24)
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ArmoryText(
          "GAMES TO EXCLUDE",
          themeController: themeController,
          baseFontSize: 12,
          baseStrokeWidth: 2,
          color: isCustom ? coreColor : coreColor,
          overrideStrokeColor: isCustom? Colors.black : Colors.black,
        ),
        
        const SizedBox(width: 10),

        Flexible(
          child: PopupMenuButton<String>(
            color: isCustom ? const Color.fromARGB(255, 0, 0, 0) : primaryFaded,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isCustom ? accentColor : Theme.of(context).colorScheme.primary.withOpacity(0.6)),
            ),

            onSelected: (String game) {
              HapticFeedback.selectionClick();
              setState(() {
                if (_excludedGames.contains(game)) {
                  _excludedGames.remove(game);
                } else {
                  _excludedGames.add(game);
                }
                _excludedGames.sort();
                
                _validateGameMode();
                _validateCategory();
              });
              _saveSettings();
            },

            itemBuilder: (context) {
              List<String> alphabetizedKeys = List.from(_gameKeys)..sort();
              
              return alphabetizedKeys.map((game) {
                return PopupMenuItem<String>(
                  value: game,
                  onTap: null,
                  padding: EdgeInsets.zero,
                  child: StatefulBuilder(
                    builder: (context, setMenuState) {
                      bool isExcluded = _excludedGames.contains(game);
                      
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            if (_excludedGames.contains(game)) {
                              _excludedGames.remove(game);
                            } else {
                              _excludedGames.add(game);
                            }
                            _excludedGames.sort();
                            _validateGameMode();
                            _validateCategory();
                          });
                          setMenuState(() {});
                          _saveSettings();
                        },
                        child: Container(
                          height: 48, 
                          padding: const EdgeInsets.symmetric(horizontal: 16), 
                          child: Row(
                            children: [
                              Icon(
                                isExcluded ? Icons.check_box : Icons.check_box_outline_blank,
                                size: 18,
                                color: isExcluded ? Colors.amberAccent : Colors.white24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ArmoryText(
                                  game.toUpperCase(),
                                  themeController: themeController,
                                  baseFontSize: 12,
                                  baseStrokeWidth: 1.5,
                                  textAlign: TextAlign.start,
                                  color: isExcluded 
                                      ? Colors.amberAccent 
                                      : (isCustom ? coreColor : accentColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList();
            },
            
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isCustom ? Colors.amberAccent.withOpacity(0.6) : Theme.of(context).colorScheme.primary.withOpacity(0.6)
                ), 
                borderRadius: BorderRadius.circular(6)
              ),
              child: ArmoryText(
                _excludedGames.isEmpty ? "SELECT" : (_excludedGames..sort()).join(" | "),
                themeController: themeController,
                baseFontSize: 10,
                baseStrokeWidth: 1.5,
                color: Colors.amberAccent,
                textAlign: TextAlign.end,
              ),
            ),
          ),
        )
      ],
    ),
  );
}

Widget _buildControlTile(String label, Widget trailing, ThemeData theme) {
  final isCustom = widget.themeController.activeTheme.id == 'neon_custom';
  final accent = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 3),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    decoration: BoxDecoration(
      color: isCustom ? const Color.fromARGB(255, 0, 0, 0) : primaryFaded,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: isCustom ? coreColor.withOpacity(0.4) : theme.colorScheme.primary.withOpacity(0.6),
        width: 1,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ArmoryText(
          label,
          themeController: widget.themeController,
          baseFontSize: 12,
          color: isCustom ? coreColor : coreColor,
          baseStrokeWidth: 1.8,
        ),

        Theme(
          data: theme.copyWith(
            switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.resolveWith((states) => 
                states.contains(WidgetState.selected) ? (isCustom ? coreColor : Colors.amberAccent) : Colors.grey),
              trackColor: WidgetStateProperty.resolveWith((states) => 
                states.contains(WidgetState.selected) ? (isCustom ? accent.withOpacity(0.5) : null) : null),
            ),
          ),
          child: trailing,
        ),
      ],
    ),
  );
}

InputDecoration _inputDecoration(String hint, ThemeData theme) {
  final activeFont = widget.themeController.activeFont;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );
  
  return InputDecoration(
    hintText: hint.toUpperCase(),
    hintStyle: TextStyle(
      color: Colors.white24, 
      fontSize: 10,
      fontFamily: activeFont,
      letterSpacing: 1.2,
    ),
    filled: true,
    fillColor: theme.colorScheme.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), 
      borderSide: const BorderSide(color: Colors.white10)
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), 
      borderSide: const BorderSide(color: Colors.white10)
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), 
      borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5))
    ),
  );
}

Widget _buildModeDropdown() {
  final themeController = widget.themeController;
  final bool isCustom = themeController.activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final Color primaryColor = isCustom ? coreColor : Theme.of(context).colorScheme.primary;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );

  final bool isTacticalRifle = _selectedCategory == "TACTICAL RIFLE";
  final bool forceMultiplayer = _isLegacyOnly || isTacticalRifle;

  final List<String> availableModes = forceMultiplayer ? ['MULTIPLAYER'] : ['WARZONE', 'MULTIPLAYER'];

  String currentValue = availableModes.contains(_selectedMode) ? _selectedMode : 'MULTIPLAYER';

  return DropdownButton<String>(
    value: currentValue,
    onChanged: availableModes.length > 1 
      ? (v) {
          if (v == null) return;
          HapticFeedback.selectionClick();
          setState(() {
            _selectedMode = v;
            _validateCategory();
          });
        }
      : null,
    
    dropdownColor: isCustom ? Colors.black : primaryFaded,
    borderRadius: BorderRadius.circular(12),
    underline: const SizedBox(),
    alignment: AlignmentDirectional.centerEnd,
    
    icon: availableModes.length > 1 
      ? Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(
            Icons.expand_more, 
            color: isCustom ? coreColor.withOpacity(0.5) : primaryColor.withOpacity(0.5), 
            size: 16
          ),
        )
      : const SizedBox.shrink(),
      
    items: availableModes.map((mode) => DropdownMenuItem(
      value: mode, 
      child: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ArmoryText(
          mode,
          themeController: themeController,
          baseFontSize: 11,
          baseStrokeWidth: isCustom ? 1.8 : 1.8,
          color: availableModes.length > 1 ? coreColor : coreColor,
          letterSpacing: 1.2,
          overrideStrokeColor: Colors.black,
        ),
      )
    )).toList(),
  );
}

Widget _buildQuantityDropdown() {
  final themeController = widget.themeController;
  final bool isCustom = themeController.activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );

  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final Color primaryColor = isCustom ? coreColor : Theme.of(context).colorScheme.primary;

  return DropdownButton<int>(
    value: _amount,
    onChanged: (v) {
      HapticFeedback.selectionClick();
      setState(() => _amount = v!);
    },
    dropdownColor: isCustom ? Theme.of(context).colorScheme.surface : primaryFaded,
    underline: const SizedBox(),
    alignment: AlignmentDirectional.centerEnd,
    icon: Icon(
      Icons.expand_more, 
      color: isCustom ? coreColor.withOpacity(0.5) : primaryColor.withOpacity(0.5), 
      size: 16
    ),
    items: List.generate(10, (i) => i + 1).map((e) => DropdownMenuItem(
      value: e, 
      child: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 8), 
        child: ArmoryText(
          "$e",
          themeController: themeController,
          baseFontSize: 14,
          baseStrokeWidth: isCustom ? 1.8 : 1.8,
          color: coreColor,
          overrideStrokeColor: Colors.black,
        ),
      )
    )).toList(),
  );
}

Widget _buildInitializeButton(ArmoryTheme activeTheme, ThemeData theme) {
  final isCustom = activeTheme.id == 'neon_custom';
  final isHolographic = activeTheme.isHolographic;
  final isStandardPath = !isCustom && !isHolographic;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );
  
  final accent = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;

  final Color buttonFill = isCustom 
      ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.94) 
      : primaryFaded;

  final Color borderFill = isCustom 
      ? coreColor 
      : (activeTheme.borderGradient.isNotEmpty 
          ? activeTheme.borderGradient.first 
          : theme.colorScheme.primary);

  Widget button = SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();

        HapticFeedback.heavyImpact();

        if (_isRandomWeapon || _selectedWeapon == null) {
           setState(() => _selectedWeapon = null);
        }

        _generate();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonFill,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: !isHolographic 
              ? BorderSide(color: borderFill, width: isCustom ? 2 : 1.5) 
              : BorderSide.none,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
            return (isCustom || isHolographic) ? Colors.white.withOpacity(0.05) : null;
          }
          return null;
        }),
      ),
      child: ArmoryText(
        "INITIALIZE",
        themeController: widget.themeController,
        baseFontSize: 14,
        baseStrokeWidth: (isCustom || isHolographic) ? 2.5 : 2.0,
        color: (isCustom || isHolographic) ? coreColor : Colors.white,
        letterSpacing: 2,
        overrideStrokeColor: (isCustom || isHolographic) ? Colors.black : Colors.black,
      ),
    ),
  );

  if (isHolographic) {
    return _InternalAnimatedBorder(
      colors: activeTheme.refractionColors.isNotEmpty 
          ? activeTheme.refractionColors 
          : activeTheme.borderGradient,
      child: button,
    );
  }

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        if (isCustom) ...[
          BoxShadow(color: accent.withOpacity(0.8), blurRadius: 1, spreadRadius: 0.5),
          BoxShadow(color: accent.withOpacity(0.3), blurRadius: 15, spreadRadius: 2),
        ] else ...[
          BoxShadow(
            color: borderFill.withOpacity(0.2),
            blurRadius: 8,
          )
        ],
      ],
    ),
    child: button,
  );
}

Widget _buildLockedSearchTile(ThemeData theme) {
  final themeController = widget.themeController;
  final activeTheme = themeController.activeTheme;
  final bool isNeon = activeTheme.id == 'neon_custom';
  final Color accent = themeController.activeAccentColor;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );
  
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;

  final Color containerBg = isNeon 
      ? const Color.fromARGB(255, 0, 0, 0) 
      : primaryFaded;

  final Color borderColor = isNeon 
      ? coreColor.withOpacity(0.4) 
      : theme.colorScheme.primary.withOpacity(0.6);

  return Container(
    margin: const EdgeInsets.only(top: 12, bottom: 4), 
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: containerBg, 
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: borderColor, 
        width: 1,
      ),
    ),
    child: Row(
      children: [
        Icon(
          Icons.lock_outline, 
          color: isNeon 
              ? coreColor.withOpacity(0.4) 
              : theme.colorScheme.primary.withOpacity(0.6), 
          size: 14
        ),
        
        const SizedBox(width: 12), 
        
        Expanded(
          child: ArmoryText(
            "SEARCH LOCKED: RANDOM MODE ACTIVE",
            themeController: themeController,
            baseFontSize: 10,
            baseStrokeWidth: isNeon ? 2.5 : 2.0, 
            color: isNeon ? coreColor.withOpacity(0.3) : Theme.of(context).colorScheme.primary,
            overrideStrokeColor: isNeon ? Colors.black : Colors.black,
          ),
        ),
      ],
    ),
  );
}
}

class AegisGlitchEffect extends StatefulWidget {
  final Widget child;
  const AegisGlitchEffect({super.key, required this.child});

  @override
  State<AegisGlitchEffect> createState() => _AegisGlitchEffectState();
}

class _AegisGlitchEffectState extends State<AegisGlitchEffect> {
  bool _isGlitching = true;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _isGlitching = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isGlitching) return widget.child;

    return StreamBuilder(
      stream: Stream.periodic(const Duration(milliseconds: 40)),
      builder: (context, snapshot) {
        return Stack(
          children: [

            Transform.translate(
              offset: Offset(_random.nextDouble() * 6 - 3, _random.nextDouble() * 2 - 1),
              child: Opacity(opacity: 0.4, child: widget.child),
            ),

            Transform.translate(
              offset: Offset(_random.nextDouble() * -6 + 3, _random.nextDouble() * -2 + 1),
              child: Opacity(opacity: 0.2, child: widget.child),
            ),

            widget.child,
          ],
        );
      },
    );
  }
}

class GlitchedResultCard extends StatefulWidget {
  final Map<String, dynamic> loadout;
  final ThemeController themeController;

  const GlitchedResultCard({
    super.key, 
    required this.loadout,
    required this.themeController,
  });

  @override
  State<GlitchedResultCard> createState() => _GlitchedResultCardState();
}

class _GlitchedResultCardState extends State<GlitchedResultCard> 
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;

  late AnimationController _infilController;
  late Map<String, dynamic> _displayLoadout; 
  
  late Animation<double> _boxDrop;
  late Animation<double> _headerWipe;
  late Animation<double> _attachmentReveal;

  bool _isSameWeapon = false;

  @override
  void initState() {
    super.initState();
    _displayLoadout = widget.loadout; 
    
    _infilController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _boxDrop = CurvedAnimation(
      parent: _infilController, 
      curve: const Interval(0.0, 0.4, curve: Curves.easeOutExpo)
    );

    _headerWipe = CurvedAnimation(
      parent: _infilController, 
      curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic)
    );

    _attachmentReveal = CurvedAnimation(
      parent: _infilController, 
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut)
    );

    _infilController.forward();
  }

 @override
  void didUpdateWidget(covariant GlitchedResultCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.loadout['id'] != widget.loadout['id']) {
      final bool sameWeapon = oldWidget.loadout['weapon_name'] == widget.loadout['weapon_name'];
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        if (sameWeapon) {
          setState(() => _isSameWeapon = true);

          _infilController.animateTo(0.6, duration: const Duration(milliseconds: 200)).then((_) {
            if (mounted) {
              setState(() => _displayLoadout = widget.loadout);

              _infilController.forward();
            }
          });
        } else {

          setState(() => _isSameWeapon = false);
          _infilController.animateBack(0.25, duration: const Duration(milliseconds: 300)).then((_) {
            if (mounted) {
              setState(() => _displayLoadout = widget.loadout);
              _infilController.forward();
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _infilController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final loadout = _displayLoadout; 
    final themeController = widget.themeController;
    final theme = Theme.of(context);
    final isCustom = themeController.activeTheme.id == 'neon_custom';
    final Color coreColor = Color.lerp(themeController.activeAccentColor, Colors.white, 0.35)!;
    final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );

    return AnimatedBuilder(
      animation: _infilController,
      builder: (context, child) {
        return SizeTransition(
          sizeFactor: _boxDrop,
          axisAlignment: -1.0,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCustom ? Colors.black : primaryFaded,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCustom ? coreColor.withOpacity(0.4) : theme.colorScheme.primary.withOpacity(0.6),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: _isSameWeapon ? 1.0 : _headerWipe.value,
                        child: ArmoryText(
                          (loadout['weapon_name'] ?? "UNKNOWN").toString().toUpperCase(),
                          themeController: themeController,
                          baseFontSize: 16,
                          baseStrokeWidth: 2.0,
                          color: isCustom ? coreColor : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32), 
                    Expanded(
                      child: Opacity(
                        opacity: _isSameWeapon ? 1.0 : _headerWipe.value,
                        child: ArmoryText(
                          "${loadout['archetype'] ?? ''} // ${loadout['game'] ?? ''}".toUpperCase(),
                          themeController: themeController,
                          baseFontSize: 12,
                          baseStrokeWidth: 2.0,
                          textAlign: TextAlign.end,
                          color: isCustom ? coreColor.withOpacity(0.5) : theme.colorScheme.primary,
                          overrideStrokeColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Opacity(
                  opacity: _attachmentReveal.value,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - _attachmentReveal.value)),
                    child: Column(
                      children: (loadout['attachments'] as Map? ?? {}).entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              ArmoryText(
                                "> ${entry.key.toString().toUpperCase()}",
                                themeController: themeController,
                                baseFontSize: 10,
                                baseStrokeWidth: 1.0,
                                color: isCustom ? coreColor.withOpacity(0.7) : Colors.white54,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ArmoryText(
                                  entry.value.toString().toUpperCase(),
                                  themeController: themeController,
                                  baseFontSize: 11,
                                  baseStrokeWidth: 1.2,
                                  textAlign: TextAlign.end,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CombatRatingDisplay extends StatelessWidget {
  final WeaponStats? stats;
  final ThemeController themeController;

  const _CombatRatingDisplay({
    this.stats, 
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    if (stats == null || stats!.combatRating == null) return const SizedBox.shrink();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4, bottom: 2),
        ),

        _CombatRatingBox(
          rating: stats!.combatRating!, 
          themeController: themeController,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _CombatRatingBox extends StatelessWidget {
  final CombatRating rating;
  final ThemeController themeController;

  const _CombatRatingBox({
    required this.rating, 
    required this.themeController,
  });

  Color _getRatingColor(String label) {
    switch (label) {
      case "S": return Colors.amberAccent;
      case "A": return Colors.greenAccent;
      case "B": return Colors.orangeAccent;
      default: return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ratingColor = _getRatingColor(rating.label);
    final activeTheme = themeController.activeTheme;
    final theme = Theme.of(context);
    final bool isCustom = activeTheme.id == 'neon_custom';

    final Color coreColor = Color.lerp(ratingColor, Colors.white, 0.35)!;

    return Container(
      margin: const EdgeInsets.only(top: 10), 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCustom ? coreColor : ratingColor.withOpacity(0.4), 
          width: 2.0,
        ),
        boxShadow: isCustom ? [
          BoxShadow(color: ratingColor.withOpacity(0.8), blurRadius: 1, spreadRadius: 0.5),
          BoxShadow(color: ratingColor.withOpacity(0.3), blurRadius: 15, spreadRadius: 2),
        ] : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
          color: isCustom 
              ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9) 
              : theme.colorScheme.surface.withOpacity(0.9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              Container(
                width: 45,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCustom ? Colors.transparent : ratingColor,
                  borderRadius: BorderRadius.circular(4),
                  border: isCustom ? Border.all(color: coreColor, width: 2) : null,
                  boxShadow: [
                    BoxShadow(
                      color: ratingColor.withOpacity(0.3), 
                      blurRadius: isCustom ? 12 : 8, 
                      spreadRadius: 1
                    )
                  ]
                ),
                child: ArmoryText(
                  rating.label,
                  themeController: themeController,
                  baseFontSize: 24,
                  baseStrokeWidth: isCustom ? 0.5 : 0,
                  color: isCustom ? Colors.white : Colors.black,
                  overrideStrokeColor: isCustom ? Colors.white : Colors.transparent,
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ArmoryText(
                      "COMBAT RATING",
                      themeController: themeController,
                      baseFontSize: 10,
                      baseStrokeWidth: 2,
                      color: isCustom ? Colors.white : ratingColor,
                      overrideStrokeColor: isCustom ? Colors.black : Colors.black,
                      letterSpacing: 1.4,
                    ),
                    const SizedBox(height: 2), 
                    ArmoryText(
                      rating.description.toUpperCase(),
                      themeController: themeController,
                      baseFontSize: 10,
                      baseStrokeWidth: 2.5,
                      color: Colors.white,
                      overrideStrokeColor: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AugmentItem {
  final String name;
  final String image;
  final String minor;
  final String major;

  AugmentItem({required this.name, required this.image, required this.minor, required this.major});

  factory AugmentItem.fromJson(Map<String, dynamic> json) {
    return AugmentItem(
      name: (json['perk'] ?? json['upgrade'] ?? json['augment']).toString().toUpperCase(),
      image: json['perk_image'] ?? json['upgrade_image'] ?? json['augment_image'],
      minor: json['minor_augment'],
      major: json['major_augment'],
    );
  }
}

class AugmentTreeScreen extends StatefulWidget {
  final ThemeController themeController;

  const AugmentTreeScreen({super.key, required this.themeController});

  @override
  State<AugmentTreeScreen> createState() => _AugmentTreeScreenState();
}

class _AugmentTreeScreenState extends State<AugmentTreeScreen> {
  String activeCategory = "PERKS";
  List<AugmentItem> items = [];
  bool isLoading = true;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  double _currPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() => _currPageValue = _pageController.page!);
    });
    _loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
  setState(() => isLoading = true);

  String key = activeCategory == "PERKS" ? "Perks" : 
               activeCategory == "AMMO MODS" ? "Ammo_Mods" : "Field_Upgrades";
  
  final aegisArc = Provider.of<AegisArc>(context, listen: false);
  String lang = aegisArc.languageCode;
  String suffix = aegisArc.suffix;

  String folder = 'assets/';
  String fileName = "$key.json";
  String fullPath = "$folder$fileName";

  try {
    final String response = await loadHotfixedJson(fullPath); 
    final data = json.decode(response);
    
    if (data[key] != null) {
      List<AugmentItem> loaded = (data[key] as List).map((i) => AugmentItem.fromJson(i)).toList();
      loaded.sort((a, b) => a.name.compareTo(b.name));
      setState(() { items = loaded; isLoading = false; });
    }
  } catch (e) {
    debugPrint("Load Error at $fullPath: $e");
    setState(() => isLoading = false);
  }
}

  Widget _buildCategorySelector() {
  final themeController = widget.themeController;
  final activeTheme = themeController.activeTheme;
  final bool isCustom = activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;

  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final Color themePrimary = Theme.of(context).colorScheme.primary;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 4),
    child: Row(
      children: ["PERKS", "AMMO MODS", "FIELD UPGRADES"].map((cat) {
        bool isActive = activeCategory == cat;
        
        final Color boxFill = isCustom 
            ? (isActive ? Colors.black : Colors.black.withOpacity(0.4))
            : (isActive ? themePrimary.withOpacity(0.15) : Colors.white.withOpacity(0.05));

        final Color borderColor = isCustom
            ? (isActive ? coreColor : accentColor.withOpacity(0.2))
            : (isActive ? themePrimary : Colors.white10);

        return Expanded(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() => activeCategory = cat);
              _loadData();
              if (_pageController.hasClients) _pageController.jumpToPage(0);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: boxFill,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: borderColor, 
                  width: isActive ? 2 : 1
                ),
                boxShadow: (isCustom && isActive) ? [
                  BoxShadow(color: accentColor.withOpacity(0.6), blurRadius: 1, spreadRadius: 0.5),
                  BoxShadow(color: accentColor.withOpacity(0.2), blurRadius: 12, spreadRadius: 1),
                ] : null,
              ),
              child: ArmoryText(
                cat,
                themeController: themeController,
                baseFontSize: 9,
                baseStrokeWidth: isActive ? 2.5 : 1.5,
                color: isCustom ? (isActive ? Colors.white : accentColor.withOpacity(0.4)) : (isActive ? coreColor : Colors.white38),
                letterSpacing: 1.1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

@override
Widget build(BuildContext context) {
  final themeController = widget.themeController;
  final bool isCustom = themeController.activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;
  final locale = Provider.of<AegisArc>(context);
  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
  
    Colors.black
  );

  return Scaffold(
    backgroundColor: primaryFaded, 
    appBar: AppBar(
      centerTitle: true,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: primaryFaded,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded, 
          color: isCustom ? coreColor : Colors.white, 
          size: 18
        ),
        onPressed: () {
          HapticFeedback.mediumImpact();
          Navigator.pop(context);
        },
      ),
      title: ArmoryText(
        "AUGMENT TREE", 
        themeController: themeController, 
        baseFontSize: 16,
        baseStrokeWidth: isCustom ? 3.0 : 2.0, 
        color: isCustom ? coreColor : Colors.white
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2.0),
        child: Container(
          color: isCustom ? coreColor : Theme.of(context).colorScheme.primary,
          height: 1.0,
        ),
      ),
    ),
    body: Column(
      children: [
        _buildCategorySelector(),
        
        Expanded(
          child: isLoading 
            ? Center(
                child: CircularProgressIndicator(
                  color: isCustom ? coreColor : Theme.of(context).colorScheme.primary,
                  strokeWidth: 2,
                )
              )
            : PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  double scale = (1.0 - (_currPageValue - index).abs() * 0.15).clamp(0.85, 1.0);
                  double opacity = (1.0 - (_currPageValue - index).abs() * 0.5).clamp(0.4, 1.0);

                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: _AugmentCard(
                        item: items[index], 
                        themeController: themeController
                      ),
                    ),
                  );
                },
              ),
        ),
        const SizedBox(height: 40),
      ],
    ),
  );
}
}

class _AugmentCard extends StatelessWidget {
  final AugmentItem item;
  final ThemeController themeController;

  const _AugmentCard({super.key, required this.item, required this.themeController});

  Map<String, dynamic> _parseAugment(String raw, AegisArc locale) {
    String clean = raw.replaceAll(RegExp(r'>?\s?BO7\s?|BO7\s?>?|>'), "").trim();
    List<String> parts = clean.split("|");

    String translateAndFormat(String text) {
        List<String> options = text.split("/");
        List<String> translatedOptions = options.map((opt) => 
            locale.translate(opt.trim()).translatedText
        ).toList();
        
        return translatedOptions.join(" [OR] ");
    }

    String baseRaw = parts[0].trim();
    String? bo7Raw = parts.length > 1 ? parts[1].trim() : null;

    return {
      "base": translateAndFormat(baseRaw),
      "bo7": bo7Raw != null ? translateAndFormat(bo7Raw.replaceAll("+", "")) : null,
      "isReplacement": raw.contains("BO7 >"),
    };
}

  bool get _isNeon => themeController.activeTheme.id == 'neon_custom';
  bool get _isHolo => themeController.activeTheme.isHolographic;
  bool get _useBlueprint => _isNeon || _isHolo;

  Color _getCore(Color accent) => Color.lerp(accent, Colors.white, 0.4)!;

  Widget _renderAugmentText(String text, {bool isBO7 = false}) {
    const Color textColor = Colors.white;

    if (!text.contains("[OR]")) {
      return ArmoryText(
        text.trim(), 
        themeController: themeController, 
        baseFontSize: 12, 
        baseStrokeWidth: 3.0, 
        color: textColor, 
        lineHeight: 1.4
      );
    }
    
    List<String> segments = text.split("[OR]");
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4, runSpacing: 8,
      children: segments.expand((seg) => [
        ArmoryText(
          seg.trim(), 
          themeController: themeController, 
          baseFontSize: 12, 
          baseStrokeWidth: 3.0, 
          color: textColor
        ),
        if (seg != segments.last) _buildOrBadge(textColor),
      ]).toList(),
    );
  }

  Widget _buildOrBadge(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), 
        borderRadius: BorderRadius.circular(4), 
        border: Border.all(color: color.withOpacity(0.3), width: 0.5)
      ),
      child: ArmoryText(
        "OR", 
        themeController: themeController,
        baseFontSize: 8,
        color: color.withOpacity(0.6),
        baseStrokeWidth: 0,
      ),
    );
  }

  Widget _buildStandardBox(String title, String content, Color fallbackColor) {
    final accent = themeController.activeAccentColor;
    final Color coreColor = _getCore(accent);
    final bool useBlackFill = _isNeon; 
    final Color activeColor = _useBlueprint ? coreColor : fallbackColor;
    
    
    final Color fill = useBlackFill 
        ? Colors.black.withOpacity(0.98) 
        : fallbackColor.withOpacity(0.05);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: fill, 
        borderRadius: BorderRadius.circular(24), 
        border: Border.all(
          color: activeColor.withOpacity(_useBlueprint ? 0.6 : 0.2), 
          width: _useBlueprint ? 1.5 : 1.0
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ArmoryText(
            title.toUpperCase(), 
            themeController: themeController, 
            baseFontSize: 9, 
            baseStrokeWidth: 2.0, 
            color: activeColor, 
            letterSpacing: 1.5
          ),
          const SizedBox(height: 8),
          _renderAugmentText(content),
        ],
      ),
    );
  }

  Widget _buildBO7Box(Map<String, dynamic> minor, Map<String, dynamic> major) {
    if (minor['bo7'] == null && major['bo7'] == null) return const SizedBox.shrink();

    const Color bo7Amber = Colors.amberAccent;
    final Color fill = bo7Amber.withOpacity(0.04);
    final Color borderColor = bo7Amber.withOpacity(0.3);

    Widget buildSubLabel(String label) => ArmoryText(
      label.toUpperCase(), 
      themeController: themeController, 
      baseFontSize: 8, 
      baseStrokeWidth: 1.6, 
      color: bo7Amber
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: fill, 
        borderRadius: BorderRadius.circular(24), 
        border: Border.all(color: borderColor, width: 1.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.auto_awesome, color: bo7Amber, size: 14),
            const SizedBox(width: 8),
            ArmoryText(
              "BO7 ONLY", 
              themeController: themeController, 
              baseFontSize: 10, 
              baseStrokeWidth: 2.0, 
              color: bo7Amber
            ),
          ]),
          const SizedBox(height: 15),
          if (minor['bo7'] != null) ...[
            buildSubLabel(minor['isReplacement'] ? "MINOR AUGMENT REPLACEMENT" : "ADDITIONAL MINOR SLOT:"),
            const SizedBox(height: 5),
            _renderAugmentText(minor['bo7'], isBO7: true),
            const SizedBox(height: 15),
          ],
          if (major['bo7'] != null) ...[
            buildSubLabel(major['isReplacement'] ? "MAJOR AUGMENT REPLACEMENT" : "MAJOR EVOLUTION:"),
            const SizedBox(height: 5),
            _renderAugmentText(major['bo7'], isBO7: true),
          ],
        ],
      ),
    );
  }

@override
Widget build(BuildContext context) {
  // 1. Get the locale controller
  final locale = Provider.of<AegisArc>(context);
  
  final activeTheme = themeController.activeTheme;
  final bool isHolo = activeTheme.isHolographic;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone || activeTheme.borderGradient.isNotEmpty;
  
  final accent = themeController.activeAccentColor;
  final Color coreColor = _getCore(accent);

  // 2. Prepare translated UI Labels
  final String minorLabel = locale.translate("MINOR AUGMENT").translatedText;
  final String majorLabel = locale.translate("MAJOR AUGMENT").translatedText;

  final minorData = _parseAugment(item.minor, locale);
  final majorData = _parseAugment(item.major, locale);
  
  final String minorContent = locale.translate(minorData['base']!).translatedText;
  final String majorContent = locale.translate(majorData['base']!).translatedText;

  const double outerRadius = 28.0;
  const double innerRadius = 28.0; 
  const double strokeWidth = 3.0;

  Widget slotContent = Container(
    decoration: BoxDecoration(
      color: _isNeon ? Colors.black : Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(24),
      border: (!isHolo && !isAnemone) 
          ? Border.all(
              color: _isNeon ? coreColor : Theme.of(context).colorScheme.primary, 
              width: strokeWidth,
            )
          : null,
      boxShadow: [
        if (_isNeon) ...[
          BoxShadow(color: accent.withOpacity(0.8), blurRadius: 4, spreadRadius: 1),
          BoxShadow(color: accent.withOpacity(0.3), blurRadius: 25, spreadRadius: 2),
        ],
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(innerRadius),
      clipBehavior: Clip.antiAlias,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(child: Image.network(item.image, height: 130, fit: BoxFit.contain)),
          const SizedBox(height: 20),
          Center(
            child: ArmoryText(
              locale.translate(item.name).translatedText.toUpperCase(), 
              themeController: themeController, 
              baseFontSize: 20, 
              baseStrokeWidth: (_isNeon || isHolo || isAnemone) ? 4.0 : 3.0,
              color: Colors.white
            )
          ),
          const SizedBox(height: 25),
          _buildStandardBox(
            minorLabel, 
            _parseAugment(item.minor, locale)['base'],
            Theme.of(context).colorScheme.primary
          ),
          _buildStandardBox(
            majorLabel, 
            _parseAugment(item.major, locale)['base'],
            Colors.purpleAccent
          ),
          _buildBO7Box(_parseAugment(item.minor, locale), _parseAugment(item.major, locale)),
        ],
      ),
    ),
  );

  Widget finalSlot;
  if (isHolo) {
    finalSlot = _InternalAnimatedBorder(
      colors: activeTheme.refractionColors,
      useRotation: true,
      borderRadius: 24,
      strokeWidth: 4.0,
      child: slotContent,
    );
  } else if (isAnemone) {
    finalSlot = ArmoryGradientBorder(
      gradientColors: activeTheme.borderGradient,
      strokeWidth: 4.0,
      borderRadius: 24,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      child: slotContent,
    );
  } else {
    finalSlot = slotContent;
  }

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    child: finalSlot,
  );
}
}

class MetaDashboardScreen extends StatefulWidget {
  final ThemeController themeController;

  const MetaDashboardScreen({
    super.key, 
    required this.themeController,
  });

  @override
  State<MetaDashboardScreen> createState() => _MetaDashboardScreenState();
}

class _MetaDashboardScreenState extends State<MetaDashboardScreen> {
  String activeGame = "BO6";
  String? activeClass;
  List<MetaWeapon> allWeapons = [];
  bool isLoading = true;
  final List<String> _preferredClassOrder = [
  "CLOSE RANGE (WZ)",
  "LONG RANGE (WZ)",
  "MULTIPLAYER",
  "ZOMBIES"
];

  final ValueNotifier<int> _resetNotifier = ValueNotifier<int>(0);
  final PageController _pageController = PageController(viewportFraction: 0.82);
  double _currPageValue = 0.0;

@override
void initState() {
  super.initState();
  _pageController.addListener(() {
    if (_pageController.hasClients) {
      double page = _pageController.page ?? 0;
      
      if (mounted) {
        setState(() => _currPageValue = page);
      }

      if ((page - page.round()).abs() > 0.4) {
        _resetNotifier.value++; 
      }
    }
  });
  _loadMetaData();
}

Future<void> _loadMetaData() async {
  setState(() => isLoading = true);

  try {

    final String weaponResponse = await loadHotfixedJson('assets/Weapon_Names.json');
    final Map<String, dynamic> weaponData = json.decode(weaponResponse);
    final List<dynamic> weaponList = weaponData['Weapon_Names'] ?? [];

    String? cwLogo = weaponList.firstWhere((w) => w['weapon_name'].toString().contains('(CW)'), orElse: () => null)?['game_image'];
    String? mw3Logo = weaponList.firstWhere((w) => w['weapon_name'].toString().contains('MW3'), orElse: () => null)?['game_image'];

    final String metaResponse = await loadHotfixedJson('assets/META.json');
    final metaData = json.decode(metaResponse);

    setState(() {
      allWeapons = (metaData['META'] as List).map((metaEntry) {
        String rawName = metaEntry['weapon'] ?? "";
        String searchName = rawName.replaceFirst('•', '').trim();

        searchName = searchName.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim();

        if (searchName.toUpperCase() == "MAGNUM") searchName = "MAGNUM (CW)";
        if (searchName.toUpperCase() == "AKIMBO P890") searchName = "P890";

        searchName = searchName.replaceAll('(PRESTIGE)', '').trim();
        if (searchName.contains('SNIPER SUPPORT')) {
          searchName = searchName.split('SNIPER SUPPORT')[0].trim();
        }

        dynamic imageEntry = weaponList.firstWhere(
          (w) => w['weapon_name'].toString().trim().toUpperCase() == searchName.toUpperCase(),
          orElse: () => null,
        );

        if (searchName.toUpperCase() == "SAI") {
          imageEntry = {
            "weapon_image": "https://res.cloudinary.com/dctlpj7fg/image/upload/v1759470886/Sai_HUD_Icon_BOCW_btzutq.png",
            "game_image": cwLogo
          };
        } else if (searchName.toUpperCase() == "RGL-80") {
          imageEntry = {
            "weapon_image": "https://res.cloudinary.com/dctlpj7fg/image/upload/v1759473975/RGL-80_Gunsmith_MWIII_gs85do.png",
            "game_image": mw3Logo
          };
        }

        if (imageEntry == null) {
          debugPrint("⚠️ NO IMAGE MATCH: Searched for '$searchName'");
        }

        return MetaWeapon.fromJson(metaEntry, imageEntry, searchName: searchName);
      }).toList();

      if (allWeapons.any((w) => w.game == activeGame)) {
        final List<String> currentClasses = allWeapons
            .where((w) => w.game == activeGame)
            .map((w) => w.classType)
            .toSet()
            .toList();

        if (currentClasses.contains("CLOSE RANGE (WZ)")) {
          activeClass = "CLOSE RANGE (WZ)";
        } else if (currentClasses.contains("MULTIPLAYER")) {
          activeClass = "MULTIPLAYER";
        } else {
          activeClass = currentClasses.isNotEmpty ? currentClasses.first : null;
        }
      }
      
      isLoading = false;
    });
  } catch (e) {
    debugPrint("❌ Meta Load Error: $e");
    setState(() => isLoading = false);
  }
}

  List<MetaWeapon> get filteredItems {
    return allWeapons.where((w) => w.game == activeGame && w.classType == activeClass).toList();
  }

 @override
Widget build(BuildContext context) {
  final activeTheme = widget.themeController.activeTheme;
  final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
  final Color accent = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );

  final primaryColor = Theme.of(context).colorScheme.primary;

  final Color titleColor = isNeon ? coreColor : Colors.white;

  List<String> availableClasses = allWeapons
      .where((w) => w.game == activeGame)
      .map((w) => w.classType)
      .toSet()
      .toList();

  availableClasses.sort((a, b) {
    int indexA = _preferredClassOrder.indexOf(a);
    int indexB = _preferredClassOrder.indexOf(b);
    return (indexA == -1 ? 99 : indexA).compareTo(indexB == -1 ? 99 : indexB);
  });

  if (activeClass == null || !availableClasses.contains(activeClass)) {
    activeClass = availableClasses.isNotEmpty ? availableClasses.first : null;
  }

    return Scaffold(
    backgroundColor: primaryFaded,
    appBar: AppBar(
      backgroundColor: primaryFaded,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded, 
          color: isNeon ? coreColor : Colors.white, 
          size: 18
        ),
        onPressed: () {
          HapticFeedback.mediumImpact();
          Navigator.pop(context);
        },
      ),
      title: ArmoryText(
        "META PICKS",
        themeController: widget.themeController,
        baseFontSize: 16,
        baseStrokeWidth: 2.5,
        color: titleColor,
        letterSpacing: 1.5,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          height: 1.0,
          color: isNeon 
              ? coreColor
              : primaryColor,
        ),
      ),
    ),
    body: Column(
      children: [
        _buildGameSelector(allWeapons.map((w) => w.game).toSet().toList()..sort()),

        Container(
          height: 50,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: availableClasses.map((c) => _buildClassChip(c)).toList(),
          ),
        ),

        Expanded(
          child: isLoading 
            ? Center(
                child: CircularProgressIndicator(
                  color: isNeon ? coreColor : primaryColor,
                ),
              )
            : PageView.builder(
                key: ValueKey("${activeGame}_$activeClass"),
                controller: _pageController,
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  double scale = 0.85;
                  if (index == _currPageValue.floor()) {
                    scale = 1.0 - (_currPageValue - index) * (1 - 0.85);
                  } else if (index == _currPageValue.floor() + 1) {
                    scale = 0.85 + (_currPageValue - index + 1) * (1 - 0.85);
                  }
                  
                  return Transform.scale(
                    scale: scale.clamp(0.85, 1.0),
                    child: _MetaCard(
                      weapon: filteredItems[index], 
                      resetSignal: _resetNotifier, 
                      key: ValueKey(filteredItems[index].name),
                      themeController: widget.themeController,
                    ),
                  );
                },
              ),
        ),
        const SizedBox(height: 40),
      ],
    ),
  );
}

Widget _buildClassChip(String label) {
  final activeTheme = widget.themeController.activeTheme;
  final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
  final Color accent = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;
  final primaryColor = Theme.of(context).colorScheme.primary;

  bool isActive = activeClass == label;

  return GestureDetector(
    onTap: () {
      HapticFeedback.selectionClick();
      setState(() {
        activeClass = label;
        _currPageValue = 0.0;
      });
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isActive 
            ? (isNeon ? Colors.black : primaryColor.withOpacity(0.1)) 
            : Colors.white.withOpacity(0.05),
        border: Border.all(
          color: isActive 
              ? (isNeon ? coreColor : primaryColor) 
              : Colors.white10,
          width: (isNeon && isActive) ? 2.0 : (isActive ? 1.5 : 1.0),
        ),
        boxShadow: (isNeon && isActive) ? [
          BoxShadow(color: accent.withOpacity(0.4), blurRadius: 8, spreadRadius: 0.5),
        ] : null,
      ),
      child: Center(
        child: ArmoryText(
          label.toUpperCase(),
          themeController: widget.themeController,
          baseFontSize: 9,
          baseStrokeWidth: 1.5,
          color: isActive ? (isNeon ? coreColor : Colors.white) : Colors.white38,
        ),
      ),
    ),
  );
}

Widget _buildGameSelector(List<String> options) {
  final activeTheme = widget.themeController.activeTheme;
  final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
  final Color accent = widget.themeController.activeAccentColor;
  
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;
  final primaryColor = Theme.of(context).colorScheme.primary;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Row(
      children: options.map((opt) {
        bool isActive = activeGame == opt;
    
        final Color activeBorder = isNeon ? coreColor : primaryColor;

        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque, 
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() {
                activeGame = opt;
                _currPageValue = 0.0;
                
                final List<String> newGameClasses = allWeapons
                    .where((w) => w.game == opt)
                    .map((w) => w.classType)
                    .toSet()
                    .toList();

                if (newGameClasses.contains("CLOSE RANGE (WZ)")) {
                  activeClass = "CLOSE RANGE (WZ)";
                } else if (newGameClasses.contains("MULTIPLAYER")) {
                  activeClass = "MULTIPLAYER";
                } else {
                  activeClass = newGameClasses.isNotEmpty ? newGameClasses.first : null;
                }
              });
              if (_pageController.hasClients) {
                _pageController.jumpToPage(0);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isActive 
                    ? (isNeon ? Colors.black : primaryColor.withOpacity(0.1)) 
                    : Colors.white.withOpacity(0.05),
                border: Border.all(
                  color: isActive ? activeBorder : Colors.white10,
                  width: (isNeon && isActive) ? 2.0 : 1.0, 
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: (isNeon && isActive) ? [
                  BoxShadow(color: accent.withOpacity(0.4), blurRadius: 8, spreadRadius: 0.5),
                ] : null,
              ),
              child: Center(
                child: ArmoryText(
                  opt,
                  themeController: widget.themeController,
                  baseFontSize: 10,
                  baseStrokeWidth: 1.8,
                  color: isActive ? (isNeon ? coreColor : Colors.white) : Colors.white38,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
}

class _MetaCard extends StatefulWidget {
  final MetaWeapon weapon;
  final ValueNotifier<int> resetSignal;
  final ThemeController themeController;

  const _MetaCard({
    super.key, 
    required this.weapon, 
    required this.resetSignal,
    required this.themeController,
  });

  @override
  State<_MetaCard> createState() => _MetaCardState();
}

class _MetaCardState extends State<_MetaCard> {
  bool _isFlipped = false;
  Map<String, dynamic>? _foundLoadout;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    widget.resetSignal.addListener(_handleReset);
  }

  @override
  void dispose() {
    widget.resetSignal.removeListener(_handleReset);
    super.dispose();
  }

 void _handleReset() {
  if (mounted) {
    setState(() {
      _isFlipped = false;
      _foundLoadout = null;
      _isSearching = false;
    });
  }
}

  String _getTargetJsonPath() {
  final game = widget.weapon.game;
  final type = widget.weapon.classType;

  if (type == "SPECIAL") return 'assets/Special.json';

  if (type.contains("(WZ)")) {
    if (game == "BO7") return 'assets/Warzone_BO7.json';
    if (game == "BO6") return 'assets/Warzone_BO6.json';
    if (game == "MW2") return 'assets/Warzone_MW3_MW2.json';
    if (game == "MW3") return 'assets/Warzone_MW3_MW2.json';
  } 
    
  if (type == "MULTIPLAYER") {
    if (game == "BO7") return 'assets/Multiplayer_BO7.json';
    if (game == "BO6") return 'assets/Multiplayer_MW3_BO6.json';
    if (game == "CW") return 'assets/Multiplayer_Cold_War.json';
    if (game == "MW2") return 'assets/Multiplayer_MW3_BO6.json';
    if (game == "MW3") return 'assets/Multiplayer_MW3_BO6.json';
    if (game == "MW19") return 'assets/Multiplayer_MW19.json';
  }

  if (type == "ZOMBIES") {
    if (game == "BO7") return 'assets/Zombies_BO7.json';
    if (game == "BO6") return 'assets/Zombies_MW3_BO6.json';
    if (game == "CW") return 'assets/Zombies_Cold_War.json';
    if (game == "MW2") return 'assets/Zombies_MW3_BO6.json';
    if (game == "MW3") return 'assets/Zombies_MW3_BO6.json';
  }
  
  throw UnimplementedError("No absolute path defined for Game: $game, Type: $type");
}

Future<void> _fetchLoadout() async {
  if (_foundLoadout != null) return;
  setState(() => _isSearching = true);

  try {
    final String cardName = widget.weapon.searchKey.toUpperCase();
    final bool isSpecialWarzone = cardName.contains('(WZ)') && 
                                 (cardName.contains('SNIPER SUPPORT') || cardName.contains('MOD'));

    dynamic match;
    final primaryPath = _getTargetJsonPath();

    if (isSpecialWarzone) {
      try {
        final response = await loadHotfixedJson('assets/Special.json');
        final List<dynamic> specialData = _parseJsonList(json.decode(response));
        match = specialData.firstWhere((item) {
          String combined = "${item['weapon_name']} ${item['mod']}".toUpperCase().trim();
          return combined == cardName || combined.contains(cardName);
        }, orElse: () => null);
      } catch (e) {
        debugPrint("Special JSON lookup failed: $e");
      }
    }

    if (match == null) {
      try {
        final response = await loadHotfixedJson(primaryPath);
        final List<dynamic> data = _parseJsonList(json.decode(response));
        
        match = data.firstWhere((item) {
          String itemName = (item['weapon_name'] ?? item['name'] ?? "").toString().toUpperCase().trim();
          String target = cardName.toUpperCase().trim();
          return itemName == target || itemName.contains(target) || target.contains(itemName);
        }, orElse: () => null);
      } catch (e) {
        debugPrint("Primary JSON lookup failed: $e");
      }
    }

    if (mounted) {
      setState(() {
        _foundLoadout = match;
        _isSearching = false;
      });
    }
  } catch (e) {
    debugPrint("Global Search error: $e");
    if (mounted) setState(() => _isSearching = false);
  }
}

List<dynamic> _parseJsonList(dynamic decoded) {
  if (decoded is List) return decoded;
  if (decoded is Map) {
    return decoded['weapons'] ?? 
           decoded['builds'] ?? 
           decoded.values.firstWhere((v) => v is List, orElse: () => []);
  }
  return [];
}

  void _toggleFlip() {
    HapticFeedback.mediumImpact();
    if (!_isFlipped) _fetchLoadout();
    setState(() => _isFlipped = !_isFlipped);
  }

  @override
Widget build(BuildContext context) {
  final primary = Theme.of(context).colorScheme.primary;

  return GestureDetector(
    onTap: _toggleFlip,
    child: TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      tween: Tween<double>(begin: 0, end: _isFlipped ? pi : 0),
      builder: (context, angle, child) {
        final isBack = angle >= pi / 2;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: isBack
              ? Transform(
                  transform: Matrix4.identity()..rotateY(pi),
                  alignment: Alignment.center,
                  child: _buildBack(primary),
                )
              : _buildFront(primary),
        );
      },
    ),
  );
}

Widget _buildFront(Color primary) {
  final activeTheme = widget.themeController.activeTheme;
  final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
  final bool isHolo = activeTheme.isHolographic;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
  
  final Color accent = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;

  const double outerRadius = 28.0;
  const double borderWidth = 3.0;
  const double innerRadius = 28.0;

  bool isRanked = widget.weapon.rank != null;
  String cleanName = widget.weapon.name
      .replaceAll('•', '')
      .replaceAll(RegExp(r'^\d+\.\s?'), '')
      .trim()
      .toUpperCase();

  Widget cardContent = Container(
    decoration: BoxDecoration(
      color: isNeon ? Colors.black : Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(innerRadius),
      border: (!isHolo && !isAnemone) 
          ? Border.all(
              color: isNeon ? coreColor : (isRanked ? Colors.amberAccent : primary.withOpacity(0.5)),
              width: borderWidth,
            )
          : null,
      boxShadow: isNeon ? [
        BoxShadow(color: accent.withOpacity(0.8), blurRadius: 4, spreadRadius: 0.5),
        BoxShadow(color: accent.withOpacity(0.2), blurRadius: 15, spreadRadius: 1),
      ] : null,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(innerRadius),
      child: Column(
        children: [
          const Spacer(), 
          if (widget.weapon.weaponImage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Image.network(widget.weapon.weaponImage!, height: 120, fit: BoxFit.contain),
            )
          else
            Icon(Icons.legend_toggle_rounded, size: 80, color: Colors.white.withOpacity(0.05)),
          const SizedBox(height: 20),
          _buildBadge(isRanked, primary),
          const SizedBox(height: 15),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 32,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: ArmoryText(
                  cleanName,
                  themeController: widget.themeController,
                  baseFontSize: 22,
                  baseStrokeWidth: 4.0,
                  color: Colors.white,
                  letterSpacing: cleanName.length > 15 ? 0.5 : 1.5, 
                ),
              ),
            ),
          ),
          
          SizedBox(
            height: 20, 
            child: Center(
              child: ArmoryText(
                widget.weapon.classType.toUpperCase(),
                themeController: widget.themeController,
                baseFontSize: 9,
                baseStrokeWidth: 1.8,
                color: Colors.white70,
                letterSpacing: 2.0,
              ),
            ),
          ),
          
          const Spacer(), 
          ArmoryText(
            "TAP TO VIEW ATTACHMENTS",
            themeController: widget.themeController,
            baseFontSize: 8,
            baseStrokeWidth: 1.5,
            color: Colors.white70,
          ),
          const SizedBox(height: 25), 
        ],
      ),
    ),
  );

  Widget finalCard;
  if (isHolo) {
  finalCard = _InternalAnimatedBorder(
    colors: activeTheme.refractionColors,
    useRotation: true,
    borderRadius: outerRadius,
    strokeWidth: borderWidth,
    child: cardContent,
  );
  } else if (isAnemone) {
    finalCard = ArmoryGradientBorder(
      gradientColors: activeTheme.borderGradient,
      strokeWidth: borderWidth,
      borderRadius: outerRadius,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      child: cardContent,
    );
  } else {
    finalCard = cardContent;
  }

  return Stack(
    children: [
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: finalCard,
      ),
      if (widget.weapon.gameImage != null)
        Positioned(
          top: 45,
          right: 25,
          child: Opacity(
            opacity: 0.8, 
            child: Image.network(widget.weapon.gameImage!, width: 45)
          ),
        ),
    ],
  );
}

Widget _buildBack(Color primary) {
  final activeTheme = widget.themeController.activeTheme;
  final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
  final bool isHolo = activeTheme.isHolographic;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
  final aegisArc = Provider.of<AegisArc>(context, listen: false);
  
  final Color accent = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;

  const double outerRadius = 28.0;
  const double innerRadius = 28.0;
  const double strokeWidth = 3.0;
  const double borderWidth = 3.0;

  bool isRanked = widget.weapon.rank != null;
  
  List<String> attachments = [];
  String buildCode = "";

  if (_foundLoadout != null) {
    for (int i = 1; i <= 8; i++) {
      final val = _foundLoadout!['attach_$i'];
      if (val != null && val.toString() != "null" && val.toString().isNotEmpty) {
        attachments.add(val.toString());
      }
    }
    buildCode = (_foundLoadout!['build_code'] ?? "").toString();
  }

  Widget cardContent = Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: isNeon ? Colors.black : Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(innerRadius),
      border: (!isHolo && !isAnemone) 
          ? Border.all(
              color: isNeon ? coreColor : (isRanked ? Colors.amberAccent : primary.withOpacity(0.5)),
              width: strokeWidth,
            )
          : null,
      boxShadow: isNeon ? [
        BoxShadow(color: accent.withOpacity(0.8), blurRadius: 4, spreadRadius: 0.5),
        BoxShadow(color: accent.withOpacity(0.2), blurRadius: 15, spreadRadius: 1),
      ] : null,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(innerRadius),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.fromLTRB(25, 25, 25, 20),
        child: Column(
          children: [
            ArmoryText(
              "ATTACHMENTS",
              themeController: widget.themeController,
              baseFontSize: 12,
              baseStrokeWidth: 2.0,
              color: isNeon ? coreColor : coreColor,
            ),
            const Divider(color: Colors.white10, height: 30, thickness: 0.5),
            
            Expanded(
              child: _isSearching 
                ? Center(child: CircularProgressIndicator(color: isNeon ? coreColor : primary))
                : attachments.isEmpty
                  ? Center(
                      child: ArmoryText(
                        "NO DATA FOUND",
                        themeController: widget.themeController,
                        baseFontSize: 10,
                        color: Colors.white10,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 5),
                      itemCount: attachments.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9), 
                          child: Row(
                            children: [
                              Container(
                                width: 2, height: 16, 
                                color: isNeon ? coreColor : primary
                              ),
                              const SizedBox(width: 14),
                              Expanded( 
                                child: ArmoryText(
                                  aegisArc.translate(attachments[i].toUpperCase()).translatedText,
                                  themeController: widget.themeController,
                                  baseFontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            if (buildCode.isNotEmpty) ...[
                 const Divider(color: Colors.white10, height: 20),
                 ArmoryText(
                   "BUILD CODE", 
                   themeController: widget.themeController, 
                   baseFontSize: 9, 
                   color: isNeon ? coreColor : coreColor
                 ),
                 const SizedBox(height: 5),
                 SelectableText(
                   buildCode, 
                   style: const TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 1.2)
                 ),
            ],
            
            const SizedBox(height: 10),
            ArmoryText(
              "TAP TO RETURN",
              themeController: widget.themeController,
              baseFontSize: 8,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    ),
  );

  Widget finalCard;
  if (isHolo) {
    finalCard = _InternalAnimatedBorder(
      colors: activeTheme.refractionColors,
      useRotation: true,
      borderRadius: outerRadius,
      strokeWidth: strokeWidth,
      child: cardContent,
    );
  } else if (isAnemone) {
    finalCard = ArmoryGradientBorder(
      gradientColors: activeTheme.borderGradient,
      strokeWidth: borderWidth,
      borderRadius: outerRadius,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      child: cardContent,
    );
  } else {
    finalCard = cardContent;
  }

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
    child: finalCard,
  );
}

Widget _buildBadge(bool isRanked, Color primary) {
  final activeTheme = widget.themeController.activeTheme;
  final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
  final Color accent = widget.themeController.activeAccentColor;
  
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;
  final Color effectiveColor = isRanked ? Colors.amberAccent : (isNeon ? coreColor : primary);

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: isNeon ? Colors.black : (isRanked ? effectiveColor : effectiveColor.withOpacity(0.3)),
      borderRadius: BorderRadius.circular(4),
      border: isNeon ? Border.all(color: effectiveColor, width: 1.5) : null,
      boxShadow: isNeon ? [
        BoxShadow(color: effectiveColor.withOpacity(0.5), blurRadius: 4, spreadRadius: 0.5),
      ] : null,
    ),
    child: isRanked 
      ? ArmoryText(
          "RANKED #${widget.weapon.rank}",
          themeController: widget.themeController,
          baseFontSize: 11,
          baseStrokeWidth: 2.0,
          color: isNeon ? effectiveColor : Colors.black,
          overrideStrokeColor: isNeon ? Colors.black : effectiveColor.withOpacity(0.5),
        )
      : ArmoryText(
          "POWER PICK",
          themeController: widget.themeController,
          baseFontSize: 11,
          baseStrokeWidth: 2.5,
          color: isNeon ? coreColor : coreColor,
        ),
  );
}
}

class _GradientBorderPainter extends CustomPainter {
  final double radius;
  final double width;
  final Gradient gradient;

  _GradientBorderPainter({required this.radius, required this.width, required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)), paint);
  }

  @override
  bool shouldRepaint(covariant _GradientBorderPainter oldDelegate) {
    return oldDelegate.gradient != gradient;
  }
}

List<Weapon> _heavyDataProcessing(Map<String, dynamic> data) {
  final List<String> buildJsonsRaw = data['buildJsons'];
  final String namesRaw = data['namesJson'];
  final String statsRaw = data['statsJson'];
  final List<String> filePaths = data['filePaths'];

  final Map<String, String> lookup = Map<String, String>.from(data['archetypeLookup'] ?? {});

  Map<String, Map<String, String>> imageLookup = {};
  Map<String, WeaponStats> statsLookup = {};
  Map<String, Weapon> grouped = {};

  final Map<String, dynamic> imageJson = json.decode(namesRaw);
  for (var w in imageJson['Weapon_Names']) {
    if (w['weapon_name'] != null) {
      String rawUrl = w['weapon_image'] ?? "";
      if (rawUrl.isNotEmpty) {
        rawUrl = rawUrl.replaceAll(RegExp(r'\.[a-zA-Z0-9]+(?=\?|$)'), '.png');
      }
      imageLookup[w['weapon_name']] = {
        'weapon_image': rawUrl,
        'game_image': w['game_image'] ?? ""
      };
    }
  }

  final Map<String, dynamic> statsJson = json.decode(statsRaw);
  for (var s in statsJson['Premium_Stats']) {
    String key = s['weapon_name']?.toString().toUpperCase() ?? "";
    if (key.isNotEmpty) {
      statsLookup[key] = WeaponStats(
        ttk1: s['ttk1']?.toString() ?? "-",
        range1: s['range1']?.toString() ?? "-",
        adsSpeed: s['ads_speed']?.toString() ?? "-",
        bulletVelocity: s['bullet_velocity']?.toString() ?? "-",
        shotsToKill: s['shots_to_kill']?.toString() ?? "-",
        ttk2: s['ttk2']?.toString() ?? "-",
        range2: s['range2']?.toString() ?? "-",
        hitscanRange: s['hitscan_range']?.toString() ?? "-",
        shotRange: (s['shot_range'] != null && s['shot_range'].toString().toLowerCase() != "null") 
            ? s['shot_range'].toString() : null,
      );
    }
  }

  for (int i = 0; i < buildJsonsRaw.length; i++) {
    final dynamic decoded = json.decode(buildJsonsRaw[i]);
    final String filePath = filePaths[i].toLowerCase();
    List<dynamic> itemsToProcess = (decoded is List) ? decoded : decoded.values.first;

    for (var item in itemsToProcess) {
      String rawName = item['weapon_name'] ?? item['name'] ?? 'Unknown';
      String baseName = rawName.replaceAll(_prestigeRegex, '').replaceAll(_akimboRegex, '').trim(); 

      if (baseName.toUpperCase() == "KAR98K IRON SIGHTS") {
        baseName = "KAR98K (MW3)"; 
      }
      String modeKey = "Multiplayer";
      String? modName = item['mod'] ?? item['mod_name'];

      if (rawName.toUpperCase() == "KAR98K IRON SIGHTS") {
        modName = "IRON SIGHTS";
      }

      String? specialtyBoxValue; 

      if (baseName.toUpperCase().contains("MX GUARDIAN - FULL AUTO")) {
        baseName = "MX GUARDIAN"; 
        modeKey = "MULTIPLAYER FULL AUTO";
      } else if (baseName.toUpperCase().contains("MX GUARDIAN - SEMI-AUTO")) {
        baseName = "MX GUARDIAN"; 
        modeKey = "MULTIPLAYER SEMI AUTO";
      } else {
        if (filePath.contains("special")) modeKey = "Special";
        else if (filePath.contains("zombies")) modeKey = "Zombies";
        else if (filePath.contains("warzone")) modeKey = "Warzone";
        else if (filePath.contains("rebirth")) modeKey = "Rebirth";
        else if (filePath.contains("endgame")) modeKey = "Endgame";
        else if (filePath.contains("akimbo")) modeKey = "Akimbo";
        else if (filePath.contains("single")) modeKey = "Single";
      }
      
      if (rawName.toUpperCase().contains("PRESTIGE")) modeKey = "Warzone Prestige";

      var imgData = imageLookup[baseName] ?? {'weapon_image': "", 'game_image': ""};
      String weaponImageUrl = imgData['weapon_image'] ?? "";
      if (weaponImageUrl.isNotEmpty) {
        weaponImageUrl = weaponImageUrl.replaceAll(RegExp(r'\.[a-zA-Z0-9]+(?=\?|$)'), '.png');
        weaponImageUrl = Uri.encodeFull(weaponImageUrl);
      }

      List<String> cleanAttachments = [];
      List<String> starredAttachments = [];
      Set<String> detectedCodes = {};

      void processAttachment(dynamic raw) {
        if (raw == null) return;
        String val = raw.toString().trim();
        if (val.isEmpty || val.toLowerCase() == "null") return;
        
        if (_codeRegex.hasMatch(val)) { detectedCodes.add(val); return; }
        
        String upper = val.toUpperCase();

        if (upper == "TAC STANCE" || upper == "ADS" || upper == "HIPFIRE") { 
          specialtyBoxValue = "SHOOTING STYLE - $upper"; 
          return;
        }

        if (_opticDictionary.any((optic) => upper.contains(optic))) {
           starredAttachments.add(val);
        }
        
        cleanAttachments.add(val.replaceAll('\\', ''));
      }

      for (int k = 1; k <= 8; k++) processAttachment(item['attach_$k']);
      processAttachment(item['recommended_sight_shooting_style']);

      if (filePath.contains("zombies_mw3_bo6")) { 
        dynamic extraVal = item['shooting_style_attach_6'];
        if (extraVal != null) {
          String val = extraVal.toString().trim();
          String upper = val.toUpperCase();

          if (upper == "TAC STANCE" || upper == "ADS" || upper == "HIPFIRE") {
            specialtyBoxValue = "SHOOTING STYLE - $upper";
          } else if (val.isNotEmpty && val.toLowerCase() != "null") {

            String cleanedVal = val.replaceAll('\\', '');
            
            int insertPos = math.min(5, cleanAttachments.length);
            cleanAttachments.insert(insertPos, cleanedVal);

            if (_opticDictionary.any((optic) => upper.contains(optic))) {
               starredAttachments.add(cleanedVal);
            }
          }
        }
      }

      if (baseName.toUpperCase() == "KASTOV LSW" && modeKey == "Multiplayer") {
        specialtyBoxValue = "SHOOTING STYLE - ADS";
        if (!cleanAttachments.contains("NYDAR MODEL 2023")) {
          cleanAttachments.add("NYDAR MODEL 2023 SIGHT");
          starredAttachments.add("NYDAR MODEL 2023 SIGHT");
        }
      }

      if (specialtyBoxValue == null) {
        String rec = (item['recommended_sight_shooting_style'] ?? "").toString().toUpperCase().trim();
        if (rec == "ADS" || rec == "TAC STANCE" || rec == "HIPFIRE") {
          specialtyBoxValue = "SHOOTING STYLE - $rec";
        } else {
          specialtyBoxValue = null; 
        }
      }

      WeaponStats? buildStats;
      WeaponStats? alternativeStats;

      String searchName = rawName.toUpperCase();
      String searchMod = modName?.toUpperCase() ?? "";
      String combinedSearch = "$searchName $searchMod".trim();
      bool isAkimboBuild = rawName.toUpperCase().contains("AKIMBO") || searchMod.contains("AKIMBO");

      if (searchName.contains("SOKOL 545")) {
        buildStats = statsLookup["SOKOL 545 (SLOW)"];
        alternativeStats = statsLookup["SOKOL 545 (FAST)"];
      } else {
        
        if (modeKey == "Special") {
        buildStats = statsLookup[combinedSearch]; 

      } else {
        buildStats = statsLookup[combinedSearch] ?? statsLookup[searchName];
      }
      }

      buildStats ??= WeaponStats(
        ttk1: "-", range1: "-", adsSpeed: "-", bulletVelocity: "-", 
        shotsToKill: "-", ttk2: "-", range2: "-", hitscanRange: "-"
      );

      String? archetype = lookup[combinedSearch] 
               ?? lookup[searchName] 
               ?? lookup[baseName.toUpperCase()];

      archetype ??= _legacyArchetypes[baseName.toUpperCase()];

      if (archetype == null) {
        final upperBase = baseName.toUpperCase();
        if (upperBase.contains("MAGNUM")) archetype = "PISTOL";
        else if (upperBase.contains("AK-47")) archetype = "AR";
        else archetype = "SPECIAL";
      }

      buildStats.archetype = archetype;

      bool isWarzoneType = (modeKey == "Warzone" || modeKey == "Rebirth" || modeKey == "Warzone Prestige");
      bool isSpecialType = (modeKey == "Special");

      if ((isWarzoneType || isSpecialType) && buildStats.ttk1 != "-") {
        buildStats.combatRating = calculateCombatRatingStatic(buildStats, archetype, isAkimboBuild);
      }
      
      if (alternativeStats != null) {
        alternativeStats.archetype = archetype;
        if ((isWarzoneType || isSpecialType) && alternativeStats.ttk1 != "-") {
          alternativeStats.combatRating = calculateCombatRatingStatic(alternativeStats, archetype, isAkimboBuild);
        }
      }

      if (!grouped.containsKey(baseName)) {
        grouped[baseName] = Weapon(
          name: baseName, 
          imageUrl: weaponImageUrl,
          gameLogoUrl: imgData['game_image'] ?? "", 
          builds: {}
        );
      }

      grouped[baseName]!.builds.putIfAbsent(modeKey, () => []).add(WeaponBuild(
        category: modeKey,
        attachments: List.from(cleanAttachments),
        starredAttachments: List.from(starredAttachments),
        buildCodes: detectedCodes.isNotEmpty ? detectedCodes.toList() : [item['build_code']?.toString() ?? ""].where((c) => c.isNotEmpty).toList(),
        modName: modName,
        stats: buildStats,
        alternativeStats: alternativeStats,
        specialtyValue: specialtyBoxValue,
      ));
    }
  }

  return grouped.values.toList()
    .where((weapon) {
      final name = weapon.name.toUpperCase();
      return !name.contains("MX GUARDIAN - FULL AUTO") && !name.contains("MX GUARDIAN - SEMI-AUTO");
    })
    .toList()
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
}

CombatRating? calculateCombatRatingStatic(WeaponStats stats, String? archetype, bool isAkimbo) {
  try {
    double cleanStat(String? value) {
      if (value == null || value.isEmpty || value.toLowerCase() == "null" || value == "-") return 0.0;
      String cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }

    double cleanStk(String? value) {
      if (value == null || value.isEmpty || value.toLowerCase() == "null" || value == "-") return 8.0;
      String firstPart = value.split('-')[0].split(' ')[0].trim();
      String cleaned = firstPart.replaceAll(RegExp(r'[^0-9.]'), '');
      double parsed = double.tryParse(cleaned) ?? 8.0;
      
      return parsed == 0 ? 8.0 : parsed;
    }

    double t1 = cleanStat(stats.ttk1);
    double ads = cleanStat(stats.adsSpeed);
    double vel = cleanStat(stats.bulletVelocity);
    double stkVal = cleanStk(stats.shotsToKill);
    if (stkVal == 0) stkVal = 8.0;

    String arch = (archetype ?? "AR").toUpperCase().trim();
    String dbCol = arch.toLowerCase().replaceAll(" ", "");
    if (dbCol.contains("battle")) dbCol = "battle";
    if (dbCol.contains("marksman")) dbCol = "marksman";
    if (dbCol.contains("pistol")) dbCol = "pistol";

    double combatScore = 0;

    if (arch == "SNIPER") {
      double baseAnchor;
      double adsWeight;

      if (vel >= 1300) {
        baseAnchor = 350; 
        adsWeight = 0.05;
      } else if (vel >= 1100) {
        baseAnchor = 430;
        adsWeight = 0.08;
      } else {
        baseAnchor = 380; 
        adsWeight = 0.15;
      }

      combatScore = baseAnchor + (ads * adsWeight);

    } else {
      final Map<String, Map<String, double>> hardcodedFallbacks = {
        "ar": {"min": 588.0, "max": 816.0},
        "smg": {"min": 520.0, "max": 680.0},
        "lmg": {"min": 511.0, "max": 804.0},
        "marksman": {"min": 671.0, "max": 1353.0},
        "battle": {"min": 480.0, "max": 800.0},
        "pistol": {"min": 460.0, "max": 1049.0},
      };

      var limits = minMaxAnchors?[dbCol] ?? hardcodedFallbacks[dbCol] ?? {"min": 500.0, "max": 1000.0};
      
      double minLim = double.tryParse(limits['min'].toString()) ?? 500.0;
      double maxLim = double.tryParse(limits['max'].toString()) ?? 1000.0;

      if (maxLim <= minLim) maxLim = minLim + 1.0;

      double relTtk = ((t1 - minLim) / (maxLim - minLim)) * 100;
      double forgiveness = (t1 / stkVal) / 5;
      double weightCalc = (relTtk * 0.7) + (forgiveness * 0.3);
      double multiplier = (dbCol == "pistol") ? 5.5 : 4.0;

      combatScore = (weightCalc * multiplier) + 300;
    }

    if (combatScore < 450) {
      return CombatRating("S", "Top tier pick for its class. Reliable and hard hitting.");
    } else if (combatScore < 580) {
      return CombatRating("A", "Competitive choice, but not strong enough for S tier.");
    } else if (combatScore < 700) {
      return CombatRating("B", "Usable, but will feel noticeably weaker than other picks.");
    } else {
      return CombatRating("C", "Vastly outclassed. Have steady aim if you dare try.");
    }
  } catch (e) {
    debugPrint("Combat Rating Calculation Error: $e");
    return null;
  }
}

class _InternalAnimatedBorder extends StatelessWidget {
  final List<Color> colors;
  final Widget child;
  final bool useRotation;
  final double borderRadius;
  final double strokeWidth;

  const _InternalAnimatedBorder({
    super.key, 
    required this.colors, 
    required this.child, 
    this.useRotation = false,
    this.borderRadius = 12.0,
    this.strokeWidth = 2.5,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ValueListenableBuilder<double>(
        valueListenable: masterBorderNotifier,
        child: child, 
        builder: (context, animValue, staticChild) {
          return CustomPaint(
            painter: SweepBorderPainter(
              colors: colors,
              animationValue: animValue, 
              strokeWidth: strokeWidth,
              borderRadius: borderRadius,
              useRotation: useRotation,
            ),
            child: staticChild, 
          );
        },
      ),
    );
  }
}

class SweepBorderPainter extends CustomPainter {
  final List<Color> colors;
  final double animationValue;
  final double strokeWidth;
  final double borderRadius;
  final bool useRotation;

  SweepBorderPainter({
    required this.colors,
    required this.animationValue,
    required this.borderRadius,
    this.strokeWidth = 2.0,
    this.useRotation = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    if (useRotation) {
      paint.shader = SweepGradient(
        center: Alignment.center,
        transform: GradientRotation(animationValue * 2 * math.pi),
        colors: [...colors, colors.first],
      ).createShader(rect);

    } else {

      final double xOffset = (animationValue * 2.0) - 1.0; 
      paint.shader = LinearGradient(
        begin: Alignment(xOffset - 1.0, -0.5), 
        end: Alignment(xOffset + 1.0, 0.5),
        colors: colors,
        tileMode: TileMode.repeated,
      ).createShader(rect);
    }

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(SweepBorderPainter oldDelegate) => 
      oldDelegate.animationValue != animationValue || 
      oldDelegate.borderRadius != borderRadius; 
}

class ArmoryOnboarding extends StatefulWidget {
  final ThemeController themeController;
  final VoidCallback onComplete;
  final bool isReplay;

  const ArmoryOnboarding({
    super.key, 
    required this.themeController, 
    required this.onComplete,
    this.isReplay = false,
  });

  @override
  State<ArmoryOnboarding> createState() => _ArmoryOnboardingState();
}

class _ArmoryOnboardingState extends State<ArmoryOnboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  precacheImage(
    const NetworkImage('https://res.cloudinary.com/dctlpj7fg/image/upload/v1771371000/f03dc6e1fcf5539b14a839785426f924_1_vcv2er.jpg'),
    context,
  );

  for (var slide in _slides) {
    final List<String> images = List<String>.from(slide['images']);
    for (var path in images) {
      if (path.startsWith('http')) {
        precacheImage(NetworkImage(path), context);
      } else {
        precacheImage(AssetImage(path), context);
      }
    }
  }
}

  final List<Map<String, dynamic>> _slides = [
    {
      "title": "WELCOME TO THE ARMORY",
      "desc": "THE NEXT GENERATION OF THE ARMORY IS HERE. COME ON IN, IT'S GOOD TO HAVE YOU. LET'S GET YOU UP TO SPEED ON HOW WE DO IT AROUND HERE.",
      "images": ["assets/images/ios.png"]
    },
    {
      "title": "HOME SCREEN",
      "desc": "SEARCH WEAPON NAMES, CLASS TYPES OR EVEN A GAME TO SEE ALL OF ITS WEAPONS! UTILIZE THE FILTER BUTTON TO SORT JUST HOW YOU WANT. DON'T WANT TO SEARCH OR SCROLL EVERYTIME TO GET YOUR FAVOURITES? GO AHEAD AND FAVOURITE THEM SO THEY APPEAR ON TOP!",
      "images": ["assets/images/1.jpg", "assets/images/2.jpg"]
    },
    {
      "title": "SETTINGS DRAWER",
      "desc": "ACCESS MODULES, LOG IN TO ACCESS PREMIUM BENEFITS, READ PATCH NOTES, AND MORE. NEED A REFRESHER? COME BACK HERE WITH THE INTRO SCREEN BUTTON IN CASE YOU EVER GET LOST.",
      "images": ["assets/images/3.jpg"]
    },
    {
      "title": "MODULE - META PICKS",
      "desc": "STAY ON TOP OF YOUR GAME AT ALL TIMES. NEVER AGAIN WILL YOU WONDER WHAT THE BEST PICKS ARE, OR BE CONFUSED WHAT'S WORTH USING ANYMORE FROM OLDER TITLES. ONLY THE BEST MAKE IT ON THIS LIST, AND IT'S ALWAYS UP TO DATE.",
      "images": ["assets/images/5.jpg", "assets/images/6.jpg"]
    },
    {
      "title": "MODULE - RANDOMIZER",
      "desc": "ADD SOME CHAOS TO GAME NIGHT. GENERATE UP TO 10 WEAPONS AT A TIME, UTILIZE THE EXCLUSION ZONE TO BLOCK ENTIRE GAMES WHEN PICKING WEAPONS, LOCK YOUR CHOICE IN SO YOU ONLY GET RESULTS FOR THE WEAPON YOU WANT, AND MORE.",
      "images": ["assets/images/4.jpg"]
    },
    {
      "title": "MODULE - COMBAT DELTA / AEGIS EYE",
      "desc": "THE ULTIMATE COMPARISON TOOL. DIRECTLY COMPARE WEAPONS TO SEE IF YOUR CONTROLLER WILL ENTER ORBIT DURING A FIGHT OR NOT (LOSING IS TOUGH, WE KNOW). TAP AND HOLD TO REMOVE YOUR PICKS IF YOU CHANGED YOUR MIND. SWIPE THE SCREEN TO ACCESS AEGIS EYE, A GLOBAL STAT TRACKER SORTED HOW YOU WANT. HIGHEST VELOCITY? FASTEST TTK AT RANGE 1? YOU GOT IT. TAP THE STAT NUMBERS TO VIEW MORE DETAILS! DEFAULT STAT IS TTK CLOSE.",
      "images": ["assets/images/12.jpg", "assets/images/13.jpg"]
    },
    {
      "title": "THEMES",
      "desc": "MAKE ARMORY APP YOURS. WITH TONS OF THEMES AND EVEN MORE FONT CHOICES, WE TAKE CUSTOMIZATION VERY SERIOUSLY AROUND HERE. PREMIUM MEMBERS WILL HAVE ACCESS TO EXCLUSIVE THEMES THAT TAKE IT A STEP FURTHER.",
      "images": ["assets/images/7.jpg", "assets/images/8.jpg"]
    },
    {
      "title": "PREMIUM BENEFITS",
      "desc": "ON TOP OF EXCLUSIVE THEMES, YOU ALSO GET ACCESS TO THE ARMORY'S ADVANCED WEAPON STATS, A SYSTEM BUILT FOR THOSE THAT REQUIRE ABSOLUTE PRECISION WHEN IT COMES TO MAKING EVERY MILLISECOND IN AN ENGAGEMENT MATTER. HOW FAST WILL THIS GUN DOWN AT 27 METERS? CAN THIS SNIPER ONE SHOT? NOW YOU KNOW.",
      "images": [
        "assets/images/10.jpg", "assets/images/11.jpg",
      ]
    },
    {
      "title": "LOGGING IN",
      "desc": "IF YOU'RE A PREMIUM MEMBER WITH ARMORY BOT, YOU'RE IN LUCK BECAUSE ARMORY APP IS MOVING IN NEXT DOOR AND IS VERY EXCITED TO MINGLE. LOG IN WITH YOUR DISCORD ID AND SECRET PIN TO GET ALL YOUR BENEFITS SYNCED UP ACROSS BOTH SERVICES. HOW DO YOU GET YOUR PIN? HEAD ON OVER TO ARMORY BOT AND USE THE /armorypin COMMAND AND IT WILL GET YOU SORTED.",
      "images": [
        "assets/images/9.jpg", "assets/images/pin.jpg"
      ]
    },
    {
      "title": "TIME TO DEPLOY",
      "desc": "WELL DONE, YOU'VE PASSED INSPECTION. LET'S GET YOU KITTED UP AND READY TO HIT THE FIELD SPRINTING. STAY FROSTY, YOUR SQUAD DEPENDS ON IT.",
      "images": ["assets/images/ios.png"]
    },
  ];

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_onboarding', false);
    widget.onComplete();
  }

static const Color armoryBlue = Color.fromRGBO(55, 87, 193, 1);

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            'https://res.cloudinary.com/dctlpj7fg/image/upload/v1771371000/f03dc6e1fcf5539b14a839785426f924_1_vcv2er.jpg',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.85),
            colorBlendMode: BlendMode.darken,
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (v) => setState(() => _currentPage = v),
                  itemCount: _slides.length,
                  itemBuilder: (context, i) => _buildSlide(_slides[i]),
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildSlide(Map<String, dynamic> slide) {
  final List<String> images = List<String>.from(slide['images']);
  final bool isGrid = images.length == 4;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0),
    child: Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: isGrid 
                  ? _buildImageGrid(images, constraints) 
                  : _buildImageRow(images, constraints),
              );
            },
          ),
        ),
        
        const SizedBox(height: 24),

        ArmoryText(
          slide['title']!,
          themeController: widget.themeController,
          baseFontSize: 22,
          baseStrokeWidth: 3.0,
          color: armoryBlue,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ArmoryText(
            slide['desc']!,
            themeController: widget.themeController,
            baseFontSize: 11,
            baseStrokeWidth: 1.2,
            color: Colors.white.withOpacity(0.9),
            textAlign: TextAlign.center,
            allowWrap: true,
          ),
        ),
      ],
    ),
  );
}

Widget _buildImageGrid(List<String> images, BoxConstraints constraints) {
  const double manualWidth = 320.0;
  const double manualHeight = 520.0;

  return Center(
    child: FittedBox(
      fit: BoxFit.contain,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: manualWidth,
          height: manualHeight,
        ),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: (manualWidth) / (manualHeight), 
          children: images.map((url) => _imageWrapper(url)).toList(),
        ),
      ),
    ),
  );
}

Widget _buildImageRow(List<String> images, BoxConstraints constraints) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: images.map((url) => Flexible(
      child: _imageWrapper(url, isRow: true)
    )).toList(),
  );
}

Widget _imageWrapper(String url, {bool isRow = false}) {
  bool isNetwork = url.startsWith('http');

  return Container(
    margin: EdgeInsets.symmetric(horizontal: isRow ? 8 : 0),
    decoration: BoxDecoration(
      border: Border.all(color: armoryBlue, width: 2),
      boxShadow: [
        BoxShadow(color: armoryBlue.withOpacity(0.3), blurRadius: 10)
      ],
    ),
    child: ClipRRect(
      child: isNetwork 
        ? Image.network(
            url,
            fit: BoxFit.contain, 
            loadingBuilder: (context, child, progress) => 
              progress == null ? child : const Center(child: CircularProgressIndicator(color: armoryBlue)),
          )
        : Image.asset(
            url,
            fit: BoxFit.contain,
          ),
    ),
  );
}

Widget _buildFooter() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    child: Row( 
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _currentPage == 0 ? null : () {
            HapticFeedback.lightImpact();
            _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
          },
          child: ArmoryText(
            "PREVIOUS", 
            themeController: widget.themeController, 
            baseFontSize: 11, 
            baseStrokeWidth: 2.0,
            color: _currentPage == 0 ? Colors.white12 : Colors.white60,
          ),
        ),

        Row(
          children: List.generate(_slides.length, (index) {
            bool isActive = _currentPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 4,
              width: isActive ? 16 : 4,
              decoration: BoxDecoration(
                color: isActive ? armoryBlue : armoryBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
        
        TextButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            if (_currentPage == _slides.length - 1) {
              _finishOnboarding();
            } else {
              _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
            }
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(armoryBlue),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
            overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.2)),
          ),
          child: ArmoryText(
            _currentPage == _slides.length - 1 ? "FINISH" : "NEXT",
            themeController: widget.themeController,
            baseFontSize: 11,
            baseStrokeWidth: 0,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}
}

class ResetSignal extends ChangeNotifier {
  void trigger() => notifyListeners();
}

class RankedPlayPage extends StatefulWidget {
  final ThemeController themeController;
  final List<Weapon> allWeapons;

  const RankedPlayPage({
    super.key,
    required this.themeController,
    required this.allWeapons,
  });

  @override
  State<RankedPlayPage> createState() => _RankedPlayPageState();
}

class _RankedPlayPageState extends State<RankedPlayPage> {
  List<Weapon> _rankedWeapons = [];
  bool _isLoading = true;
  final PageController _pageController = PageController(viewportFraction: 0.75);
  final ResetSignal _resetSignal = ResetSignal();
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _loadIndependentRankedData();
    _pageController.addListener(() {
      if (mounted) setState(() => _currentPage = _pageController.page ?? 0.0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadIndependentRankedData() async {
  try {
    final String rankedPath = 'assets/Ranked.json';
    final String namesPath = 'assets/Weapon_Names.json';

    final String rankedResponse = await loadHotfixedJson(rankedPath);
    final String namesResponse = await loadHotfixedJson(namesPath);
    
    final Map<String, dynamic> rankedDecoded = json.decode(rankedResponse);
    final Map<String, dynamic> namesDecoded = json.decode(namesResponse);
    
    final List<dynamic> rankedData = rankedDecoded['Ranked'] ?? [];
    final List<dynamic> masterNamesList = namesDecoded['Weapon_Names'] ?? [];

    List<Weapon> tempWeapons = rankedData.where((item) {
      final String availability = (item['availability'] ?? "YES").toString().toUpperCase();
      return availability == "YES";
    }).map((item) {
      // Use the translated name if available, or fallback to rawName
      final String rawName = (item['weapon_name'] ?? "UNKNOWN").toString().trim();
      
      // Perform translation for the weapon name dynamically
      final aegisArc = Provider.of<AegisArc>(context, listen: false);
      final String displayName = aegisArc.translate(rawName).translatedText;

      final String searchKey = (item['english_name'] ?? rawName)
          .toString()
          .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
          .toUpperCase();
      
      String? foundImageUrl;
      String? foundLogoUrl;

        try {
          final matchingWeapon = widget.allWeapons.firstWhere((w) {
            final String masterKey = w.name.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
            return masterKey == searchKey || masterKey.contains(searchKey) || searchKey.contains(masterKey);
          });
          foundImageUrl = matchingWeapon.imageUrl;
          foundLogoUrl = matchingWeapon.gameLogoUrl;
        } catch (_) {

          final rawMatch = masterNamesList.firstWhere((n) {
            final String nName = (n['weapon_name'] ?? "").toString().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
            return nName == searchKey;
          }, orElse: () => null);

          if (rawMatch != null) {
            foundImageUrl = rawMatch['weapon_image']?.toString() ?? "";
            foundLogoUrl = rawMatch['game_image']?.toString() ?? "";
          }
        }

        if (foundImageUrl != null && foundImageUrl.isNotEmpty) {
           foundImageUrl = foundImageUrl.replaceAll(RegExp(r'\.[a-zA-Z0-9]+(?=\?|$)'), '.png');
           foundImageUrl = Uri.encodeFull(foundImageUrl);
        }

        List<String> rawAttachments = [
          if (item['attach_1'] != null && item['attach_1'].toString().toLowerCase() != "null") item['attach_1'].toString(),
          if (item['attach_2'] != null && item['attach_2'].toString().toLowerCase() != "null") item['attach_2'].toString(),
          if (item['attach_3'] != null && item['attach_3'].toString().toLowerCase() != "null") item['attach_3'].toString(),
          if (item['attach_4'] != null && item['attach_4'].toString().toLowerCase() != "null") item['attach_4'].toString(),
          if (item['attach_5'] != null && item['attach_5'].toString().toLowerCase() != "null") item['attach_5'].toString(),
        ].where((a) => a.trim().isNotEmpty).toList();

        return Weapon(
          name: rawName.toUpperCase(),
          rank: item['id'] is int ? item['id'] : int.tryParse(item['id'].toString()) ?? 0,
          imageUrl: foundImageUrl ?? "", 
          gameLogoUrl: foundLogoUrl ?? "",
          builds: {
            "Ranked": [
              WeaponBuild(
                category: "Ranked",
                attachments: rawAttachments,
                starredAttachments: [],
                buildCodes: [item['build_code']?.toString() ?? ""].where((c) => c.isNotEmpty).toList(),
              )
            ],
          },
        );
      }).toList();

      tempWeapons.sort((a, b) => (a.rank ?? 99).compareTo(b.rank ?? 99));

      if (mounted) {
        setState(() {
          _rankedWeapons = tempWeapons;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Ranked Initialization Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = widget.themeController.activeTheme;
    final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
    final Color accent = widget.themeController.activeAccentColor;
    final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;

    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        title: ArmoryText(
          "RANKED PROTOCOL",
          themeController: widget.themeController,
          baseFontSize: 16,
          baseStrokeWidth: 2.5,
          color: isNeon ? coreColor : Colors.white,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded, 
            color: isNeon ? coreColor : Colors.white, 
            size: 16
          ),
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            color: isNeon 
                ? coreColor 
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              "https://res.cloudinary.com/dctlpj7fg/image/upload/v1771658833/d14bad026efc157ee1dd79cc8d0cd7b5_ierpku.jpg",
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.4),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          
          _isLoading 
              ? Center(
                  child: CircularProgressIndicator(
                    color: isNeon ? coreColor : Colors.amberAccent
                  )
                )
              : Column(
                  children: [
                    const SizedBox(height: kToolbarHeight + 40),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _rankedWeapons.length,
                        onPageChanged: (_) => _resetSignal.trigger(),
                        itemBuilder: (context, index) {
                          double delta = (index - _currentPage).abs();
                          double scale = (1 - (delta * 0.15)).clamp(0.85, 1.0);

                          return Transform.scale(
                            scale: scale,
                            child: RankedCard(
                              weapon: _rankedWeapons[index],
                              themeController: widget.themeController,
                              resetSignal: _resetSignal,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
        ],
      ),
    );
  }
}

class RankedCard extends StatefulWidget {
  final Weapon weapon;
  final ThemeController themeController;
  final ResetSignal resetSignal;

  const RankedCard({
    super.key,
    required this.weapon,
    required this.themeController,
    required this.resetSignal,
  });

  @override
  State<RankedCard> createState() => _RankedCardState();
}

class _RankedCardState extends State<RankedCard> {
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    widget.resetSignal.addListener(_handleReset);
  }

  @override
  void dispose() {
    widget.resetSignal.removeListener(_handleReset);
    super.dispose();
  }

  void _handleReset() {
    if (mounted && _isFlipped) {
      setState(() => _isFlipped = false);
    }
  }

  void _toggleFlip() {
    HapticFeedback.mediumImpact();
    setState(() => _isFlipped = !_isFlipped);
  }

  @override
  Widget build(BuildContext context) {
    final primaryThemeColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: _toggleFlip,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        tween: Tween<double>(begin: 0, end: _isFlipped ? pi : 0),
        builder: (context, angle, child) {
          final isBack = angle >= pi / 2;
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) 
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isBack
                ? Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildBack(primaryThemeColor),
                  )
                : _buildFront(primaryThemeColor),
          );
        },
      ),
    );
  }

Widget _buildFront(Color primary) {
  final activeTheme = widget.themeController.activeTheme;
  final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
  final bool isHolo = activeTheme.isHolographic;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
  
  final Color accent = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;

  const double outerRadius = 28.0;
  final double borderWidth = (isNeon || isHolo || isAnemone) ? 3.0 : 1.5;
  final double innerRadius = 28.0;

  Widget cardContent = Container(
    decoration: BoxDecoration(
      color: isNeon ? Colors.black : Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(innerRadius),
      border: (!isHolo && !isAnemone) 
          ? Border.all(
              color: isNeon ? coreColor : primary.withOpacity(0.6),
              width: borderWidth,
            )
          : null,
      boxShadow: isNeon ? [
        BoxShadow(color: accent.withOpacity(0.8), blurRadius: 4, spreadRadius: 0.5),
        BoxShadow(color: accent.withOpacity(0.2), blurRadius: 15, spreadRadius: 1),
      ] : null,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(innerRadius),
      child: Column(
        children: [
          const Spacer(), 
          _SmartImage(
            url: widget.weapon.imageUrl,
            width: 250,
          ),
          const SizedBox(height: 20),
          _buildBadge(primary),
          const SizedBox(height: 15),
          ArmoryText(
            widget.weapon.name.toUpperCase(),
            themeController: widget.themeController,
            baseFontSize: 22,
            baseStrokeWidth: (isNeon || isHolo) ? 4.0 : 3.0,
            color: Colors.white,
          ),
          ArmoryText(
            "RANKED LOADOUT",
            themeController: widget.themeController,
            baseFontSize: 9,
            baseStrokeWidth: 1.8,
            color: Colors.amberAccent,
            letterSpacing: 2.0,
          ),
          const Spacer(), 
          ArmoryText(
            "TAP TO VIEW ATTACHMENTS",
            themeController: widget.themeController,
            baseFontSize: 8,
            baseStrokeWidth: 1.5,
            color: Colors.white70,
          ),
          const SizedBox(height: 25), 
        ],
      ),
    ),
  );

  Widget finalCard;
  if (isHolo) {
    finalCard = _InternalAnimatedBorder(
      colors: activeTheme.refractionColors,
      useRotation: true,
      borderRadius: outerRadius,
      strokeWidth: borderWidth,
      child: cardContent,
    );
  } else if (isAnemone) {
    finalCard = ArmoryGradientBorder(
      gradientColors: activeTheme.borderGradient,
      strokeWidth: borderWidth,
      borderRadius: outerRadius,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      child: cardContent,
    );
  } else {
    finalCard = cardContent;
  }

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
    child: finalCard,
  );
}

 Widget _buildBack(Color primary) {
  final activeTheme = widget.themeController.activeTheme;
  final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
  final bool isHolo = activeTheme.isHolographic;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
  final locale = Provider.of<AegisArc>(context);
  
  final Color accent = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;

  const double outerRadius = 28.0;
  const double innerRadius = 28.0;
  final double borderWidth = (isNeon || isHolo || isAnemone) ? 3.0 : 1.5;

  final builds = widget.weapon.builds["Ranked"];
  final build = (builds != null && builds.isNotEmpty) ? builds.first : null;
  final List<String> attachments = build?.attachments ?? [];
  final String buildCode = (build?.buildCodes != null && build!.buildCodes.isNotEmpty) 
      ? build.buildCodes.first 
      : "";

  Widget cardContent = Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: isNeon ? Colors.black : Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(innerRadius),
      border: (!isHolo && !isAnemone) 
          ? Border.all(
              color: isNeon ? coreColor : primary.withOpacity(0.5),
              width: borderWidth,
            )
          : null,
      boxShadow: isNeon ? [
        BoxShadow(color: accent.withOpacity(0.8), blurRadius: 4, spreadRadius: 0.5),
        BoxShadow(color: accent.withOpacity(0.2), blurRadius: 15, spreadRadius: 1),
      ] : null,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(innerRadius),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.fromLTRB(25, 25, 25, 20),
        child: Column(
          children: [
            ArmoryText(
              "ATTACHMENTS",
              themeController: widget.themeController,
              baseFontSize: 12,
              baseStrokeWidth: 2.0,
              color: isNeon ? coreColor : coreColor,
            ),
            const Divider(color: Colors.white10, height: 30, thickness: 0.5),
            
            Expanded(
              child: attachments.isEmpty 
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ArmoryText(
                        "NO ATTACHMENTS AVAILABLE",
                        themeController: widget.themeController,
                        baseFontSize: 10,
                        color: Colors.white38,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 5), 
                    itemCount: attachments.length,
                    itemBuilder: (context, i) {
                      final rawAttach = attachments[i];
                      final translatedAttach = locale.translate(rawAttach).translatedText;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9), 
                        child: Row(
                          children: [
                            Container(
                              width: 2, 
                              height: 16, 
                              color: isNeon ? coreColor : primary
                            ),
                            const SizedBox(width: 14),
                            Expanded( 
                              child: ArmoryText(
                                // 3. Display the translated text
                                translatedAttach.toUpperCase(),
                                themeController: widget.themeController,
                                baseFontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            ),
            
            if (buildCode.isNotEmpty) ...[
                 const Divider(color: Colors.white10, height: 20),
                 ArmoryText(
                   "BUILD CODE", 
                   themeController: widget.themeController, 
                   baseFontSize: 9, 
                   color: isNeon ? coreColor : coreColor
                 ),
                 const SizedBox(height: 5),
                 SelectableText(
                   buildCode, 
                   style: const TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 1.2)
                 ),
            ],
            const SizedBox(height: 10),
            ArmoryText(
              "TAP TO RETURN",
              themeController: widget.themeController,
              baseFontSize: 8,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    ),
  );

  Widget finalCard;
  if (isHolo) {
    finalCard = _InternalAnimatedBorder(
      colors: activeTheme.refractionColors,
      useRotation: true,
      borderRadius: outerRadius,
      strokeWidth: borderWidth,
      child: cardContent,
    );
  } else if (isAnemone) {
    finalCard = ArmoryGradientBorder(
      gradientColors: activeTheme.borderGradient,
      strokeWidth: borderWidth,
      borderRadius: outerRadius,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      child: cardContent,
    );
  } else {
    finalCard = cardContent;
  }

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
    child: finalCard,
  );
}

Widget _buildBadge(Color primary) {
  final activeTheme = widget.themeController.activeTheme;
  final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
  final bool isSpecialty = isNeon || activeTheme.isHolographic || activeTheme.category == ThemeCategory.anemone;
  
  final Color accent = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;
  final Color effectiveBadgeColor = isNeon ? coreColor : primary;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: isNeon ? Colors.black : Colors.amber,
      borderRadius: BorderRadius.circular(4),
      border: isNeon ? Border.all(color: effectiveBadgeColor, width: 1.5) : null,
      boxShadow: isNeon ? [
        BoxShadow(
          color: accent.withOpacity(0.5),
          blurRadius: 6, 
          spreadRadius: 0.5
        ),
      ] : null,
    ),
    child: ArmoryText(
      "RANKED",
      themeController: widget.themeController,
      baseFontSize: 11,
      baseStrokeWidth: isNeon ? 2.0 : 0,
      color: isNeon ? effectiveBadgeColor : Colors.black,
      overrideStrokeColor: isNeon ? Colors.black : Colors.black,
    ),
  );
}
}

class TacticalModuleButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final ThemeController themeController;
  final Color? customColor;
  final bool isPremiumUser;

  const TacticalModuleButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.themeController,
    this.isPremiumUser = false,
    this.customColor,
  });

  @override
  State<TacticalModuleButton> createState() => _TacticalModuleButtonState();
}

class _TacticalModuleButtonState extends State<TacticalModuleButton> {
  bool _isPressed = false;

  Widget _buildTacticalIcon(IconData icon, Color color, {double strokeSize = 1.0}) {
  return Text(
    String.fromCharCode(icon.codePoint),
    style: TextStyle(
      inherit: false,
      color: color,
      fontSize: 30,
      fontFamily: icon.fontFamily,
      package: icon.fontPackage,
      shadows: [
        Shadow(
          offset: Offset(-strokeSize, -strokeSize), 
          color: Colors.black, 
          blurRadius: 1
        ),
        Shadow(
          offset: Offset(strokeSize, -strokeSize), 
          color: Colors.black, 
          blurRadius: 1
        ),
        Shadow(
          offset: Offset(-strokeSize, strokeSize), 
          color: Colors.black, 
          blurRadius: 1
        ),
        Shadow(
          offset: Offset(strokeSize, strokeSize), 
          color: Colors.black, 
          blurRadius: 1
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final activeTheme = widget.themeController.activeTheme;
    final theme = Theme.of(context);
    final bool isHolographic = activeTheme.isHolographic;
    final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
    final bool isCustom = activeTheme.id == 'neon_custom';
    final bool canShowEffects = widget.isPremiumUser;

    final Color accentColor = widget.themeController.activeAccentColor;
    final Color baseColor = widget.customColor ?? (isCustom && canShowEffects ? accentColor : theme.colorScheme.primary);
    final Color coreColor = Color.lerp(baseColor, Colors.white, 0.35)!;

    double scale = _isPressed ? 0.96 : 1.0;
    double glowOpacity = _isPressed ? 0.6 : 0.3;
    double blurRadius = _isPressed ? 20.0 : 15.0;

    Widget boxContent = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(24),
        border: (canShowEffects && (isHolographic || isAnemone || isCustom))
            ? null
            : Border.all(color: baseColor, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTacticalIcon(
            widget.icon, 
            (isCustom && canShowEffects) ? coreColor : baseColor, strokeSize: 0.8
          ),
          const SizedBox(width: 15),
          Flexible(
            child: ArmoryText(
              widget.label.toUpperCase(),
              themeController: widget.themeController,
              baseFontSize: 12,
              baseStrokeWidth: 2.5,
              color: Colors.white,
              overrideStrokeColor: (isCustom && canShowEffects) ? baseColor.withOpacity(0.4) : Colors.black,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );

    Widget themedButton;
    if (isHolographic && canShowEffects) {
      themedButton = _InternalAnimatedBorder(colors: activeTheme.refractionColors, borderRadius: 24, strokeWidth: 3.5, child: boxContent);
    } else if (isAnemone && canShowEffects) {
      themedButton = ArmoryGradientBorder(gradientColors: activeTheme.borderGradient, borderRadius: 24, strokeWidth: 3.5, child: boxContent);
    } else if (isCustom && canShowEffects) {
      themedButton = AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: coreColor, width: _isPressed ? 2.5 : 2.0),
          boxShadow: [
            BoxShadow(color: baseColor.withOpacity(0.8), blurRadius: 1, spreadRadius: 0.5),
            BoxShadow(color: baseColor.withOpacity(glowOpacity), blurRadius: blurRadius, spreadRadius: 2),
          ],
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(24), child: boxContent),
      );
    } else {
      themedButton = boxContent;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        child: themedButton,
      ),
    );
  }
}

class AppRestartWrapper extends StatefulWidget {
  final Widget child;
  const AppRestartWrapper({super.key, required this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<AppRestartWrapperState>()?.restart();
  }

  @override
  AppRestartWrapperState createState() => AppRestartWrapperState();
}

class AppRestartWrapperState extends State<AppRestartWrapper> {
  Key key = UniqueKey();

  void restart() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

class ComparisonScreen extends StatefulWidget {
  final ThemeController themeController;
  final List<Weapon> allWeapons;

  const ComparisonScreen({
    super.key, 
    required this.themeController, 
    required this.allWeapons
  });

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  Weapon? _weaponA;
  Weapon? _weaponB;
  
  String? _selectedBuildA;
  String? _selectedBuildB;

  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final Map<String, bool> _lowerIsBetter = {
    'ads_speed': true,
    'sprint_to_fire': true,
    'reload_time': true,
    'ttk': true,
    'ttk_2': true,
  };

String? _getDifferential(String? valA, String? valB, bool isSlotA, bool lowerIsBetter) {
  if (valA == null || valB == null || valA == "---" || valB == "---") return null;

  List<double> parseRange(String v) {
    return v.split('-').map((part) {
      return double.tryParse(part.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    }).toList();
  }

  final rangeA = parseRange(valA);
  final rangeB = parseRange(valB);

  if (rangeA.isEmpty || rangeB.isEmpty) return null;

  List<double> percentages = [];

  double closeA = rangeA[0];
  double closeB = rangeB[0];
  if (closeA > 0 && closeB > 0 && closeA != closeB) {
     bool aWins = lowerIsBetter ? (closeA < closeB) : (closeA > closeB);
     if (isSlotA == aWins) {
       double big = closeA > closeB ? closeA : closeB;
       double small = closeA > closeB ? closeB : closeA;
       percentages.add(((big - small) / small) * 100);
     }
  }

  if (rangeA.length > 1 && rangeB.length > 1) {
    double farA = rangeA[1];
    double farB = rangeB[1];
    if (farA > 0 && farB > 0 && farA != farB) {
      bool aWins = lowerIsBetter ? (farA < farB) : (farA > farB);
      if (isSlotA == aWins) {
        double big = farA > farB ? farA : farB;
        double small = farA > farB ? farB : farA;
        percentages.add(((big - small) / small) * 100);
      }
    }
  }

  if (percentages.isEmpty) return null;
  double bestWin = percentages.reduce((a, b) => a > b ? a : b);

  return bestWin > 1 ? "+${bestWin.toStringAsFixed(0)}%" : null;
}

List<Weapon> _getCompatibleWeapons(List<Weapon> all, Set<String> validNames) {
  return all.where((w) {
    final name = w.name.toLowerCase().trim();
    return validNames.contains(name) || 
           validNames.any((n) => n.startsWith(name));
  }).where((w) {
    final n = w.name.toUpperCase();
    return n != "GRAV" && n != "M13";
  }).toList();
}

Set<String> _cachedValidNames = {};

@override
void initState() {
  super.initState();
  _initCompatibilityData();
}

Future<void> _initCompatibilityData() async {
  final String response = await loadHotfixedJson('assets/Premium_Stats.json');
  final Map<String, dynamic> data = json.decode(response);
  final List<dynamic> premiumList = data['Premium_Stats'];
  
  setState(() {
    _cachedValidNames = premiumList
        .map((item) => item['weapon_name'].toString().toLowerCase().trim())
        .toSet();
  });
}

WeaponStats? _getWeaponStats(Weapon? weapon, String? selectedBuild) {
  if (weapon == null || selectedBuild == null) return null;

  final String targetName = selectedBuild.toUpperCase().trim();

  for (var category in weapon.builds.values) {
    for (var build in category) {
      if (build.modName?.toUpperCase().trim() == targetName) {
        if (build.stats != null) return build.stats;
      }
    }
  }

  if (weapon.builds.containsKey(selectedBuild)) {
    final list = weapon.builds[selectedBuild];
    if (list != null && list.isNotEmpty) return list.first.stats;
  }

  if (weapon.builds.containsKey('Warzone')) {
    return weapon.builds['Warzone']?.first.stats;
  }

  return null;
}

  Color _getComparisonColor(String? valA, String? valB, bool isSlotA, {bool lowerIsBetter = false}) {
    if (valA == null || valB == null || valA == "---" || valB == "---" || valA == "N/A" || valB == "N/A") {
      return Colors.white24;
    }
    double? d1 = double.tryParse(valA.replaceAll(RegExp(r'[^0-9.]'), ''));
    double? d2 = double.tryParse(valB.replaceAll(RegExp(r'[^0-9.]'), ''));
    if (d1 == null || d2 == null || d1 == d2) return Colors.white;
    bool aWins = lowerIsBetter ? (d1 < d2) : (d1 > d2);
    if (isSlotA) return aWins ? Colors.greenAccent : Colors.redAccent;
    return aWins ? Colors.redAccent : Colors.greenAccent;
  }

void _openWeaponSelector(String slot) async {
  _searchQuery = "";
  _searchController.clear();

  final String response = await loadHotfixedJson('assets/Premium_Stats.json');
  final Map<String, dynamic> data = json.decode(response);
  final List<dynamic> premiumList = data['Premium_Stats'];
  
  final Set<String> validNamesInJson = premiumList
      .map((item) => item['weapon_name'].toString().toLowerCase().trim())
      .toSet();

  if (!mounted) return;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        final activeTheme = widget.themeController.activeTheme;
        final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
        final bool isHolo = activeTheme.isHolographic;
        final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
        final accentColor = widget.themeController.activeAccentColor;
        final coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
        final activeFont = widget.themeController.activeFont;
        final aegisArc = Provider.of<AegisArc>(context);
        final Color primaryFaded = Color.alphaBlend(
        Theme.of(context).colorScheme.surface.withOpacity(0.2), 
        Colors.black
      );

        final filtered = widget.allWeapons.where((w) {
          final name = w.name.toLowerCase().trim();
          bool hasExactMatch = validNamesInJson.contains(name);
          bool isPrefixMatch = validNamesInJson.any((n) => n.startsWith(name));
          return hasExactMatch || isPrefixMatch;
        }).where((w) {
          final n = w.name.toUpperCase();
          return n != "GRAV" && n != "M13"; 
        }).where((w) => w.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList()
        ..sort((a, b) => a.name.compareTo(b.name));

        Widget modalBody = Container(
          decoration: BoxDecoration(
            color: isNeon ? Colors.black : Colors.black,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: (!isHolo && !isAnemone)
                ? Border(
                    top: BorderSide(
                      color: isNeon ? coreColor : accentColor.withOpacity(0.8),
                      width: 2.5,
                    ),
                  )
                : null,
            boxShadow: isNeon ? [
              BoxShadow(color: accentColor.withOpacity(0.8), blurRadius: 4, spreadRadius: 1),
              BoxShadow(color: accentColor.withOpacity(0.3), blurRadius: 20, spreadRadius: 2),
            ] : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(width: 35, height: 4, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 15),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _searchController,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (val) => setModalState(() => _searchQuery = val),
                  style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: activeFont),
                  decoration: InputDecoration(
                    hintText: aegisArc.translateStatic("SEARCH FOR WEAPON..."),
                    hintStyle: const TextStyle(color: Colors.white30, fontSize: 11),
                    prefixIcon: Icon(Icons.search, color: accentColor, size: 18),
                    filled: true,
                    fillColor: isNeon ? Colors.white.withOpacity(0.05) : Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8), 
                      borderSide: isNeon ? BorderSide(color: coreColor.withOpacity(0.2)) : BorderSide.none
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 15),

              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final w = filtered[index];
                    return GestureDetector(
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        final String response = await loadHotfixedJson('assets/Premium_Stats.json');
                        final Map<String, dynamic> data = json.decode(response);
                        final List<dynamic> premiumList = data['Premium_Stats'];
                        final String weaponNameLower = w.name.toLowerCase().trim();
                        final Set<String> validNamesInJson = premiumList.map((item) => item['weapon_name'].toString().toLowerCase().trim()).toSet();
                        bool hasBaseInJson = validNamesInJson.contains(weaponNameLower);
                        bool hasPrestigeInJson = validNamesInJson.any((n) => n.contains(weaponNameLower) && n.contains("prestige"));
                        bool hasSpecialVariantInJson = validNamesInJson.any((n) => n.startsWith(weaponNameLower) && n != weaponNameLower && !n.contains("prestige"));

                        final validBuilds = w.builds.keys.where((key) {
                          final k = key.toLowerCase();
                          bool isWzVariantInJson = validNamesInJson.any((n) => n.contains(weaponNameLower) && n.contains("(wz)"));
                          if (k.contains("warzone") || k.contains("(wz)")) return isWzVariantInJson || hasBaseInJson;
                          if (k.contains("prestige")) return hasPrestigeInJson;
                          if (k == "special" || k.contains("conversion") || k.contains(weaponNameLower)) {
                            if (hasSpecialVariantInJson) return true;
                            return !(hasBaseInJson || hasPrestigeInJson);
                          }
                          return false;
                        }).toList();

                        List<String> finalSelection = validBuilds;
                        if (finalSelection.isEmpty && (hasBaseInJson || hasPrestigeInJson || hasSpecialVariantInJson)) {
                          finalSelection = w.builds.entries.where((e) => e.value.any((b) => b.stats != null)).map((e) => e.key).toList();
                        }

                        if (finalSelection.length > 1) {
                          _showVariantDialog(context, w, finalSelection, slot);
                        } else if (finalSelection.isNotEmpty) {
                          _selectWeapon(w, finalSelection.first, slot);
                        } else {
                          _selectWeapon(w, w.builds.keys.contains('Warzone') ? 'Warzone' : w.builds.keys.first, slot);
                        }
                      },
                      child: Container(
                        width: 130,
                        margin: const EdgeInsets.only(right: 12, bottom: 12, top: 4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isNeon ? coreColor.withOpacity(0.6) : Colors.white10,
                            width: isNeon ? 1.5 : 1.0
                          ),
                          boxShadow: isNeon ? [
                            BoxShadow(color: accentColor.withOpacity(0.4), blurRadius: 4),
                          ] : [],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: isNeon ? coreColor.withOpacity(0.15) : Colors.white.withOpacity(0.05),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(11))
                              ),
                              child: ArmoryText(
                                w.name.toUpperCase(), 
                                themeController: widget.themeController,
                                baseFontSize: 8,
                                textAlign: TextAlign.center,
                                allowWrap: true,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(w.imageUrl, fit: BoxFit.contain),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );

        Widget finalModal;
        if (isHolo) {
          finalModal = _InternalAnimatedBorder(
            colors: activeTheme.refractionColors,
            useRotation: true,
            child: modalBody,
          );
        } else if (isAnemone) {
          finalModal = ArmoryGradientBorder(
            gradientColors: activeTheme.borderGradient,
            strokeWidth: 3,
            borderRadius: 12,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            child: modalBody,
          );
        } else {
          finalModal = modalBody;
        }

        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: finalModal,
        );
      }
    ),
  );
}

void _selectWeapon(Weapon? w, String? buildName, String slot) {
  if (Navigator.canPop(context) && w != null) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  String? finalBuildName = buildName;

  if (w != null && buildName != null) {
    final String bLower = buildName.toLowerCase();
    if (bLower == "special" || bLower.contains("conversion")) {
      final builds = w.builds[buildName];
      if (builds != null && builds.isNotEmpty) {
        final wzBuild = builds.firstWhere(
          (b) => b.modName != null && b.modName!.toUpperCase().contains("(WZ)"),
          orElse: () => builds.firstWhere(
            (b) => b.modName != null && b.modName!.toLowerCase() != w.name.toLowerCase(),
            orElse: () => builds.first,
          ),
        );

        if (wzBuild.modName != null) {
          finalBuildName = wzBuild.modName;
        }
      }
    }
  }

  setState(() {
    if (slot.toUpperCase() == 'A' || slot == '1') {
      _weaponA = w;
      _selectedBuildA = finalBuildName;
    } else {
      _weaponB = w;
      _selectedBuildB = finalBuildName;
    }
  });
  
  _searchController.clear();
  _searchQuery = "";
}

void _showVariantDialog(BuildContext context, Weapon w, List<String> buildNames, String slot) {
  final activeTheme = widget.themeController.activeTheme;
  final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
  final bool isHolo = activeTheme.isHolographic;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
  final accentColor = widget.themeController.activeAccentColor;
  
  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

  const double outerRadius = 28.0;
  final double borderWidth = (isNeon || isHolo || isAnemone) ? 3.0 : 1.5;

  Widget dialogContent = Container(
    width: MediaQuery.of(context).size.width * 0.85,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isNeon ? Colors.black : Colors.black,
      borderRadius: BorderRadius.circular(outerRadius),
      border: (!isHolo && !isAnemone) 
          ? Border.all(
              color: isNeon ? coreColor : accentColor.withOpacity(0.5),
              width: borderWidth,
            )
          : null,
      boxShadow: isNeon ? [
        BoxShadow(color: accentColor.withOpacity(0.8), blurRadius: 4, spreadRadius: 0.5),
        BoxShadow(color: accentColor.withOpacity(0.2), blurRadius: 15, spreadRadius: 1),
      ] : null,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ArmoryText("SELECT CONFIGURATION", themeController: widget.themeController, baseFontSize: 12),
        const SizedBox(height: 20),
        ...buildNames.map((name) {
          String displayLabel = name.toUpperCase();
          String actualSelectionName = name;
          if (name.toLowerCase() == "special" || name.toLowerCase().contains("conversion")) {
            final builds = w.builds[name];
            if (builds != null && builds.isNotEmpty) {
              final specialBuild = builds.firstWhere(
                (b) => b.modName != null && b.modName!.toUpperCase().contains("(WZ)"),
                orElse: () => builds.firstWhere(
                  (b) => b.modName != null && b.modName!.toLowerCase() != w.name.toLowerCase(),
                  orElse: () => builds.first
                )
              );
              if (specialBuild.modName != null) {
                displayLabel = specialBuild.modName!.toUpperCase();
                actualSelectionName = specialBuild.modName!; 
              }
            }
          }
          String weaponNameUpper = w.name.toUpperCase();
          if (displayLabel.contains(weaponNameUpper) && displayLabel != weaponNameUpper) {
            displayLabel = displayLabel.replaceFirst(weaponNameUpper, "").trim();
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); 
                _selectWeapon(w, actualSelectionName, slot);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: isNeon ? Colors.black : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isNeon ? coreColor.withOpacity(0.5) : accentColor.withOpacity(0.3)
                  ),
                ),
                child: ArmoryText(
                  displayLabel,
                  themeController: widget.themeController, 
                  baseFontSize: 9, 
                  textAlign: TextAlign.center,
                  allowWrap: true,
                ),
              ),
            ),
          );
        }),
      ],
    ),
  );

  Widget wrappedDialog;
  if (isHolo) {
    wrappedDialog = _InternalAnimatedBorder(
      colors: activeTheme.refractionColors,
      borderRadius: outerRadius,
      useRotation: true,
      child: dialogContent,
    );
  } else if (isAnemone) {
    wrappedDialog = ArmoryGradientBorder(
      gradientColors: activeTheme.borderGradient,
      borderRadius: outerRadius,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      child: dialogContent,
    );
  } else {
    wrappedDialog = dialogContent;
  }

  showDialog(
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: wrappedDialog,
        ),
      ),
    ),
  );
}

@override
Widget build(BuildContext context) {
  final isCustom = widget.themeController.activeTheme.id == 'neon_custom';
  final accentColor = widget.themeController.activeAccentColor;
  final coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );

  return Scaffold(
    backgroundColor: Colors.black,
    body: PageView(
      physics: const BouncingScrollPhysics(),
      children: [
        _buildComparisonDeltaPage(context, isCustom, accentColor, coreColor), 
        
        GlobalAnalysisScreen(
          themeController: widget.themeController,
          allWeapons: _getCompatibleWeapons(widget.allWeapons, _cachedValidNames),
        ),
      ],
    ),
  );
}

Widget _buildComparisonDeltaPage(BuildContext context, bool isCustom, Color accentColor, Color coreColor) {
  final statsA = _getWeaponStats(_weaponA, _selectedBuildA);
  final statsB = _getWeaponStats(_weaponB, _selectedBuildB);
  final bool showSniperStats = (statsA?.shotRange != null || statsB?.shotRange != null);
  final double ratingBoxSize = showSniperStats ? 65.0 : 80.0;
  final double vsFontSize = showSniperStats ? 12.0 : 16.0;

  final bool showAegisHint = (_weaponA == null || _weaponB == null);

  return Column(
    children: [
      _buildCustomAppBar(isCustom, coreColor), 
      
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(child: _buildSelectionSlot('A', _weaponA, _selectedBuildA, isCustom, accentColor, coreColor)),
            const SizedBox(width: 10),
            Expanded(child: _buildSelectionSlot('B', _weaponB, _selectedBuildB, isCustom, accentColor, coreColor)),
          ],
        ),
      ),
      const SizedBox(height: 15),
      if (_weaponA != null && _weaponB != null)
      Padding(
        padding: const EdgeInsets.all(8),
        child: Container(height: 1, color: Colors.white38),
      ),
      if (_weaponA != null && _weaponB != null)
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        _buildCompareRow("VELOCITY", statsA?.bulletVelocity, statsB?.bulletVelocity),
                        _buildCompareRow("ADS SPEED", statsA?.adsSpeed, statsB?.adsSpeed, lowerIsBetter: true),
                        _buildCompareRow("TTK CLOSE", statsA?.ttk1, statsB?.ttk1, lowerIsBetter: true, subValA: "0 - ${statsA?.range1}", subValB: "0 - ${statsB?.range1}"),
                        _buildCompareRow("TTK FAR", statsA?.ttk2, statsB?.ttk2, lowerIsBetter: true, subValA: (statsA?.range1 == statsA?.range2) ? "${statsA?.range2}+" : "${statsA?.range1} - ${statsA?.range2}", subValB: (statsB?.range1 == statsB?.range2) ? "${statsB?.range2}+" : "${statsB?.range1} - ${statsB?.range2}"),
                        _buildCompareRow("HITS TO KILL", statsA?.shotsToKill, statsB?.shotsToKill, lowerIsBetter: true),
                        _buildCompareRow("HITSCAN", statsA?.hitscanRange, statsB?.hitscanRange),
                        if (statsA?.shotRange != null || statsB?.shotRange != null)
                          _buildCompareRow("ONE SHOT", statsA?.shotRange, statsB?.shotRange),
                        
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(height: 1, color: Colors.white38),
                        ),
                        
                        const SizedBox(height: 10),
                        ArmoryText("COMBAT RATING", themeController: widget.themeController, baseFontSize: 16),
                        ArmoryText("FOR CLASS", themeController: widget.themeController, baseFontSize: 8, color: Colors.white54),
                        
                        const Spacer(flex: 1),
                        
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (statsA != null) 
                                _CombatRatingBoxMinimal(
                                  rating: statsA.combatRating ?? CombatRating("C", "No data available"), 
                                  themeController: widget.themeController, 
                                  size: ratingBoxSize
                                ),
                                
                              ArmoryText("VS", themeController: widget.themeController, baseFontSize: vsFontSize, color: Colors.white30),
                              
                              if (statsB != null) 
                                _CombatRatingBoxMinimal(
                                  rating: statsB.combatRating ?? CombatRating("C", "No data available"), 
                                  themeController: widget.themeController, 
                                  size: ratingBoxSize
                                ),
                            ],
                          ),
                        ),
                        
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )
      else
        Expanded(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.compare_arrows_rounded, color: Colors.white38, size: 60),
                    const SizedBox(height: 10),
                    ArmoryText("SELECT TWO WEAPONS", themeController: widget.themeController, baseFontSize: 10, color: Colors.white),
                  ],
                ),
              ),
              if (showAegisHint)
                Positioned(
                  bottom: 30,
                  right: 20,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ArmoryText(
                        "SWIPE FOR AEGIS EYE",
                        themeController: widget.themeController,
                        baseFontSize: 9,
                        color: Colors.white,
                        letterSpacing: 2.5,
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.trending_flat_rounded,
                        color: Colors.white38,
                        size: 28,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
    ],
  );
}

Widget _buildCustomAppBar(bool isCustom, Color coreColor) {
  final accentColor = widget.themeController.activeAccentColor;
  final Color primaryFaded = Color.alphaBlend(
    Theme.of(context).colorScheme.surface.withOpacity(0.8), 
    Colors.black
  );

  return Container(
    width: double.infinity, 
    padding: const EdgeInsets.only(top: 47.5, bottom: 20),
    decoration: BoxDecoration(
      color: Colors.black,
      border: isCustom 
        ? Border(bottom: BorderSide(color: coreColor, width: 1)) 
        : Border(bottom: BorderSide(color: coreColor, width: 1)),
      boxShadow: isCustom ? [
        BoxShadow(
          color: coreColor.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 2),
        )
      ] : null,
    ),
    child: Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 5,
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white, 
                size: 16
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.pop(context);
              },
            ),
          ),
        ),

        ArmoryText(
          "ARMORY COMBAT DELTA", 
          themeController: widget.themeController, 
          baseFontSize: 16
        ),
        
        Positioned(
          right: 8,
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Icon(
                Icons.info_outline, 
                color: isCustom ? coreColor : accentColor, 
                size: 24
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                _showIntelGlossary(context);
              },
            ),
          ),
        ),
      ],
    ),
  );
}

void _showIntelGlossary(BuildContext context) {
  final activeTheme = widget.themeController.activeTheme;
  final isCustom = activeTheme.id == 'neon_custom';
  final accentColor = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

  showDialog(
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Builder(
          builder: (context) {
            Widget dialogContent = Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isCustom ? Colors.black : Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(24),
                border: activeTheme.isHolographic || activeTheme.category == ThemeCategory.anemone
                    ? null 
                    : Border.all(
                        color: isCustom ? coreColor : accentColor.withOpacity(0.5),
                        width: isCustom ? 1.5 : 1.2,
                      ),
                boxShadow: isCustom ? [

                  BoxShadow(
                    color: accentColor.withOpacity(0.8), 
                    blurRadius: 4, 
                    spreadRadius: 1,
                  ),

                  BoxShadow(
                    color: accentColor.withOpacity(0.3), 
                    blurRadius: 20, 
                    spreadRadius: 2,
                  ),
                ] : [],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ArmoryText(
                    "STAT TERMINOLOGY", 
                    themeController: widget.themeController, 
                    baseFontSize: 14, 
                    color: isCustom ? coreColor : Colors.white
                  ),
                  const SizedBox(height: 20),
                  
                  _buildGlossaryItem("VELOCITY", "Speed of the bullet. For snipers, higher values means less bullet drop and leading (shooting ahead of a moving target). For other weapons this also applies, but also means you won't have bullet travel time to slow down your TTK, shifting a gunfight into your favour. Higher is better."),
                  _buildGlossaryItem("ADS SPEED", "Time between when you hit the aim button, and when you are fully aimed in and ready to fire at 100% accuracy. Lower is better."),
                  _buildGlossaryItem("TTK CLOSE/FAR", "Time to Kill. 'Close' is how fast you will kill within the first damage range. 'Far' is how fast you will kill within the second damage range. Lower is better."),
                  _buildGlossaryItem("HITS TO KILL", "The number of shots required to kill at 'Close' and 'Far' range. Lower is better."),
                  _buildGlossaryItem("HITSCAN", "The distance where bullets connect instantly, meaning there is no delay between pressing the fire button, and seeing a hitmarker. Higher is better."),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: ArmoryText("CLOSE", themeController: widget.themeController, baseFontSize: 10, color: Colors.white38),
                  ),
                ],
              ),
            );

            if (activeTheme.isHolographic) {
              return _InternalAnimatedBorder(
                colors: activeTheme.refractionColors,
                useRotation: true, 
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: dialogContent,
                ),
              );
              
            } else if (activeTheme.category == ThemeCategory.anemone) {
              return ArmoryGradientBorder(
                gradientColors: activeTheme.borderGradient,
                strokeWidth: 2,
                borderRadius: 12,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                child: dialogContent,
              );
            } else {
              return dialogContent;
            }
          },
        ),
      ),
    ),
  );
}

Widget _buildGlossaryItem(String title, String explanation) {

  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        ArmoryText(
          title, 
          themeController: widget.themeController, 
          baseFontSize: 10, 
          color: Colors.white, 
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        ArmoryText(
          explanation, 
          themeController: widget.themeController, 
          color: Colors.white54, 
          textAlign: TextAlign.center,
          allowWrap: true,
          baseFontSize: 10
        ),
      ],
    ),
  );
}

Widget _buildSelectionSlot(String slot, Weapon? weapon, String? selectedBuild, bool isCustom, Color accentColor, Color coreColor) {
  final activeTheme = widget.themeController.activeTheme;
  final theme = Theme.of(context);
  
  String displayName = "SLOT $slot";
  
  if (weapon != null) {
    String buildLabel = selectedBuild ?? "";

    if (buildLabel.toLowerCase() == "special") {
      final b = weapon.builds[selectedBuild]?.firstWhere(
        (b) => b.modName != null && b.modName!.toLowerCase() != weapon.name.toLowerCase(),
        orElse: () => weapon.builds[selectedBuild]!.first
      );
      if (b?.modName != null) {
        buildLabel = b!.modName!.toUpperCase().replaceFirst(weapon.name.toUpperCase(), "").trim();
      }
    }

    displayName = (buildLabel != "" && buildLabel.toLowerCase() != 'warzone' && buildLabel.toLowerCase() != 'multiplayer') 
      ? "${weapon.name}\n($buildLabel)" 
      : weapon.name;
  }

  Widget slotContent = AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    height: 140, 
    decoration: BoxDecoration(
      color: isCustom ? const Color(0xFF000000) : const Color(0xFF080808),
      borderRadius: BorderRadius.circular(18),
      border: (!activeTheme.isHolographic && activeTheme.category != ThemeCategory.anemone)
          ? Border.all(
              color: isCustom ? coreColor : accentColor, 
              width: isCustom ? 2.0 : 1.5
            )
          : null,
      boxShadow: (isCustom && weapon != null) ? [
        BoxShadow(color: accentColor.withOpacity(0.8), blurRadius: 1, spreadRadius: 0.5),
        BoxShadow(color: accentColor.withOpacity(0.3), blurRadius: 15, spreadRadius: 2),
      ] : (weapon != null ? [BoxShadow(color: accentColor.withOpacity(0.1), blurRadius: 4)] : []),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: weapon != null ? accentColor.withOpacity(0.12) : Colors.transparent,
              border: Border(bottom: BorderSide(color: isCustom ? coreColor.withOpacity(0.3) : Colors.transparent)),
            ),
            child: ArmoryText(
              displayName.toUpperCase(),
              themeController: widget.themeController,
              baseFontSize: 9,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Center(
              child: weapon != null
                  ? Padding(
                      padding: const EdgeInsets.all(12.0), 
                      child: Image.network(weapon.imageUrl, fit: BoxFit.contain)
                    )
                  : const Icon(Icons.add_circle_outline_rounded, color: Colors.white24, size: 24),
            ),
          ),
        ],
      ),
    ),
  );

  Widget finalSlot;
  if (activeTheme.isHolographic) {
    finalSlot = _InternalAnimatedBorder(
      colors: activeTheme.refractionColors,
      useRotation: true,
      borderRadius: 18,
      child: slotContent,
    );
  } else if (activeTheme.category == ThemeCategory.anemone) {
    finalSlot = ArmoryGradientBorder(
      gradientColors: activeTheme.borderGradient,
      strokeWidth: 2,
      borderRadius: 18,
      child: slotContent,
    );
  } else {
    finalSlot = slotContent;
  }

  return GestureDetector(
    onTap: () {
      HapticFeedback.mediumImpact();
      _openWeaponSelector(slot);
    },
    onLongPress: weapon == null ? null : () async {
  HapticFeedback.mediumImpact(); 
  await Future.delayed(const Duration(milliseconds: 50));
  HapticFeedback.heavyImpact(); 

  setState(() {
    if (slot.toUpperCase() == 'A' || slot == '1') {
      _weaponA = null;
      _selectedBuildA = null;
    } else {
      _weaponB = null;
      _selectedBuildB = null;
    }
  });
},
    child: finalSlot,
  );
}

 Widget _buildCompareRow(
  String label, 
  String? valA, 
  String? valB, {
  bool lowerIsBetter = false, 
  String? subValA, 
  String? subValB,
  bool subLowerIsBetter = false,
}) {
  final diffA = _getDifferential(valA, valB, true, lowerIsBetter);
  final diffB = _getDifferential(valA, valB, false, lowerIsBetter);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // WEAPON A
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ArmoryText(
                (valA != null && valA.isNotEmpty) ? valA : "---", 
                themeController: widget.themeController, 
                baseFontSize: 14, 
                color: _getComparisonColor(valA, valB, true, lowerIsBetter: lowerIsBetter), 
                textAlign: TextAlign.start
              ),
              if (diffA != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: ArmoryText(diffA, themeController: widget.themeController, baseFontSize: 7, color: Colors.greenAccent.withOpacity(0.8)),
                ),
            ],
          ),
        ),

        // CENTER LABEL + RANGE WINDOWS
        SizedBox(
          width: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ArmoryText(label, themeController: widget.themeController, baseFontSize: 9, color: Colors.white, textAlign: TextAlign.center),
              
              if (subValA != null && subValB != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ArmoryText(
                          subValA, 
                          themeController: widget.themeController, 
                          baseFontSize: 8, 
                          color: Colors.white54,
                          textAlign: TextAlign.end, 
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ArmoryText("|", themeController: widget.themeController, baseFontSize: 8, color: Colors.white24),
                      ),
                      Expanded(
                        child: ArmoryText(
                          subValB, 
                          themeController: widget.themeController, 
                          baseFontSize: 8, 
                          color: Colors.white54,
                          textAlign: TextAlign.start, 
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: (subValA != null) ? 4 : 12), 
            ],
          ),
        ),

        // WEAPON B
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ArmoryText(
                (valB != null && valB.isNotEmpty) ? valB : "---", 
                themeController: widget.themeController, 
                baseFontSize: 14, 
                color: _getComparisonColor(valA, valB, false, lowerIsBetter: lowerIsBetter), 
                textAlign: TextAlign.end
              ),
              if (diffB != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: ArmoryText(diffB, themeController: widget.themeController, baseFontSize: 7, color: Colors.greenAccent.withOpacity(0.8)),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildStatRow(String label, String key, String? valA, String? valB) {
  bool lowerBetter = _lowerIsBetter[key] ?? false;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
    child: Row(
      children: [
        // WEAPON A VALUE
        Expanded(
          child: ArmoryText(
            (valA != null && valA.isNotEmpty) ? valA : "---",
            themeController: widget.themeController,
            baseFontSize: 12,
            textAlign: TextAlign.start,
            color: _getComparisonColor(valA, valB, true, lowerIsBetter: lowerBetter),
          ),
        ),
        
        // STAT LABEL
        ArmoryText(
          label.toUpperCase(),
          themeController: widget.themeController,
          baseFontSize: 10,
          color: Colors.white24,
        ),

        // WEAPON B VALUE
        Expanded(
          child: ArmoryText(
            (valB != null && valB.isNotEmpty) ? valB : "---",
            themeController: widget.themeController,
            baseFontSize: 12,
            textAlign: TextAlign.end,
            color: _getComparisonColor(valA, valB, false, lowerIsBetter: lowerBetter),
          ),
        ),
      ],
    ),
  );
}
}

class _CombatRatingBoxMinimal extends StatelessWidget {
  final CombatRating rating;
  final ThemeController themeController;
  final double size;
  final String? customText;

  const _CombatRatingBoxMinimal({
    required this.rating, 
    required this.themeController,
    this.size = 80,
    this.customText,
  });

  Color _getRatingColor(String label) {
    switch (label) {
      case "S": return Colors.amberAccent;
      case "A": return Colors.greenAccent;
      case "B": return Colors.deepOrangeAccent;
      default: return Colors.red.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ratingColor = _getRatingColor(rating.label);
    final isCustom = themeController.activeTheme.id == 'neon_custom';
    final Color coreColor = Color.lerp(ratingColor, Colors.white, 0.35)!;

    final String displayText = customText ?? rating.label;

    double fontSizeMultiplier = 0.475;
    if (displayText.length == 2) fontSizeMultiplier = 0.4;
    if (displayText.length >= 3) fontSizeMultiplier = 0.3;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isCustom ? coreColor : ratingColor.withOpacity(0.4), 
          width: 2.5,
        ),
        boxShadow: isCustom ? [
          BoxShadow(color: ratingColor.withOpacity(0.6), blurRadius: 10, spreadRadius: 1),
        ] : [],
      ),
      alignment: Alignment.center,
      child: ArmoryText(
        displayText,
        themeController: themeController,
        baseFontSize: size * fontSizeMultiplier, 
        baseStrokeWidth: isCustom ? 1 : 0,
        color: isCustom ? Colors.white : ratingColor,
      ),
    );
  }
}

class GlobalAnalysisScreen extends StatefulWidget {
  final ThemeController themeController;
  final List<Weapon> allWeapons;
  
  const GlobalAnalysisScreen({
    super.key, 
    required this.themeController, 
    required this.allWeapons,
  });

  @override
  State<GlobalAnalysisScreen> createState() => _GlobalAnalysisScreenState();
}

enum SortMode { highToLow, lowToHigh, none }

class _GlobalAnalysisScreenState extends State<GlobalAnalysisScreen> {
  Map<String, dynamic> archetypesJson = {};
  String _currentFilter = "TTK CLOSE";
  SortMode _sortMode = SortMode.none;
  int? _flippedIndex;
  Map<String, WeaponStats> statsLookup = {}; 

  final List<String> _filters = ["TTK CLOSE", "TTK FAR", "VELOCITY", "ADS SPEED", "STK"];

  final List<String> weaponCategories = [
  "ALL", "AR", "SMG", "LMG", "SHOTGUN", 
  "MARKSMAN RIFLE", "SNIPER", "BATTLE RIFLE", "PISTOL"
];

String selectedCategory = "ALL";

void _handleFilterTap(String filter) {
  setState(() {
    _flippedIndex = null;

    if (_currentFilter != filter) {
      _currentFilter = filter;
      _sortMode = (filter == "VELOCITY") ? SortMode.highToLow : SortMode.lowToHigh;
      return;
    }

    if (filter == "VELOCITY") {
      if (_sortMode == SortMode.highToLow) {
        _sortMode = SortMode.lowToHigh;
      } else if (_sortMode == SortMode.lowToHigh) {
        _sortMode = SortMode.none; 
      } else {
        _sortMode = SortMode.highToLow;
      }
    } else {
      if (_sortMode == SortMode.lowToHigh) {
        _sortMode = SortMode.highToLow;
      } else if (_sortMode == SortMode.highToLow) {
        _sortMode = SortMode.none;
      } else {
        _sortMode = SortMode.lowToHigh;
      }
    }
  });
}

bool _isHighBetter(String filter) {
  return filter == "VELOCITY" || filter == "RATING";
}

double _parse(dynamic val) {
  if (val == null) return 0.0;
  String clean = val.toString().replaceAll(RegExp(r'[^0-9.]'), '');
  return double.tryParse(clean) ?? 0.0;
}

WeaponStats? _extractBaseStats(
  Weapon weapon, {
  String? targetSpecificName, 
  Map<String, WeaponStats>? statsLookup
}) {
  if (targetSpecificName != null) {
    final String target = targetSpecificName.toUpperCase().trim();

    if (statsLookup != null && statsLookup.containsKey(target)) {
      final exactStats = statsLookup[target];
      if (exactStats != null) {
        if (target.contains("SOKOL 545") && exactStats.combatRating == null) {
          exactStats.archetype = "LMG";
          exactStats.combatRating = calculateCombatRatingStatic(exactStats, "LMG", false);
        }
        return exactStats;
      }
    }

    for (var buildsList in weapon.builds.values) {
      for (var build in buildsList) {
        final String buildName = (build.modName ?? "").toUpperCase().trim();
        if (buildName == target) return build.stats;
      }
    }

    for (var buildsList in weapon.builds.values) {
      for (var build in buildsList) {
        final String buildName = (build.modName ?? "").toUpperCase().trim();
        if (buildName.isNotEmpty && 
            !target.contains("SOKOL 545") && 
            target.contains(buildName)) {
           return build.stats;
        }
      }
    }
  }

  if (weapon.builds.containsKey('Warzone')) {
    return weapon.builds['Warzone']?.first.stats;
  }
  return weapon.builds.values.isNotEmpty ? weapon.builds.values.first.first.stats : null;
}

  @override
  void initState() {
    super.initState();
    _loadArchetypes();
  }

  Future<void> _loadArchetypes() async {
  try {
    final aegisArc = Provider.of<AegisArc>(context, listen: false);
    final String lang = aegisArc.languageCode;

    String getAssetPath(String fileName) {
      if (lang == 'en') {
        return 'assets/$fileName';
      } else {

        String nameWithoutExtension = fileName.split('.').first;
        return 'assets/$lang/${nameWithoutExtension}_$lang.json';
      }
    }

    final String archetypesAssetPath = getAssetPath('archetypes.json');
    final String statsAssetPath = getAssetPath('Premium_Stats.json');

    final String archetypesResponse = await loadHotfixedJson(archetypesAssetPath);
    final data = json.decode(archetypesResponse);

    final String statsResponse = await loadHotfixedJson(statsAssetPath);
    final Map<String, dynamic> statsData = json.decode(statsResponse);

    final Map<String, WeaponStats> tempLookup = {};
    if (statsData['Premium_Stats'] != null) {
      for (var s in statsData['Premium_Stats']) {
        String key = (s['english_id'] ?? s['weapon_name'])
            ?.toString()
            .toUpperCase()
            .trim() ?? "";

        if (key.isNotEmpty) {
          tempLookup[key] = WeaponStats(
            ttk1: s['ttk1']?.toString() ?? "-",
            ttk2: s['ttk2']?.toString() ?? "-",
            adsSpeed: s['ads_speed']?.toString() ?? "-",
            bulletVelocity: s['bullet_velocity']?.toString() ?? "-",
            shotsToKill: s['shots_to_kill']?.toString() ?? "-",
            range1: s['range1']?.toString() ?? "-",
            range2: s['range2']?.toString() ?? "-",
            hitscanRange: s['hitscan_range']?.toString() ?? "-",
          );
        }
      }
    }

    if (mounted) {
      setState(() {
        archetypesJson = data;
        statsLookup = tempLookup;
      });
    }
    
  } catch (e) {
    debugPrint("❌ Error in GlobalAnalysis Localization: $e");
  }
}

@override
Widget build(BuildContext context) {
  final sortedWeapons = _getSortedWeapons();
  final activeTheme = widget.themeController.activeTheme;
  final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
  final Color coreColor = Color.lerp(widget.themeController.activeAccentColor, Colors.white, 0.35)!;

  return Scaffold(
    backgroundColor: Colors.black,
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: _buildCustomAppBar(isNeon, coreColor),
    ),
    body: Column(
      children: [
        _buildModernFilterBar(), 
        Expanded(
          child: ListView.builder(
            itemCount: sortedWeapons.length,
            padding: const EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index) {
              final item = sortedWeapons[index];
              return _buildStatBlade(
                index, 
                item.displayName, 
                item.stats, 
                item.weapon
              );
            }
          ),
        ),
      ],
    ),
  );
}

Widget _buildCustomAppBar(bool isCustom, Color coreColor) {
  final accentColor = widget.themeController.activeAccentColor;

  return Container(
    width: double.infinity, 
    padding: const EdgeInsets.only(top: 47.5, bottom: 20),
    decoration: BoxDecoration(
      color: Colors.black,
      border: Border(bottom: BorderSide(color: coreColor, width: 1)),
    ),
    child: Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 5,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        ArmoryText(
          "AEGIS EYE", 
          themeController: widget.themeController, 
          baseFontSize: 16
        ),
        
        Positioned(
          right: 8,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.info_outline, 
              color: isCustom ? coreColor : accentColor, 
              size: 24
            ),
            onPressed: () {
              HapticFeedback.mediumImpact();
              _showGlossary(context);
            },
          ),
        ),
      ],
    ),
  );
}

void _showGlossary(BuildContext context) {
  final activeTheme = widget.themeController.activeTheme;
  final accentColor = widget.themeController.activeAccentColor;
  final coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

  final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;

  Widget dialogBody = Container(
    padding: const EdgeInsets.all(20),
    decoration: const BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: ArmoryText("COMBAT RATINGS", 
            themeController: widget.themeController, 
            baseFontSize: 18,
          )
        ),
        const SizedBox(height: 30),
        _buildGlossaryItem("S", Colors.amberAccent, "TOP TIER PICK FOR ITS CLASS. RELIABLE AND HARD HITTING."),
        const SizedBox(height: 12),
        _buildGlossaryItem("A", Colors.greenAccent, "COMPETITIVE CHOICE, BUT NOT AS STRONG AS S TIER."),
        const SizedBox(height: 12),
        _buildGlossaryItem("B", Colors.deepOrangeAccent, "USABLE, BUT WILL FEEL NOTICABLY WEAKER THAN OTHER PICKS."),
        const SizedBox(height: 12),
        _buildGlossaryItem("C", Colors.red.shade600, "VASTLY OUTCLASSED. HAVE STEADY AIM IF YOU DARE TRY."),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: ArmoryText("CLOSE", themeController: widget.themeController, baseFontSize: 12),
        )
      ],
    ),
  );

  Widget themedDialog;
  
  if (activeTheme.isHolographic) {
    themedDialog = _InternalAnimatedBorder(
      colors: activeTheme.refractionColors,
      useRotation: true, 
      borderRadius: 15,
      child: dialogBody,
    );
  } else if (activeTheme.category == ThemeCategory.anemone) {
    themedDialog = ArmoryGradientBorder(
      gradientColors: activeTheme.borderGradient,
      strokeWidth: 2,
      borderRadius: 15,
      child: dialogBody,
    );
  } else if (isNeon) {
    themedDialog = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: coreColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.6), 
            blurRadius: 12, 
            spreadRadius: 1
          ),
          BoxShadow(
            color: accentColor.withOpacity(0.2), 
            blurRadius: 20, 
            spreadRadius: 2
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: dialogBody,
      ),
    );
  } else {
    themedDialog = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: accentColor, 
          width: 1.5
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: dialogBody,
      ),
    );
  }

  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5), 
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: themedDialog,
      ),
    ),
  );
}

Widget _buildGlossaryItem(String label, Color color, String description) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 1.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: ArmoryText(label, 
            themeController: widget.themeController, 
            baseFontSize: 12, 
            color: color,
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: ArmoryText(description, 
            themeController: widget.themeController, 
            baseFontSize: 10, 
            color: Colors.white,
            allowWrap: true,
          ),
      ),
    ],
  );
}

Widget _buildModernFilterBar() {
    final accentColor = widget.themeController.activeAccentColor;
    final isCustom = widget.themeController.activeTheme.id == 'neon_custom';
    final coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showCategoryDialog(context, isCustom ? coreColor : accentColor),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selectedCategory != "ALL" ? accentColor.withOpacity(0.15) : Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedCategory != "ALL" 
                    ? (isCustom ? coreColor : accentColor) 
                    : Colors.white12,
                  width: 1.2,
                ),
                boxShadow: (selectedCategory != "ALL" && isCustom) ? [
                  BoxShadow(color: accentColor.withOpacity(0.4), blurRadius: 6, spreadRadius: 0.5),
                ] : [],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.grid_view_rounded, 
                    size: 14, 
                    color: selectedCategory != "ALL" ? (isCustom ? coreColor : accentColor) : Colors.white38
                  ),
                  const SizedBox(width: 8),
                  ArmoryText(
                    selectedCategory,
                    themeController: widget.themeController,
                    baseFontSize: 10,
                    color: selectedCategory != "ALL" ? Colors.white : Colors.white38,
                  ),
                ],
              ),
            ),
          ),

          ..._filters.map((filter) {
            final isSelected = _currentFilter == filter && _sortMode != SortMode.none;
            
            return GestureDetector(
              onTap: () => _handleFilterTap(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? accentColor.withOpacity(0.1) : Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                      ? (isCustom ? coreColor : accentColor) 
                      : Colors.white10,
                    width: 1.2,
                  ),
                  boxShadow: (isSelected && isCustom) ? [
                    BoxShadow(color: accentColor.withOpacity(0.4), blurRadius: 4, spreadRadius: 0.5),
                  ] : [],
                ),
                child: Row(
                  children: [
                    ArmoryText(
                      filter,
                      themeController: widget.themeController,
                      baseFontSize: 10,
                      color: isSelected ? Colors.white : Colors.white38,
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Icon(
                        _sortMode == SortMode.highToLow 
                            ? Icons.arrow_downward 
                            : Icons.arrow_upward,
                        size: 12,
                        color: isCustom ? coreColor : accentColor,
                      ),
                    ]
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }

Widget _buildStatBlade(int index, String displayName, WeaponStats stats, Weapon weapon) {
  final activeTheme = widget.themeController.activeTheme;
  final accentColor = widget.themeController.activeAccentColor;
  final isCustom = activeTheme.id == 'neon_custom';
  final coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final aegisArc = Provider.of<AegisArc>(context);

  final int totalCount = _getSortedWeapons().length; 
  
  int rank;
  
  if (_sortMode == SortMode.none) {
    rank = index + 1;
  } 
  else if (_currentFilter == "VELOCITY") {
    rank = (_sortMode == SortMode.highToLow) 
        ? (index + 1) 
        : (totalCount - index);
  } 
  else {
    rank = (_sortMode == SortMode.lowToHigh) 
        ? (index + 1) 
        : (totalCount - index);
  }

  String displayValue = _extractValue(stats);

  bool isTTK = _currentFilter == "TTK CLOSE" || _currentFilter == "TTK FAR";
  bool isFlipped = _flippedIndex == index && isTTK;

  if (isFlipped) {
    if (_currentFilter == "TTK CLOSE") {
      displayValue = "0 - ${stats.range1}";
    } else {
      displayValue = "${stats.range1}+";
    }
  }

  Widget cardContent = Container(
    height: 50,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: const BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.all(Radius.circular(24)),
    ),
    child: Row(
      children: [
        if (stats.combatRating != null)
          _CombatRatingBoxMinimal(
            rating: stats.combatRating!, 
            themeController: widget.themeController,
            size: 32,
            customText: rank.toString(), 
          )
        else
          const SizedBox(
            width: 32, 
            child: Icon(Icons.remove, color: Colors.white10, size: 16)
          ),

        const SizedBox(width: 12),

        Expanded(
          child: ArmoryText(
            displayName.toUpperCase(),
            themeController: widget.themeController, 
            baseFontSize: 13,
          ),
        ),

        const SizedBox(width: 18),
        
        GestureDetector(
          onTap: () {
            if (isTTK) {
              setState(() {
                _flippedIndex = (_flippedIndex == index) ? null : index;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 7),
            child: ArmoryText(
              displayValue, 
              themeController: widget.themeController, 
              baseFontSize: 13, 
              color: isFlipped ? coreColor : Colors.white,
            ),
          ),
        ),
      ],
    ),
  );

  Widget finalWidget;

  if (activeTheme.isHolographic) {
    finalWidget = _InternalAnimatedBorder(
      colors: activeTheme.refractionColors,
      borderRadius: (24),
      child: cardContent, 
    );
  } else if (activeTheme.category == ThemeCategory.anemone) {
    finalWidget = RepaintBoundary(
      child: ArmoryGradientBorder(
        gradientColors: activeTheme.borderGradient,
        strokeWidth: 2.5,
        borderRadius: 24,
        child: cardContent,
      ),
    );
  } else if (isCustom) {
    finalWidget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: coreColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.8), 
            blurRadius: 4, 
            spreadRadius: 1,
          ),
          BoxShadow(
            color: accentColor.withOpacity(0.05), 
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: cardContent,
      ),
    );
  } else {
    finalWidget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accentColor.withOpacity(0.8), 
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: cardContent,
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    child: finalWidget,
  );
}

String _extractValue(WeaponStats stats) {
  switch (_currentFilter) {
    case "STK": return stats.shotsToKill;
    case "VELOCITY": return stats.bulletVelocity;
    case "ADS SPEED": return stats.adsSpeed;
    case "TTK CLOSE": return stats.ttk1;
    case "TTK FAR": return stats.ttk2;
    default: return stats.combatRating?.label ?? "N/A";
  }
}

List<SortedItem> _getSortedWeapons() {
  List<SortedItem> items = [];

  List<String> allowedInSearch = [];
  final Map<String, dynamic> archetypes = archetypesJson['archetypes'] ?? {};
  final Map<String, String> nameToArchetypeMap = {};

  if (selectedCategory == "ALL") {
    archetypes.forEach((arch, list) {
      if (list is List) {
        for (var n in list) {
          nameToArchetypeMap[n.toString().toUpperCase().trim()] = arch;
        }
      }
    });
  }

  if (selectedCategory != "ALL") {
    allowedInSearch = (archetypes[selectedCategory] as List<dynamic>?)
            ?.map((e) => e.toString().toUpperCase().trim())
            .toList() ?? [];
  } else {
    for (var list in archetypes.values) {
      if (list is List) {
        allowedInSearch.addAll(list.map((e) => e.toString().toUpperCase().trim()));
      }
    }
  }

  for (var weapon in widget.allWeapons) {
  final String baseName = weapon.name.toUpperCase().trim();

  List<String> variants = allowedInSearch.where((name) {
    final String cleanName = name.toUpperCase().trim();

    if (cleanName == baseName) return true;
    if (cleanName.startsWith("$baseName (")) return true;
    if (cleanName.startsWith("$baseName ")) {

      String remaining = cleanName.substring(baseName.length + 1);
      bool startsWithNumber = remaining.isNotEmpty && RegExp(r'^[0-9]').hasMatch(remaining);
      return !startsWithNumber; 
    }
    return false;
  }).toList();

  if (variants.isNotEmpty) {
  }

  if (variants.isEmpty && selectedCategory == "ALL") {
    variants.add(baseName);
  }

  final Set<String> processedNames = {};

  for (var vName in variants) {
    if (processedNames.contains(vName)) {
      debugPrint("🚫 [AEGIS_EYE] Skipping duplicate variant: $vName for weapon $baseName");
      continue;
    }

    if (vName == "SOKOL 545") continue;

    final stats = _extractBaseStats(weapon, targetSpecificName: vName, statsLookup: statsLookup);
    
    if (stats != null) {
        if (stats.combatRating == null) {
          
          String arch = nameToArchetypeMap[vName] ?? 
                       (selectedCategory != "ALL" ? selectedCategory : "");
          
          stats.archetype = arch;

          if (arch.isNotEmpty) {
            stats.combatRating = calculateCombatRatingStatic(
              stats, 
              arch, 
              false
            );
          }
        }

        String rawValue = "";
        switch (_currentFilter) {
          case "ADS SPEED": rawValue = stats.adsSpeed.toString().trim(); break;
          case "VELOCITY": rawValue = stats.bulletVelocity.toString().trim(); break;
          case "TTK CLOSE": rawValue = stats.ttk1.toString().trim(); break;
          case "TTK FAR": rawValue = stats.ttk2.toString().trim(); break;
          case "STK": rawValue = stats.shotsToKill.toString().trim(); break;
        }

        if (rawValue == "-") continue;

        String cleanedName = vName.replaceAll(" (WZ)", "");
        items.add(SortedItem(weapon, stats, displayName: cleanedName));
        processedNames.add(vName);
      }
    }
  }

  if (_sortMode == SortMode.none) {
    items.sort((a, b) => a.displayName.compareTo(b.displayName));
    return items;
  }

  items.sort((a, b) {
    int comparison = 0;
    try {
      switch (_currentFilter) {
        case "VELOCITY":
          comparison = _parse(a.stats.bulletVelocity).compareTo(_parse(b.stats.bulletVelocity));
          break;
        case "ADS SPEED":
          comparison = _parse(a.stats.adsSpeed).compareTo(_parse(b.stats.adsSpeed));
          break;
        case "TTK CLOSE":
          comparison = _parse(a.stats.ttk1).compareTo(_parse(b.stats.ttk1));
          break;
        case "TTK FAR":
          comparison = _parse(a.stats.ttk2).compareTo(_parse(b.stats.ttk2));
          break;
        case "STK":
          int calculateWeightedStk(WeaponStats s) {
            final raw = s.shotsToKill.toString().trim();
            if (raw.isEmpty || raw == "-") return 9999;
            
            if (raw.contains("-")) {
              final parts = raw.split("-");
              final close = int.tryParse(parts[0].replaceAll(RegExp(r'[^0-9]'), '')) ?? 99;
              final far = int.tryParse(parts[1].replaceAll(RegExp(r'[^0-9]'), '')) ?? 99;
              return (close * 100) + far;
            }
            
            final val = int.tryParse(raw.replaceAll(RegExp(r'[^0-9]'), '')) ?? 99;
            return (val * 100) + val;
          }
          comparison = calculateWeightedStk(a.stats).compareTo(calculateWeightedStk(b.stats));
          break;
      }
    } catch (e) {
      comparison = 0;
    }

    if (_sortMode == SortMode.highToLow) {
      return (comparison * -1);
    }
    return comparison;
  });
  
  return items;
}

void _showCategoryDialog(BuildContext context, Color coreColor) {
  showDialog(
    context: context,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: SimpleDialog(
          backgroundColor: Colors.black.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: coreColor, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          title: ArmoryText("SELECT CATEGORY", 
            themeController: widget.themeController, 
            baseFontSize: 14, 
            color: coreColor
          ),
          children: weaponCategories.map((cat) {
            return SimpleDialogOption(
              onPressed: () {
                setState(() => selectedCategory = cat);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ArmoryText(cat, 
                  themeController: widget.themeController, 
                  baseFontSize: 12,
                  color: selectedCategory == cat ? coreColor : Colors.white70
                ),
              ),
            );
          }).toList(),
        ),
      );
    },
  );
}
}

class SortedItem {
  final Weapon weapon;
  final WeaponStats stats;
  final String displayName;

  SortedItem(this.weapon, this.stats, {required this.displayName});
}

class ArchetypeRank {
  final int rank;
  final int total;
  ArchetypeRank(this.rank, this.total);
}

Map<String, ArchetypeRank> calculateArchetypeRankings({
  required Weapon currentWeapon,
  required WeaponStats currentStats,
  required List<WeaponStats> allPremiumStats,
}) {
  Map<String, ArchetypeRank> rankings = {};

  final String targetArchetype = currentStats.archetype ?? "";
  if (targetArchetype.isEmpty) return rankings;
  
  List<WeaponStats> peers = allPremiumStats.where((s) => s.archetype == targetArchetype).toList();

  List<String> statKeys = ['ttkClose', 'ttkFar', 'adsSpeed', 'velocity', 'stk'];

  for (var key in statKeys) {
    List<double> values = peers.map((p) {
      String? val;
      if (key == 'ttkClose') val = p.ttk1;
      if (key == 'ttkFar') val = p.ttk2;
      if (key == 'adsSpeed') val = p.adsSpeed;
      if (key == 'velocity') val = p.bulletVelocity;
      if (key == 'stk') val = p.shotsToKill;
      
      return double.tryParse(val ?? '0') ?? 0.0;
    }).where((v) => v > 0).toList();

    if (values.isEmpty) continue;

    values.sort();

    bool lowerIsBetter = (key != 'velocity');
    if (!lowerIsBetter) {
      values = values.reversed.toList();
    }

    double currentVal = 0.0;
    if (key == 'ttkClose') currentVal = double.tryParse(currentStats.ttk1) ?? 0.0;
    if (key == 'ttkFar') currentVal = double.tryParse(currentStats.ttk2) ?? 0.0;
    if (key == 'adsSpeed') currentVal = double.tryParse(currentStats.adsSpeed) ?? 0.0;
    if (key == 'velocity') currentVal = double.tryParse(currentStats.bulletVelocity) ?? 0.0;
    if (key == 'stk') currentVal = double.tryParse(currentStats.shotsToKill) ?? 0.0;

    int rank = values.indexOf(currentVal) + 1;
    if (rank == 0) rank = values.length; 

    rankings[key] = ArchetypeRank(rank, peers.length);
  }

  return rankings;
}

class TranslationResult {
  final String translatedText;
  final String category;

  TranslationResult(this.translatedText, this.category);

@override
  String toString() => translatedText;
}

class AegisArc extends ChangeNotifier {
  String _currentLocale = 'en';
  Map<String, dynamic> _masterDict = {};

  String get languageCode => _currentLocale;

  Future<void> loadMasterDictionary() async {
    final String content = await rootBundle.loadString('assets/master.json');
    _masterDict = json.decode(content);
    
    notifyListeners();
  }

String translateStatic(String key) {
  final langMap = uiTranslations[_currentLocale];
  if (langMap == null) return key; 

  final String upperKey = key.toUpperCase().trim();

  if (langMap.containsKey(upperKey)) return langMap[upperKey]!;

  for (String dictKey in langMap.keys) {
    if (upperKey.contains(dictKey)) {
      return upperKey.replaceAll(dictKey, langMap[dictKey]!);
    }
  }
  return key;
}

  TranslationResult translate(String key) {
    final String upperKey = key.toUpperCase().trim();

    if (_currentLocale == 'en') {
      return TranslationResult(key, _getCategoryFor(upperKey));
    }

    if (upperKey.contains('/')) {
      final parts = upperKey.split('/');
      
      final translatedParts = parts
          .map((p) {
            final partKey = p.trim();
            final res = _translateSingle(partKey);
            return res.translatedText;
          })
          .join(' / ');
          
      return TranslationResult(translatedParts, _getCategoryFor(parts.first.trim()));
    }

    return _translateSingle(upperKey);
  }

  TranslationResult _translateSingle(String key) {
  final String upperKey = key.toUpperCase().trim();

  for (var entry in _masterDict.entries) {
    if (entry.value is Map && entry.value.containsKey(upperKey)) {
      String translation = entry.value[upperKey][_currentLocale.toUpperCase()] ?? key;

      String categoryKey = entry.key;

      String translatedCategory = categoryKey;
      if (_masterDict.containsKey("WORDS") && _masterDict["WORDS"].containsKey(categoryKey)) {
        translatedCategory = _masterDict["WORDS"][categoryKey][_currentLocale.toUpperCase()] ?? categoryKey;
      }

      if (categoryKey == "WORDS") {
        return TranslationResult(translation, "");
      }

      return TranslationResult(translation, translatedCategory);
    }
  }

  return TranslationResult(key, "UNKNOWN");
}

  String _getCategoryFor(String upperKey) {
    for (var entry in _masterDict.entries) {
      if (entry.value is Map && entry.value.containsKey(upperKey)) {
        return entry.key;
      }
    }
    return "UNKNOWN";
  }

  bool get isSpanish => _currentLocale == 'es';

  AegisArc() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLocale = prefs.getString('selected_language') ?? 'en';
    notifyListeners();
  }

  Future<void> loadSavedLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  _currentLocale = prefs.getString('selected_language') ?? 'en';
  notifyListeners();
}

  Future<void> setLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('selected_language', code);

    if (_currentLocale != code) {
      _currentLocale = code;
      notifyListeners();
    }
  }

  String get suffix {
    if (_currentLocale == 'en') return '';
    return '_$_currentLocale';
  }
}
