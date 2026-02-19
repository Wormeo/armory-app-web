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
import 'package:flutter/scheduler.dart';

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
late AnimationController masterBorderController;

class GlobalTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  masterBorderController = AnimationController(
    vsync: GlobalTickerProvider(),
    duration: const Duration(seconds: 3),
  )..addListener(() {
      masterBorderNotifier.value = masterBorderController.value;
    })..repeat();

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
  
  runApp(MyApp(themeController: themeController));
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

  Weapon({required this.name, required this.imageUrl, required this.gameLogoUrl, required this.builds});
}

class MetaWeapon {
  final String name;
  final int? rank; 
  final String game;
  final String classType;
  final String? weaponImage;
  final String? gameImage;

  MetaWeapon({
    required this.name, 
    this.rank, 
    required this.game, 
    required this.classType,
    this.weaponImage,
    this.gameImage,
  });

  factory MetaWeapon.fromJson(Map<String, dynamic> json, Map<String, dynamic>? imageEntry) {
    return MetaWeapon(
      name: json['weapon'] ?? "UNKNOWN",
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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeController.activeTheme.themeData,
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
      'assets/Akimbo_202602130023.json', 'assets/Cold_War_Akimbo_202602130024.json',
      'assets/Cold_War_Single_202602130024.json', 'assets/Endgame_BO7_202602130023.json',
      'assets/Multiplayer_BO7_202602130017.json', 'assets/Multiplayer_Cold_War_202602130020.json',
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
        Uri.parse('http://127.0.0.1:5005/verify-premium?user_id=$savedId&pin=$savedPin')
      ).timeout(const Duration(seconds: 2));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        bool isPrem = data['premium'] == true;
        await prefs.setBool('is_premium_user', isPrem);
        return isPrem;
      }
    } catch (_) {}
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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<Weapon> _loadedWeapons = [];
  List<Weapon> displayList = [];
  bool _isPremiumUser = false;
  final _dataReady = true;

  ConnectionStatus _connectionStatus = ConnectionStatus.offline;
  Timer? _statusTimer;
  final String _ngrokUrl = "https://cherty-frowningly-rickie.ngrok-free.dev";

  Widget _SearchField({required Function(String) onChanged, required ThemeController themeController}) {
  final activeTheme = themeController.activeTheme;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
  final bool isHolographic = activeTheme.isHolographic;
  final bool isSimple = activeTheme.useWhiteSearch;

  Color inputTextColor = isSimple ? Colors.white : activeTheme.themeData.colorScheme.primary;
  Color borderColor = isSimple ? Colors.white : activeTheme.themeData.colorScheme.primary.withOpacity(0.3);

  Widget textField = TextField(
    onChanged: onChanged,
    autofocus: false,
    style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Days One'), 
    decoration: InputDecoration(
      hintText: "SEARCH WEAPONS...",
      hintStyle: TextStyle(
        color: Colors.white.withOpacity(0.6), fontSize: 12
      ),
      prefixIcon: Icon(Icons.search, color: inputTextColor),
      filled: true,
      fillColor: activeTheme.themeData.colorScheme.surface.withOpacity(0.8),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: (isAnemone || isHolographic) ? BorderSide.none : BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: (isAnemone || isHolographic) ? BorderSide.none : BorderSide(color: borderColor, width: 2),
      ),
    ),
  );

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: isHolographic
      ? _InternalAnimatedBorder(
          colors: activeTheme.refractionColors,
          child: textField,
        )
      : isAnemone 
          ? ArmoryGradientBorder(
              gradientColors: activeTheme.borderGradient,
              borderRadius: 12,
              strokeWidth: 2,
              child: textField,
            )
          : textField,
  );
}

@override
void initState() {
  super.initState();
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
      'assets/Akimbo_202602130023.json', 'assets/Cold_War_Akimbo_202602130024.json',
      'assets/Cold_War_Single_202602130024.json', 'assets/Endgame_BO7_202602130023.json',
      'assets/Multiplayer_BO7_202602130017.json', 'assets/Multiplayer_Cold_War_202602130020.json',
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
      Stack(
        children: [
          Text(
            statusText,
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
              fontSize: 7,
              letterSpacing: 1.2,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.2
                ..color = Colors.black,
            ),
          ),
          Text(
            statusText,
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
              fontSize: 7,
              color: statusColor.withOpacity(0.9),
              letterSpacing: 1.2,
            ),
          ),
        ],
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
    MaterialPageRoute(builder: (context) => const MetaDashboardScreen()),
  );
}

void _runBootSequence() async {
  await Future.delayed(const Duration(milliseconds: 500));
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
   SnackBar(
      content: Text("VERIFYING DATA INTEGRITY...", style: TextStyle(fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily, color: Theme.of(context).colorScheme.primary, fontSize: 12)),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 1),
    ),
  );

  bool updateFound = await _syncData();

  if (updateFound) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("DOWNLOADING LATEST PATCH...", style: TextStyle(fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily, color: Colors.amberAccent, fontSize: 12)),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2),
        ),
      );
    }

    await _performPreload(); 
    
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      
      ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
          content: Text("PATCH COMPLETE. SYSTEM UPDATED.", style: TextStyle(fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily, color:Theme.of(context).colorScheme.primary, fontSize: 12)),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2),
        ),
      );
    }

  } else {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("SYSTEM UP TO DATE.", style: TextStyle(fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily, color: Theme.of(context).colorScheme.primary, fontSize: 12)),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

void _showThemePickerDialog() {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "ThemePicker",
    barrierColor: Colors.black.withOpacity(0.7),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white10),
            ),

            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Text(
                    "INTERFACE THEME",
                    style: TextStyle(
                      fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                Expanded(
                  child: _buildThemeCategoryRows(), 
                ),
                
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("CLOSE", style: TextStyle(fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily, color: Colors.white54)),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    ),
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

Widget _buildThemeCategoryRows() {
  return ListView(
    padding: const EdgeInsets.only(bottom: 30),
    children: [
      _buildCategoryHeader("SIMPLE"),
      _buildThemeRow(ThemeCategory.simple),
      
      const SizedBox(height: 20),
      _buildCategoryHeader("ANEMONE"),
      _buildThemeRow(ThemeCategory.anemone),
      
      const SizedBox(height: 20),
      _buildCategoryHeader("HOLOGRAPHIC"),
      _buildThemeRow(ThemeCategory.premium),
    ],
  );
}

Widget _buildCategoryHeader(String title) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Days One',
          color: Colors.white70,
          fontSize: 12,
          letterSpacing: 1.5,
        ),
      ),
    ),
  );
}

Widget _buildThemeRow(ThemeCategory category) {
  final categoryThemes = ThemeController.allThemes
      .where((t) => t.category == category)
      .toList();

  if (categoryThemes.isEmpty) return const SizedBox.shrink();

  return SizedBox(
    height: 135,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      clipBehavior: Clip.none,
      itemCount: categoryThemes.length,
      itemBuilder: (context, index) {
        final theme = categoryThemes[index];
        bool isActive = widget.themeController.activeTheme.id == theme.id;
        bool isLocked = theme.category == ThemeCategory.premium && !_isPremiumUser;

        return GestureDetector(
          onTap: isLocked ? null : () {
            HapticFeedback.lightImpact();
            widget.themeController.setTheme(theme);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 105, 
            height: 105,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              gradient: theme.pickerGradient != null 
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isActive 
                          ? theme.pickerGradient!.map((c) => c.withOpacity(0.9)).toList()
                          : theme.pickerGradient!.map((c) => c.withOpacity(0.3)).toList(),
                    ) 
                  : null,
              color: theme.pickerGradient == null 
                  ? (isActive ? theme.themeData.primaryColor.withOpacity(0.4) : theme.pickerBoxColor)
                  : null,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive ? theme.themeData.primaryColor : theme.pickerBorderColor,
                width: isActive ? 2.5 : 1,
              ),
              boxShadow: isActive ? [
                BoxShadow(
                  color: (theme.pickerGradient?.first ?? theme.themeData.primaryColor).withOpacity(0.5),
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
                    child: Text(
                      theme.name.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Days One',
                        fontSize: 10,
                        letterSpacing: 1.1,
                        color: isLocked ? Colors.white24 : Colors.white,
                      ),
                    ),
                  ),
                ),
                if (isLocked)
                   const Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.lock_outline, color: Colors.amberAccent, size: 14),
                  ),
              ],
            ),
          ),
        );
      },
    ),
  );
}


