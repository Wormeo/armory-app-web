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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  if (defaultTargetPlatform != TargetPlatform.linux || kIsWeb) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
    } catch (e) {
      debugPrint("Firebase init failed: $e");
    }
  } else {
    debugPrint("🖥️ Running on Linux: Firebase features are disabled.");
  }

  runApp(const MyApp());
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
  
  // Add this line so the rating has a home!
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
    this.combatRating, // And add it here
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
      weaponImage: imageEntry?['weapon_image'], // Check if this is 'weapon_image' in your JSON
      gameImage: imageEntry?['game_image'],   // Check if this is 'game_image' in your JSON
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(2, 91, 207, 1),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        useMaterial3: true,
      ),
      home: const LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

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
    // We start immediately now.
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
    // Ensure we transition even if it fails so the user isn't stuck
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
  const MyHomePage({super.key, required this.preloadedData, required this.initialPremiumStatus});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum ConnectionStatus { connected, tunnelIssue, offline }

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  List<Weapon> _loadedWeapons = [];
  List<Weapon> displayList = [];
  bool _isPremiumUser = false;
  bool _dataReady = true;

  ConnectionStatus _connectionStatus = ConnectionStatus.offline;
  Timer? _statusTimer;
  final String _ngrokUrl = "https://cherty-frowningly-rickie.ngrok-free.dev";

  Widget _SearchField({required Function(String) onChanged}) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: TextField(
      onChanged: onChanged,
      autofocus: false, // STOPS THE AUTO-OPEN
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "SEARCH WEAPONS...",
        hintStyle: const TextStyle(color: Colors.white24, fontFamily: 'Bungee', fontSize: 12),
        prefixIcon: const Icon(Icons.search, color: Colors.cyanAccent),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
    ),
  );
}

