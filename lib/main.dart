// ignore_for_file: unused_local_variable, unused_element_parameter, unused_element, non_constant_identifier_names, curly_braces_in_flow_control_structures, use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
import 'package:armory_app/themes.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:math' as math;


const String globalNgrokUrl = "https://cherty-frowningly-rickie.ngrok-free.dev";

Future<String> loadHotfixedJson(String assetPath) async {
  String fileName = assetPath.split('/').last;
  final directory = await getApplicationDocumentsDirectory();
  final localFile = File('${directory.path}/$fileName');

  if (await localFile.exists()) {
    return await localFile.readAsString();
  } else {
    return await rootBundle.loadString(assetPath);
  }
}

final Map<String, String> _archetypeLookup = {
    // SMG
    "RYDEN 45K": "SMG", "RK-9": "SMG", "RAZOR 9MM": "SMG", "RAZOR 9MM (PRESTIGE)": "SMG", "DRAVEC 45": "SMG", "CARBON 57": "SMG", "MPC-25": "SMG", "KOGOT-7": "SMG", "STURMWOLF 45": "SMG", "STURMWOLF 45 (PRESTIGE)": "SMG", "REV-46": "SMG", "C9": "SMG", "KSV": "SMG", "TANTO .22": "SMG", "PP-919": "SMG", "JACKAL PDW": "SMG", "KOMPAKT 92": "SMG", "SAUG": "SMG", "PPSH-41 (BO6)": "SMG", "LC10 (BO6)": "SMG", "LADRA": "SMG", "DRESDEN 9MM": "SMG", "LACHMANN SHROUD": "SMG", "ISO 45": "SMG", "ISO 9MM": "SMG", "PDSW 528": "SMG", "VEL 46": "SMG", "FENNEC 45": "SMG", "BAS-P": "SMG", "LACHMANN SUB": "SMG", "FSS HURRICANE": "SMG", "MX9": "SMG", "MINIBAK": "SMG", "VAZNEV-9K": "SMG", "FJX HORUS": "SMG", "STATIC-HV": "SMG", "SUPERI 46": "SMG", "RAM-9": "SMG", "AMR9": "SMG", "RIVAL-9": "SMG", "HRM-9": "SMG", "STRIKER 9": "SMG", "STRIKER": "SMG", "WSP-9": "SMG", "WSP SWARM": "SMG",
    // AR
    "M15 MOD 0": "AR", "AK-27": "AR", "AK-27 (PRESTIGE)": "AR", "MXR-17": "AR", "X9 MAVERICK": "AR", "DS20 MIRAGE": "AR", "PEACEKEEPER MK1": "AR", "MADDOX RFB": "AR", "EGRT-17": "AR", "XM4 (BO6)": "AR", "AK-74 (BO6)": "AR", "AMES 85": "AR", "GPR 91": "AR", "MODEL L": "AR", "GOBLIN MK2": "AR", "AS VAL (BO6)": "AR", "KRIG C": "AR", "CYPHER 091": "AR", "KILO 141 (BO6)": "AR", "CR-56 AMAX (BO6)": "AR", "FFAR 1 (BO6)": "AR", "ABR A1": "AR", "ABR A1 FULL AUTO": "AR", "MERRICK 556": "AR", "TAQ-56": "AR", "M4": "AR", "STB 556": "AR", "KASTOV 762": "AR", "M13B": "AR", "CHIMERA": "AR", "ISO HEMLOCK": "AR", "TEMPUS RAZORBACK": "AR", "FR AVANCER": "AR", "M13C": "AR", "TR-76 GEIST": "AR", "LACHMANN-556": "AR", "M16 (MW2)": "AR", "M16 (MW2) FULL AUTO (WZ)": "AR", "KASTOV-74U": "AR", "KASTOV 545": "AR", "STG44": "AR", "MTZ-556": "AR", "BAL-27": "AR", "RAM-7": "AR", "SVA 545": "AR", "BP50": "AR", "HOLGER 556": "AR", "MCW": "AR", "MCW SNIPER SUPPORT (WZ)": "AR", "DG-56": "AR", "FR 5.56 (MW3)": "AR",
    // SHOTGUN
    "M10 BREACHER": "SHOTGUN", "ECHO 12": "SHOTGUN", "AKITA": "SHOTGUN", "MARINE SP": "SHOTGUN", "ASG-89": "SHOTGUN", "MAELSTROM": "SHOTGUN", "KV BROADSIDE": "SHOTGUN", "LOCKWOOD 300": "SHOTGUN", "EXPEDITE 12": "SHOTGUN", "BRYSON 800": "SHOTGUN", "BRYSON 890": "SHOTGUN", "MX GUARDIAN": "SHOTGUN", "RECLAIMER 18": "SHOTGUN", "LOCKWOOD 680 (MW3)": "SHOTGUN", "HAYMAKER": "SHOTGUN", "RVIETER": "SHOTGUN",
    // LMG
    "MK.78": "LMG", "XM325": "LMG", "SOKOL 545 (FAST)": "LMG", "SOKOL 545 (SLOW)": "LMG", "PU-21": "LMG", "XMG": "LMG", "GPMG-7": "LMG", "FENG 82": "LMG", "PML 5.56": "LMG", "RAAL MG": "LMG", "RPK": "LMG", "SAKIN MG38": "LMG", "556 ICARUS": "LMG", "RAPP H": "LMG", "HCR 56": "LMG", "BRUEN MK9 (MW3)": "LMG", "KASTOV LSW": "LMG", "TAQ EVOLVERE": "LMG", "PULEMYOT 762": "LMG", "DG-58 LSW": "LMG", "DG-58 LSW BULLPUP CONVERSION (WZ)": "LMG", "TAQ ERADICATOR": "LMG", "HOLGER 26": "LMG",
    // MARKSMAN RIFLE
    "M8A1": "MARKSMAN RIFLE", "M8A1 SNIPER SUPPORT (WZ)": "MARKSMAN RIFLE", "WARDEN 308": "MARKSMAN RIFLE", "M34 NOVALINE": "MARKSMAN RIFLE", "SWAT 5.56": "MARKSMAN RIFLE", "TSARKOV 7.62": "MARKSMAN RIFLE", "AEK-973": "MARKSMAN RIFLE", "AEK-973 FULL AUTO MID RANGE": "MARKSMAN RIFLE", "DM-10": "MARKSMAN RIFLE", "TR2": "MARKSMAN RIFLE", "ESSEX MODEL 07": "MARKSMAN RIFLE", "EBR-14 (MW2)": "MARKSMAN RIFLE", "SP-R 208 (MW2)": "MARKSMAN RIFLE", "LOCKWOOD MK2": "MARKSMAN RIFLE", "TEMPUS TORRENT": "MARKSMAN RIFLE", "CROSSBOW (MW3)": "MARKSMAN RIFLE", "LM-S": "MARKSMAN RIFLE", "SA-B 50": "MARKSMAN RIFLE", "TAQ-M": "MARKSMAN RIFLE", "KAR98K": "MARKSMAN RIFLE", "KVD ENFORCER": "MARKSMAN RIFLE", "MCW 6.8": "MARKSMAN RIFLE", "DM56": "MARKSMAN RIFLE", "MTZ INTERCEPTOR": "MARKSMAN RIFLE",
    // SNIPER
    "VS RECON": "SNIPER", "SHADOW SK": "SNIPER", "XR-3 ION": "SNIPER", "HAWKER HX": "SNIPER", "LW3A1 FROSTLINE": "SNIPER", "SVD": "SNIPER", "LR 7.62": "SNIPER", "AMR MOD 4": "SNIPER", "HDR (BO6)": "SNIPER", "MCPR-300": "SNIPER", "SIGNAL 50": "SNIPER", "VICTUS XMR": "SNIPER", "FJX IMPERIUM": "SNIPER", "CARRACK .300": "SNIPER", "LA-B 330": "SNIPER", "SP-X 80": "SNIPER", "MORS": "SNIPER", "XRK STALKER": "SNIPER", "KATT-AMR": "SNIPER", "LONGBOW": "SNIPER", "KV INHIBITOR": "SNIPER",
    // BATTLE RIFLE
    "LACHMANN-762": "BATTLE RIFLE", "CRONEN SQUALL": "BATTLE RIFLE", "FTAC RECON": "BATTLE RIFLE", "TAQ-V": "BATTLE RIFLE", "SO-14": "BATTLE RIFLE", "DTIR 30-06": "BATTLE RIFLE", "SOA SUBVERTER": "BATTLE RIFLE", "BAS-B": "BATTLE RIFLE", "SIDEWINDER": "BATTLE RIFLE", "MTZ-762": "BATTLE RIFLE", "SVD FULL AUTO DMR": "BATTLE RIFLE",
    // PISTOL
    "JAGER 45": "PISTOL", "VELOX 5.7": "PISTOL", "CODA 9": "PISTOL", "9MM PM": "PISTOL", "GREKHOVA": "PISTOL", "GS45": "PISTOL", "STRYDER .22": "PISTOL", "GRAVEMARK .357": "PISTOL", "P890": "PISTOL", ".50 GS (MW2)": "PISTOL", "X12": "PISTOL", "BASILISK": "PISTOL", "FTAC SIEGE": "PISTOL", "GS MAGNA": "PISTOL", "9MM DAEMON": "PISTOL", "X13 AUTO": "PISTOL", "COR-45": "PISTOL", "RENETTI (MW3)": "PISTOL", "RENETTI (MW3) FULL AUTO + ATTACHMENTS (WZ)": "PISTOL", "RENETTI (MW3) SEMI AUTO + DAMAGE INCREASE (WZ)": "PISTOL", "TYR": "PISTOL", "WSP STINGER": "PISTOL",
    // SPECIAL
    "SIRIIN 9MM": "SPECIAL", "D1.3 SECTOR": "SPECIAL", "X52 RESONATOR": "SPECIAL",};

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
"LETHAL TOOLS ELO OPTIC"};

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

  if (defaultTargetPlatform != TargetPlatform.linux || kIsWeb) {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    } catch (e) {
      debugPrint("Firebase init failed: $e");
    }
  }

  final themeController = ThemeController();
  await themeController.loadSavedTheme();
  
  runApp(
    SyncProvider(
      child: MyApp(themeController: themeController),
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
  final String adsSpeed;
  final String bulletVelocity;
  final String shotsToKill;
  final String ttk2;
  final String range2;
  final String hitscanRange;
  final String? shotRange;
  
  CombatRating? combatRating; 

  WeaponStats({
    required this.ttk1,
    required this.adsSpeed,
    required this.bulletVelocity,
    required this.shotsToKill,
    required this.ttk2,
    required this.range2,
    required this.hitscanRange,
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
  const MyApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {

        final baseTheme = themeController.activeTheme.themeData;
        
        return MaterialApp(
          debugShowCheckedModeBanner: false,
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

  const ArmoryGradientBorder({
    super.key,
    required this.child,
    required this.gradientColors,
    this.strokeWidth = 2.0,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientPainter(
        strokeWidth: strokeWidth,
        radius: borderRadius,
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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

  Future<void> _performPreload() async {
    setState(() => _dataReady = false);
  try {
    final premiumTask = _verifyPremiumStatus();
    final List<String> buildFiles = [
      'assets/Akimbo_202603022137.json', 'assets/Cold_War_Akimbo_202602130024.json',
      'assets/Cold_War_Single_202602130024.json', 'assets/Endgame_BO7_202602130023.json',
      'assets/Multiplayer_BO7_202603041754.json', 'assets/Multiplayer_Cold_War_202603041703.json',
      'assets/Multiplayer_MW19_202602130020.json', 'assets/Multiplayer_MW3_BO6_202602130020.json',
      'assets/REBIRTH_202602130024.json', 'assets/Single_202602130024.json',
      'assets/Special_202602130024.json', 'assets/Warzone_BO6_202602130021.json',
      'assets/Warzone_BO7_202602130021.json', 'assets/Warzone_MW3_MW2_202602130021.json',
      'assets/Zombies_BO7_202602130022.json', 'assets/Zombies_Cold_War_202602130022.json',
      'assets/Zombies_MW3_BO6_202602130022.json',
    ];

    final List<Future<String>> loadFutures = buildFiles.map((path) => loadHotfixedJson(path)).toList();
    loadFutures.add(loadHotfixedJson('assets/Weapon_Names_202602160630.json'));
    loadFutures.add(loadHotfixedJson('assets/Premium_Stats_202602131455.json'));

    final allRawData = await Future.wait(loadFutures);
    
    _isPremiumUser = await premiumTask;
    await Future.delayed(const Duration(milliseconds: 600));

    _loadedWeapons = await compute(_heavyDataProcessing, {
      'buildJsons': allRawData.sublist(0, buildFiles.length),
      'namesJson': allRawData[allRawData.length - 2],
      'statsJson': allRawData.last,
      'filePaths': buildFiles,
    });

    setState(() {
      _dataReady = true;
    });

    _checkTransition();
    
  } catch (e, stack) {
    debugPrint("Background Sync Preload Error: $e");
    FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Sync Preload Failed');
    _dataReady = true;
    _checkTransition();
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
enum AppState { initializing, onboarding, booting, ready }
bool _hasRunBootSequence = false;

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final FocusNode _searchFocusNode = FocusNode();
  List<Weapon> _loadedWeapons = [];
  List<Weapon> displayList = [];
  bool _isPremiumUser = false;
  final _dataReady = true;
  bool showOnboarding = true;
  bool _initialized = false;
  bool _hasRunBootSequence = false;
  AppState _currentState = AppState.initializing;
  bool _isManualReplay = false;

  ConnectionStatus _connectionStatus = ConnectionStatus.offline;
  Timer? _statusTimer;
  final String _ngrokUrl = "https://cherty-frowningly-rickie.ngrok-free.dev";

  Widget _SearchField({required Function(String) onChanged, required ThemeController themeController}) {
  final activeTheme = themeController.activeTheme;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
  final bool isHolographic = activeTheme.isHolographic;
  final bool isCustom = activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;
  final activeFont = themeController.activeFont;
  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

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
    focusNode: _searchFocusNode,
    onChanged: onChanged,
    autocorrect: false,
    enableSuggestions: false,
    textInputAction: TextInputAction.search,
    onSubmitted: (_) => _searchFocusNode.unfocus(),
    onTapOutside: (event) => _searchFocusNode.unfocus(),
    
    style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: activeFont), 
    decoration: InputDecoration(
      hintText: "SEARCH WEAPONS...",
      hintStyle: TextStyle(
        color: Colors.white.withOpacity(0.4), fontSize: 12, fontFamily: activeFont
      ),
      prefixIcon: Icon(Icons.search, color: inputIconColor),
      filled: true,
      fillColor: isCustom 
          ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.98) 
          : activeTheme.themeData.colorScheme.surface.withOpacity(0.9),
      
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: hasSpecialWrapper 
            ? BorderSide.none 
            : BorderSide(
                color: activeBorderColor.withOpacity(0.5), 
                width: 1.5
              ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
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
    finalSearch = _InternalAnimatedBorder(colors: activeTheme.refractionColors, child: textField);
  } else if (isAnemone && _isPremiumUser) {
    finalSearch = ArmoryGradientBorder(gradientColors: activeTheme.borderGradient, borderRadius: 12, child: textField);
  } else if (isCustom && _isPremiumUser) {
    finalSearch = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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

Future<void> _checkOnboardingStatus() async {
  final prefs = await SharedPreferences.getInstance();
  bool needsIntro = prefs.getBool('show_onboarding') ?? true;
  
  setState(() {
    _initialized = true;
    if (needsIntro) {
      _currentState = AppState.onboarding;
    } else {
      _currentState = AppState.ready;
      _runBootSequence(); 
    }
  });
}

void _startFirstTimeBootSequence() async {
  setState(() {
    _currentState = AppState.booting;
  });

  await _performPreload();
  
  await Future.delayed(const Duration(seconds: 3));

  if (mounted) {
    setState(() {
      _currentState = AppState.ready;
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

Widget _buildFirstTimeLoadingVisual() {
  final primary = widget.themeController.activeTheme.themeData.colorScheme.primary;
  return Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ArmoryText(
            "ESTABLISHING NEURAL LINK...",
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
            "LOADING DATA FOR FIRST BOOT",
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

@override
void initState() {
  super.initState();
  _checkOnboardingStatus();
  WidgetsBinding.instance.addObserver(this);
  
  displayList = List.from(widget.preloadedData); 
  _isPremiumUser = widget.initialPremiumStatus;

  _loadStoredCredentials();
  _loadFavorites();
  _startConnectionHeartbeat();
  _runBootSequence();
}

  Future<void> _performPreload() async {
  try {
    final List<String> buildFiles = [
      'assets/Akimbo_202603022137.json', 'assets/Cold_War_Akimbo_202602130024.json',
      'assets/Cold_War_Single_202602130024.json', 'assets/Endgame_BO7_202602130023.json',
      'assets/Multiplayer_BO7_202602130017.json', 'assets/Multiplayer_Cold_War_202603041703.json',
      'assets/Multiplayer_MW19_202602130020.json', 'assets/Multiplayer_MW3_BO6_202602130020.json',
      'assets/REBIRTH_202602130024.json', 'assets/Single_202602130024.json',
      'assets/Special_202602130024.json', 'assets/Warzone_BO6_202602130021.json',
      'assets/Warzone_BO7_202602130021.json', 'assets/Warzone_MW3_MW2_202602130021.json',
      'assets/Zombies_BO7_202602130022.json', 'assets/Zombies_Cold_War_202602130022.json',
      'assets/Zombies_MW3_BO6_202602130022.json',
    ];

    final List<Future<String>> loadFutures = buildFiles.map((path) => loadHotfixedJson(path)).toList();
    loadFutures.add(loadHotfixedJson('assets/Weapon_Names_202602160630.json'));
    loadFutures.add(loadHotfixedJson('assets/Premium_Stats_202602131455.json'));

    final allRawData = await Future.wait(loadFutures);
    _isPremiumUser = widget.initialPremiumStatus;

    _loadedWeapons = await compute(_heavyDataProcessing, {
      'buildJsons': allRawData.sublist(0, buildFiles.length),
      'namesJson': allRawData[allRawData.length - 2],
      'statsJson': allRawData.last,
      'filePaths': buildFiles,
    });

    setState(() {
      displayList = List.from(_loadedWeapons); 
    });
    
  } catch (e, stack) {
    debugPrint("Background Sync Preload Error: $e");
    FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Sync Preload Failed');
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
  WidgetsBinding.instance.removeObserver(this);
  _statusTimer?.cancel();
  _idController.dispose();
  _pinController.dispose();
  _searchFocusNode.dispose();
  super.dispose();
}

@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.resumed) {
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

void _runBootSequence() async {
  if (_hasRunBootSequence || _currentState != AppState.ready) return;
  await Future.delayed(const Duration(milliseconds: 1000));
  if (!mounted) return;
  
  _hasRunBootSequence = true;

  final themeController = widget.themeController;
  final activeTheme = themeController.activeTheme;
  final isCustom = activeTheme.id == 'neon_custom';
  final isHolographic = activeTheme.isHolographic;
  final isAnemone = activeTheme.category == ThemeCategory.anemone;
  final Color themeAccent = isCustom ? themeController.activeAccentColor : Theme.of(context).colorScheme.primary;

  void showTacticalSnack(String message, Color textColor, Duration duration) {
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

  const double topMargin = 10.0;
  const double bottomMargin = 2.0;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: isCustom 
          ? Colors.black 
          : Theme.of(context).colorScheme.surface,
      behavior: SnackBarBehavior.fixed,
      elevation: 0,
      duration: duration,
      padding: EdgeInsets.zero, 
      shape: Border(
        top: BorderSide(
          color: borderColor, 
          width: isCustom ? 2.5 : 1.5,
        ),
      ),
      content: Container(
        padding: const EdgeInsets.only(
          top: topMargin, 
          bottom: bottomMargin,
          left: 15,
          right: 15,
        ),
        child: ArmoryText(
          message,
          themeController: themeController,
          baseFontSize: 12,
          baseStrokeWidth: isCustom ? 2.5 : 1.5,
          color: textColor,
          overrideStrokeColor: Colors.black,
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

  showTacticalSnack("VERIFYING DATA INTEGRITY...", themeAccent, const Duration(seconds: 1));

  await Future.delayed(const Duration(milliseconds: 1200));

  bool updateFound = await _syncData();

  if (updateFound) {
    if (mounted) {
      showTacticalSnack("DOWNLOADING LATEST PATCH...", Colors.amberAccent, const Duration(seconds: 2));
    }
    
    await Future.delayed(const Duration(seconds: 2));
    await _performPreload(); 
    
    if (mounted) {
      showTacticalSnack("SYSTEM UPDATED. RESTART APP TO APPLY.", themeAccent, const Duration(seconds: 3));
    }
  } else {
    if (mounted) {
      showTacticalSnack("SYSTEM UP TO DATE.", themeAccent, const Duration(seconds: 2));
    }
  }
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

          final Color accent = widget.themeController.activeAccentColor;
          final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;
          final Color primary = Theme.of(context).colorScheme.primary;
          final Color simpleBorderColor = Color.lerp(primary, Colors.white, 0.3)!.withOpacity(1.0);

          final double borderWidth = (isNeon || isHolo || isAnemone) ? 2.5 : 1.5;
          final Color containerBg = isNeon ? Colors.black : Theme.of(context).colorScheme.surface;

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
                  child: ValueListenableBuilder<double>(
                    valueListenable: masterBorderNotifier,
                    builder: (context, rotation, _) {
                      final double angle = isHolo ? (rotation * 2 * math.pi) : 0.0;
                      
                      final Alignment begin = (isHolo) 
                          ? Alignment(math.cos(angle), math.sin(angle)) 
                          : Alignment.centerLeft;
                      final Alignment end = (isHolo) 
                          ? Alignment(math.cos(angle + math.pi), math.sin(angle + math.pi)) 
                          : Alignment.centerRight;

                      Gradient? borderGradient;
                      if (isHolo) {
                        borderGradient = LinearGradient(begin: begin, end: end, colors: activeTheme.refractionColors);
                      } else if (isAnemone) {
                        borderGradient = LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: activeTheme.borderGradient);
                      }

                      final Border? activeBorder = (borderGradient == null)
                          ? Border.all(color: isNeon ? coreColor : simpleBorderColor, width: borderWidth)
                          : null;

                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: Container(
                          key: const ValueKey("theme_picker_window"),
                          padding: EdgeInsets.all(borderWidth),
                          decoration: BoxDecoration(
                            color: (isHolo || isAnemone) ? null : containerBg,
                            gradient: borderGradient,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              if (isNeon) BoxShadow(
                                color: accent.withOpacity(0.5),
                                blurRadius: 25,
                                spreadRadius: 2,
                              )
                            ],
                            border: activeBorder,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24 - borderWidth),
                            child: Container(
                              decoration: BoxDecoration(color: containerBg),
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
                                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
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
                          ),
                        ),
                      );
                    },
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
              borderRadius: BorderRadius.circular(8),
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
                duration: const Duration(milliseconds: 1500), 
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
              
              borderRadius: BorderRadius.circular(12),
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
  final Color accentColor = controller.activeAccentColor;
  final Color neonBorderColor = Color.lerp(accentColor, Colors.white, 0.35)!;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF121212),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: ArmoryText(
          "PICK NEON COLOR",
          themeController: controller,
          baseFontSize: 14, 
          color: Colors.white,
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: controller.customColor,
            onColorChanged: (color) => controller.updateCustomColor(color),
            displayThumbColor: true,
            enableAlpha: false,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: neonBorderColor, 
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Text(
                  "DONE",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}


Future<bool> _syncData() async {
  bool performedActualUpdate = false;
  try {
    final response = await http.get(
      Uri.parse("$globalNgrokUrl/cdn/manifest.json"),
      headers: {"ngrok-skip-browser-warning": "true"}
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final manifest = json.decode(response.body);
      final remoteFiles = manifest['files'] as Map<String, dynamic>;
      final prefs = await SharedPreferences.getInstance();
      final directory = await getApplicationDocumentsDirectory();

      for (String fileName in remoteFiles.keys) {
        int remoteVersion = remoteFiles[fileName];
        String storageKey = 'key_$fileName';
        int localVersion = prefs.getInt(storageKey) ?? 0;

        debugPrint("[SYNC] $fileName -> Remote: $remoteVersion | Local: $localVersion");

        if (remoteVersion > localVersion) {
          final fileResponse = await http.get(
            Uri.parse("$globalNgrokUrl/cdn/$fileName"),
            headers: {"ngrok-skip-browser-warning": "true"}
          );

          if (fileResponse.statusCode == 200) {
            final file = File('${directory.path}/$fileName');
            await file.writeAsBytes(fileResponse.bodyBytes);
            await prefs.setInt(storageKey, remoteVersion);
            
            performedActualUpdate = true;
            debugPrint("[SYNC] Successfully patched $fileName to version $remoteVersion");
          }
        }
      }
    }
    return performedActualUpdate; 
    
  } catch (e) {
    debugPrint("⚠️ [SYNC] Error: $e");
    return false;
  }
}

Future<void> _checkConnection() async {
  try {
    final netCheck = await http.get(Uri.parse('https://google.com'))
        .timeout(const Duration(seconds: 5));
    
    if (netCheck.statusCode == 200) {
      try {
        final armoryCheck = await http.get(
          Uri.parse(_ngrokUrl), 
          headers: {"ngrok-skip-browser-warning": "true"}
        ).timeout(const Duration(seconds: 5));

        if (armoryCheck.statusCode == 200) {
          if (_connectionStatus != ConnectionStatus.connected) {
             setState(() => _connectionStatus = ConnectionStatus.connected);
          }
        }
      } catch (e) {
        setState(() => _connectionStatus = ConnectionStatus.tunnelIssue);
      }
    }
  } catch (e) {
    setState(() => _connectionStatus = ConnectionStatus.offline);
  }
}

  final List<String> mainListChips = ["Multiplayer", "Warzone", "Rebirth", "Warzone Prestige", "Special", "Zombies", "Endgame", "Akimbo", "Single"];
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

 Set<String> _favorites = {};

void _showPatchNotes(BuildContext context) {
  final primary = Theme.of(context).colorScheme.primary;

  final List<String> notes = [
    "!FEATURES",
    "ADVANCED LOADOUT VIEWER WITH GLOBAL SEARCH",
    "RANDOMIZER ENGINE WITH EXCLUSION ZONE AND CUSTOMIZABLE RULES",
    "CARD STYLE AUGMENT TREE AND META DASHBOARD",
    "FAVOURITE WEAPON INDEXING",
    "LOGIN SYSTEM",
    "!WHAT'S NEW IN V1.1.0",
    "THEME SELECTOR",
    "FONT SELECTOR",
    "RANKED PROTOCOL",
    "APP-WIDE OPTIMIZATIONS AND THEME DRAWING IMPROVEMENTS",
    "NEW THEME: NEON",
    "!QOL FEATURES",
    "REAL TIME DATA TUNING TUNNEL",
    "LIVE NETWORK DIAGNOSITC STATUS",
    "AUTO WEAPON DATA VALIDATION (REQUIRES RESTART TO APPLY WHEN NEEDED)",
    "SMART SCALING OF FONT TEXT FOR SCREEN COMPATABILITY"
  ];

  showDialog(
  context: context,
  builder: (context) {
    final activeTheme = widget.themeController.activeTheme;
    final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
    final Color accent = widget.themeController.activeAccentColor;
    final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;
    final Color effectivePrimary = isNeon ? coreColor : primary;

    return AlertDialog(
      backgroundColor: isNeon ? Colors.black : const Color(0xFF0D0D0D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isNeon ? coreColor : primary.withOpacity(0.5),
          width: isNeon ? 2.0 : 1.5,
        ),
      ),
      title: Column(
        children: [
          ArmoryText(
            "SYSTEM UPDATES | BETA V1.1.0 XIRCON",
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
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
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
    );
  },
);
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
    });
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

      setState(() => _isPremiumUser = verified);
      
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

  void search(String query) {
    setState(() { displayList = widget.preloadedData.where((w) => w.name.toLowerCase().contains(query.toLowerCase())).toList(); });
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
        borderRadius: BorderRadius.circular(12),
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
          Container(height: 1, color: armoryBlue.withOpacity(0.2)),
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
          style: TextStyle(
            fontFamily: widget.themeController.activeFont,
            color: Colors.white, 
            fontSize: 13
          ),
          decoration: InputDecoration(
            hintText: "Describe the issue and how it occurred if applicable.",
            hintStyle: TextStyle(
              fontFamily: widget.themeController.activeFont, 
              color: armoryBlue.withOpacity(0.4),
              fontSize: 11,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: armoryBlue.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: armoryBlue),
              borderRadius: BorderRadius.circular(8),
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
            side: WidgetStateProperty.all(BorderSide(color: Colors.white.withOpacity(0.1))),
            overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.05)),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
          child: ArmoryText(
            "CANCEL",
            themeController: widget.themeController,
            baseFontSize: 10,
            baseStrokeWidth: 0,
            color: Colors.grey,
          ),
        ),
        
        TextButton(
          onPressed: () async {
            if (bugController.text.isNotEmpty) {
              final note = bugController.text;
              await FirebaseAnalytics.instance.logEvent(
                name: 'dev_symptom_report',
                parameters: {'note': note},
              );
              FirebaseCrashlytics.instance.log("MANUAL_REPORT: $note");

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
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        bottom: 2.0,
                        left: 15,
                        right: 15,
                      ),
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
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
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
  if (!_initialized) return const Scaffold(backgroundColor: Colors.black);

  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 1000),
    child: _buildCurrentStateUI(),
  );
}

Widget _buildCurrentStateUI() {
  switch (_currentState) {
    case AppState.onboarding:
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
      return _buildFirstTimeLoadingVisual();

    case AppState.ready:
    default:
      return _buildMainScaffold();
  }
}

Widget _buildMainScaffold() {
  double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
  final activeTheme = widget.themeController.activeTheme;
  final themeController = widget.themeController;
  final bool isCustom = activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;

  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

  return Scaffold(
    key: const ValueKey('main_armory_ui'),
    backgroundColor: Theme.of(context).colorScheme.surface,
    resizeToAvoidBottomInset: false, 
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
                _SearchField(onChanged: search, themeController: themeController),
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
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 16),
                    ArmoryText(
                      "SYNCHRONIZING DATA...",
                      themeController: themeController,
                      baseFontSize: 12,
                      baseStrokeWidth: 2.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
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
            ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.98) 
            : theme.colorScheme.surface,
        
        border: Border(
          right: BorderSide(
            color: isCustom ? coreColor : theme.colorScheme.primary.withOpacity(0.8), 
            width: isCustom ? 2.5 : 2.5,
          ),
        ),

        boxShadow: isCustom ? [
          BoxShadow(color: accentColor.withOpacity(0.2), blurRadius: 20, spreadRadius: 2)
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
                        ? accentColor.withOpacity(0.3) 
                        : theme.colorScheme.primary.withOpacity(0.1), 
                    width: 1
                  )
                )
              ),
              child: Center(
                child: ArmoryText(
                  "THE ARMORY DRAWER",
                  themeController: themeController,
                  baseFontSize: 16,
                  baseStrokeWidth: 2.5,
                  color: Colors.white,
                  overrideStrokeColor: isCustom ? accentColor : Colors.black,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        
        Divider(color: isCustom ? accentColor : Theme.of(context).colorScheme.primary, height: 3, thickness: 1.5,),

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
                onTap: () => Navigator.push(
                  context, 
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    reverseTransitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (context, animation, secondaryAnimation) => 
                        RandomLoadoutScreen(themeController: widget.themeController),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(1.0, 0.0); 
                    var end = Offset.zero;

                    var curve = Curves.ease; 

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  }
                  ),
                ),
              ),
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
              const Divider(color: Colors.white10, thickness: 1),
              const SizedBox(height: 15),

              _isPremiumUser ? _buildPremiumSection() : _buildAuthSection(),
            ],
          ),
        ),

        Divider(color: isCustom ? accentColor : Theme.of(context).colorScheme.primary, height: 1, thickness: 1.5),
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
          label: "JOIN THE ARMORY DISCORD",
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
          label: "PATCH NOTES",
          icon: Icons.terminal_outlined,
          onTap: () {
            HapticFeedback.mediumImpact(); 
            _showPatchNotes(context);
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
      color: isCustom
      ? theme.colorScheme.surface.withOpacity(0.92)
      : theme.colorScheme.surface.withOpacity(0.92),
      borderRadius: BorderRadius.circular(12),
      border: !isCustom ? Border.all(
        color: aegisColor,
        width: 1.5,
      ) : null,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(aegisIcon, color: isCustom ? coreColor : aegisColor, size: 24),
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
        borderRadius: BorderRadius.circular(12),
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

Widget _buildMinorDrawerTile({required String label, required IconData icon, required VoidCallback onTap}) {
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
              scale: 1.15,
              child: Icon(
                icon,
                size: 16, 
                color: Colors.black,
              ),
            ),
            
            Icon(
              icon,
              size: 16, 
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
      color: isCustom ? coreColor : Theme.of(context).colorScheme.primary,
      overrideStrokeColor: Colors.black,
      letterSpacing: 0.5,
    ),
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
      borderRadius: BorderRadius.circular(12),
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
          color: isCustom 
              ? theme.colorScheme.surface.withOpacity(0.9)
              : theme.colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          
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
            Icon(Icons.stars_rounded, color: isCustom ? coreColor : premiumGold, size: 24),
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
          await prefs.clear();
          setState(() {
            _isPremiumUser = false;
            _idController.clear();
            _pinController.clear();
          });
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
            overrideStrokeColor: isCustom ? Colors.black : Colors.transparent,
          ),
          prefixIcon: Icon(Icons.person_search, color: isCustom ? coreColor : primaryColor),
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
          prefixIcon: Icon(Icons.lock_outline, color: isCustom ? coreColor : primaryColor),
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
            minimumSize: const Size(double.infinity, 45),
            side: BorderSide(color: isCustom ? coreColor : primaryColor, width: 2.0),
            shape: const StadiumBorder(),
            backgroundColor: isCustom ? const Color.fromARGB(255, 0, 0, 0) : Theme.of(context).colorScheme.surface.withOpacity(0.9), 
            elevation: 0,
          ),
          child: ArmoryText(
            "AUTHENTICATE",
            themeController: themeController,
            baseFontSize: 13,
            baseStrokeWidth: 2.5,
            color: Colors.white,
            overrideStrokeColor: isCustom ? accentColor : Colors.black,
            textAlign: TextAlign.center,
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
        child: OutlinedButton.icon(
          onPressed: () => launchUrl(Uri.parse('https://buy.stripe.com/dRm6oH6BFamr8Xe2CddUY00')), 
          icon: Icon(Icons.shopping_cart_outlined, size: 16, color: isCustom ? Colors.white : Colors.amberAccent),
          label: ArmoryText(
            "BUY PREMIUM",
            themeController: themeController,
            baseFontSize: 12,
            baseStrokeWidth: 1.5,
            color: Colors.white,
            overrideStrokeColor: isCustom ? Colors.amberAccent : Colors.black,
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: isCustom ? Colors.black : Theme.of(context).colorScheme.surface.withOpacity(0.9),
            side: BorderSide(color: isCustom ? Color.lerp(Colors.amberAccent, Colors.white, 0.35)! : Colors.amberAccent, width: 1.5), 
            minimumSize: const Size(double.infinity, 45)
          ),
        ),
      ),
      const SizedBox(height: 15)
    ],
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
  Widget cardContent = RepaintBoundary(
    child: Card(
      color: isCustom 
          ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9) 
          : theme.colorScheme.surface.withOpacity(0.7), 
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
          title: ArmoryText(
            weapon.name,
            themeController: themeController,
            baseFontSize: 16,
            baseStrokeWidth: 3.0,
            overrideStrokeColor: Colors.black, 
            color: Colors.white,
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
      child: cardContent,
    );
  } else if (activeTheme.category == ThemeCategory.anemone) {
    finalWidget = RepaintBoundary(
      child: ArmoryGradientBorder(
        gradientColors: activeTheme.borderGradient,
        strokeWidth: 2,
        borderRadius: 12,
        child: cardContent,
      ),
    );
  } else if (isCustom) {
    finalWidget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
        borderRadius: BorderRadius.circular(11),
        child: cardContent,
      ),
    );
  } 
  else {
    finalWidget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.5), 
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

  @override
  void initState() {
    super.initState();

  final keys = widget.weapon.builds.keys.where((k) {
    if (widget.weapon.name == "MAGNUM (CW)" && k == "Multiplayer") {
      return false;
    }
    return true;
  }).toList();

  const order = {
    "MULTIPLAYER FULL AUTO": 0,
    "MULTIPLAYER SEMI AUTO": 1,
    "Multiplayer": 2, 
    "Warzone": 3, 
    "Rebirth": 4, 
    "Warzone Prestige": 5, 
    "Endgame": 6, 
    "Zombies": 7, 
    "Special": 8
  };
  
  keys.sort((a, b) => (order[a] ?? 99).compareTo(order[b] ?? 99));
  
  flatBuilds = [];
  for (var k in keys) { 
    flatBuilds.addAll(widget.weapon.builds[k]!); 
  }
  selectedIndex = 0;
}

@override
Widget build(BuildContext context) {
  final activeTheme = widget.themeController.activeTheme;
  final theme = Theme.of(context);
  final bool isHolographic = activeTheme.isHolographic;
  final bool isCustom = activeTheme.id == 'neon_custom';
  final Color accentColor = widget.themeController.activeAccentColor;

  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

  final currentBuild = flatBuilds[selectedIndex];

  String baseWeaponName = widget.weapon.name.split(" - ")[0].toUpperCase();
  String effectiveImageUrl = widget.weapon.imageUrl;
  
  final bool isSokol = baseWeaponName.contains("SOKOL 545");
  final bool isRebirth = currentBuild.category == "Rebirth";

  WeaponStats? displayStats = (isSokol && isFastMode && currentBuild.alternativeStats != null)
      ? currentBuild.alternativeStats
      : currentBuild.stats;

  final hasStats = displayStats != null && !isRebirth;

  return Scaffold(
    backgroundColor: theme.colorScheme.surface,
    extendBodyBehindAppBar: true, 
    appBar: AppBar(
      title: ArmoryText(
        widget.weapon.name.toUpperCase(),
        themeController: widget.themeController,
        baseFontSize: 18,
        baseStrokeWidth: 2.5,
        overrideStrokeColor: Colors.black,
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
        if (hasStats && showStats && isSokol) _buildFireModeToggle(),
        if (hasStats) ...[
          if (widget.isPremiumUser) ...[
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF0D0D0D),
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
                        setState(() {
                          selectedIndex = index;
                          if (flatBuilds[index].stats == null || flatBuilds[index].category == "Rebirth") {
                            showStats = false;
                          }
                        });
                      },

                      // GAME MODE SELECTORS

                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                        decoration: BoxDecoration(
                          color: (isCustom && sel) 
                              ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9)
                              : (sel ? buildAccent : theme.colorScheme.surface.withOpacity(0.9)),
                          borderRadius: BorderRadius.circular(8),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    if (hasStats) _CombatRatingDisplay(stats: displayStats, themeController: widget.themeController),
                    if (showStats && hasStats && widget.isPremiumUser) _PremiumStatCard(stats: displayStats, themeController: widget.themeController),
                    if (currentBuild.modName != null) 
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8), 
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isCustom 
                                ? const Color(0xFF000000) 
                                : theme.colorScheme.surface.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCustom ? coreColor : theme.colorScheme.primary.withOpacity(0.6), 
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

                    ...currentBuild.attachments.map((att) => _AttachmentTile(
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
    return Container(
      height: 160,
      width: double.infinity,
      color: Colors.transparent,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(26.0), 
          child: _SmartImage(url: url), 
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
        setState(() => isFastMode = !isFastMode);
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

 Widget _AttachmentTile({
    required String text, 
    required bool isStarred, 
    required ThemeController themeController
  }) {
  final activeTheme = themeController.activeTheme;
  final theme = activeTheme.themeData;
  final bool isHolographic = activeTheme.isHolographic;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
  final bool isCustom = activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;

  Widget tileContent = Container(
    margin: (isAnemone || isHolographic || isCustom) ? EdgeInsets.zero : const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface.withOpacity(0.9),
      borderRadius: BorderRadius.circular(10),
      border: (isAnemone || isHolographic || isCustom) ? null : Border.all(
        color: theme.colorScheme.primary.withOpacity(0.15),
      ),
    ),
    child: ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      visualDensity: const VisualDensity(horizontal: 0, vertical: -2), 
      leading: Icon(
        isStarred ? Icons.star : Icons.check_circle,
        color: isStarred ? Colors.amber : (isCustom ? accentColor : theme.colorScheme.primary),
        size: 16,
      ),
      title: ArmoryText(
        text.toUpperCase(),
        themeController: themeController,
        baseFontSize: 13,
        baseStrokeWidth: 2.5,
        color: Colors.white,
        overrideStrokeColor: Colors.black,
        letterSpacing: 0.5,
      ),
    ),
  );

  if (isHolographic) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: _InternalAnimatedBorder(
        colors: activeTheme.refractionColors,
        child: tileContent,
      ),
    );
  } 
  
  else if (isAnemone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ArmoryGradientBorder(
        gradientColors: activeTheme.borderGradient,
        borderRadius: 10,
        child: tileContent,
      ),
    );
  } 

  else if (isCustom) {
    final Color coreColor = Color.lerp(accentColor, Colors.white, 0.45)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), 
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: coreColor, 
            width: 1.5,
          ),
          boxShadow: [

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
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Container(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.92),
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -2), 
              leading: Icon(
                isStarred ? Icons.star : Icons.check_circle,
                color: isStarred ? Colors.amber : coreColor, 
                size: 16,
              ),
              title: ArmoryText(
                text.toUpperCase(),
                themeController: themeController,
                baseFontSize: 13,
                baseStrokeWidth: 2.5,
                color: Colors.white, 
                overrideStrokeColor: Colors.black, 
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  return tileContent;
}
}

class _PremiumStatCard extends StatelessWidget {
  final WeaponStats stats;
  final ThemeController themeController;

  const _PremiumStatCard({
    required this.stats, 
    required this.themeController,
  });

  bool _hasData(String? val) {
    if (val == null) return false;
    final v = val.trim();
    return v.isNotEmpty && v != "-" && v.toLowerCase() != "null";
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = themeController.activeTheme;
    final theme = Theme.of(context);
    final Color accentColor = themeController.activeAccentColor;
    final bool isCustom = activeTheme.id == 'neon_custom';

    final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {

        final Color statTextColor = isCustom ? Colors.white : theme.colorScheme.primary;

        return Container(
          margin: const EdgeInsets.only(top: 8, bottom: 12),
          width: double.infinity,
          decoration: BoxDecoration(
            color: isCustom 
                ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9) 
                : theme.colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12), 
            border: Border.all(
              color: isCustom ? coreColor : theme.colorScheme.primary.withOpacity(0.15),
              width: 2.0,
            ),
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ArmoryText(
                  "ADVANCED WEAPON STATS",
                  themeController: themeController,
                  baseFontSize: 10,
                  baseStrokeWidth: 2.2,
                  color: statTextColor,
                  overrideStrokeColor: isCustom ? accentColor : Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  color: isCustom ? accentColor.withOpacity(0.3) : Colors.white10, 
                  height: 1
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12, left: 4, right: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_hasData(stats.ttk1))
                      _buildExpandedStat("TTK < ${stats.range2}", stats.ttk1, statTextColor),
                    if (_hasData(stats.ttk2))
                      _buildExpandedStat("TTK > ${stats.range2}", stats.ttk2, statTextColor),
                    
                    _buildExpandedStat("ADS SPEED", stats.adsSpeed, statTextColor),
                    _buildExpandedStat("VELOCITY", stats.bulletVelocity, statTextColor),
                    _buildExpandedStat("HITS TO KILL", stats.shotsToKill, statTextColor),
                    
                    if (!_hasData(stats.ttk2) && _hasData(stats.range2))
                      _buildExpandedStat("DROP", stats.range2, statTextColor),

                    _buildExpandedStat("HITSCAN", stats.hitscanRange, statTextColor),

                    if (stats.shotRange != null && _hasData(stats.shotRange))
                      _buildExpandedStat("ONE SHOT", stats.shotRange!, statTextColor),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildExpandedStat(String label, String value, Color textColor) {
    return Expanded(
      child: Center(
        child: _StatItem(
          label: label, 
          value: value,
          themeController: themeController,
          color: textColor,
        )
      )
    );
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
              baseFontSize: 8,
              baseStrokeWidth: isCustom ? 2.2 : 1.8,
              color: isCustom ? baseDisplayColor : baseDisplayColor,
              overrideStrokeColor: isCustom ? accentColor.withOpacity(0.5) : Colors.black,
              letterSpacing: 0.5,
            ),
          ],
        );
      }
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  final String text; 
  final bool isStarred;
  final ThemeController themeController;

  const _AttachmentTile({
    required this.text, 
    this.isStarred = false,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    final primaryBlue = const Color.fromRGBO(2, 91, 207, 1);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8), 
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), 
        borderRadius: BorderRadius.circular(8)
      ), 
      child: ListTile(
        dense: true, 
        leading: Icon(
          isStarred ? Icons.star : Icons.check_circle_outline, 
          size: 18, 
          color: isStarred ? Colors.amber : primaryBlue,
        ), 

        title: ArmoryText(
          text.toUpperCase(),
          themeController: themeController,
          baseFontSize: 13,
          baseStrokeWidth: 2.0,
          color: isStarred ? Colors.amber[100]! : Colors.white,
        ),
      ),
    );
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCustom ? coreColor : theme.colorScheme.primary.withOpacity(0.5), 
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
    return Stack(children: [
      Container(height: 180,
      width: double.infinity,
      alignment: Alignment.center,
        child: _SmartImage(
          url: url,
          width: 300
          )),
        Positioned.fill(
          child:
            Container(
              decoration:
                BoxDecoration(
                  gradient:
                    LinearGradient(
                      begin:
                        Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.9)]))))]);
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
      padding: const EdgeInsets.symmetric(vertical: 4),
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
                color: isNeon ? coreColor : Colors.white,
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
            borderRadius: BorderRadius.circular(12),
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
  const RandomLoadoutScreen({super.key, required this.themeController});

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
      });
    }
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
    if (u.contains('CW') || u.contains('COLDWAR')) return 'cw';
    if (u.contains('MW3')) return 'mw3';
    if (u.contains('MW2')) return 'mw2';
    if (u.contains('MW19')) return 'mw19';
    if (u.contains('WARZONE')) return 'warzone';
    return 'unknown';
  }

  Future<void> _loadCADData() async {
    final String cadResponse = await rootBundle.loadString('assets/CAD_202602140253.json');
    final Map<String, dynamic> cadJson = json.decode(cadResponse);
    final List<dynamic> cadList = cadJson['CAD'];

    final String namesResponse = await rootBundle.loadString('assets/Weapon_Names_202602160630.json');
    final Map<String, dynamic> namesJson = json.decode(namesResponse);
    final List<dynamic> namesData = namesJson['Weapon_Names'] ?? [];

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
    });
  }

void _generate() {
    if (!_isRandomWeapon && _selectedWeapon == null) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.black, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: ArmoryText(
                  "PLEASE SELECT A WEAPON SYSTEM",
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

    List<dynamic> allowedPool = _allWeaponData.where((w) {
      String url = (w['game_image'] ?? "").toString().toUpperCase();

      if (_isExclusionZoneActive && _excludedGames.isNotEmpty) {
        bool isExcluded = _excludedGames.any((game) => url.contains(game.toUpperCase()));
        if (isExcluded) return false;
      }

      String g = _getGameFromUrl(w['game_image']);
      if (_selectedMode == 'WARZONE') {
        return ['bo7', 'bo6', 'mw3', 'mw2'].contains(g);
      } else {
        return ['bo7', 'bo6', 'mw3', 'mw2', 'cw', 'mw19'].contains(g);
      }
    }).toList();

    if (allowedPool.isEmpty) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: Colors.redAccent, width: 1),
          ),
          content: Row(
            children: [
              const Icon(Icons.gpp_maybe_outlined, color: Colors.redAccent, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: ArmoryText(
                  "CRITICAL ERROR: EXCLUSION ZONE EMPTY",
                  themeController: widget.themeController,
                  baseFontSize: 10,
                  baseStrokeWidth: 1.2,
                  color: Colors.redAccent,
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
            orElse: () => allowedPool[_rng.nextInt(allowedPool.length)] as Map<String, dynamic>,
          );
    
    String anchorGame = _getGameFromUrl(anchorWeapon['game_image']);

    for (int i = 0; i < _amount; i++) {
      var weapon = (_lockWeapon && !_isRandomWeapon) 
          ? anchorWeapon 
          : (i == 0 ? anchorWeapon : null);

      if (weapon == null) {
        List<dynamic> constraintPool = [];
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

      List<String> categories = ['barrel', 'stock', 'muzzle', 'rear grip', 'optic', 'underbarrel', 'magazine', 'laser', 'comb', 'trigger action', 'guard', 'bolt', 'arm', 'rail', 'carry handle', 'lever', 'loader', 'wire', 'slings', 'fire mods', 'perk', 'pumps', 'pump grip', 'ammunition'];
      categories.shuffle();
      Map<String, String> picks = {};
      int count = 0;
      for (var cat in categories) {
        if (count >= 5) break;
        String? options = weapon[cat];
        if (options != null && options.trim().isNotEmpty) {
          var list = options.split(',').map((e) => e.trim()).toList();
          picks[cat.replaceAll('_', ' ').toUpperCase()] = list[_rng.nextInt(list.length)];
          count++;
        }
      }

      tempResults.add({'id': 'gen_${timestamp}_$i', 'name': weapon['weapon_name'], 'attachments': picks});
    }

    setState(() {
      _generatedLoadouts = tempResults;
    });
  }

  @override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final activeTheme = widget.themeController.activeTheme;
  final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
  final Color accent = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;
  final Color scaffoldBg = isNeon ? Colors.black : theme.colorScheme.surface;

  return Scaffold(
    backgroundColor: scaffoldBg, 
    resizeToAvoidBottomInset: false, 
    appBar: AppBar(
      backgroundColor: scaffoldBg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: ArmoryText(
        "MODULE: RANDOMIZER",
        themeController: widget.themeController,
        baseFontSize: 14,
        baseStrokeWidth: isNeon ? 2.5 : 2.0,
        color: isNeon ? coreColor : theme.colorScheme.primary,
        letterSpacing: 1.5,
      ),
      leading: IconButton(
        splashColor: isNeon ? coreColor.withOpacity(0.1) : null,
        highlightColor: Colors.transparent,
        hoverColor: isNeon ? Colors.white.withOpacity(0.05) : null,
        icon: Icon(
          Icons.arrow_back_ios, 
          color: isNeon ? coreColor : theme.colorScheme.primary, 
          size: 16
        ),
        onPressed: () => Navigator.pop(context),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2.0),
        child: Container(
          height: 1.0,
          color: isNeon 
              ? accent.withOpacity(0.6) 
              : Theme.of(context).colorScheme.primary,
        ),
      ),
    ),
    body: Stack(
      children: [
        Column(
          children: [
            _buildStatusHeader(theme),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(
                  left: 20, 
                  right: 20, 
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20
                ),
                children: [
                  _buildControlTile(
                    "EXCLUSION ZONE",
                    Switch(
                      value: _isExclusionZoneActive,
                      activeColor: Colors.amberAccent,
                      onChanged: (v) {
                        HapticFeedback.selectionClick();
                        setState(() => _isExclusionZoneActive = v);
                        _saveSettings();
                      },
                    ),
                    theme,
                  ),
                  if (_isExclusionZoneActive) _buildExclusionDropdown(theme),
                  const SizedBox(height: 10),
                  _buildControlTile(
                    "RANDOM WEAPON",
                    ListenableBuilder(
                      listenable: widget.themeController,
                      builder: (context, _) {
                        final isCustom = widget.themeController.activeTheme.id == 'neon_custom';
                        final accent = widget.themeController.activeAccentColor;
                        final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;

                        return Switch(
                          value: _isRandomWeapon,
                          activeColor: isCustom ? coreColor : theme.colorScheme.primary,
                          activeTrackColor: isCustom ? accent.withOpacity(0.4) : null,
                          inactiveThumbColor: Colors.grey[700],
                          inactiveTrackColor: Colors.white10,
                          onChanged: (v) {
                            HapticFeedback.mediumImpact();
                            setState(() => _isRandomWeapon = v);
                          },
                        );
                      }
                    ),
                    theme,
                  ),
                  if (!_isRandomWeapon) ...[
                  const SizedBox(height: 10),
                  _buildOptimizedSearch(theme),
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
                ] else
                  _buildLockedSearchTile(theme),
                  const SizedBox(height: 10),
                  _buildControlTile("GAME MODE", _buildModeDropdown(), theme),
                  const SizedBox(height: 10),
                  _buildControlTile("QUANTITY", _buildQuantityDropdown(), theme),
                  const SizedBox(height: 30),
                  _buildInitializeButton(widget.themeController.activeTheme, theme),
                  const SizedBox(height: 30),
                  ..._generatedLoadouts.map((loadout) => GlitchedResultCard(
                        key: ValueKey(loadout['id']),
                        loadout: loadout,
                        themeController: widget.themeController,
                      )),
                ],
              ),
            ),
          ],
        ),

        IgnorePointer(
          child: RepaintBoundary(
            child: _buildScanlines(),
          ),
        ),
      ],
    ),
  );
}