Future<bool> _syncData() async {
  bool didUpdate = false;
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
        int localVersion = prefs.getInt('key_$fileName') ?? 0;

        if (remoteVersion > localVersion) {
          didUpdate = true;
          
          final fileResponse = await http.get(
            Uri.parse("$globalNgrokUrl/cdn/$fileName"),
            headers: {"ngrok-skip-browser-warning": "true"}
          );

          if (fileResponse.statusCode == 200) {
            final file = File('${directory.path}/$fileName');
            await file.writeAsBytes(fileResponse.bodyBytes);
            await prefs.setInt('key_$fileName', remoteVersion);
          }
        }
      }
    }
    return didUpdate;
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
  final bodyFont = Theme.of(context).textTheme.bodyLarge?.fontFamily;

  final List<String> notes = [
    "!FEATURES",
    "ADVANCED LOADOUT VIEWER + GLOBAL SEARCH",
    "RANDOMIZER ENGINE WITH EXCLUSION ZONE AND CUSTOMIZATION PARAMS",
    "CARD STYLE AUGMENT TREE AND META DASHBOARD",
    "FAVOURITE WEAPON INDEXING",
    "FUNCTIONING LOGIN SYSTEM FOR PREMIUM MEMBERS",
    "!NEW IN V0.9.5",
    "THEME SELECTOR",
    "!QOL FEATURES",
    "HOTFIX TUNNEL FOR REAL-TIME DATA TUNING",
    "LIVE NETWORK DIAGNOSTIC STATUS ON HOME SCREEN",
    "AUTO-SYNCS WEAPON DATA ON APP LAUNCH"
  ];

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF0D0D0D),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: primary),
        borderRadius: BorderRadius.circular(12),
      ),
      title: Stack(
        children: [
          Text(
            "SYSTEM UPDATES | BETA V0.9.5 - XEON",
            style: TextStyle(
              fontFamily: bodyFont,
              fontSize: 14,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2.5
                ..color = Colors.black,
            ),
          ),
          Text(
            "SYSTEM UPDATES | BETA V0.9.5 - XEON",
            style: TextStyle(fontFamily: bodyFont, color: primary, fontSize: 14),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: notes.length,
          itemBuilder: (context, i) {
            String line = notes[i];
            bool isHeader = line.startsWith('!');
            if (isHeader) line = line.substring(1);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Stack(
                alignment: isHeader ? Alignment.center : Alignment.centerLeft,
                children: [

                  Text(
                    isHeader ? line : "> $line",
                    textAlign: isHeader ? TextAlign.center : TextAlign.left,
                    style: TextStyle(
                      fontFamily: bodyFont,
                      fontSize: isHeader ? 12 : 11,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = isHeader ? 2.0 : 1.5
                        ..color = Colors.black,
                    ),
                  ),

                  Text(
                    isHeader ? line : "> $line",
                    textAlign: isHeader ? TextAlign.center : TextAlign.left,
                    style: TextStyle(
                      color: isHeader ? primary : Colors.white70,
                      fontSize: isHeader ? 12 : 11,
                      fontFamily: bodyFont,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Stack(
            children: [
              Text(
                "ACKNOWLEDGE",
                style: TextStyle(
                  fontFamily: bodyFont,
                  fontSize: 10,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2.0
                    ..color = Colors.black,
                ),
              ),
              Text(
                "ACKNOWLEDGE",
                style: TextStyle(
                  color: primary,
                  fontFamily: bodyFont,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
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

  HapticFeedback.mediumImpact();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("CONNECTING TO ARMORY CORE..."), 
      duration: Duration(milliseconds: 800),
      backgroundColor: Color.fromRGBO(2, 91, 207, 1),
    )
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("PREMIUM ACCESS GRANTED"), backgroundColor: Colors.green)
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("DENIED: ${data['message'] ?? 'Invalid ID/PIN'}"), backgroundColor: Colors.red)
        );
      }
    }
  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("SERVER UNREACHABLE: Check ngrok tunnel"), 
        backgroundColor: Colors.orange
      )
    );
  }
}

  void search(String query) {
    setState(() { displayList = widget.preloadedData.where((w) => w.name.toLowerCase().contains(query.toLowerCase())).toList(); });
  }

  void _showBugReportDialog() {
  final TextEditingController bugController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      title: Text("ARMORY BUG REPORT", 
        style: TextStyle(fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily, color: Theme.of(context).colorScheme.primary, fontSize: 14)),
      content: TextField(
        controller: bugController,
        maxLines: 3,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: "Describe the issue and how it occurred if applicable.",
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("CANCEL", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Report Sent to Firebase. Thank You!")),
                );
              }
            }
          },
          child: const Text("TRANSMIT", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}

@override
Widget build(BuildContext context) {
  double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
  final activeTheme = widget.themeController.activeTheme;

  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    resizeToAvoidBottomInset: false, 
    drawer: _buildSettingsDrawer(),
    appBar: AppBar(
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.settings, color: Colors.white70),
          onPressed: () {
            HapticFeedback.mediumImpact(); 
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Text(
                "THE ARMORY",
                style: TextStyle(
                  fontFamily: 'Days One',
                  fontSize: 20,
                  letterSpacing: 4.0,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3.0
                    ..color = Colors.black,
                ),
              ),

              Text(
                "THE ARMORY",
                style: const TextStyle(
                  fontFamily: 'Days One',
                  fontSize: 20,
                  letterSpacing: 4.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _buildStatusIndicator(),
        ],
      ),
      centerTitle: true, 
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.7), 
      elevation: 0
    ),

    body: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
                _SearchField(onChanged: search, themeController: widget.themeController),
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
                            themeController: widget.themeController, 
                            onFavorite: () {
                              HapticFeedback.mediumImpact();
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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          "SYNCHRONIZING DATA...",
                          style: TextStyle(
                            fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
                            fontSize: 12,
                            letterSpacing: 1.5,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2.0
                              ..color = Colors.black,
                          ),
                        ),
                        Text(
                          "SYNCHRONIZING DATA...",
                          style: TextStyle(
                            fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
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
  final bool isHolographic = activeTheme.isHolographic;

  return Drawer(
    elevation: 0,
    backgroundColor: theme.colorScheme.surface,
    child: Column(
      children: [
        SafeArea(
          bottom: false,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Center(
              child: Stack(
                children: [

                  Text(
                    "THE ARMORY DRAWER",
                    style: TextStyle(
                      fontFamily: 'Days One',
                      fontSize: 16,
                      letterSpacing: 1.2,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2.5
                        ..color = Colors.black,
                    ),
                  ),

                  Text(
                    "THE ARMORY DRAWER",
                    style: TextStyle(
                      fontFamily: 'Days One',
                      color: isHolographic ? theme.colorScheme.primary : Colors.white,
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const Divider(color: Colors.white10, height: 3),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              const SizedBox(height: 20),
              _buildAegisBox(activeTheme, theme),
              const SizedBox(height: 15),

              _buildDrawerButton(
                label: "RANDOMIZER",
                icon: Icons.cached_rounded,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RandomLoadoutScreen(themeController: widget.themeController))),
              ),
              const SizedBox(height: 15),

              _buildDrawerButton(
                label: "AUGMENT TREE",
                icon: Icons.hub_rounded,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AugmentTreeScreen())),
              ),
              const SizedBox(height: 15),

              _buildDrawerButton(
                label: "META PICKS",
                icon: Icons.assessment_rounded,
                onTap: () {
                  HapticFeedback.heavyImpact();
                  _showMetaDashboard();
                },
              ),
              const SizedBox(height: 15),

              _buildDrawerButton(
                label: "THEMES",
                icon: Icons.palette_rounded,
                customColor: theme.colorScheme.primary, 
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context);
                  _showThemePickerDialog(); 
                },
              ),
              
              const SizedBox(height: 20),
              const Divider(color: Colors.white10, thickness: 1),
              const SizedBox(height: 20),

              _isPremiumUser ? _buildPremiumSection() : _buildAuthSection(),
            ],
          ),
        ),

        const Divider(color: Colors.white10, height: 1),
        _buildMinorDrawerTile(
          label: "REPORT A BUG",
          icon: Icons.bug_report_outlined,
          onTap: () {
            Navigator.pop(context);
            _showBugReportDialog();
          },
        ),
        _buildMinorDrawerTile(
          label: "JOIN THE ARMORY DISCORD",
          icon: Icons.discord, 
          onTap: () => launchUrl(Uri.parse("https://discord.gg/mE5DRyf2BX"), mode: LaunchMode.externalApplication),
        ),
        _buildMinorDrawerTile(
          label: "TRY ME OUT ON DISCORD",
          icon: Icons.discord_rounded,
          onTap: () => launchUrl(Uri.parse("https://top.gg/bot/1313580706131087421"), mode: LaunchMode.externalApplication),
        ),
        _buildMinorDrawerTile(
          label: "PATCH NOTES",
          icon: Icons.terminal_outlined,
          onTap: () => _showPatchNotes(context),
        ),
        const SizedBox(height: 20), 
      ],
    ),
  );
}