// 2. Fix the Black Screen: Ensure displayList is ready
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addObserver(this);
  
  displayList = List.from(widget.preloadedData); 
  _isPremiumUser = widget.initialPremiumStatus;
  
  // 1. Initialize the Controller
  _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  // 2. INITIALIZE THE ANIMATION (The missing piece)
  _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
    CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
  );

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
        Text(
          statusText,
          style: TextStyle(
            fontFamily: 'Bungee',
            fontSize: 7,
            color: statusColor.withOpacity(0.8),
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

@override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _statusTimer?.cancel();
    _pulseController.dispose();
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

  // 1. Initial Check Snackbar
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("VERIFYING DATA INTEGRITY...", style: TextStyle(fontFamily: 'Bungee', color: Colors.cyanAccent, fontSize: 12)),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 1),
    ),
  );

  // 2. Run Sync
  bool updateFound = await _syncData();

  if (updateFound) {
    if (mounted) {
      // 3. NEW: Notify user that the download/processing has started
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("DOWNLOADING LATEST PATCH...", style: TextStyle(fontFamily: 'Bungee', color: Colors.amberAccent, fontSize: 12)),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2),
        ),
      );
    }

    await _performPreload(); 
    
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("PATCH COMPLETE. SYSTEM UPDATED.", style: TextStyle(fontFamily: 'Bungee', color: Colors.cyanAccent, fontSize: 12)),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2),
        ),
      );
    }

  } else {
    // 4. No update needed
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("SYSTEM UP TO DATE.", style: TextStyle(fontFamily: 'Bungee', color: Colors.cyanAccent, fontSize: 12)),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
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
          didUpdate = true; // We found an update!
          
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
  
  // Premium Verification State
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

 Set<String> _favorites = {};

 void _showPatchNotes(BuildContext context) {
  final List<String> notes = [
    "!features",
    "loadout viewer with search function",
    "randomizer with exclusion zone and params",
    "augment tree",
    "favouriting of loadouts",
    "functioning login system for premium members",
    "meta picks with elegant card display and selectors",
    "hotfix tunnel for immediate tuning updates",
    "functional connection status on home screen",
    "auto checking and updating of weapon data on boot"
  ];

showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF0D0D0D),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.cyanAccent, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      title: const Text("SYSTEM UPDATES | BETA V0.8.3 - XEON",
          style: TextStyle(fontFamily: 'Bungee', color: Colors.cyanAccent, fontSize: 14)),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: notes.length,
          itemBuilder: (context, i) {
            String line = notes[i];
            bool shouldCenter = line.startsWith('!');

            if (shouldCenter) {
              line = line.substring(1);
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                shouldCenter ? line : "> $line",
                textAlign: shouldCenter ? TextAlign.center : TextAlign.left,
                style: TextStyle(
                  color: shouldCenter ? Colors.cyanAccent : Colors.white70,
                  fontSize: shouldCenter ? 12 : 11,
                  fontFamily: 'Bungee',
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("ACKNOWLEDGE",
              style: TextStyle(color: Colors.cyanAccent, fontFamily: 'Bungee', fontSize: 10)),
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
    // ignore: use_build_context_synchronously
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
  final TextEditingController _bugController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      title: const Text("ARMORY BUG REPORT", 
        style: TextStyle(fontFamily: 'Bungee', color: Colors.cyanAccent, fontSize: 14)),
      content: TextField(
        controller: _bugController,
        maxLines: 3,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: "Describe the issue and how it occurred if applicable.",
          hintStyle: TextStyle(color: Colors.cyanAccent),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("CANCEL", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
          onPressed: () async {
            if (_bugController.text.isNotEmpty) {
              final note = _bugController.text;

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
  return Scaffold(
    backgroundColor: Colors.black,
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
          const Text(
            "THE ARMORY", 
            style: TextStyle(
              fontFamily: 'Bungee', 
              fontSize: 20,
              letterSpacing: 4.0, 
              color: Colors.white
            )
          ),
          const SizedBox(height: 4),
          _buildStatusIndicator(),
        ],
      ), 
      centerTitle: true, 
      backgroundColor: Colors.black.withOpacity(0.7), 
      elevation: 0
    ),

    body: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          // 1. Background Image
          Positioned.fill(
            child: Image.network(
              "https://res.cloudinary.com/dctlpj7fg/image/upload/f_auto,q_auto/v1745431924/Armory_Bot_Background_1080_idegb5.jpg",
              fit: BoxFit.cover,
              cacheWidth: 1080, 
              filterQuality: FilterQuality.low,
              color: Colors.black.withOpacity(0.6),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Column(
              children: [
                _SearchField(onChanged: search),
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
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.cyanAccent),
                    SizedBox(height: 16),
                    Text(
                      "SYNCHRONIZING DATA...",
                      style: TextStyle(
                        fontFamily: 'Bungee',
                        color: Colors.cyanAccent,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
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
  return Drawer(
    backgroundColor: const Color(0xFF0D0D0D),
    child: Column(
      children: [
        // 1. Header Section with responsive height
        SafeArea(
          bottom: false,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: const Center(
              child: Text(
                "THE ARMORY DRAWER",
                style: TextStyle(
                  fontFamily: 'Bungee',
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
        
        const Divider(color: Colors.white10, height: 3),

        // 2. Main Scrollable Content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              const SizedBox(height: 20),

              // AEGIS PROTOCOL BOX
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 255, 255, 0.05),
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.3), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    FadeTransition(
                      opacity: _pulseAnimation,
                      child: const Icon(Icons.shield_rounded, color: Colors.cyanAccent, size: 24),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "AEGIS PROTOCOL: ACTIVE",
                      style: TextStyle(fontFamily: 'Bungee', color: Colors.cyanAccent, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // RANDOMIZER BUTTON
              _buildDrawerButton(
                label: "RANDOMIZER",
                icon: Icons.cached_rounded,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RandomLoadoutScreen())),
              ),
              
              const SizedBox(height: 15),

              // AUGMENT TREE BUTTON
              _buildDrawerButton(
                label: "AUGMENT TREE",
                icon: Icons.hub_rounded,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AugmentTreeScreen())),
              ),

              const SizedBox(height: 15),

              // META BUTTON
              _buildDrawerButton(
                label: "META PICKS",
                icon: Icons.assessment_rounded, // Looks like a chart/ranking
                onTap: () {
                  HapticFeedback.heavyImpact();
                  _showMetaDashboard(); // We'll build this next
                },
              ),
              
              const SizedBox(height: 20),
              const Divider(color: Colors.white10, thickness: 1),
              const SizedBox(height: 20),

              // CONDITIONAL USER SECTION
              _isPremiumUser
                ? _buildPremiumSection()
                : _buildAuthSection(),
            ],
          ),
        ),

        // 3. Bottom Pinned Section
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

Widget _buildMinorDrawerTile({required String label, required IconData icon, required VoidCallback onTap}) {
  return ListTile(
    dense: true, 
    visualDensity: VisualDensity.compact,
    leading: Icon(icon, color: Colors.white24, size: 18),
    title: Text(
      label, 
      style: const TextStyle(
        fontFamily: 'Bungee', 
        fontSize: 9, 
        color: Colors.white24, 
        letterSpacing: 1.1
      )
    ),
    onTap: onTap,
  );
}

Widget _buildDrawerButton({required String label, required IconData icon, required VoidCallback onTap}) {
  return SizedBox(
    width: double.infinity,
    height: 55, 
    child: OutlinedButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.cyanAccent.withOpacity(0.5)),
        backgroundColor: Colors.cyanAccent.withOpacity(0.02),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(opacity: _pulseAnimation, child: Icon(icon, size: 20, color: Colors.cyanAccent)),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontFamily: 'Bungee', fontSize: 12, color: Colors.white, letterSpacing: 1.5)),
        ],
      ),
    ),
  );
}

Widget _buildPremiumSection() {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 191, 0, 0.05),
          border: Border.all(color: Colors.amberAccent.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            FadeTransition(opacity: _pulseAnimation, child: const Icon(Icons.stars_rounded, color: Colors.amberAccent, size: 24)),
            const SizedBox(width: 15),
            const Text("PREMIUM STATUS: ACTIVE", style: TextStyle(fontFamily: 'Bungee', color: Colors.amberAccent, fontSize: 12)),
          ],
        ),
      ),
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
        child: const Text("TERMINATE SESSION", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    ],
  );
}

Widget _buildAuthSection() {
  return Column(
    children: [
      TextField(
        controller: _idController,
        style: const TextStyle(color: Colors.cyanAccent, fontFamily: 'Bungee', fontSize: 13),
        decoration: InputDecoration(
          labelText: "DISCORD USER ID",
          labelStyle: const TextStyle(fontSize: 10, color: Colors.cyanAccent),
          prefixIcon: const Icon(Icons.person_search, color: Colors.cyanAccent), // Fits "ID"
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent.withOpacity(0.3))),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
        ),
      ),

      const SizedBox(height: 15),

      TextField(
        controller: _pinController,
        keyboardType: TextInputType.number, 
        obscureText: true,
        maxLength: 6,
        style: const TextStyle(color: Colors.cyanAccent, fontFamily: 'Bungee', fontSize: 13),
        decoration: InputDecoration(
          labelText: "SECRET PIN",
          labelStyle: const TextStyle(fontSize: 10, color: Colors.cyanAccent),
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.cyanAccent), // Keep the lock
          counterStyle: const TextStyle(color: Colors.white38), 
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent.withOpacity(0.3))),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
        ),
      ),
      const SizedBox(height: 30),
      ElevatedButton(
        onPressed: _verifyPremium,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 45)),
        child: const Text("AUTHENTICATE", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const SizedBox(height: 15),
      OutlinedButton.icon(
        onPressed: () => launchUrl(Uri.parse('https://buy.stripe.com/dRm6oH6BFamr8Xe2CddUY00'), mode: LaunchMode.externalApplication),
        icon: const Icon(Icons.shopping_cart_outlined, size: 16),
        label: const Text("BUY PREMIUM"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.amberAccent, side: const BorderSide(color: Colors.amberAccent), minimumSize: const Size(double.infinity, 45)),
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

  const WeaponListItem({
    super.key,
    required this.weapon,
    required this.mainListChips,
    required this.isPremium,
    required this.isFavorite,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF141414).withOpacity(0.9),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => DetailScreen(weapon: weapon, isPremiumUser: isPremium))),
        leading: _SmartImage(url: weapon.gameLogoUrl, width: 40),
        title: Text(weapon.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(padding: const EdgeInsets.only(top: 8),
        child: SingleChildScrollView(scrollDirection: Axis.horizontal,
        child: Row(children: mainListChips.map((m) => _StatusChip(label: m, isActive: weapon.builds.containsKey(m))).toList()))),
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
      )
    );
  }
}