Widget _buildOptimizedSearch(ThemeData theme) {
  final themeController = widget.themeController;
  final bool isCustom = themeController.activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;

  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

  return Autocomplete<String>(
    optionsBuilder: (val) {
      if (val.text.isEmpty) return const Iterable<String>.empty();
      return _weaponNames.where((s) => s.toLowerCase().contains(val.text.toLowerCase()));
    },
    onSelected: (s) => setState(() => _selectedWeapon = s),
    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
      return Container(
        decoration: isCustom ? BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: focusNode.hasFocus ? [
            BoxShadow(color: accentColor.withOpacity(0.8), blurRadius: 1, spreadRadius: 0.5),
            BoxShadow(color: accentColor.withOpacity(0.3), blurRadius: 15, spreadRadius: 2),
          ] : [],
        ) : null,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          autocorrect: false,
          enableSuggestions: false,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: themeController.activeFont,
          ),
          decoration: _inputDecoration("SEARCH ARMORY...", theme).copyWith(
            fillColor: isCustom ? const Color.fromARGB(255, 0, 0, 0) : theme.colorScheme.surface.withOpacity(0.9),
            
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close, 
                      size: 16, 
                      color: isCustom ? coreColor : theme.colorScheme.primary),
                    onPressed: () {
                      controller.clear();
                      HapticFeedback.selectionClick();
                    })
                : Icon(Icons.search, 
                    size: 16, 
                    color: isCustom ? coreColor.withOpacity(0.6) : theme.colorScheme.primary),
            
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isCustom ? coreColor : theme.colorScheme.primary, 
                width: 2.0
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isCustom ? accentColor.withOpacity(0.4) : Colors.white10, 
                width: 1.0
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildStatusHeader(ThemeData theme) {
  final themeController = widget.themeController;
  final bool isCustom = themeController.activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;
  
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
            color: isCustom ? const Color.fromARGB(255, 0, 0, 0) : primaryColor.withOpacity(0.05),
            border: Border.all(
              color: isCustom ? coreColor.withOpacity(0.4) : primaryColor.withOpacity(0.2),
              width: isCustom ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isCustom ? [
              BoxShadow(color: accentColor.withOpacity(0.1), blurRadius: 10, spreadRadius: -2)
            ] : null,
          ),
          child: Row(
            children: [
              Icon(Icons.bolt, color: isCustom ? coreColor : primaryColor, size: 20),
              const SizedBox(width: 12),
              ArmoryText(
                "SYSTEM READY: SELECT PARAMETERS",
                themeController: themeController,
                baseFontSize: 12,
                baseStrokeWidth: isCustom ? 2.0 : 1.5,
                color: isCustom ? coreColor : primaryColor,
              ),
            ],
          ),
        ),
        
        if (_isExclusionZoneActive) ...[
          const SizedBox(height: 10),
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
                          baseStrokeWidth: 1.5,
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
                          baseStrokeWidth: 1.5,
                          color: isCustom ? coreColor : theme.colorScheme.primary,
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

  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

  return Container(
    margin: const EdgeInsets.only(top: 5),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: BoxDecoration(
      color: isCustom ? const Color.fromARGB(255, 0, 0, 0) : Colors.amberAccent.withOpacity(0.02),
      border: Border.all(
        color: isCustom ? Colors.amberAccent.withOpacity(0.3) : Colors.white.withOpacity(0.05)
      ),
      borderRadius: BorderRadius.circular(12)
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ArmoryText(
          "GAMES TO EXCLUDE",
          themeController: themeController,
          baseFontSize: 10,
          baseStrokeWidth: 1.5,
          color: isCustom ? Colors.white24 : Colors.white38,
        ),
        
        const SizedBox(width: 10),

        Flexible(
          child: PopupMenuButton<String>(
            color: isCustom ? const Color.fromARGB(255, 0, 0, 0) : theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isCustom ? accentColor : Colors.white10),
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
              });
              _saveSettings();
            },
            itemBuilder: (context) {
              List<String> alphabetizedKeys = List.from(_gameKeys)..sort();
              return alphabetizedKeys.map((game) {
                bool isExcluded = _excludedGames.contains(game);
                return CheckedPopupMenuItem(
                  value: game,
                  checked: isExcluded,
                  child: ArmoryText(
                    game,
                    themeController: themeController,
                    baseFontSize: 12,
                    baseStrokeWidth: 1.5,
                    color: isExcluded ? Colors.amberAccent : (isCustom ? coreColor : Colors.white),
                  ),
                );
              }).toList();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isCustom ? Colors.amberAccent.withOpacity(0.6) : Colors.white10
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

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: isCustom ? const Color.fromARGB(255, 0, 0, 0) : theme.colorScheme.surface.withOpacity(0.5),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isCustom ? coreColor.withOpacity(0.4) : theme.colorScheme.primary.withOpacity(0.2),
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
          color: isCustom ? coreColor : theme.colorScheme.primary,
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

  return DropdownButton<String>(
    value: _selectedMode,
    onChanged: (v) {
      HapticFeedback.selectionClick();
      setState(() => _selectedMode = v!);
    },

    dropdownColor: isCustom ? const Color.fromARGB(255, 0, 0, 0) : const Color(0xFF0D0D0D),
    borderRadius: BorderRadius.circular(12),
    underline: const SizedBox(),
    alignment: AlignmentDirectional.centerEnd,
    icon: Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Icon(
        Icons.expand_more, 
        color: isCustom ? coreColor.withOpacity(0.5) : primaryColor.withOpacity(0.5), 
        size: 16
      ),
    ),
    items: ['WARZONE', 'MULTIPLAYER'].map((mode) => DropdownMenuItem(
      value: mode, 
      child: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ArmoryText(
          mode,
          themeController: themeController,
          baseFontSize: 11,
          baseStrokeWidth: isCustom ? 1.8 : 1.5,
          color: primaryColor,
          letterSpacing: 1.2,
          overrideStrokeColor: isCustom ? Colors.black : Colors.transparent,
        ),
      )
    )).toList(),
  );
}