Widget _buildAegisBox(ArmoryTheme activeTheme, ThemeData theme) {
  final bool isHolographic = activeTheme.isHolographic;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone;

  Widget boxContent = Container(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface, 
      borderRadius: BorderRadius.circular(12),
      border: (isHolographic || isAnemone) ? null : Border.all(
        color: theme.colorScheme.primary.withOpacity(0.5), 
        width: 1,
      ),
    ),
    child: Row(
      children: [
        Icon(Icons.shield_rounded, color: theme.colorScheme.primary, size: 24),
        const SizedBox(width: 15),
        Stack(
          children: [
            Text(
              "AEGIS PROTOCOL : ACTIVE",
              style: TextStyle(
                fontFamily: 'Days One', 
                fontSize: 12,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Colors.black,
              ),
            ),

            Text(
              "AEGIS PROTOCOL : ACTIVE",
              style: const TextStyle(
                fontFamily: 'Days One', 
                color: Colors.white, 
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  if (isHolographic) {
    return _InternalAnimatedBorder(
      colors: activeTheme.refractionColors,
      child: boxContent,
    );
  } else if (isAnemone) {
    return ArmoryGradientBorder(
      gradientColors: activeTheme.borderGradient,
      borderRadius: 12,
      child: boxContent,
    );
  }
  return boxContent;
}

Widget _buildMinorDrawerTile({required String label, required IconData icon, required VoidCallback onTap}) {
  return ListTile(
    dense: true, 
    visualDensity: VisualDensity.compact,
    leading: Icon(icon, color: Colors.white24, size: 18),
    title: Stack(
      children: [

        Text(
          label, 
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily, 
            fontSize: 9, 
            letterSpacing: 1.1,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.6
              ..color = Colors.black,
          )
        ),

        Text(
          label, 
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily, 
            fontSize: 9, 
            color: Theme.of(context).colorScheme.primary, 
            letterSpacing: 1.1
          )
        ),
      ],
    ),
    onTap: onTap,
  );
}

Widget _buildDrawerButton({
  required String label,
  required IconData icon,
  required VoidCallback onTap,
  Color? customColor,
}) {
  final activeTheme = widget.themeController.activeTheme;
  final theme = Theme.of(context);
  final bool isHolographic = activeTheme.isHolographic;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
  
  final Color effectiveColor = customColor ?? theme.colorScheme.primary;

  Widget boxContent = Container(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface, 
      borderRadius: BorderRadius.circular(12),
      border: (isHolographic || isAnemone) ? null : Border.all(
        color: effectiveColor.withOpacity(0.5), 
        width: 1,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        Icon(icon, color: effectiveColor, size: 20),
        const SizedBox(width: 15),
        Stack(
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Days One', 
                fontSize: 12,
                letterSpacing: 1.5,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Colors.black,
              ),
            ),

            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Days One', 
                color: Colors.white, 
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget themedButton;
  if (isHolographic) {
    themedButton = _InternalAnimatedBorder(
      colors: activeTheme.refractionColors,
      child: boxContent,
    );
  } else if (isAnemone) {
    themedButton = ArmoryGradientBorder(
      gradientColors: activeTheme.borderGradient,
      borderRadius: 12,
      strokeWidth: 2,
      child: boxContent,
    );
  } else {
    themedButton = boxContent;
  }

  return GestureDetector(
    onTap: () {
      HapticFeedback.lightImpact();
      onTap();
    },
    child: themedButton,
  );
}

Widget _buildPremiumSection() {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 191, 0, 0.05),
          border: Border.all(color: Colors.amberAccent.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.stars_rounded, color: Colors.amberAccent, size: 24),
            const SizedBox(width: 15),
            Stack(
              children: [
                Text(
                  "PREMIUM STATUS: ACTIVE", 
                  style: TextStyle(
                    fontFamily: 'Days One', 
                    fontSize: 11,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2.5
                      ..color = Colors.black,
                  )
                ),

                Text(
                  "PREMIUM STATUS: ACTIVE", 
                  style: const TextStyle(
                    fontFamily: 'Days One', 
                    color: Colors.amberAccent, 
                    fontSize: 11,
                  )
                ),
              ],
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
        child: Stack(
          children: [
            Text(
              "TERMINATE SESSION", 
              style: TextStyle(
                fontSize: 10, 
                letterSpacing: 1.1,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1.8
                  ..color = Colors.black,
              )
            ),

            const Text(
              "TERMINATE SESSION", 
              style: TextStyle(
                color: Colors.redAccent, 
                fontSize: 10, 
                letterSpacing: 1.1,
              )
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildAuthSection() {
  final primaryColor = Theme.of(context).colorScheme.primary;
  final bodyFont = Theme.of(context).textTheme.bodyLarge?.fontFamily;

  return Column(
    children: [
      TextField(
        controller: _idController,
        style: TextStyle(color: primaryColor, fontFamily: bodyFont, fontSize: 13),
        decoration: InputDecoration(
          label: Stack(
            children: [
              Text("DISCORD USER ID", style: TextStyle(fontSize: 10, foreground: Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = Colors.black)),
              Text("DISCORD USER ID", style: TextStyle(fontSize: 10, color: primaryColor)),
            ],
          ),
          prefixIcon: Icon(Icons.person_search, color: primaryColor),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor.withOpacity(0.3))),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        ),
      ),

      const SizedBox(height: 15),

      TextField(
        controller: _pinController,
        keyboardType: TextInputType.number, 
        obscureText: true,
        maxLength: 6,
        style: TextStyle(color: primaryColor, fontFamily: bodyFont, fontSize: 13),
        decoration: InputDecoration(
          label: Stack(
            children: [
              Text("SECRET PIN", style: TextStyle(fontSize: 10, foreground: Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = Colors.black)),
              Text("SECRET PIN", style: TextStyle(fontSize: 10, color: primaryColor)),
            ],
          ),
          prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
          counterStyle: const TextStyle(color: Colors.white38), 
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor.withOpacity(0.3))),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        ),
      ),
      
      const SizedBox(height: 30),

      ElevatedButton(
        onPressed: _verifyPremium,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, 
          foregroundColor: Colors.black, 
          minimumSize: const Size(double.infinity, 45)
        ),
        child: Stack(
          children: [
            Text(
              "AUTHENTICATE",
              style:
              TextStyle(
                foreground: Paint()..
                style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..color = Colors.black)),

            Text("AUTHENTICATE", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
      
      const SizedBox(height: 15),

      OutlinedButton.icon(
        onPressed: () => launchUrl(Uri.parse('https://buy.stripe.com/dRm6oH6BFamr8Xe2CddUY00'), mode: LaunchMode.externalApplication),
        icon: const Icon(Icons.shopping_cart_outlined, size: 16, color: Colors.amberAccent),
        label: Stack(
          children: [
            Text("BUY PREMIUM", style: TextStyle(foreground: Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = Colors.black)),
            const Text("BUY PREMIUM", style: TextStyle(color: Colors.amberAccent)),
          ],
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.amberAccent), 
          minimumSize: const Size(double.infinity, 45)
        ),
      ),
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
    final bool isAnemone = activeTheme.category == ThemeCategory.anemone;
    final bool isHolographic = activeTheme.isHolographic;

    Widget cardContent = Card(
      color: theme.colorScheme.surface.withOpacity(0.6),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: (isAnemone || isHolographic)
            ? BorderSide.none
            : BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
      ),
      child: ListTile(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => DetailScreen(
                      weapon: weapon,
                      isPremiumUser: isPremium,
                      themeController: themeController,
                    ))),
        leading: _SmartImage(url: weapon.gameLogoUrl, width: 40),

        title: Stack(
          children: [
            Text(
              weapon.name,
              style: TextStyle(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Colors.black,
              ),
            ),
            Text(
              weapon.name,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: mainListChips
                  .map((m) => _StatusChip(
                      label: m, isActive: weapon.builds.containsKey(m)))
                  .toList(),
            ),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Colors.amber : Colors.white10,
          ),
          onPressed: () {
            HapticFeedback.mediumImpact();
            onFavorite();
          },
        ),
      ),
    );

    Widget finalWidget = cardContent;

    if (isHolographic) {
      finalWidget = StatefulBuilder(builder: (context, setState) {
        return _InternalAnimatedBorder(
          colors: activeTheme.refractionColors,
          child: cardContent,
        );
      });
    } else if (isAnemone) {
      finalWidget = ArmoryGradientBorder(
        gradientColors: activeTheme.borderGradient,
        strokeWidth: 2,
        borderRadius: 12,
        child: cardContent,
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
    final keys = widget.weapon.builds.keys.toList();
    const order = {"Multiplayer": 1, "Warzone": 2, "Rebirth": 3, "Warzone Prestige": 4, "Endgame": 5, "Zombies": 6, "Special": 7};
    keys.sort((a, b) => (order[a] ?? 99).compareTo(order[b] ?? 99));
    flatBuilds = [];
    for (var k in keys) { flatBuilds.addAll(widget.weapon.builds[k]!); }
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = widget.themeController.activeTheme;
    final theme = Theme.of(context);
    final bool isHolographic = activeTheme.isHolographic;
    
    final currentBuild = flatBuilds[selectedIndex];
    final bool isSokol = widget.weapon.name.toUpperCase().contains("SOKOL 545");
    
    WeaponStats? displayStats = (isSokol && isFastMode && currentBuild.alternativeStats != null)
        ? currentBuild.alternativeStats
        : currentBuild.stats;

    final hasStats = displayStats != null;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: Stack(
          children: [
            Text(
              widget.weapon.name.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Days One',
                fontSize: 18,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2.5
                  ..color = Colors.black,
              ),
            ),
            Text(
              widget.weapon.name.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Days One',
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ), 
        backgroundColor: theme.colorScheme.surface.withOpacity(0.8),
        elevation: 0,
        actions: [
          if (hasStats && showStats && isSokol)
            _buildFireModeToggle(),

          if (hasStats) ...[
            if (widget.isPremiumUser) ...[
              Center(
                child: Stack(
                  children: [
                    Text(
                      "STATS",
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 1.5
                          ..color = Colors.black,
                      ),
                    ),
                    Text(
                      "STATS",
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.primary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: showStats, 
                onChanged: (v) => setState(() => showStats = v),
                activeColor: theme.colorScheme.primary,
              ),
            ] else ...[
              IconButton(
                icon: const Icon(Icons.analytics_outlined, color: Colors.white24, size: 18),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Technical Specs Locked. Link account in Settings."))
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
                _ImageHeader(url: widget.weapon.imageUrl),
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Wrap(
                    spacing: 8.0, 
                    runSpacing: 8.0, 
                    alignment: WrapAlignment.center,
                    children: List.generate(flatBuilds.length, (index) {
                      final b = flatBuilds[index];
                      bool sel = selectedIndex == index;

                      Color activeColor = b.category == "Special" 
                          ? Colors.purpleAccent 
                          : (b.category.contains("Prestige") ? const Color(0xFFFFD700) : theme.colorScheme.primary);

                      return GestureDetector(
                        onTap: () => setState(() {
                          selectedIndex = index;
                          if (flatBuilds[index].stats == null) showStats = false;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: sel ? activeColor : theme.colorScheme.surface.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: sel ? Colors.white : theme.colorScheme.primary.withOpacity(0.2)
                            ),
                          ),
                          child: Stack(
                            children: [

                              Text(
                                (b.modName ?? b.category).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Days One',
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 1.5
                                    ..color = sel ? Colors.white : Colors.black,
                                ),
                              ),

                              Text(
                                (b.modName ?? b.category).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Days One',
                                  color: sel ? Colors.black : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    children: [
                      if (hasStats) _CombatRatingDisplay(stats: displayStats),
                      if (showStats && hasStats && widget.isPremiumUser) _PremiumStatCard(stats: displayStats),

                      if (currentBuild.modName != null) 
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 12), 
                          child: Center(
                            child: Stack(
                              children: [
                                Text(
                                  currentBuild.modName!.toUpperCase(),
                                  style: TextStyle(
                                    letterSpacing: 1.2,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 2.0
                                      ..color = Colors.black,
                                  ),
                                ),
                                Text(
                                  currentBuild.modName!.toUpperCase(),
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                      ...currentBuild.buildCodes.map((c) => _BuildCodeBox(code: c, weaponName: widget.weapon.name, mode: currentBuild.category)),
                      const SizedBox(height: 10),
                      
                      ...currentBuild.attachments.map((att) => _AttachmentTile(
                        text: att, 
                        isStarred: currentBuild.starredAttachments.contains(att),
                        themeController: widget.themeController
                      )),
                      
                      if (currentBuild.specialtyValue != null) _SpecialtyBox(value: currentBuild.specialtyValue!),
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
      height: 150,
      width: double.infinity,
      color: Colors.transparent,
      child: Center(
        child: Image.network(
          url,
          fit: BoxFit.contain,
          
          scale: 0.75,
        ),
      ),
    );
  }

  Widget _buildFireModeToggle() {
  final theme = Theme.of(context);
  final accentColor = isFastMode ? Colors.redAccent : Colors.greenAccent;
  final label = isFastMode ? "FAST FIRE" : "SLOW FIRE";

  return Center(
    child: GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => isFastMode = !isFastMode);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: accentColor),
        ),
        child: Stack(
          children: [

            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontFamily: theme.textTheme.bodyLarge?.fontFamily,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2.0
                  ..color = Colors.black,
              ),
            ),

            Text(
              label,
              style: TextStyle(
                color: accentColor,
                fontSize: 9,
                fontFamily: theme.textTheme.bodyLarge?.fontFamily,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _AttachmentTile({required String text, required bool isStarred, required ThemeController themeController}) {
  final activeTheme = widget.themeController.activeTheme;
  final theme = activeTheme.themeData;
  final bool isHolographic = activeTheme.isHolographic;
  final bool isAnemone = activeTheme.category == ThemeCategory.anemone;

  Widget tileContent = Container(
    margin: isAnemone || isHolographic ? EdgeInsets.zero : const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface.withOpacity(0.7),
      borderRadius: BorderRadius.circular(10),
      border: (isAnemone || isHolographic) ? null : Border.all(
        color: theme.colorScheme.primary.withOpacity(0.15),
      ),
    ),
    child: ListTile(
      dense: true,
      leading: Icon(
        isStarred ? Icons.star : Icons.check_circle,
        color: isStarred ? Colors.amber : theme.colorScheme.primary,
        size: 20,
      ),
      title: Stack(
        children: [
          Text(
            text.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              letterSpacing: 0.5,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..color = Colors.black,
            ),
          ),
          Text(
            text.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 13, 
              letterSpacing: 0.5
            ),
          ),
        ],
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
  } else if (isAnemone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ArmoryGradientBorder(
        gradientColors: activeTheme.borderGradient,
        borderRadius: 10,
        child: tileContent,
      ),
    );
  }

  return tileContent;
}
}

class _PremiumStatCard extends StatelessWidget {
  final WeaponStats stats;
  const _PremiumStatCard({required this.stats});

  bool _hasData(String? val) {
    if (val == null) return false;
    final v = val.trim();
    return v.isNotEmpty && v != "-" && v.toLowerCase() != "null";
  }

  @override
Widget build(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      border: Border.symmetric(
        horizontal: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.1))
      ),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Stack(
            children: [
              Text(
                "ADVANCED WEAPON STATS",
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 2,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3
                    ..color = Colors.black,
                ),
              ),

              Text(
                "ADVANCED WEAPON STATS",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12, left: 4, right: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_hasData(stats.ttk1))
                  Expanded(
                    child: Center(
                      child: _StatItem(
                        label: _hasData(stats.ttk2) 
                            ? "TTK < ${stats.range2}" 
                            : "TTK RANGE 1", 
                        value: stats.ttk1
                      )
                    )
                  ),

                if (_hasData(stats.ttk2))
                  Expanded(
                    child: Center(
                      child: _StatItem(
                        label: (stats.range2 != "-" && stats.range2.isNotEmpty) 
                            ? "TTK > ${stats.range2}" 
                            : "LONG TTK", 
                        value: stats.ttk2
                      ),
                    ),
                  ),

                Expanded(child: Center(child: _StatItem(label: "ADS SPEED", value: stats.adsSpeed))),
                Expanded(child: Center(child: _StatItem(label: "VELOCITY", value: stats.bulletVelocity))),
                Expanded(child: Center(child: _StatItem(label: "HITS TO KILL", value: stats.shotsToKill))),
                
                if (!_hasData(stats.ttk2) && _hasData(stats.range2))
                  Expanded(child: Center(child: _StatItem(label: "DROP", value: stats.range2))),

                Expanded(child: Center(child: _StatItem(label: "HITSCAN", value: stats.hitscanRange))),

                if (stats.shotRange != null && _hasData(stats.shotRange))
                  Expanded(child: Center(child: _StatItem(label: "SNIPER", value: stats.shotRange!))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 9,
                height: 1.0,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Colors.black,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                height: 1.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
      Stack(
        children: [

          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3,
              color: null,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 9,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      )
      ],
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  final String text; final bool isStarred;
  const _AttachmentTile({required this.text, this.isStarred = false});
  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.only(bottom: 8), decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(8)), child: ListTile(dense: true, leading: Icon(isStarred ? Icons.star : Icons.check_circle_outline, size: 18, color: isStarred ? Colors.amber : const Color.fromRGBO(2, 91, 207, 1)), title: Text(text, style: TextStyle(fontSize: 14, color: isStarred ? Colors.amber[100] : Colors.white))));
  }
}

class _SpecialtyBox extends StatelessWidget {
  final String value;
  const _SpecialtyBox({required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color.fromRGBO(2, 91, 207, 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color.fromRGBO(2, 91, 207, 0.5))), child: Text(value.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Color.fromRGBO(2, 91, 207, 1), fontWeight: FontWeight.bold, letterSpacing: 1.5))));
  }
}

class _StatusChip extends StatelessWidget {
  final String label; 
  final bool isActive;
  const _StatusChip({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    Color activeColor = const Color.fromRGBO(2, 91, 207, 1);
    if (label == "Special") activeColor = Colors.purple;
    if (label == "Akimbo") activeColor = Colors.orange;
    if (label == "Single") activeColor = Colors.green;
    if (label.contains("Prestige")) activeColor = const Color(0xFFFFD700);

    return Container(
      margin: const EdgeInsets.only(right: 6), 
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), 
      decoration: BoxDecoration(
        color: isActive ? activeColor.withOpacity(0.2) : Colors.transparent, 
        borderRadius: BorderRadius.circular(4), 
        border: Border.all(color: isActive ? activeColor.withOpacity(0.5) : Colors.white10)
      ), 
      child: Stack(
        children: [

          Text(
            label, 
            style: TextStyle(
              fontSize: 9, 
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.5
                ..color = isActive ? Colors.black : Colors.transparent
            )
          ),

          Text(
            label, 
            style: TextStyle(
              fontSize: 9, 
              color: isActive ? Colors.white : Colors.white10
            )
          ),
        ],
      )
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
  const _BuildCodeBox({required this.code, required this.weaponName, required this.mode});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: code));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("$weaponName code copied!"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: primaryColor,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: primaryColor.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.copy, size: 16, color: primaryColor),
              const SizedBox(width: 10),
              Stack(
                children: [
                  Text(
                    code,
                    style: TextStyle(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.black,
                    ),
                  ),
                  Text(
                    code,
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmartImage extends StatelessWidget {
  final String url; final double? width;
  const _SmartImage({required this.url, this.width});
  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const Icon(Icons.image_not_supported, color: Colors.white10);
    final String size = (width != null && width! < 150) ? 'w_150' : 'w_800';
    final String optimizedUrl = url.contains('/upload/') ? url.replaceFirst('/upload/', '/upload/$size,c_limit,f_auto,q_auto/') : url;
    return Image.network(optimizedUrl, width: width, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.error), frameBuilder: (c, child, frame, wasSync) => wasSync ? child : AnimatedOpacity(opacity: frame == null ? 0 : 1, duration: const Duration(milliseconds: 300), child: child));
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
  List<String> _excludedGames = [];
  final List<String> _gameKeys = ["MW2", "MW3", "BO6", "BO7", "CW", "MW19"];

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadCADData();
  }


  Future<void> _loadSettings() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    _isExclusionZoneActive = prefs.getBool('exclusion_active') ?? false;
    _excludedGames = prefs.getStringList('excluded_games') ?? [];
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
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PLEASE SELECT A WEAPON SYSTEM", style: TextStyle(fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily, fontSize: 10)))
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
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("CRITICAL ERROR: EXCLUSION ZONE EMPTY", style: TextStyle(fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily, fontSize: 10, color: Colors.redAccent)))
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
      var weapon = (i == 0) ? anchorWeapon : null;

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
  return ListenableBuilder(
    listenable: widget.themeController,
    builder: (context, _) {
      final theme = Theme.of(context);
      final activeTheme = widget.themeController.activeTheme;

      return Scaffold(
        backgroundColor: theme.colorScheme.surface, 
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Stack(
          children: [
            Text(
              "MODULE: RANDOMIZER", 
              style: TextStyle(
                fontFamily: 'Days One', 
                fontSize: 14, 
                letterSpacing: 1.5,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2.0
                  ..color = Colors.black,
              )
            ),
            Text(
              "MODULE: RANDOMIZER", 
              style: TextStyle(
                fontFamily: 'Days One', 
                fontSize: 14, 
                color: theme.colorScheme.primary,
                letterSpacing: 1.5,
              )
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.colorScheme.primary, size: 16), 
          onPressed: () => Navigator.pop(context)
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildControlTile(
                        "EXCLUSION ZONE", 
                        Switch(
                          value: _isExclusionZoneActive, 
                          activeColor: Colors.amberAccent, 
                          onChanged: (v) {
                            setState(() => _isExclusionZoneActive = v);
                            _saveSettings();
                          }
                        ),
                        theme
                      ),

                      if (_isExclusionZoneActive) _buildExclusionDropdown(theme),

                      const SizedBox(height: 10),
                      _buildControlTile(
                        "RANDOM WEAPON", 
                        Switch(
                          value: _isRandomWeapon, 
                          activeColor: theme.colorScheme.primary, 
                          onChanged: (v) => setState(() => _isRandomWeapon = v)
                        ),
                        theme
                      ),
                      
                      if (!_isRandomWeapon) ...[
                        const SizedBox(height: 10),
                        Autocomplete<String>(
                          optionsBuilder: (val) {
                            if (val.text.isEmpty) return const Iterable<String>.empty();
                            return _weaponNames.where((s) => s.toLowerCase().contains(val.text.toLowerCase()));
                          },
                          onSelected: (s) => setState(() => _selectedWeapon = s),
                          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                            return TextField(
                              controller: controller, 
                              focusNode: focusNode,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                              decoration: _inputDecoration("SEARCH ARMORY...", theme).copyWith(
                                suffixIcon: controller.text.isNotEmpty 
                                  ? IconButton(icon: const Icon(Icons.close, size: 16), onPressed: () => controller.clear()) 
                                  : const Icon(Icons.search, size: 16),
                              ),
                            );
                          },
                          optionsViewBuilder: (context, onSelected, options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                color: Colors.transparent,
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 40,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface.withOpacity(0.95), 
                                    borderRadius: BorderRadius.circular(8), 
                                    border: Border.all(color: Colors.white10)
                                  ),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero, 
                                    shrinkWrap: true, 
                                    itemCount: options.length,
                                    itemBuilder: (context, index) {
                                      final option = options.elementAt(index);

                                      return ListTile(
                                        title: Text(option, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                        onTap: () => onSelected(option),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ] else _buildLockedSearchTile(theme),

                      const SizedBox(height: 10),
                      _buildControlTile("GAME MODE", _buildModeDropdown(), theme),
                      const SizedBox(height: 10),
                      _buildControlTile("QUANTITY", _buildQuantityDropdown(), theme),
                      const SizedBox(height: 30),
                      
                      _buildInitializeButton(activeTheme, theme), 
                      
                      const SizedBox(height: 30),
                      ..._generatedLoadouts.map((loadout) => GlitchedResultCard(key: ValueKey(loadout['id']), loadout: loadout)),
                    ],
                  ),
                ),
              ],
            ),

            _buildScanlines(),
          ],
        ),
      );
    }
  );
}

Widget _buildStatusHeader(ThemeData theme) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.05),
            border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Row(
            children: [
              Icon(Icons.bolt, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              Stack(
                children: [
                  Text(
                    "SYSTEM READY: SELECT PARAMETERS", 
                    style: TextStyle(
                      fontFamily: 'Days One', 
                      fontSize: 10,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1.5
                        ..color = Colors.black,
                    )
                  ),
                  Text(
                    "SYSTEM READY: SELECT PARAMETERS", 
                    style: TextStyle(fontFamily: 'Days One', color: theme.colorScheme.primary, fontSize: 10)
                  ),
                ],
              ),
            ],
          ),
        ),
        
        if (_isExclusionZoneActive) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amberAccent.withOpacity(0.05),
              border: Border.all(color: Colors.amberAccent.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(8)
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
                        Stack(
                          children: [
                            Text("EXCLUSION ZONE: ACTIVE", style: TextStyle(fontFamily: 'Days One', fontSize: 10, foreground: Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = Colors.black)),
                            const Text("EXCLUSION ZONE: ACTIVE", style: TextStyle(fontFamily: 'Days One', color: Colors.amberAccent, fontSize: 10)),
                          ],
                        ),
                        const Text("  |  ", style: TextStyle(color: Colors.white24, fontSize: 10)),
                        Text(
                          (_gameKeys.where((g) => !_excludedGames.contains(g)).toList()..sort()).join(" | "),
                          style: TextStyle(fontFamily: 'Days One', color: theme.colorScheme.primary, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
      ],
    ),
  );
}

  Widget _buildExclusionDropdown(ThemeData theme) {
  return Container(
    margin: const EdgeInsets.only(top: 5),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.amberAccent.withOpacity(0.02),
      border: Border.all(color: Colors.white.withOpacity(0.05)),
      borderRadius: BorderRadius.circular(8)
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("GAMES TO EXCLUDE", style: TextStyle(color: Colors.white38, fontFamily: 'Days One', fontSize: 10)),
        PopupMenuButton<String>(
          color: theme.colorScheme.surface,
          onSelected: (String game) {
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
              return CheckedPopupMenuItem(
                value: game,
                checked: _excludedGames.contains(game),
                child: Text(game, style: const TextStyle(color: Colors.white, fontSize: 12)),
              );
            }).toList();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.white10), borderRadius: BorderRadius.circular(4)),
            child: Text(
              _excludedGames.isEmpty ? "SELECT" : (_excludedGames..sort()).join(" | "),
              style: TextStyle(color: Colors.amberAccent, fontSize: 10, fontFamily: 'Days One'),
            ),
          ),
        )
      ],
    ),
  );
}

Widget _buildControlTile(String label, Widget trailing, ThemeData theme) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05)))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
      children: [
        Stack(
          children: [
            Text(label, style: TextStyle(fontFamily: 'Days One', fontSize: 10, foreground: Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = Colors.black)),
            Text(label, style: const TextStyle(color: Colors.white38, fontFamily: 'Days One', fontSize: 10)),
          ],
        ),
        trailing,
      ]
    ),
  );
}

  InputDecoration _inputDecoration(String hint, ThemeData theme) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white24, fontSize: 10),
    filled: true,
    fillColor: theme.colorScheme.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white10)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white10)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5))),
  );
}

  Widget _buildModeDropdown() {
    return DropdownButton<String>(
      value: _selectedMode,
      onChanged: (v) => setState(() => _selectedMode = v!),
      dropdownColor: const Color(0xFF0D0D0D),
      underline: const SizedBox(),
      items: ['WARZONE', 'MULTIPLAYER'].map((mode) => DropdownMenuItem(value: mode, child: Text(mode, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily)))).toList(),
    );
  }

  Widget _buildQuantityDropdown() {
    return DropdownButton<int>(
      value: _amount,
      onChanged: (v) => setState(() => _amount = v!),
      dropdownColor: const Color(0xFF0D0D0D),
      underline: const SizedBox(),
      items: List.generate(10, (i) => i + 1).map((e) => DropdownMenuItem(value: e, child: Text("$e", style: TextStyle(color: Theme.of(context).colorScheme.primary)))).toList(),
    );
  }