class DetailScreen extends StatefulWidget {
  final Weapon weapon;
  final bool isPremiumUser;
  const DetailScreen({super.key, required this.weapon, required this.isPremiumUser});
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
    final currentBuild = flatBuilds[selectedIndex];
    final bool isSokol = widget.weapon.name.toUpperCase().contains("SOKOL 545");
    
    WeaponStats? displayStats = (isSokol && isFastMode && currentBuild.alternativeStats != null)
        ? currentBuild.alternativeStats
        : currentBuild.stats;

    final hasStats = displayStats != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.weapon.name, style: const TextStyle(fontWeight: FontWeight.bold)), 
        backgroundColor: Colors.black,
        actions: [
          // 2. FIRE MODE TOGGLE (Only shows if it's Sokol and Stats are enabled)
          if (hasStats && showStats && isSokol)
            _buildFireModeToggle(),

          if (hasStats) ...[
            if (widget.isPremiumUser) ...[
              const Center(child: Text("STATS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.cyanAccent, letterSpacing: 1))),
              Switch(
                value: showStats, 
                onChanged: (v) => setState(() => showStats = v),
                activeColor: Colors.cyanAccent,
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
      body: Column(
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
                return GestureDetector(
                  onTap: () => setState(() {
                    selectedIndex = index;
                    if (flatBuilds[index].stats == null) showStats = false;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: sel 
                        ? (b.category == "Special" ? Colors.purple : b.category.contains("Prestige") ? const Color(0xFFFFD700) : const Color.fromRGBO(2, 91, 207, 1)) 
                        : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: sel ? Colors.white : Colors.white12),
                    ),
                    child: Text(
                      (b.modName ?? b.category).toUpperCase(), 
                      style: TextStyle(
                        fontSize: 10, 
                        fontWeight: FontWeight.bold, 
                        color: sel && b.category.contains("Prestige") ? Colors.black : Colors.white
                      )
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
                // 3. UPDATED: Pass displayStats so Combat Rating badge updates on toggle
                if (hasStats) 
                  _CombatRatingDisplay(stats: displayStats),

                // 4. UPDATED: Pass displayStats so raw numbers update on toggle
                if (showStats && hasStats && widget.isPremiumUser) 
                  _PremiumStatCard(stats: displayStats),

                if (currentBuild.modName != null) 
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 12), 
                    child: Center(child: Text(currentBuild.modName!.toUpperCase(), style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.w900, letterSpacing: 1.2)))
                  ),
                
                ...currentBuild.buildCodes.map((c) => _BuildCodeBox(code: c, weaponName: widget.weapon.name, mode: currentBuild.category)),
                const SizedBox(height: 10),
                ...currentBuild.attachments.map((att) => _AttachmentTile(text: att, isStarred: currentBuild.starredAttachments.contains(att))),
                if (currentBuild.specialtyValue != null) _SpecialtyBox(value: currentBuild.specialtyValue!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFireModeToggle() {
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
            color: isFastMode ? Colors.redAccent.withOpacity(0.2) : Colors.greenAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: isFastMode ? Colors.redAccent : Colors.greenAccent),
          ),
          child: Text(
            isFastMode ? "FAST FIRE" : "SLOW FIRE",
            style: TextStyle(
              color: isFastMode ? Colors.redAccent : Colors.greenAccent,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              fontFamily: 'Bungee'
            ),
          ),
        ),
      ),
    );
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
        color: Colors.cyanAccent.withOpacity(0.02),
        border: Border.symmetric(horizontal: BorderSide(color: Colors.cyanAccent.withOpacity(0.1))),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text("ADVANCED WEAPON STATS", 
              style: TextStyle(color: Colors.cyanAccent.withOpacity(0.5), fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 2)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_hasData(stats.ttk1))
                  Expanded(child: Center(child: _StatItem(label: "TTK RANGE 1", value: stats.ttk1))),

                if (_hasData(stats.ttk2))
                  Expanded(
                    child: Center(
                      child: _StatItem(
                        label: (stats.range2 != "-" && stats.range2.isNotEmpty) ? "TTK >${stats.range2}" : "LONG TTK", 
                        value: stats.ttk2
                      ),
                    ),
                  ),

                Expanded(child: Center(child: _StatItem(label: "ADS SPEED", value: stats.adsSpeed))),
                Expanded(child: Center(child: _StatItem(label: "BULLET VELOCITY", value: stats.bulletVelocity))),
                Expanded(child: Center(child: _StatItem(label: "SHOTS TO KILL", value: stats.shotsToKill))),
                
                if (!_hasData(stats.ttk2) && _hasData(stats.range2))
                   Expanded(child: Center(child: _StatItem(label: "DROP", value: stats.range2))),

                Expanded(child: Center(child: _StatItem(label: "HITSCAN RANGE", value: stats.hitscanRange))),

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
        Text(value, 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white, height: 1.0),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(label.toUpperCase(), 
          style: const TextStyle(color: Colors.cyanAccent, fontSize: 8, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
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
  final String label; final bool isActive;
  const _StatusChip({required this.label, required this.isActive});
  @override
  Widget build(BuildContext context) {
    Color activeColor = const Color.fromRGBO(2, 91, 207, 1);
    if (label == "Special") activeColor = Colors.purple;
    if (label == "Akimbo") activeColor = Colors.orange;
    if (label == "Single") activeColor = Colors.green;
    if (label.contains("Prestige")) activeColor = const Color(0xFFFFD700);
    return Container(margin: const EdgeInsets.only(right: 6), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: isActive ? activeColor.withOpacity(0.2) : Colors.transparent, borderRadius: BorderRadius.circular(4), border: Border.all(color: isActive ? activeColor.withOpacity(0.5) : Colors.white10)), child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isActive ? Colors.white : Colors.white10)));
  }
}

class _ImageHeader extends StatelessWidget {
  final String url;
  const _ImageHeader({required this.url});
  @override
  Widget build(BuildContext context) {
    return Stack(children: [Container(height: 180, width: double.infinity, alignment: Alignment.center, child: _SmartImage(url: url, width: 300)), Positioned.fill(child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.9)]))))]);
  }
}