Widget _buildQuantityDropdown() {
  final themeController = widget.themeController;
  final bool isCustom = themeController.activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;

  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final Color primaryColor = isCustom ? coreColor : Theme.of(context).colorScheme.primary;

  return DropdownButton<int>(
    value: _amount,
    onChanged: (v) {
      HapticFeedback.selectionClick();
      setState(() => _amount = v!);
    },
    dropdownColor: isCustom ? const Color.fromARGB(255, 0, 0, 0) : const Color(0xFF0D0D0D),
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
        child: ArmoryText(
          "$e",
          themeController: themeController,
          baseFontSize: 12,
          baseStrokeWidth: isCustom ? 1.8 : 1.5,
          color: primaryColor,
          overrideStrokeColor: isCustom ? Colors.black : Colors.transparent,
        ),
      )
    )).toList(),
  );
}

Widget _buildInitializeButton(ArmoryTheme activeTheme, ThemeData theme) {
  final isCustom = activeTheme.id == 'neon_custom';
  final isHolographic = activeTheme.isHolographic;
  final isStandardPath = !isCustom && !isHolographic;
  
  final accent = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;

  final Color buttonFill = isCustom 
      ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.94) 
      : theme.colorScheme.surface.withOpacity(0.9);

  final Color borderFill = isCustom 
      ? coreColor 
      : (activeTheme.borderGradient.isNotEmpty 
          ? activeTheme.borderGradient.first 
          : theme.colorScheme.primary);

  Widget button = SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: _generate,
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
        overrideStrokeColor: (isCustom || isHolographic) ? Colors.black : Colors.transparent,
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
  final bool isCustom = themeController.activeTheme.id == 'neon_custom';
  final Color accentColor = themeController.activeAccentColor;

  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
  final Color primaryColor = isCustom ? coreColor : theme.colorScheme.primary;

  return Container(
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    decoration: BoxDecoration(
      color: isCustom ? const Color.fromARGB(255, 0, 0, 0) : Colors.white.withOpacity(0.02), 
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isCustom 
            ? accentColor.withOpacity(0.2)
            : Colors.white10, 
        width: 1,
      ),
    ),
    child: Row(
      children: [

        Icon(
          Icons.lock_outline, 
          color: isCustom ? accentColor.withOpacity(0.6) : primaryColor.withOpacity(0.5), 
          size: 14
        ), 
        const SizedBox(width: 12), 
        
        Expanded(
          child: ArmoryText(
            "SEARCH LOCKED: RANDOM MODE ACTIVE",
            themeController: themeController,
            baseFontSize: 9,
            baseStrokeWidth: 1.5,
            color: isCustom ? coreColor.withOpacity(0.4) : Colors.white38,
            overrideStrokeColor: isCustom ? Colors.black : Colors.transparent,
          ),
        ),
      ],
    ),
  );
}

  Widget _buildScanlines() {
    return IgnorePointer(
      child: Stack(
        children: [
          Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white.withOpacity(0.02), Colors.transparent, Colors.black.withOpacity(0.05)]))),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(), itemCount: 500,
            itemBuilder: (context, index) => Container(height: 1, color: Colors.black.withOpacity(0.08)),
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