Widget _buildInitializeButton(ArmoryTheme activeTheme, ThemeData theme) {
  Widget button = SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: _generate,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Stack(
        children: [
          Text(
            "INITIALIZE",
            style: TextStyle(
              fontFamily: 'Days One', 
              letterSpacing: 2,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2.6
                ..color = Colors.black,
            ),
          ),
          const Text(
            "INITIALIZE",
            style: TextStyle(fontFamily: 'Days One', color: Colors.white, letterSpacing: 2),
          ),
        ],
    ),
  ),
  );

  if (activeTheme.isHolographic) {
    return _InternalAnimatedBorder(
      colors: activeTheme.refractionColors.isNotEmpty 
          ? activeTheme.refractionColors 
          : activeTheme.borderGradient,
      child: button,
    );
  }

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: activeTheme.borderGradient.isNotEmpty 
            ? activeTheme.borderGradient.first 
            : theme.colorScheme.primary,
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: (activeTheme.borderGradient.isNotEmpty 
              ? activeTheme.borderGradient.first 
              : theme.colorScheme.primary).withOpacity(0.2),
          blurRadius: 8,
        )
      ],
    ),
    child: button,
  );
}

  Widget _buildLockedSearchTile(ThemeData theme) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.02), 
      border: Border.all(color: Colors.white10), 
      borderRadius: BorderRadius.circular(8)
    ),
    child: Row(
      children: [
        Icon(Icons.lock_outline, color: theme.colorScheme.primary.withOpacity(0.5), size: 14), 
        const SizedBox(width: 10), 
        const Text("SEARCH LOCKED: RANDOM MODE ACTIVE", style: TextStyle(color: Colors.white38, fontSize: 9, fontFamily: 'Days One'))
      ]
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
  const GlitchedResultCard({super.key, required this.loadout});

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
  final primaryColor = Theme.of(context).colorScheme.primary;
  final bodyFont = Theme.of(context).textTheme.bodyLarge?.fontFamily;

  return AegisGlitchEffect(
    child: Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          AnimatedOpacity(
            opacity: _showText ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Stack(
              children: [
                Text(
                  widget.loadout['name'].toString().toUpperCase(),
                  style: TextStyle(
                    fontFamily: bodyFont,
                    fontSize: 18,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 3.0
                      ..color = Colors.black,
                  ),
                ),
                Text(
                  widget.loadout['name'].toString().toUpperCase(),
                  style: TextStyle(
                    color: primaryColor,
                    fontFamily: bodyFont,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 10),
          const Divider(color: Colors.white10), 
          const SizedBox(height: 10),

          AnimatedOpacity(
            opacity: _showText ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Column(
              children: widget.loadout['attachments'].entries.map<Widget>((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.chevron_right, color: primaryColor, size: 14),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Stack(
                            children: [
                              Text(
                                "${e.key}:",
                                style: TextStyle(
                                  fontSize: 10,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 1.5
                                    ..color = Colors.black,
                                ),
                              ),
                              Text(
                                "${e.key}:",
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            Text(
                              e.value,
                              style: TextStyle(
                                fontSize: 11,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1.5
                                  ..color = Colors.black,
                              ),
                            ),
                            Text(
                              e.value,
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )).toList(),
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
  const _CombatRatingDisplay({this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats == null || stats!.combatRating == null) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
        ),
        _CombatRatingBox(rating: stats!.combatRating!),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _CombatRatingBox extends StatelessWidget {
  final CombatRating rating;
  const _CombatRatingBox({required this.rating});

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
    final color = _getRatingColor(rating.label);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8), 
      padding: const EdgeInsets.all(16), 
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6), 
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, spreadRadius: 1)
              ]
            ),
            child: Text(
              rating.label,
              style: const TextStyle(
                color: Colors.black, 
                fontSize: 24, 
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Text(
                      "COMBAT RATING",
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.2,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3
                          ..color = Colors.black,
                      ),
                    ),
                    Text(
                      "COMBAT RATING",
                      style: TextStyle(
                        color: color.withOpacity(0.8),
                        fontSize: 9,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Stack(
                  children: [
                    Text(
                      rating.description,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.3,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3
                          ..color = Colors.black,
                      ),
                    ),
                    Text(
                      rating.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
  const AugmentTreeScreen({super.key});

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
      setState(() {
        _currPageValue = _pageController.page!;
      });
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
  String fileName = "";
  String key = "";
  
  if (activeCategory == "PERKS") { 
    fileName = "Perks_202602141947.json"; 
    key = "Perks"; 
  }
  else if (activeCategory == "AMMO MODS") { 
    fileName = "Ammo_Mods_202602141947.json"; 
    key = "Ammo_Mods"; 
  }
  else { 
    fileName = "Field_Upgrades_202602141947.json"; 
    key = "Field_Upgrades"; 
  }

  try {
    final String response = await loadHotfixedJson('assets/$fileName'); 

    final data = json.decode(response);

    if (data[key] != null) {
      List<AugmentItem> loaded = (data[key] as List)
          .map((i) => AugmentItem.fromJson(i))
          .toList();
      
      loaded.sort((a, b) => a.name.compareTo(b.name));

      setState(() {
        items = loaded;
        isLoading = false;
      });
    }
  } catch (e) {
    debugPrint("Augment Load Error: $e");
    setState(() => isLoading = false);
  }
}

Widget _buildCategorySelector() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    child: Row(
      children: ["PERKS", "AMMO MODS", "FIELD UPGRADES"].map((cat) {
        bool isActive = activeCategory == cat;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() => activeCategory = cat);
              _loadData();
              _pageController.jumpToPage(0);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isActive ? Theme.of(context).colorScheme.primary : Colors.white10, 
                  width: isActive ? 2 : 1
                ),
              ),
              child: Center(
                child: Stack(
                  children: [
                    Text(
                      cat, 
                      style: TextStyle(
                        fontSize: 10, 
                        letterSpacing: 1,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3
                          ..color = Colors.black,
                      )
                    ),
                    Text(
                      cat, 
                      style: TextStyle(
                        color: isActive ? Theme.of(context).colorScheme.primary : Colors.white38, 
                        fontSize: 10, 
                        letterSpacing: 1
                      )
                    ),
                  ],
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
      centerTitle: true,
      title: Stack(
        children: [
          Text(
            "AUGMENT TREE", 
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily, 
              fontSize: 18,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..color = Colors.black,
            )
          ),
          Text(
            "AUGMENT TREE", 
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily, 
              fontSize: 18, 
              color: Colors.white
            )
          ),
        ],
      ),
      backgroundColor: Colors.black,
      elevation: 0,
    ),
      body: Column(
        children: [

          _buildCategorySelector(),

          Expanded(
            child: isLoading 
              ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary))
              : PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    double scale = 0.85;
                    if (index == _currPageValue.floor()) {
                      scale = 1.0 - (_currPageValue - index) * (1 - 0.85);
                    } else if (index == _currPageValue.floor() + 1) {
                      scale = 0.85 + (_currPageValue - index + 1) * (1 - 0.85);
                    } else if (index == _currPageValue.floor() - 1) {
                      scale = 0.85 + (index - _currPageValue + 1) * (1 - 0.85);
                    }

                    return Transform.scale(
                      scale: scale.clamp(0.85, 1.0),
                      child: _AugmentCard(item: items[index]),
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
  const _AugmentCard({required this.item});

 Map<String, dynamic> _parseAugment(String raw) {
    String clean = raw.replaceAll(RegExp(r'>?\s?BO7\s?|BO7\s?>?|>'), "").trim();
    List<String> parts = clean.split("|");
    String baseRaw = parts[0].trim();
    String? bo7Raw = parts.length > 1 ? parts[1].trim() : null;
    String formatChoice(String text) {
      return text.replaceAll("/", " [OR] ").trim();
    }

    String? bo7Display;
    bool isReplacement = false;

    if (bo7Raw != null) {
      if (raw.contains("BO7 >")) {
        isReplacement = true;
        bo7Display = formatChoice(bo7Raw);
      } else {
        isReplacement = false;
        bo7Display = formatChoice(bo7Raw.replaceAll("+", ""));
      }
    }

    return {
      "base": formatChoice(baseRaw),
      "bo7": bo7Display,
      "isReplacement": isReplacement,
    };
  }

Widget _renderAugmentText(String text, TextStyle baseStyle) {
    Widget buildStrokedText(String content) {
      return Stack(
        children: [
          Text(
            content.trim(),
            style: baseStyle.copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..color = Colors.black,
            ),
          ),
          Text(
            content.trim(),
            style: baseStyle,
          ),
        ],
      );
    }

    if (!text.contains("[OR]")) return buildStrokedText(text);

    List<String> segments = text.split("[OR]");
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (int i = 0; i < segments.length; i++) ...[
          buildStrokedText(segments[i]),
          if (i < segments.length - 1)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white24, width: 0.5),
              ),
              child: const Text(
                "OR", 
                style: TextStyle(color: Colors.white38, fontSize: 8)
              ),
            ),
        ]
      ],
    );
  }

  Widget _buildStandardBox(String title, String content, Color color) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: color.withOpacity(0.05),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Text(title, style: TextStyle(fontSize: 9, letterSpacing: 1.5, foreground: Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = Colors.black)),
            Text(title, style: TextStyle(color: color, fontSize: 9, letterSpacing: 1.5)),
          ],
        ),
        const SizedBox(height: 8),
        _renderAugmentText(content, const TextStyle(color: Colors.white, fontSize: 12, height: 1.4)),
      ],
    ),
  );
}