class _BuildCodeBox extends StatelessWidget {
  final String code, weaponName, mode;
  const _BuildCodeBox({required this.code, required this.weaponName, required this.mode});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: InkWell(onTap: () { Clipboard.setData(ClipboardData(text: code)); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$weaponName code copied!"), behavior: SnackBarBehavior.floating, backgroundColor: const Color.fromRGBO(2, 91, 207, 1))); }, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.cyanAccent.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.cyanAccent.withOpacity(0.2))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.copy, size: 16, color: Colors.cyanAccent), const SizedBox(width: 10), Text(code, style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold))]))));
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
  const RandomLoadoutScreen({super.key});

  @override
  State<RandomLoadoutScreen> createState() => _RandomLoadoutScreenState();
}

class _RandomLoadoutScreenState extends State<RandomLoadoutScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final Random _rng = Random(); 
  
  List<dynamic> _allWeaponData = [];
  List<String> _weaponNames = [];
  String? _selectedWeapon;
  bool _isRandomWeapon = false;
  int _amount = 1;
  List<Map<String, dynamic>> _generatedLoadouts = [];
  String _selectedMode = 'WARZONE';

  // --- EXCLUSION ZONE STATE ---
  bool _isExclusionZoneActive = false;
  List<String> _excludedGames = [];
  final List<String> _gameKeys = ["MW2", "MW3", "BO6", "BO7", "CW", "MW19"];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(_pulseController);
    _loadSettings();
    _loadCADData();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
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
        const SnackBar(content: Text("PLEASE SELECT A WEAPON SYSTEM", style: TextStyle(fontFamily: 'Bungee', fontSize: 10)))
      );
      return;
    }

    if (_allWeaponData.isEmpty) return;

    HapticFeedback.heavyImpact();
    List<Map<String, dynamic>> tempResults = [];
    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    // --- STEP 1: APPLY MODE FILTER + EXCLUSION ZONE ---
    List<dynamic> allowedPool = _allWeaponData.where((w) {
      String url = (w['game_image'] ?? "").toString().toUpperCase();
      
      // EXCLUSION ZONE LOGIC
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
        const SnackBar(content: Text("CRITICAL ERROR: EXCLUSION ZONE EMPTY", style: TextStyle(fontFamily: 'Bungee', fontSize: 10, color: Colors.redAccent)))
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
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("MODULE: RANDOMIZER", style: TextStyle(fontFamily: 'Bungee', fontSize: 14, color: Colors.cyanAccent)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent, size: 16), onPressed: () => Navigator.pop(context)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildStatusHeader(),
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
                      )
                    ),

                    if (_isExclusionZoneActive) _buildExclusionDropdown(),

                    const SizedBox(height: 10),
                    _buildControlTile("RANDOM WEAPON", Switch(value: _isRandomWeapon, activeColor: Colors.cyanAccent, onChanged: (v) => setState(() => _isRandomWeapon = v))),
                    
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
                            controller: controller, focusNode: focusNode,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            decoration: _inputDecoration("SEARCH ARMORY...").copyWith(
                              suffixIcon: controller.text.isNotEmpty ? IconButton(icon: const Icon(Icons.close, size: 16), onPressed: () => controller.clear()) : const Icon(Icons.search, size: 16),
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
                                decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white10)),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero, shrinkWrap: true, itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final option = options.elementAt(index);
                                    final weaponData = _allWeaponData.firstWhere((w) => w['weapon_name'] == option);
                                    String url = (weaponData['game_image'] ?? "").toString().toUpperCase();
                                    
                                    bool isBlocked = _isExclusionZoneActive && _excludedGames.any((game) => url.contains(game.toUpperCase()));

                                    return ListTile(
                                      title: Text(option, style: TextStyle(color: isBlocked ? Colors.white24 : Colors.white, fontSize: 12)),
                                      subtitle: isBlocked ? const Text("LOCKED: EXCLUSION ZONE", style: TextStyle(color: Colors.amberAccent, fontSize: 8, fontFamily: 'Bungee')) : null,
                                      trailing: isBlocked ? const Icon(Icons.lock_outline, color: Colors.amberAccent, size: 14) : null,
                                      onTap: isBlocked ? null : () => onSelected(option),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ] else _buildLockedSearchTile(),

                    const SizedBox(height: 10),
                    _buildControlTile("GAME MODE", _buildModeDropdown()),
                    const SizedBox(height: 10),
                    _buildControlTile("QUANTITY", _buildQuantityDropdown()),
                    const SizedBox(height: 30),
                    _buildInitializeButton(),
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

  // --- UI COMPONENTS ---

  Widget _buildStatusHeader() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        // BOX 1: SYSTEM READY
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.cyanAccent.withOpacity(0.05),
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Row(
            children: [
              FadeTransition(opacity: _pulseAnimation, child: const Icon(Icons.bolt, color: Colors.cyanAccent, size: 20)),
              const SizedBox(width: 12),
              const Text("SYSTEM READY: SELECT PARAMETERS", style: TextStyle(fontFamily: 'Bungee', color: Colors.cyanAccent, fontSize: 10)),
            ],
          ),
        ),
        
        // BOX 2: EXCLUSION ZONE (With Allowed Games readout)
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
                        const Text("EXCLUSION ZONE: ACTIVE", style: TextStyle(fontFamily: 'Bungee', color: Colors.amberAccent, fontSize: 10)),
                        const Text("  |  ", style: TextStyle(color: Colors.white24, fontSize: 10)),
                        const Text("ALLOWED: ", style: TextStyle(fontFamily: 'Bungee', color: Colors.white38, fontSize: 10)),
                        Text(
                          (_gameKeys.where((g) => !_excludedGames.contains(g)).toList()..sort()).join(" | "),
                          style: const TextStyle(fontFamily: 'Bungee', color: Colors.cyanAccent, fontSize: 10),
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

  Widget _buildExclusionDropdown() {
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
          const Text("GAMES TO EXCLUDE", style: TextStyle(color: Colors.white38, fontFamily: 'Bungee', fontSize: 10)),
          PopupMenuButton<String>(
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
                style: const TextStyle(color: Colors.amberAccent, fontSize: 10, fontFamily: 'Bungee'),
              ),
            ),
          )],
      ),
    );
  }

  Widget _buildControlTile(String label, Widget trailing) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05)))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontFamily: 'Bungee', fontSize: 10)),
        trailing,
      ]),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24, fontSize: 10),
      filled: true,
      fillColor: Colors.white.withOpacity(0.02),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.cyanAccent),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildModeDropdown() {
    return DropdownButton<String>(
      value: _selectedMode,
      onChanged: (v) => setState(() => _selectedMode = v!),
      dropdownColor: const Color(0xFF0D0D0D),
      underline: const SizedBox(),
      items: ['WARZONE', 'MULTIPLAYER'].map((mode) => DropdownMenuItem(value: mode, child: Text(mode, style: const TextStyle(color: Colors.cyanAccent, fontSize: 12, fontFamily: 'Bungee')))).toList(),
    );
  }

  Widget _buildQuantityDropdown() {
    return DropdownButton<int>(
      value: _amount,
      onChanged: (v) => setState(() => _amount = v!),
      dropdownColor: const Color(0xFF0D0D0D),
      underline: const SizedBox(),
      items: List.generate(10, (i) => i + 1).map((e) => DropdownMenuItem(value: e, child: Text("$e", style: const TextStyle(color: Colors.cyanAccent)))).toList(),
    );
  }

  Widget _buildInitializeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _generate,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: const Text("INITIALIZE", style: TextStyle(fontFamily: 'Bungee', letterSpacing: 2)),
      ),
    );
  }

  Widget _buildLockedSearchTile() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), border: Border.all(color: Colors.white10), borderRadius: BorderRadius.circular(8)),
      child: const Row(children: [Icon(Icons.lock_outline, color: Colors.white38, size: 14), SizedBox(width: 10), Text("SEARCH LOCKED: RANDOM MODE ACTIVE", style: TextStyle(color: Colors.white38, fontSize: 9, fontFamily: 'Bungee'))]),
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
      stream: Stream.periodic(const Duration(milliseconds: 40)), // Slightly faster jitter
      builder: (context, snapshot) {
        return Stack(
          children: [
            // Ghost Layer 1
            Transform.translate(
              offset: Offset(_random.nextDouble() * 6 - 3, _random.nextDouble() * 2 - 1),
              child: Opacity(opacity: 0.4, child: widget.child),
            ),
            // Ghost Layer 2
            Transform.translate(
              offset: Offset(_random.nextDouble() * -6 + 3, _random.nextDouble() * -2 + 1),
              child: Opacity(opacity: 0.2, child: widget.child),
            ),
            // The Stable Base (stays dark)
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
    // Wait for the jitter to stabilize before showing text
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _showText = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AegisGlitchEffect(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // WEAPON NAME FADE
            AnimatedOpacity(
              opacity: _showText ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Text(
                widget.loadout['name'].toString().toUpperCase(),
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontFamily: 'Bungee',
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // STABLE DIVIDER (Does not fade, jitters with the box)
            const Divider(color: Colors.white10), 
            
            const SizedBox(height: 10),

            // ATTACHMENTS FADE
            AnimatedOpacity(
              opacity: _showText ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500), // Slightly slower for effect
              child: Column(
                children: widget.loadout['attachments'].entries.map<Widget>((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.chevron_right, color: Colors.cyanAccent, size: 14),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "${e.key}:",
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            e.value,
                            style: const TextStyle(color: Colors.white, fontSize: 11),
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
    // If no stats or no rating, render nothing
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
      // 1. Remove horizontal margin to match the edge-to-edge look of other boxes
      margin: const EdgeInsets.symmetric(vertical: 8), 
      // 2. Consistent padding
      padding: const EdgeInsets.all(16), 
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        // 3. Match your standard border radius (usually 4 or 6 in your file)
        borderRadius: BorderRadius.circular(6), 
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            // 4. Fixed width/height container for the letter ensures alignment
            width: 45,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              rating.label,
              style: const TextStyle(
                color: Colors.black, 
                fontWeight: FontWeight.bold, 
                fontSize: 24, // Slightly larger to fill the 45x45 box
                fontFamily: 'Bungee'
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "COMBAT RATING", 
                  style: TextStyle(
                    color: color.withOpacity(0.8), 
                    fontSize: 9, 
                    fontWeight: FontWeight.w900, // Matching the 'heavy' look of your app
                    letterSpacing: 1.2
                  )
                ),
                const SizedBox(height: 4),
                Text(
                  rating.description,
                  style: const TextStyle(
                    color: Colors.white, // White text is easier to read than colored opacities
                    fontSize: 11, 
                    fontWeight: FontWeight.w500,
                    height: 1.3 // Adds a bit of breathing room to the text
                  ),
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

  // Factory to handle the different JSON keys
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
                // Reset carousel to first item when switching categories
                _pageController.jumpToPage(0);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isActive ? Colors.cyanAccent : Colors.white10, 
                    width: isActive ? 2 : 1
                  ),
                  boxShadow: isActive ? [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.2), 
                      blurRadius: 8
                    )
                  ] : [],
                ),
                child: Center(
                  child: Text(
                    cat, 
                    style: TextStyle(
                      color: isActive ? Colors.cyanAccent : Colors.white38, 
                      fontSize: 10, 
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1
                    )
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
        title: const Text("AUGMENT TREE", style: TextStyle(fontFamily: 'Bungee', fontSize: 18)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // The Row Selector remains the same as before...
          _buildCategorySelector(),

          Expanded(
            child: isLoading 
              ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
              : PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    // CALCULATE SCALE
                    // 1.0 is full size, 0.85 is the "shrunk" side size
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
    if (!text.contains("[OR]")) return Text(text, style: baseStyle);

    List<String> segments = text.split("[OR]");
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (int i = 0; i < segments.length; i++) ...[
          Text(segments[i].trim(), style: baseStyle),
          if (i < segments.length - 1)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white24, width: 0.5),
              ),
              child: const Text("OR", style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
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
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 9, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          _renderAugmentText(content, const TextStyle(color: Colors.white, fontSize: 12, height: 1.4, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildBO7Box(Map<String, dynamic> minor, Map<String, dynamic> major) {
    bool hasMinorBO7 = minor['bo7'] != null;
    bool hasMajorBO7 = major['bo7'] != null;

    if (!hasMinorBO7 && !hasMajorBO7) return const SizedBox.shrink();

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
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 14),
              SizedBox(width: 8),
              Text("BO7 ONLY", style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.2)),
            ],
          ),
          const SizedBox(height: 15),
          
          if (hasMinorBO7) ...[
            Text(
              minor['isReplacement'] ? "REPLACED IN BO7 BY:" : "ADDITIONAL MINOR SLOT:",
              style: TextStyle(color: Colors.amberAccent.withOpacity(0.5), fontSize: 8, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 4),
            _renderAugmentText(minor['bo7'], const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],

          if (hasMinorBO7 && hasMajorBO7) const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Colors.amberAccent, thickness: 0.1),
          ),

          if (hasMajorBO7) ...[
            Text(
              major['isReplacement'] ? "REPLACED IN BO7 BY:" : "MAJOR AUGMENT EVOLUTION:",
              style: TextStyle(color: Colors.amberAccent.withOpacity(0.5), fontSize: 8, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 4),
            _renderAugmentText(major['bo7'], const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
            Center(child: Text(item.name, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Bungee', fontSize: 22, color: Colors.white))),
            const SizedBox(height: 8),
            Center(child: Container(width: 30, height: 2, color: Colors.cyanAccent)),
            const SizedBox(height: 25),
            _buildStandardBox("MINOR AUGMENT", minorData['base']!, Colors.cyanAccent),
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
  String? activeClass; // Null initially to auto-select first available
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
    // 1. Load the Weapon Database
    final String weaponResponse = await loadHotfixedJson('assets/Weapon_Names_202602160630.json');
    final Map<String, dynamic> weaponData = json.decode(weaponResponse);
    final List<dynamic> weaponList = weaponData['Weapon_Names'] ?? [];

    // 2. Extract Game Logos for fallbacks (SAI/RGL-80)
    String? cwLogo = weaponList.firstWhere((w) => w['weapon_name'].toString().contains('(CW)'), orElse: () => null)?['game_image'];
    String? mw3Logo = weaponList.firstWhere((w) => w['weapon_name'].toString().contains('MW3'), orElse: () => null)?['game_image'];

    // 3. Load the Meta Rankings
    final String metaResponse = await loadHotfixedJson('assets/META_202602160120.json');
    final metaData = json.decode(metaResponse);

    setState(() {
      allWeapons = (metaData['META'] as List).map((metaEntry) {
        String rawName = metaEntry['weapon'] ?? "";
        
        // --- STEP A: NORMALIZE PREFIXES ---
        String searchName = rawName.replaceFirst('•', '').trim();
        searchName = searchName.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim();

        // --- STEP B: HANDLE OUTLIERS & REDIRECTS ---
        if (searchName.toUpperCase() == "MAGNUM") searchName = "MAGNUM (CW)";
        if (searchName.toUpperCase() == "AKIMBO P890") searchName = "P890";

        // --- STEP C: STRIP PRESTIGE & WZ IDENTITY ---
        searchName = searchName.replaceAll('(PRESTIGE)', '').trim();
        if (searchName.contains('SNIPER SUPPORT')) {
          searchName = searchName.split('SNIPER SUPPORT')[0].trim();
        }

        // --- STEP D: PERFORM LOOKUP ---
        dynamic imageEntry = weaponList.firstWhere(
          (w) => w['weapon_name'].toString().trim().toUpperCase() == searchName.toUpperCase(),
          orElse: () => null,
        );

        // --- STEP E: HARDCODED INJECTION (SAI / RGL-80) ---
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

      // --- FINAL POLISH: INTELLIGENT CLASS SELECTION ---
      if (allWeapons.any((w) => w.game == activeGame)) {
        final List<String> currentClasses = allWeapons
            .where((w) => w.game == activeGame)
            .map((w) => w.classType)
            .toSet()
            .toList();

        // Check priorities: Warzone Close Range ALWAYS takes the crown
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
      title: const Text("GLOBAL META", style: TextStyle(fontFamily: 'Bungee', fontSize: 16, color: Colors.cyanAccent)),
      backgroundColor: Colors.black,
      centerTitle: true,
    ),
    body: Column(
      children: [
        // Automatically fetch games from JSON to avoid "MWIII" vs "MW3" naming errors
        _buildGameSelector(allWeapons.map((w) => w.game).toSet().toList()..sort()),

        // Dynamic, Sorted Class Selector
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
            ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
            : PageView.builder(
                controller: _pageController,
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  // ... Keep existing scale logic for 120Hz smoothness
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
          color: isActive ? Colors.cyanAccent.withOpacity(0.1) : Colors.white.withOpacity(0.05),
          border: Border.all(color: isActive ? Colors.cyanAccent : Colors.white10),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: isActive ? Colors.cyanAccent : Colors.white38, fontSize: 9, fontFamily: 'Bungee')),
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
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() {
                activeGame = opt;
                
                // Get all available classes for the NEWLY selected game
                final List<String> newGameClasses = allWeapons
                    .where((w) => w.game == opt)
                    .map((w) => w.classType)
                    .toSet()
                    .toList();

                // Re-apply the same priority logic here
                if (newGameClasses.contains("CLOSE RANGE (WZ)")) {
                  activeClass = "CLOSE RANGE (WZ)";
                } else if (newGameClasses.contains("MULTIPLAYER")) {
                  activeClass = "MULTIPLAYER";
                } else {
                  activeClass = newGameClasses.isNotEmpty ? newGameClasses.first : null;
                }
              });
              if (_pageController.hasClients) _pageController.jumpToPage(0);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: activeGame == opt ? Colors.cyanAccent.withOpacity(0.1) : Colors.white.withOpacity(0.05),
                border: Border.all(color: activeGame == opt ? Colors.cyanAccent : Colors.white10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: Text(opt, style: TextStyle(color: activeGame == opt ? Colors.cyanAccent : Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))),
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
    String cleanName = weapon.name.replaceAll('•', '').replaceAll(RegExp(r'^\d+\.\s?'), '').trim();

    return Stack(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D0D),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isRanked ? Colors.amberAccent.withOpacity(0.3) : Colors.cyanAccent.withOpacity(0.1),
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

              // RANK BADGE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isRanked ? Colors.amberAccent : Colors.cyanAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isRanked ? "RANKED #${weapon.rank}" : "POWER PICK",
                  style: TextStyle(
                    color: isRanked ? Colors.black : Colors.cyanAccent,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Bungee'
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              
              Text(
                cleanName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Bungee', fontSize: 22, color: Colors.white, letterSpacing: 1.2),
              ),
              
              Text(
                weapon.classType, 
                style: const TextStyle(color: Colors.white24, fontSize: 9, letterSpacing: 2)
              ),
            ],
          ),
        ),

        // GAME LOGO
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

  // 1. Process Image Names
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

  // 2. Process Stats
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
  
  // 1. CLEAN THE NAME (Keep spaces for the lookup)
  String baseName = rawName
      .replaceAll(_prestigeRegex, '')
      .replaceAll(_akimboRegex, '')
      .trim(); 

  // 2. FETCH THE URL FROM JSON
  var imgData = imageLookup[baseName] ?? {'weapon_image': "", 'game_image': ""};
  String weaponImageUrl = imgData['weapon_image'] ?? "";

  // 3. THE HEALER: Extract extension and force .png
  if (weaponImageUrl.isNotEmpty) {
    weaponImageUrl = weaponImageUrl.replaceAll(RegExp(r'\.[a-zA-Z0-9]+(?=\?|$)'), '.png');
    weaponImageUrl = Uri.encodeFull(weaponImageUrl);
  }
      
      // Categorization Logic 
      String modeKey = "Multiplayer";
      if (filePath.contains("special")) modeKey = "Special";
      else if (filePath.contains("zombies")) modeKey = "Zombies";
      else if (filePath.contains("warzone")) modeKey = "Warzone";
      else if (filePath.contains("rebirth")) modeKey = "Rebirth";
      else if (filePath.contains("endgame")) modeKey = "Endgame";
      else if (filePath.contains("akimbo")) modeKey = "Akimbo";
      else if (filePath.contains("single")) modeKey = "Single";
      if (rawName.toUpperCase().contains("PRESTIGE")) modeKey = "Warzone Prestige";

      // Attachment & Optic Logic 
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
      WeaponStats? alternativeStats; // NEW: Holder for the Fast mode stats

      bool isWarzoneType = (modeKey == "Warzone" || 
                            modeKey == "Rebirth" || 
                            modeKey == "Warzone Prestige");
      bool isSpecialType = (modeKey == "Special");

      if (isWarzoneType || isSpecialType) {
        String searchName = rawName.toUpperCase();
        String searchMod = modName?.toUpperCase() ?? "";
        String combinedSearch = "$searchName $searchMod".trim();
        
        // 1. HARDCODED SOKOL EXCEPTION
        if (searchName.contains("SOKOL 545")) {
          buildStats = statsLookup["SOKOL 545 (SLOW)"];
          alternativeStats = statsLookup["SOKOL 545 (FAST)"];
        } else {
          // 2. STANDARD LOOKUP
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
              
              // Also calculate rating for the Fast mode if it exists so the Tier badge updates too
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
        alternativeStats: alternativeStats, // NEW: Pass the Fast stats into the build
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