class _GlitchedResultCardState extends State<GlitchedResultCard> {
  bool _showText = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _showText = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeController = widget.themeController;
    final bool isCustom = themeController.activeTheme.id == 'neon_custom';
    final Color accentColor = themeController.activeAccentColor;

    final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;
    final Color primaryColor = isCustom ? coreColor : Theme.of(context).colorScheme.primary;

    return AegisGlitchEffect(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isCustom ? const Color.fromARGB(255, 0, 0, 0) : Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCustom ? coreColor : primaryColor.withOpacity(0.3),
            width: isCustom ? 2.0 : 1.0,
          ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedOpacity(
              opacity: _showText ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: ArmoryText(
                widget.loadout['name'].toString().toUpperCase(),
                themeController: themeController,
                baseFontSize: 20,
                baseStrokeWidth: isCustom ? 3.0 : 2.5,
                color: primaryColor,
                overrideStrokeColor: isCustom ? Colors.black : Colors.transparent,
              ),
            ),
            
            const SizedBox(height: 12),
            Divider(
              color: isCustom ? accentColor.withOpacity(0.2) : Colors.white10,
              thickness: 1,
            ), 
            const SizedBox(height: 12),

            AnimatedOpacity(
              opacity: _showText ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Column(
                children: (widget.loadout['attachments'] as Map<String, dynamic>).entries.map<Widget>((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chevron_right, 
                          color: isCustom ? coreColor.withOpacity(0.7) : primaryColor, 
                          size: 14
                        ),
                        const SizedBox(width: 8),

                        Expanded(
                          flex: 2,
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.scaleDown,
                            child: ArmoryText(
                              "${e.key.toString().toUpperCase()}:",
                              themeController: themeController,
                              baseFontSize: 10,
                              baseStrokeWidth: 1.5,
                              color: Colors.white38,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: FittedBox(
                            alignment: Alignment.centerRight,
                            fit: BoxFit.scaleDown,
                            child: ArmoryText(
                              e.value.toString().toUpperCase(),
                              themeController: themeController,
                              baseFontSize: 11,
                              baseStrokeWidth: 1.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
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
      margin: const EdgeInsets.only(top: 2, bottom: 2), 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
        borderRadius: BorderRadius.circular(11),
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
                  baseStrokeWidth: isCustom ? 2.5 : 0,
                  color: isCustom ? Colors.white : Colors.black,
                  overrideStrokeColor: isCustom ? ratingColor : Colors.transparent,
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
    String fileName = "${key.replaceAll(" ", "_")}_202602141947.json";

    try {
      final String response = await loadHotfixedJson('assets/$fileName'); 
      final data = json.decode(response);
      if (data[key] != null) {
        List<AugmentItem> loaded = (data[key] as List).map((i) => AugmentItem.fromJson(i)).toList();
        loaded.sort((a, b) => a.name.compareTo(b.name));
        setState(() { items = loaded; isLoading = false; });
      }
    } catch (e) {
      debugPrint("Load Error: $e");
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
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: borderColor, 
                  width: isActive ? 2 : 1
                ),
                boxShadow: (isCustom && isActive) ? [
                  BoxShadow(color: accentColor.withOpacity(0.6), blurRadius: 1, spreadRadius: 0.5),
                  BoxShadow(color: accentColor.withOpacity(0.2), blurRadius: 12, spreadRadius: 1),
                ] : null,
              ),
              child: Center(
                child: ArmoryText(
                  cat,
                  themeController: themeController,
                  baseFontSize: 9,
                  baseStrokeWidth: isActive ? 2.5 : 1.5,
                  color: isCustom 
                      ? (isActive ? coreColor : accentColor.withOpacity(0.4))
                      : (isActive ? themePrimary : Colors.white38),
                  letterSpacing: 1.1,
                ),
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
  final Color coreColor = Color.lerp(accentColor, Colors.white, 0.35)!;

  return Scaffold(
    backgroundColor: const Color(0xFF000000), 
    appBar: AppBar(
      centerTitle: true,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: const Color(0xFF000000),
      title: ArmoryText(
        "AUGMENT TREE", 
        themeController: themeController, 
        baseFontSize: 16,
        baseStrokeWidth: isCustom ? 3.0 : 2.0, 
        color: isCustom ? coreColor : Colors.white
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: isCustom ? accentColor.withOpacity(0.6) : Theme.of(context).colorScheme.primary,
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

  Map<String, dynamic> _parseAugment(String raw) {
    String clean = raw.replaceAll(RegExp(r'>?\s?BO7\s?|BO7\s?>?|>'), "").trim();
    List<String> parts = clean.split("|");
    String baseRaw = parts[0].trim();
    String? bo7Raw = parts.length > 1 ? parts[1].trim() : null;
    String formatChoice(String text) => text.replaceAll("/", " [OR] ").trim();

    return {
      "base": formatChoice(baseRaw),
      "bo7": bo7Raw != null ? formatChoice(bo7Raw.replaceAll("+", "")) : null,
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
      child: Text("OR", style: TextStyle(color: color.withOpacity(0.6), fontSize: 8, fontWeight: FontWeight.bold)),
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
        borderRadius: BorderRadius.circular(12), 
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
      color: bo7Amber.withOpacity(0.5)
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: fill, 
        borderRadius: BorderRadius.circular(12), 
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
            _renderAugmentText(minor['bo7'], isBO7: true),
            const SizedBox(height: 10),
          ],
          if (major['bo7'] != null) ...[
            buildSubLabel(major['isReplacement'] ? "MAJOR AUGMENT REPLACEMENT" : "MAJOR EVOLUTION:"),
            _renderAugmentText(major['bo7'], isBO7: true),
          ],
        ],
      ),
    );
  }

@override
Widget build(BuildContext context) {
  final activeTheme = themeController.activeTheme;
  final bool isHolo = activeTheme.isHolographic;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone || activeTheme.borderGradient.isNotEmpty;
  
  final accent = themeController.activeAccentColor;
  final Color coreColor = _getCore(accent);
  final double borderWidth = (_isNeon || isHolo || isAnemone) ? 2.5 : 1.0;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    child: ValueListenableBuilder<double>(
      valueListenable: masterBorderNotifier,
      builder: (context, rotation, _) {

        final double angle = rotation * 2 * math.pi; 
        final Alignment begin = isHolo 
            ? Alignment(math.cos(angle), math.sin(angle)) 
            : Alignment.centerLeft;
            
        final Alignment end = isHolo 
            ? Alignment(math.cos(angle + math.pi), math.sin(angle + math.pi)) 
            : Alignment.centerRight;

        Gradient? borderGradient;
        if (isHolo) {
          borderGradient = LinearGradient(
            begin: begin, 
            end: end, 
            colors: activeTheme.refractionColors,
            tileMode: TileMode.clamp,
          );
        } else if (isAnemone) {
          borderGradient = LinearGradient(
            begin: begin,
            end: end,
            colors: activeTheme.borderGradient,
            tileMode: TileMode.clamp,
          );
        }

        return Stack(
          children: [
            if (borderGradient != null)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: borderGradient,
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
              
            Padding(
              padding: EdgeInsets.all(borderWidth),
              child: Container(
                decoration: BoxDecoration(
                  color: _isNeon ? Colors.black : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(28 - borderWidth),
                  border: borderGradient == null 
                      ? Border.all(
                          color: _isNeon ? coreColor : Theme.of(context).colorScheme.primary, 
                          width: borderWidth
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
                  borderRadius: BorderRadius.circular(28 - borderWidth),
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Center(child: Image.network(item.image, height: 130, fit: BoxFit.contain)),
                      const SizedBox(height: 20),
                      Center(
                        child: ArmoryText(
                          item.name.toUpperCase(), 
                          themeController: themeController, 
                          baseFontSize: 20, 
                          baseStrokeWidth: (_isNeon || isHolo || isAnemone) ? 4.0 : 3.0,
                          color: Colors.white
                        )
                      ),
                      const SizedBox(height: 25),
                      _buildStandardBox("MINOR AUGMENT", _parseAugment(item.minor)['base']!, Theme.of(context).colorScheme.primary),
                      _buildStandardBox("MAJOR AUGMENT", _parseAugment(item.major)['base']!, Colors.purpleAccent),
                      _buildBO7Box(_parseAugment(item.minor), _parseAugment(item.major)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }
    ),
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

    final String weaponResponse = await loadHotfixedJson('assets/Weapon_Names_202602160630.json');
    final Map<String, dynamic> weaponData = json.decode(weaponResponse);
    final List<dynamic> weaponList = weaponData['Weapon_Names'] ?? [];

    String? cwLogo = weaponList.firstWhere((w) => w['weapon_name'].toString().contains('(CW)'), orElse: () => null)?['game_image'];
    String? mw3Logo = weaponList.firstWhere((w) => w['weapon_name'].toString().contains('MW3'), orElse: () => null)?['game_image'];

    final String metaResponse = await loadHotfixedJson('assets/META_202602160120.json');
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
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
                ? accent.withOpacity(0.6) 
                : Theme.of(context).colorScheme.primary,
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
        borderRadius: BorderRadius.circular(10),
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
                borderRadius: BorderRadius.circular(8),
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

    if (type == "SPECIAL") {
    return 'assets/Special_202602130024.json'; 
  }

    if (type.contains("(WZ)")) {
      if (game == "BO7") return 'assets/Warzone_BO7_202602130021.json';
      if (game == "BO6") return 'assets/Warzone_BO6_202602130021.json';
      if (game == "MW2") return 'assets/Warzone_MW3_MW2_202602130021.json';
      if (game == "MW3") return 'assets/Warzone_MW3_MW2_202602130021.json';
    } 
    
    if (type == "MULTIPLAYER") {
      if (game == "BO7") return 'assets/Multiplayer_BO7_202603041754.json';
      if (game == "BO6") return 'assets/Multiplayer_MW3_BO6_202602130020.json';
      if (game == "CW") return 'assets/Multiplayer_Cold_War_202603041703.json';
      if (game == "MW2") return 'assets/Multiplayer_MW3_BO6_202602130020.json';
      if (game == "MW3") return 'assets/Multiplayer_MW3_BO6_202602130020.json';
      if (game == "MW19") return 'assets/Multiplayer_MW19_202602130020.json';
    }

    if (type == "ZOMBIES") {
      if (game == "BO7") return 'assets/Zombies_BO7_202602130022.json';
      if (game == "BO6") return 'assets/Zombies_MW3_BO6_202602130022.json';
      if (game == "CW") return 'assets/Zombies_Cold_War_202602130022.json';
      if (game == "MW2") return 'assets/Zombies_MW3_BO6_202602130022.json';
      if (game == "MW3") return 'assets/Zombies_MW3_BO6_202602130022.json';
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
      debugPrint("🎯 Warzone Special Detected: $cardName. Checking Special JSON...");
      const specialPath = 'assets/Special_202602130024.json';
      try {
        final response = await loadHotfixedJson(specialPath);
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
        // Normalize the name from the JSON
        String itemName = (item['weapon_name'] ?? item['name'] ?? "").toString().toUpperCase().trim();
        
        // Normalize your target name
        String target = cardName.toUpperCase().trim();

        // 1. Exact match (should hit "MAGNUM (CW)")
        if (itemName == target) return true;

        // 2. Fuzzy match (handles hidden spaces in JSON)
        if (itemName.contains(target) || target.contains(itemName)) return true;

        return false;
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
      if (match == null) debugPrint("❌ TOTAL MISS: No match for $cardName");
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

  final double borderWidth = (isNeon || isHolo || isAnemone) ? 2.0 : 1.5;

  bool isRanked = widget.weapon.rank != null;
  String cleanName = widget.weapon.name
      .replaceAll('•', '')
      .replaceAll(RegExp(r'^\d+\.\s?'), '')
      .trim()
      .toUpperCase();

  return ValueListenableBuilder<double>(
    valueListenable: masterBorderNotifier,
    builder: (context, rotation, _) {

      final double angle = isHolo ? (rotation * 2 * math.pi) : 0.0; 

      final Alignment begin = isHolo 
          ? Alignment(math.cos(angle) * 1.5, math.sin(angle) * 1.5)
          : Alignment.centerLeft;
          
      final Alignment end = isHolo 
          ? Alignment(math.cos(angle + math.pi) * 1.5, math.sin(angle + math.pi) * 1.5)
          : Alignment.centerRight;

      Gradient? universalGradient;
      Color? universalSolidColor;

      if (isHolo) {
        universalGradient = LinearGradient(
          begin: begin, 
          end: end, 
          colors: activeTheme.refractionColors,
        );
      } else if (isAnemone) {
        universalGradient = LinearGradient(
          begin: begin, 
          end: end, 
          colors: activeTheme.borderGradient,
        );
      } else if (isNeon) {
        universalSolidColor = coreColor;
      } else {
        universalSolidColor = isRanked ? Colors.amberAccent : primary.withOpacity(0.5);
      }

      return Stack(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            decoration: BoxDecoration(
              color: universalSolidColor,
              gradient: universalGradient, 
              borderRadius: BorderRadius.circular(28),
              boxShadow: isNeon ? [
                BoxShadow(color: accent.withOpacity(0.8), blurRadius: 4, spreadRadius: 0.5),
                BoxShadow(color: accent.withOpacity(0.2), blurRadius: 15, spreadRadius: 1),
              ] : null,
            ),
            padding: EdgeInsets.all(borderWidth),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28 - borderWidth),
              child: Container(
                decoration: BoxDecoration(
                  color: isNeon ? Colors.black : Theme.of(context).colorScheme.surface,
                ),
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
            ),
          ),
          
          if (widget.weapon.gameImage != null)
            Positioned(
              top: 45,
              right: 25,
              child: Opacity(opacity: 0.8, child: Image.network(widget.weapon.gameImage!, width: 45)),
            ),
        ],
      );
    },
  );
}

Widget _buildBack(Color primary) {
  final activeTheme = widget.themeController.activeTheme;
  final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
  final bool isHolo = activeTheme.isHolographic;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
  
  final Color accent = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;
  final double borderWidth = (isNeon || isHolo || isAnemone) ? 2.0 : 1.5;

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

  return ValueListenableBuilder<double>(
    valueListenable: masterBorderNotifier,
    builder: (context, rotation, _) {
      final double angle = isHolo ? (rotation * 2 * math.pi) : 0.0; 
      
      final Alignment begin = isHolo 
          ? Alignment(math.cos(angle) * 1.5, math.sin(angle) * 1.5)
          : Alignment.centerLeft;
          
      final Alignment end = isHolo 
          ? Alignment(math.cos(angle + math.pi) * 1.5, math.sin(angle + math.pi) * 1.5)
          : Alignment.centerRight;

      Gradient? universalGradient;
      Color? universalSolidColor;

      if (isHolo) {
        universalGradient = LinearGradient(
          begin: begin, end: end, colors: activeTheme.refractionColors,
        );
      } else if (isAnemone) {
        universalGradient = LinearGradient(
          begin: begin, end: end, colors: activeTheme.borderGradient,
        );
      } else if (isNeon) {
        universalSolidColor = coreColor;
      } else {
        universalSolidColor = isRanked ? Colors.amberAccent : primary.withOpacity(0.5);
      }

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        decoration: BoxDecoration(
          color: universalSolidColor,
          gradient: universalGradient, 
          borderRadius: BorderRadius.circular(28),
          boxShadow: isNeon ? [
            BoxShadow(color: accent.withOpacity(0.8), blurRadius: 4, spreadRadius: 0.5),
            BoxShadow(color: accent.withOpacity(0.2), blurRadius: 15, spreadRadius: 1),
          ] : null,
        ),
        padding: EdgeInsets.all(borderWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28 - borderWidth),
          child: Container(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 20),
            decoration: BoxDecoration(
              color: isNeon ? Colors.black : Theme.of(context).colorScheme.surface,
            ),
            child: Column(
              children: [
                ArmoryText(
                  "ATTACHMENTS",
                  themeController: widget.themeController,
                  baseFontSize: 12,
                  baseStrokeWidth: 2.0,
                  color: isNeon ? coreColor : primary,
                ),
                const Divider(color: Colors.white10, height: 30, thickness: 0.5),
                
                Expanded(
                  child: _isSearching 
                    ? Center(child: CircularProgressIndicator(color: primary))
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
                                      attachments[i].toUpperCase(),
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
                       color: isNeon ? coreColor : primary
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
    },
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
      color: isNeon ? Colors.black : (isRanked ? effectiveColor : effectiveColor.withOpacity(0.1)),
      borderRadius: BorderRadius.circular(4),
      border: isNeon ? Border.all(
        color: effectiveColor, 
        width: 1.5
      ) : null,
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
          color: isNeon ? coreColor : primary,
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
      String modeKey = "Multiplayer";
      String? modName = item['mod'] ?? item['mod_name']; 
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

        if (upper == "SIGHT") return;

        if (_opticDictionary.any((optic) => upper.contains(optic))) {
           starredAttachments.add(val);
        }
        
        cleanAttachments.add(val.replaceAll('\\', ''));
      }

      for (int k = 1; k <= 8; k++) processAttachment(item['attach_$k']);
      processAttachment(item['recommended_sight_shooting_style']);

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
      bool isWarzoneType = (modeKey == "Warzone" || modeKey == "Rebirth" || modeKey == "Warzone Prestige");
      bool isSpecialType = (modeKey == "Special");

      if (isWarzoneType || isSpecialType) {
        String searchName = rawName.toUpperCase();
        String searchMod = modName?.toUpperCase() ?? "";
        String combinedSearch = "$searchName $searchMod".trim();
        
        if (searchName.contains("SOKOL 545")) {
          buildStats = statsLookup["SOKOL 545 (SLOW)"];
          alternativeStats = statsLookup["SOKOL 545 (FAST)"];
        } else {
          buildStats = statsLookup[combinedSearch] ?? (isWarzoneType ? statsLookup[searchName] : null);
        }

        if (buildStats != null && isWarzoneType) {
          bool isAkimboBuild = rawName.toUpperCase().contains("AKIMBO") || searchMod.contains("AKIMBO");
          String? archetype = _archetypeLookup[combinedSearch] ?? _archetypeLookup[searchName] ?? _archetypeLookup[baseName.toUpperCase()];
          if (archetype != null) {
            buildStats.combatRating = calculateCombatRatingStatic(buildStats, archetype, isAkimboBuild);
            if (alternativeStats != null) alternativeStats.combatRating = calculateCombatRatingStatic(alternativeStats, archetype, isAkimboBuild);
          }
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
    double clean(String? val) {
      if (val == null || val == "-" || val.toLowerCase() == "null") return 0;
      return double.tryParse(val.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    }

    double t1 = clean(stats.ttk1);
    double t2 = clean(stats.ttk2);
    double ads = clean(stats.adsSpeed);
    double vel = clean(stats.bulletVelocity);

    double rawScore = 0;
    double deduction = 0;
    String arch = archetype?.toUpperCase().trim() ?? "";

    if (arch == "SNIPER") {
      double baseAnchor;
      if (vel >= 1350) baseAnchor = 450;
      else if (vel >= 1300) baseAnchor = 560;
      else if (vel >= 1200) baseAnchor = 650;
      else baseAnchor = 750;
      rawScore = baseAnchor + (ads * 0.1);
    } else {
      if (isAkimbo) {
        rawScore = (t1 * 0.7) + (t2 * 0.3);
      } else {
        rawScore = (t1 * 0.5) + (ads * 0.3) + (t2 * 0.2);
      }

      Map<String, double> deductions = {
        "AR": 45, "LMG": 85, "SMG": 30, "MARKSMAN RIFLE": 30,
        "BATTLE RIFLE": 40, "PISTOL": 120, "SHOTGUN": 160, "AKIMBO": 60
      };

      String key = (arch == "PISTOL" && isAkimbo) ? "AKIMBO" : arch;
      deduction = deductions[key] ?? 0;
    }

    double combatScore = rawScore - deduction;

    if (combatScore < 540) return CombatRating("S", "Top tier pick for its class. Reliable and hard hitting.");
    if (combatScore < 610) return CombatRating("A", "Competitive choice, but not strong enough for S tier.");
    if (combatScore < 710) return CombatRating("B", "Usable, but will feel noticeably weaker than meta picks.");
    return CombatRating("C", "Vastly out-classed. Use with caution.");
  } catch (e) {
    return null;
  }
}

class SweepBorderPainter extends CustomPainter {
  final List<Color> colors;
  final double animationValue;
  final double strokeWidth;
  final double borderRadius;

  SweepBorderPainter({
    required this.colors,
    required this.animationValue,
    this.strokeWidth = 2.0,
    this.borderRadius = 12.0,
  });

  @override
void paint(Canvas canvas, Size size) {
  final rect = Offset.zero & size;
  final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
  final double xOffset = animationValue * 2.0; 

  final Paint paint = Paint()
    ..isAntiAlias = true
    ..shader = LinearGradient(
      begin: Alignment(xOffset - 1.0, -0.5), 
      end: Alignment(xOffset + 1.0, 0.5),
      colors: colors,
      tileMode: TileMode.repeated,
    ).createShader(rect)
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth;

  canvas.drawRRect(rrect, paint);
}

  @override
  bool shouldRepaint(SweepBorderPainter oldDelegate) => 
      oldDelegate.animationValue != animationValue; 
}

class _InternalAnimatedBorder extends StatelessWidget {
  final List<Color> colors;
  final Widget child;

  const _InternalAnimatedBorder({super.key, required this.colors, required this.child});

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
              strokeWidth: 2.5,
            ),

            child: staticChild, 
          );
        },
      ),
    );
  }
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
    for (var url in images) {
      precacheImage(NetworkImage(url), context);
    }
  }
}

  final List<Map<String, dynamic>> _slides = [
    {
      "title": "WELCOME TO THE ARMORY",
      "desc": "THE NEXT GENERATION OF THE ARMORY IS HERE. COME ON IN, IT'S GOOD TO HAVE YOU. LET'S GET YOU UP TO SPEED ON HOW WE DO IT AROUND HERE.",
      "images": ["https://res.cloudinary.com/dctlpj7fg/image/upload/v1771647135/ios_htmmoe.png"]
    },
    {
      "title": "HOME SCREEN",
      "desc": "SCROLL, OR SEARCH FOR YOUR DESIRED WEAPONS TO FIND WHAT YOU NEED. TAKE IT A STEP FURTHER AND ADD THEM TO YOUR FAVOURITES SO THEY APPEAR FIRST IN THE LIST FOR EASY ACCESS!",
      "images": ["https://res.cloudinary.com/dctlpj7fg/image/upload/v1771713738/Screenshot_20260221_165020_md1gmz.jpg"]
    },
    {
      "title": "SETTINGS DRAWER",
      "desc": "ACCESS MODULES, LOG IN TO ACCESS PREMIUM BENEFITS, READ PATCH NOTES, AND MORE. NEED A REFRESHER? COME BACK HERE WITH THE INTRO SCREEN BUTTON IN CASE YOU EVER GET LOST.",
      "images": ["https://res.cloudinary.com/dctlpj7fg/image/upload/v1771713738/Screenshot_20260221_173651_eb78fl.jpg"]
    },
    {
      "title": "MODULE - META PICKS",
      "desc": "STAY ON TOP OF YOUR GAME AT ALL TIMES. NEVER AGAIN WILL YOU WONDER WHAT THE BEST PICKS ARE, OR BE CONFUSED WHAT'S WORTH USING ANYMORE FROM OLDER TITLES. ONLY THE BEST MAKE IT ON THIS LIST, AND IT'S ALWAYS UP TO DATE.",
      "images": [
        "https://res.cloudinary.com/dctlpj7fg/image/upload/v1772230207/Screenshot_20260227_163221_qxaqvu.jpg",
        "https://res.cloudinary.com/dctlpj7fg/image/upload/v1772230207/Screenshot_20260227_163223_miuhrd.jpg" 
      ]
    },
    {
      "title": "MODULE - RANDOMIZER",
      "desc": "ADD SOME CHAOS TO GAME NIGHT. GENERATE UP TO 10 WEAPONS AT A TIME, UTILIZE THE EXCLUSION ZONE TO BLOCK ENTIRE GAMES WHEN PICKING WEAPONS, LOCK YOUR CHOICE IN SO YOU ONLY GET RESULTS FOR THE WEAPON YOU WANT, AND MORE.",
      "images": [
        "https://res.cloudinary.com/dctlpj7fg/image/upload/v1772398546/Screenshot_20260301_154943_xws36e.jpg", 
      ]
    },
    {
      "title": "THEMES",
      "desc": "MAKE ARMORY APP YOURS. WITH TONS OF THEMES AND EVEN MORE FONT CHOICES, WE TAKE CUSTOMIZATION VERY SERIOUSLY AROUND HERE. PREMIUM MEMBERS WILL HAVE ACCESS TO EXCLUSIVE THEMES THAT TAKE IT A STEP FURTHER.",
      "images": [
        "https://res.cloudinary.com/dctlpj7fg/image/upload/v1772230207/Screenshot_20260227_162907_gdvq97.jpg",
        "https://res.cloudinary.com/dctlpj7fg/image/upload/v1772230207/Screenshot_20260227_162925_z3epnj.jpg",
      ]
    },
    {
      "title": "PREMIUM BENEFITS",
      "desc": "ON TOP OF EXCLUSIVE THEMES, YOU ALSO GET ACCESS TO THE ARMORY'S ADVANCED WEAPON STATS, A SYSTEM BUILT FOR THOSE THAT REQUIRE ABSOLUTE PRECISION WHEN IT COMES TO MAKING EVERY MILLISECOND IN AN ENGAGEMENT MATTER. HOW FAST WILL THIS GUN DOWN AT 27 METERS? CAN THIS SNIPER ONE SHOT? NOW YOU KNOW.",
      "images": [
        "https://res.cloudinary.com/dctlpj7fg/image/upload/v1771713470/Screenshot_20260221_171720_qymkjm.jpg",
        "https://res.cloudinary.com/dctlpj7fg/image/upload/v1772230992/Screenshot_20260227_172240_pmyd1v.jpg"
      ]
    },
    {
      "title": "LOGGING IN",
      "desc": "IF YOU'RE A PREMIUM MEMBER WITH ARMORY BOT, YOU'RE IN LUCK BECAUSE ARMORY APP IS MOVING IN NEXT DOOR AND IS VERY EXCITED TO MINGLE. LOG IN WITH YOUR DISCORD ID AND SECRET PIN TO GET ALL YOUR BENEFITS SYNCED UP ACROSS BOTH SERVICES. HOW DO YOU GET YOUR PIN? HEAD ON OVER TO ARMORY BOT AND USE THE /armorypin COMMAND AND IT WILL GET YOU SORTED.",
      "images": [
        "https://res.cloudinary.com/dctlpj7fg/image/upload/v1772235502/Screenshot_20260227_183803_wshl0m.jpg",
        "https://res.cloudinary.com/dctlpj7fg/image/upload/v1772235424/Screenshot_20260227_182644_Discord_ks4aea.jpg"
      ]
    },
    {
      "title": "TIME TO DEPLOY",
      "desc": "WELL DONE, YOU'VE PASSED INSPECTION. LET'S GET YOU KITTED UP AND READY TO HIT THE FIELD SPRINTING. STAY FROSTY, YOUR SQUAD DEPENDS ON IT.",
      "images": ["https://res.cloudinary.com/dctlpj7fg/image/upload/v1771647135/ios_htmmoe.png"]
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
  return Container(
    margin: EdgeInsets.symmetric(horizontal: isRow ? 8 : 0),
    decoration: BoxDecoration(
      border: Border.all(color: armoryBlue, width: 2),
      boxShadow: [
        BoxShadow(color: armoryBlue.withOpacity(0.3), blurRadius: 10)
      ],
    ),
    child: ClipRRect(
      child: Image.network(
        url,
        fit: BoxFit.contain, 
        loadingBuilder: (context, child, progress) => 
          progress == null ? child : const Center(child: CircularProgressIndicator(color: armoryBlue)),
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
      final String rankedResponse = await loadHotfixedJson('assets/Ranked_202602202346.json');
      final String namesResponse = await loadHotfixedJson('assets/Weapon_Names_202602160630.json');
      
      final Map<String, dynamic> rankedDecoded = json.decode(rankedResponse);
      final Map<String, dynamic> namesDecoded = json.decode(namesResponse);
      
      final List<dynamic> rankedData = rankedDecoded['Ranked'] ?? [];
      final List<dynamic> masterNamesList = namesDecoded['Weapon_Names'] ?? [];

      List<Weapon> tempWeapons = rankedData.where((item) {
        final String availability = (item['availability'] ?? "YES").toString().toUpperCase();
        return availability == "YES";
      }).map((item) {
        final String rawName = (item['weapon_name'] ?? "UNKNOWN").toString().trim();
        final String searchKey = rawName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
        
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
          baseFontSize: 14,
          baseStrokeWidth: 2.5,
          color: isNeon ? coreColor : Colors.white,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new, 
            color: isNeon ? coreColor : Theme.of(context).colorScheme.primary, 
            size: 18
          ),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            height: 2.0,
            color: isNeon 
                ? accent 
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

  final double borderWidth = (isNeon || isHolo || isAnemone) ? 2.0 : 1.5;

  return ValueListenableBuilder<double>(
    valueListenable: masterBorderNotifier,
    builder: (context, rotation, _) {
      final double angle = isHolo ? (rotation * 2 * math.pi) : 0.0; 
      
      final Alignment begin = isHolo 
          ? Alignment(math.cos(angle) * 1.5, math.sin(angle) * 1.5)
          : Alignment.centerLeft;
          
      final Alignment end = isHolo 
          ? Alignment(math.cos(angle + math.pi) * 1.5, math.sin(angle + math.pi) * 1.5)
          : Alignment.centerRight;

      Gradient? universalGradient;
      Color? universalSolidColor;

      if (isHolo) {
        universalGradient = LinearGradient(
          begin: begin, end: end, 
          colors: activeTheme.refractionColors,
        );
      } else if (isAnemone) {
        universalGradient = LinearGradient(
          begin: begin, end: end, 
          colors: activeTheme.borderGradient,
        );
      } else if (isNeon) {
        universalSolidColor = coreColor;
      } else {
        universalSolidColor = primary.withOpacity(0.6);
      }

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        decoration: BoxDecoration(
          color: universalSolidColor,
          gradient: universalGradient, 
          borderRadius: BorderRadius.circular(28),
          boxShadow: isNeon ? [
            BoxShadow(color: accent.withOpacity(0.8), blurRadius: 4, spreadRadius: 0.5),
            BoxShadow(color: accent.withOpacity(0.2), blurRadius: 15, spreadRadius: 1),
          ] : null,
        ),
        padding: EdgeInsets.all(borderWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28 - borderWidth),
          child: Container(
            decoration: BoxDecoration(
              color: isNeon ? Colors.black : Theme.of(context).colorScheme.surface,
            ),
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
        ),
      );
    },
  );
}

  Widget _buildBack(Color primary) {
  final activeTheme = widget.themeController.activeTheme;
  final bool isNeon = activeTheme.name.toLowerCase().contains('neon') || activeTheme.isCustom;
  final bool isHolo = activeTheme.isHolographic;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
  
  final Color accent = widget.themeController.activeAccentColor;
  final Color coreColor = Color.lerp(accent, Colors.white, 0.35)!;
  final double borderWidth = (isNeon || isHolo || isAnemone) ? 2.0 : 1.5;

  final builds = widget.weapon.builds["Ranked"];
  final build = (builds != null && builds.isNotEmpty) ? builds.first : null;
  final List<String> attachments = build?.attachments ?? [];
  final String buildCode = (build?.buildCodes != null && build!.buildCodes.isNotEmpty) 
      ? build.buildCodes.first 
      : "";

  return ValueListenableBuilder<double>(
    valueListenable: masterBorderNotifier,
    builder: (context, rotation, _) {
      final double angle = isHolo ? (rotation * 2 * math.pi) : 0.0; 
      
      final Alignment begin = isHolo 
          ? Alignment(math.cos(angle) * 1.5, math.sin(angle) * 1.5)
          : Alignment.centerLeft;
          
      final Alignment end = isHolo 
          ? Alignment(math.cos(angle + math.pi) * 1.5, math.sin(angle + math.pi) * 1.5)
          : Alignment.centerRight;

      Gradient? universalGradient;
      Color? universalSolidColor;

      if (isHolo) {
        universalGradient = LinearGradient(begin: begin, end: end, colors: activeTheme.refractionColors);
      } else if (isAnemone) {
        universalGradient = LinearGradient(begin: begin, end: end, colors: activeTheme.borderGradient);
      } else if (isNeon) {
        universalSolidColor = coreColor;
      } else {
        universalSolidColor = primary.withOpacity(0.5);
      }

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        decoration: BoxDecoration(
          color: universalSolidColor,
          gradient: universalGradient, 
          borderRadius: BorderRadius.circular(28),
          boxShadow: isNeon ? [
            BoxShadow(color: accent.withOpacity(0.8), blurRadius: 4, spreadRadius: 0.5),
            BoxShadow(color: accent.withOpacity(0.2), blurRadius: 15, spreadRadius: 1),
          ] : null,
        ),
        padding: EdgeInsets.all(borderWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28 - borderWidth),
          child: Container(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 20), 
            decoration: BoxDecoration(
              color: isNeon ? Colors.black : Theme.of(context).colorScheme.surface,
            ),
            child: Column(
              children: [
                ArmoryText(
                  "ATTACHMENTS",
                  themeController: widget.themeController,
                  baseFontSize: 12,
                  baseStrokeWidth: 2.0,
                  color: isNeon ? coreColor : primary,
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
                                    attachments[i].toUpperCase(),
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
                       color: isNeon ? coreColor : primary
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
    },
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
      color: isNeon ? Colors.black : effectiveBadgeColor,
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
        borderRadius: BorderRadius.circular(12),
        border: (canShowEffects && (isHolographic || isAnemone || isCustom))
            ? null
            : Border.all(color: baseColor.withOpacity(_isPressed ? 0.8 : 0.5), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(widget.icon, color: (isCustom && canShowEffects) ? coreColor : baseColor, size: 20),
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
      themedButton = _InternalAnimatedBorder(colors: activeTheme.refractionColors, child: boxContent);
    } else if (isAnemone && canShowEffects) {
      themedButton = ArmoryGradientBorder(gradientColors: activeTheme.borderGradient, borderRadius: 12, strokeWidth: 2, child: boxContent);
    } else if (isCustom && canShowEffects) {
      themedButton = AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: coreColor, width: _isPressed ? 2.5 : 2.0),
          boxShadow: [
            BoxShadow(color: baseColor.withOpacity(0.8), blurRadius: 1, spreadRadius: 0.5),
            BoxShadow(color: baseColor.withOpacity(glowOpacity), blurRadius: blurRadius, spreadRadius: 2),
          ],
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(10), child: boxContent),
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