Widget _buildBO7Box(Map<String, dynamic> minor, Map<String, dynamic> major) {
  bool hasMinorBO7 = minor['bo7'] != null;
  bool hasMajorBO7 = major['bo7'] != null;
  if (!hasMinorBO7 && !hasMajorBO7) return const SizedBox.shrink();

  Widget buildSubLabel(String label) {
    return Stack(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            letterSpacing: 0.5,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.6
              ..color = Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.amberAccent.withOpacity(0.5), 
            fontSize: 8,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.amberAccent.withOpacity(0.04),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.amberAccent.withOpacity(0.3), width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 14),
            const SizedBox(width: 8),
            Stack(
              children: [
                Text("BO7 ONLY", style: TextStyle(fontSize: 10, letterSpacing: 1.2, foreground: Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = Colors.black)),
                const Text("BO7 ONLY", style: TextStyle(color: Colors.amberAccent, fontSize: 10, letterSpacing: 1.2)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        
        if (hasMinorBO7) ...[
          buildSubLabel(minor['isReplacement'] ? "REPLACED IN BO7 BY:" : "ADDITIONAL MINOR AUGMENT SLOT:"),
          const SizedBox(height: 4),
          _renderAugmentText(minor['bo7'], const TextStyle(color: Colors.white, fontSize: 12)),
        ],

        if (hasMinorBO7 && hasMajorBO7) const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(color: Colors.amberAccent, thickness: 0.1),
        ),

        if (hasMajorBO7) ...[
          buildSubLabel(major['isReplacement'] ? "REPLACED IN BO7 BY:" : "MAJOR AUGMENT EVOLUTION:"),
          const SizedBox(height: 4),
          _renderAugmentText(major['bo7'], const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final minorData = _parseAugment(item.minor);
    final majorData = _parseAugment(item.major);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 30)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(child: Image.network(item.image, height: 130, fit: BoxFit.contain)),
            const SizedBox(height: 20),
            
            Center(
              child: Stack(
                children: [
                  Text(
                    item.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
                      fontSize: 22,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = Colors.black,
                    ),
                  ),
                  Text(
                    item.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
                      fontSize: 22, 
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            Center(child: Container(width: 30, height: 2, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 25),
            _buildStandardBox("MINOR AUGMENT", minorData['base']!, Theme.of(context).colorScheme.primary),
            _buildStandardBox("MAJOR AUGMENT", majorData['base']!, Colors.purpleAccent),
            _buildBO7Box(minorData, majorData),
          ],
        ),
      ),
    );
  }
}

class MetaDashboardScreen extends StatefulWidget {
  const MetaDashboardScreen({super.key});

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

  final PageController _pageController = PageController(viewportFraction: 0.82);
  double _currPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() => setState(() => _currPageValue = _pageController.page!));
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

        return MetaWeapon.fromJson(metaEntry, imageEntry);
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
      title: Stack(
        children: [
          Text(
            "META PICKS", 
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily, 
              fontSize: 16, 
              letterSpacing: 1.5,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2.5
                ..color = Colors.black,
            )
          ),
          Text(
            "META PICKS", 
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily, 
              fontSize: 16, 
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.5,
            )
          ),
        ],
      ),

      backgroundColor: Colors.black,
      centerTitle: true,
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
            ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary))
            : PageView.builder(
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
                    child: _MetaCard(weapon: filteredItems[index]),
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
    bool isActive = activeClass == label;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => activeClass = label);
        if (_pageController.hasClients) _pageController.jumpToPage(0);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isActive ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.white.withOpacity(0.05),
          border: Border.all(color: isActive ? Theme.of(context).colorScheme.primary : Colors.white10),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.white38, fontSize: 9, fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily)),
        ),
      ),
    );
  }

Widget _buildGameSelector(List<String> options) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Row(
      children: options.map((opt) => Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque, 
          onTap: () {
            HapticFeedback.mediumImpact();
            setState(() {
              activeGame = opt;
              
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
              _pageController.animateToPage(
                0, 
                duration: const Duration(milliseconds: 300), 
                curve: Curves.easeOut
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: activeGame == opt 
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1) 
                  : Colors.white.withOpacity(0.05),
              border: Border.all(
                color: activeGame == opt 
                    ? Theme.of(context).colorScheme.primary 
                    : Colors.white10
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Stack(
                children: [
                  Text(
                    opt, 
                    style: TextStyle(
                      fontSize: 10, 
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1.8
                        ..color = Colors.black
                    )
                  ),
                  Text(
                    opt, 
                    style: TextStyle(
                      color: activeGame == opt ? Colors.white : Colors.white38, 
                      fontSize: 10
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
      )).toList(),
    ),
  );
}
}

class _MetaCard extends StatelessWidget {
  final MetaWeapon weapon;
  const _MetaCard({required this.weapon});

  @override
  Widget build(BuildContext context) {
    bool isRanked = weapon.rank != null;
    String cleanName = weapon.name.replaceAll('•', '').replaceAll(RegExp(r'^\d+\.\s?'), '').trim().toUpperCase();
    final primary = Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D0D),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isRanked ? Colors.amberAccent.withOpacity(0.3) : primary.withOpacity(0.3),
              width: 1.5
            ),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (weapon.weaponImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Image.network(
                    weapon.weaponImage!,
                    height: 120,
                    fit: BoxFit.contain,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) return child;
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        child: child,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint("❌ Failed to load: ${weapon.weaponImage}");
                      return const Icon(Icons.broken_image, size: 80, color: Colors.white10);
                    },
                  ),
                )
              else
                Icon(Icons.legend_toggle_rounded, size: 80, color: Colors.white.withOpacity(0.05)),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isRanked ? Colors.amberAccent : primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: isRanked 
                  ? Text(
                      "RANKED #${weapon.rank}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    )
                  : Stack(
                      children: [
                        Text(
                          "POWER PICK",
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 0.5,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2.5
                              ..color = Colors.black,
                          ),
                        ),
                        Text(
                          "POWER PICK",
                          style: TextStyle(
                            color: primary,
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
              ),
              
              const SizedBox(height: 15),
              
              Stack(
                children: [
                  Text(
                    cleanName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily, 
                      fontSize: 22, 
                      letterSpacing: 1.2,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = Colors.black,
                    ),
                  ),
                  Text(
                    cleanName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22, 
                      color: Colors.white, 
                      letterSpacing: 1.2
                    ),
                  ),
                ],
              ),
              
              Stack(
                children: [
                  Text(
                    weapon.classType.toUpperCase(), 
                    style: TextStyle(
                      fontSize: 9, 
                      letterSpacing: 2,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1.8
                        ..color = Colors.black,
                    )
                  ),
                  Text(
                    weapon.classType.toUpperCase(), 
                    style: const TextStyle(color: Colors.white24, fontSize: 9, letterSpacing: 2)
                  ),
                ],
              ),
            ],
          ),
        ),

        if (weapon.gameImage != null)
          Positioned(
            top: 45,
            right: 25,
            child: Opacity(
              opacity: 0.8,
              child: Image.network(
                weapon.gameImage!,
                width: 45,
              ),
            ),
          ),
      ],
    );
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

  String baseName = rawName
      .replaceAll(_prestigeRegex, '')
      .replaceAll(_akimboRegex, '')
      .trim(); 

  var imgData = imageLookup[baseName] ?? {'weapon_image': "", 'game_image': ""};
  String weaponImageUrl = imgData['weapon_image'] ?? "";

  if (weaponImageUrl.isNotEmpty) {
    weaponImageUrl = weaponImageUrl.replaceAll(RegExp(r'\.[a-zA-Z0-9]+(?=\?|$)'), '.png');
    weaponImageUrl = Uri.encodeFull(weaponImageUrl);
  }

      String modeKey = "Multiplayer";
      if (filePath.contains("special")) modeKey = "Special";
      else if (filePath.contains("zombies")) modeKey = "Zombies";
      else if (filePath.contains("warzone")) modeKey = "Warzone";
      else if (filePath.contains("rebirth")) modeKey = "Rebirth";
      else if (filePath.contains("endgame")) modeKey = "Endgame";
      else if (filePath.contains("akimbo")) modeKey = "Akimbo";
      else if (filePath.contains("single")) modeKey = "Single";
      if (rawName.toUpperCase().contains("PRESTIGE")) modeKey = "Warzone Prestige";

      List<String> cleanAttachments = [];
      List<String> starredAttachments = [];
      Set<String> detectedCodes = {};
      bool showOpticBox = false;
      String? styleFound;
      String? modName = item['mod'] ?? item['mod_name'];

      void processAttachment(dynamic raw) {
        if (raw == null) return;
        String val = raw.toString().trim();
        if (val.isEmpty || val.toLowerCase() == "null") return;
        if (_codeRegex.hasMatch(val)) { detectedCodes.add(val); return; }
        
        String upper = val.toUpperCase();
        if (_opticDictionary.any((optic) => upper.contains(optic))) starredAttachments.add(val);
        if (upper.contains("SIGHT") || upper.contains("OPTIC") || upper.contains("SCOPE")) showOpticBox = true;
        if (upper.contains("TAC STANCE") || upper.contains("ADS") || upper.contains("HIPFIRE")) { styleFound = val; return; }
        cleanAttachments.add(val.replaceAll('\\', ''));
      }

      for (int k = 1; k <= 8; k++) processAttachment(item['attach_$k']);
      processAttachment(item['recommended_sight_shooting_style']);

      WeaponStats? buildStats;
      WeaponStats? alternativeStats;

      bool isWarzoneType = (modeKey == "Warzone" || 
                            modeKey == "Rebirth" || 
                            modeKey == "Warzone Prestige");
      bool isSpecialType = (modeKey == "Special");

      if (isWarzoneType || isSpecialType) {
        String searchName = rawName.toUpperCase();
        String searchMod = modName?.toUpperCase() ?? "";
        String combinedSearch = "$searchName $searchMod".trim();
        
        if (searchName.contains("SOKOL 545")) {
          buildStats = statsLookup["SOKOL 545 (SLOW)"];
          alternativeStats = statsLookup["SOKOL 545 (FAST)"];
        } else {

          buildStats = statsLookup[combinedSearch];
          if (buildStats == null && isWarzoneType) {
            buildStats = statsLookup[searchName];
          }
        }

        if (buildStats != null) {
          bool isAkimboBuild = rawName.toUpperCase().contains("AKIMBO") || searchMod.contains("AKIMBO");

          if (isWarzoneType) {
            String? archetype = _archetypeLookup[combinedSearch] ?? 
                                _archetypeLookup[searchName] ?? 
                                _archetypeLookup[baseName.toUpperCase()];
            
            if (archetype != null) {
              buildStats.combatRating = calculateCombatRatingStatic(buildStats, archetype, isAkimboBuild);
              
              if (alternativeStats != null) {
                alternativeStats.combatRating = calculateCombatRatingStatic(alternativeStats, archetype, isAkimboBuild);
              }
            } else {
              buildStats.combatRating = null;
            }
          } else {
            buildStats.combatRating = null;
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
      ));
  }
  }

  return grouped.values.toList()..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
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

    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment(-1.0 + (animationValue * 2.0), 0),
        end: Alignment(1.0 + (animationValue * 2.0), 0),
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
    return ValueListenableBuilder<double>(
      valueListenable: masterBorderNotifier,
      builder: (context, animValue, _) {
        return RepaintBoundary(
          child: CustomPaint(
            painter: SweepBorderPainter(
              colors: colors,
              animationValue: animValue, 
              strokeWidth: 2.5,
            ),
            child: child,
          ),
        );
      },
    );
  }
}