// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:armory_app/main.dart';

enum ThemeCategory { simple, anemone, premium, neon}

const Map<String, Map<String, String>> uiTranslations = {
  'es': {
    'SELECT LANGUAGE': 'SELECCIONAR IDIOMA',
    'LANGUAGE:': 'IDIOMA:',
    'AEGIS PROTOCOL : ACTIVE': 'PROTOCOLO AEGIS : ACTIVO',
    'RANDOMIZER': 'ALEATORIZADOR',
    'AUGMENT TREE': 'ÁRBOL DE AUMENTOS',
    'META PICKS': 'SELECCIONES META',
    'RANKED PLAY': 'MODO CLASIFICATORIO',
    'ARMORY DELTA': 'ARMERÍA DELTA',
    'HOTFIXES': 'REPARACIONES RÁPIDAS',
    'PATCH NOTES': 'NOTAS DEL PARCHE',
    'REPORT A BUG': 'REPORTAR UN ERROR',
    'JOIN THE ARMORY DISCORD': 'ÚNETE AL DISCORD DE LA ARMERÍA',
    'TRY ME OUT ON DISCORD': 'PRUÉBAME EN DISCORD',
    'INTRO SCREEN': 'PANTALLA DE INICIO',
    'PREMIUM STATUS: ACTIVE': 'ESTADO PREMIUM: ACTIVO',
    'TERMINATE SESSION': 'FINALIZAR SESIÓN',
    'DISCORD USER ID': 'ID DE USUARIO DE DISCORD',
    'SECRET PIN': 'PIN SECRETO',
    'AUTHENTICATE': 'AUTENTICAR',
    'PURCHASE PREMIUM': 'COMPRAR PREMIUM',
    'FORGOT PIN?': '¿OLVIDASTE TU PIN?',
    'THE ARMORY DRAWER': 'EL PANEL DE LA ARMERÍA',
    'THE ARMORY': 'LA ARMERÍA',
    'SYSTEM ONLINE': 'SISTEMA EN LÍNEA',
    'CORE UNREACHABLE': 'NÚCLEO NO ALCANZABLE',
    'LINK OFFLINE': 'ENLACE FUERA DE LÍNEA',
    'SEARCH WEAPONS OR ARCHETYPES...': 'BUSCAR ARMAS O ARQUETIPOS...',
    'COMBAT RATING': 'CALIFICACIÓN DE COMBATE',
    'TOP TIER PICK FOR ITS CLASS. RELIABLE AND HARD HITTING.': 'SELECCIÓN DE ÉLITE EN SU CLASE. FIABLE Y DE GRAN IMPACTO.',
    'COMPETITIVE CHOICE, BUT NOT STRONG ENOUGH FOR S TIER.': 'OPCIÓN COMPETITIVA, PERO NO LO SUFICIENTE PARA EL NIVEL S.',
    'USABLE, BUT WILL FEEL NOTICEABLY WEAKER THAN OTHER PICKS.': 'UTILIZABLE, PERO SE SIENTE NOTABLEMENTE MÁS DÉBIL QUE OTRAS OPCIONES.',
    'VASTLY OUTCLASSED. HAVE STEADY AIM IF YOU DARE TRY.': 'AMPLIAMENTE SUPERADA. TEN PUNTERÍA FIRME SI TE ATREVES A PROBARLA.',
    'MARKSMAN RIFLE': 'FUSIL TÁCTICO',
    'SNIPER': 'FUSIL DE PRECISIÓN',
    'PISTOL': 'PISTOLA',
    'SHOTGUN': 'ESCOPETA',
    'AR RANKING': 'CLASIFICACIÓN de FUSIL DE ASALTO',
    'SMG RANKING': 'CLASIFICACIÓN de SUBFUSIL',
    'SHOTGUN RANKING': 'CLASIFICACIÓN de ESCOPETA',
    'LMG RANKING': 'CLASIFICACIÓN de AMETRALLADORA LIGERA',
    'MARKSMAN RIFLE RANKING': 'CLASIFICACIÓN de FUSIL TÁCTICO',
    'SNIPER RANKING': 'CLASIFICACIÓN de FUSIL DE PRECISIÓN',
    'PISTOL RANKING': 'CLASIFICACIÓN de PISTOLA',
    'BATTLE RIFLE RANKING': 'CLASIFICACIÓN de FUSIL DE COMBATE',
    'ADVANCED WEAPON STATS': 'ESTADÍSTICAS AVANZADAS DE ARMA',
    'MULTIPLAYER': 'MULTIJUGADOR',
    'ZOMBIES': 'ZOMBIS',
    'VELOCITY': 'VELOCIDAD',
    'SHOTS TO KILL': 'DISPAROS PARA MATAR',
    'BATTLE RIFLE': 'FUSIL DE COMBATE',
    'TACTICAL RIFLE': 'FUSIL TÁCTICO', 
    'SPECIAL': 'ESPECIAL',
    'FILTER BY GAME': 'FILTRAR POR JUEGO',
    'FILTER BY CATEGORY': 'FILTRAR POR CATEGORÍA',
    'RESET FILTERS': 'REINICIAR FILTROS',
    'MODULE: RANDOMIZER': 'MÓDULO: ALEATORIZADOR',
    'SYSTEM READY: SELECT PARAMETERS': 'SISTEMA LISTO: SELECCIONAR PARÁMETROS',
    'ALLOWED GAMES:': 'JUEGOS PERMITIDOS:',
    'SEARCH ARMORY...': 'BUSCAR EN LA ARMERÍA...',
    'EXCLUSION ZONE': 'ZONA DE EXCLUSIÓN',
    'GAMES TO EXCLUDE': 'JUEGOS A EXCLUIR',
    'SELECT': 'SELECCIONAR',
    'RANDOM WEAPON': 'ARMA ALEATORIA',
    'LOCK WEAPON CHOICE': 'BLOQUEAR ELECCIÓN DE ARMA',
    'GAME MODE': 'MODO DE JUEGO',
    'CATEGORY': 'CATEGORÍA',
    'QUANTITY': 'CANTIDAD',
    'INITIALIZE': 'INICIALIZAR',
    'TYPE WEAPON NAME...': 'ESCRIBE EL NOMBRE DEL ARMA...',
    'NO MATCHES FOUND': 'SIN COINCIDENCIAS',
    'PERKS': 'VENTAJAS',
    'AMMO MODS': 'MODS. DE MUNICIÓN',
    'FIELD UPGRADES': 'MEJORAS DE CAMPO',
    'CLOSE RANGE (WZ)': 'CORTO ALCANCE (WZ)',
    'LONG RANGE (WZ)': 'LARGO ALCANCE (WZ)',
    'RANKED': 'IGUALADA',
    'RANKED PROTOCOL': 'PROTOCOLO DE IGUALADA',
    'RANKED LOADOUT': 'ARMAMENTO DE IGUALADA',
    'TAP TO VIEW ATTACHMENTS': 'TOCA PARA VER ACCESORIOS',
    'TAP TO RETURN': 'TOCA PARA VOLVER',
    'ATTACHMENTS': 'ACCESORIOS',
    'SPECIAL BUILD': 'PROYECTO ESPECIAL',
    'ARMORY COMBAT DELTA': 'ARMERÍA COMBAT DELTA',
    'SELECT TWO WEAPONS': 'SELECCIONA DOS ARMAS',
    'SWIPE FOR AEGIS EYE': 'DESLIZA PARA AEGIS EYE',
    'AEGIS EYE': 'AEGIS EYE', 
    'SLOT A': 'RANURA A',
    'SLOT B': 'RANURA B',
    'SEARCH FOR WEAPON...': 'BUSCAR ARMA...',
    'FULL AUTO': 'AUTOMÁTICO',
    'WARZONE PRESTIGE': 'PRESTIGIO DE WARZONE',
    'STOCK': 'ESTÁNDAR',
    'ARMORY CLASSIC': 'ARMERÍA CLÁSICA',
    'DUSK': 'OCASO',
    'SLATE': 'PIZARRA',
    'ROYALTY': 'REALEZA',
    'SCARLET ROSE': 'ROSA ESCARLATA',
    'COFFEE': 'CAFÉ',
    'LAVENDER': 'LAVANDA',
    'PASTEL': 'PASTEL',
    'SHERBET': 'SORBETE',
    'CHAMELEON': 'CAMALEÓN',
    'STRAWBERRY': 'FRESA',
    'GHOST': 'FANTASMA',
    'TOXIN': 'TOXINA',
    'SYSTEM SHOCK': 'CHOQUE DEL SISTEMA',
    'COLD SNAP': 'GOLPE DE FRÍO',
    'MAGMA': 'MAGMA',
    'MOLTEN GOLD': 'ORO FUNDIDO',
    'IRIDESCENT': 'IRIDISCENTE',
    'RAINBOW': 'ARCOÍRIS',
    'VIPER': 'VÍBORA',
    'NEBULA': 'NEBULOSA',
    'DARK AETHER': 'ÉTER OSCURO',
    'OPAL': 'ÓPALO',
    'NEON': 'NEÓN',
    'ANEMONE': 'ANÉMONA',
    'HOLOGRAPHIC': 'HOLOGRÁFICO',
    'INTERFACE THEME': 'TEMA DE INTERFAZ',
    'CUSTOM NEON ENGINE': 'MOTOR NEÓN PERSONALIZADO',
    'HEX': 'HEX',
    'SYSTEM FONT': 'FUENTE DEL SISTEMA',
    'SIMPLE': 'SIMPLE',
    '(FAST)': '(RÁPIDO)',
    '(SLOW)': '(LENTO)',
    '(PRESTIGE)': '(PRESTIGIO)',
    'TTK CLOSE': 'TTK CERCANO',
    'TTK FAR': 'TTK LEJANO',
    'STATS': 'ESTADÍSTICAS',
    'HITS TO KILL': 'BALAS PARA MATAR',
    'SINGLE': 'TIRO A TIRO',
    'REBIRTH': 'REBIRTH',
    'ENDGAME': 'ENDGAME',
    'SOKOL 545 (FAST)': 'SOKOL 545 (RÁPIDO)',
    'SOKOL 545 (SLOW)': 'SOKOL 545 (LENTO)',
    'STURMWOLF 45 (PRESTIGE)': 'STURMWOLF 45 (PRESTIGIO)',
    'AK-27 (PRESTIGE)': 'AK-27 (PRESTIGIO)',
    'RAZOR 9MM (PRESTIGE)': 'RAZOR 9MM (PRESTIGIO)',

    '.50 CAL KIT (MW3 MP)': 'KIT CALIBRE .50 (MW3 MP)',
    '.50 CAL KIT (WZ)': 'KIT CALIBRE .50 (WZ)',
    '2 ROUND BURST (MW3 MP)': 'RÁFAGA DE 2 BALAS (MW3 MP)',
    '2 ROUND BURST (WZ)': 'RÁFAGA DE 2 BALAS (WZ)',
    '3 ROUND BURST (MW3 MP)': 'RÁFAGA DE 3 BALAS (MW3 MP)',
    '3 ROUND BURST (WZ)': 'RÁFAGA DE 3 BALAS (WZ)',
    'AKIMBO': 'DUALES',
    'AKIMBO (MW3 MP)': 'DUALES (MW3 MP)',
    'AKIMBO MOD (MW3 MP)': 'MOD DUALES (MW3 MP)',
    'AKIMBO MOD (WZ)': 'MOD DUALES (WZ)',
    'BINARY TRIGGER': 'GATILLO BINARIO',
    'BINARY TRIGGER + ATTACHMENTS (MW3 MP)': 'GATILLO BINARIO + ACCESORIOS (MW3 MP)',
    'BLUNDERBUSS (SHOTGUN - MW3 MP)': 'TRABUCO (ESCOPETA - MW3 MP)',
    'BLUNDERBUSS (SHOTGUN - WZ)': 'TRABUCO (ESCOPETA - WZ)',
    'BULLPUP CONVERSION (MW3 MP)': 'CONVERSIÓN BULLPUP (MW3 MP)',
    'BULLPUP CONVERSION (WZ)': 'CONVERSIÓN BULLPUP (WZ)',
    'BULLPUP CONVERSION': 'CONVERSIÓN BULLPUP',
    'BURST MOD': 'MOD DE RÁFAGAS',
    'BURST MOD (MP)': 'MOD DE RÁFAGAS (MP)',
    'BURST MOD (MW3 MP)': 'MOD DE RÁFAGAS (MW3 MP)',
    'BURST MOD (WZ)': 'MOD DE RÁFAGAS (WZ)',
    'CLOSE-MID RANGE ASSAULT RIFLE (WZ)': 'FUSIL DE ASALTO CORTA-MEDIA DISTANCIA (WZ)',
    'DAMAGE INCREASE (MW3 MP)': 'AUMENTO DE DAÑO (MW3 MP)',
    'DAMAGE INCREASE (WZ)': 'AUMENTO DE DAÑO (WZ)',
    'DOUBLE BARREL MOD': 'MOD DE DOBLE CAÑÓN',
    'DUAL SHOT (MW3 MP)': 'DISPARO DUAL (MW3 MP)',
    'DUAL SHOT (RANGE, ADS - MW3 MP)': 'DISPARO DUAL (ALCANCE, ADS - MW3 MP)',
    'DUAL SHOT (TAC STANCE - MW3 MP)': 'DISPARO DUAL (POSTURA TÁCTICA - MW3 MP)',
    'DUAL SHOT (WZ)': 'DISPARO DUAL (WZ)',
    'EXTREME FIRE RATE INCREASE (MW3 MP)': 'AUMENTO EXTREMO DE CADENCIA (MW3 MP)',
    'EXTREME FIRE RATE INCREASE (WZ)': 'AUMENTO EXTREMO DE CADENCIA (WZ)',
    'FULL AUTO (MW3 MP)': 'AUTOMÁTICO (MW3 MP)',
    'FULL AUTO (WZ)': 'AUTOMÁTICO (WZ)',
    'FULL AUTO + ATTACHMENTS (MW3 MP)': 'AUTOMÁTICO + ACCESORIOS (MW3 MP)',
    'FULL AUTO + ATTACHMENTS (WZ)': 'AUTOMÁTICO + ACCESORIOS (WZ)',
    'FULL AUTO DMR': 'DMR AUTOMÁTICO',
    'FULL AUTO MID RANGE': 'AUTOMÁTICO MEDIA DISTANCIA',
    'FULL AUTO MOD': 'MOD AUTOMÁTICO',
    'GRADUAL FIRE RATE INCREASE (MP)': 'INCREMENTO GRADUAL DE CADENCIA (MP)',
    'GRADUAL FIRE RATE INCREASE (WZ)': 'INCREMENTO GRADUAL DE CADENCIA (WZ)',
    'GRADUAL FIRE RATE SPEEDUP (MW3 MP)': 'ACELERACIÓN GRADUAL DE CADENCIA (MW3 MP)',
    'GRADUAL FIRE RATE SPEEDUP (WZ)': 'ACELERACIÓN GRADUAL DE CADENCIA (WZ)',
    'HAMR CONVERSION KIT': 'KIT DE CONVERSIÓN HAMR',
    'HEAVY ASSAULT RIFLE (MW3 MP)': 'FUSIL DE ASALTO PESADO (MW3 MP)',
    'HIGH CALIBER CONVERSION': 'CONVERSIÓN DE ALTO CALIBRE',
    'HIGH DAMAGE DMR': 'DMR DE ALTO DAÑO',
    'HIGH DAMAGE KIT (MW3 MP)': 'KIT DE ALTO DAÑO (MW3 MP)',
    'HIGH DAMAGE KIT (WZ)': 'KIT DE ALTO DAÑO (WZ)',
    'JAKOBS SIX SHOOTER (AKIMBO - MW3 MP)': 'JAKOBS SIX SHOOTER (DUALES - MW3 MP)',
    'JAKOBS SIX SHOOTER (MW3 MP)': 'JAKOBS SIX SHOOTER (MW3 MP)',
    'JAKOBS SIX SHOOTER (WZ)': 'JAKOBS SIX SHOOTER (WZ)',
    'LASER RIFLE (MW3 MP)': 'FUSIL LÁSER (MW3 MP)',
    'LASER RIFLE (WZ)': 'FUSIL LÁSER (WZ)',
    'LIGHTWEIGHT ASSAULT (MW3 MP)': 'ASALTO LIGERO (MW3 MP)',
    'LIGHTWEIGHT ASSAULT (WZ)': 'ASALTO LIGERO (WZ)',
    'LIGHTWEIGHT CQB CONVERSION': 'CONVERSIÓN CQB LIGERA',
    'LIGHTWEIGHT MARKSMAN CONVERSION (MW3 MP)': 'CONVERSIÓN DE TIRADOR LIGERA (MW3 MP)',
    'LIGHTWEIGHT MARKSMAN CONVERSION (WZ)': 'CONVERSIÓN DE TIRADOR LIGERA (WZ)',
    'LOW RECOIL / LONG RANGE (MW3 MP)': 'RETROCESO BAJO / LARGO ALCANCE (MW3 MP)',
    'MID RANGE ASSAULT (MP)': 'ASALTO MEDIA DISTANCIA (MP)',
    'PNEUMATIC RIVERT LAUNCHER (MW3 MP)': 'LANZACLAVOS NEUMÁTICO (MW3 MP)',
    'RAPID FIRE': 'FUEGO RÁPIDO',
    'RAPID FIRE + MARKSMAN CONVERSION (MW3 MP)': 'FUEGO RÁPIDO + CONVERSIÓN TIRADOR (MW3 MP)',
    'RAPID FIRE + MARKSMAN RIFLE CONVERSION (WZ)': 'FUEGO RÁPIDO + CONVERSIÓN FUSIL TIRADOR (WZ)',
    'RECOILLESS (MP)': 'SIN RETROCESO (MP)',
    'RECOILLESS (WZ)': 'SIN RETROCESO (WZ)',
    'RIFLE CONVERSION (MW3 MP)': 'CONVERSIÓN A FUSIL (MW3 MP)',
    'RIFLE CONVERSION (WZ)': 'CONVERSIÓN A FUSIL (WZ)',
    'ROCKET LAUNCHER': 'LANZACOHETES',
    'SEMI AUTO + DAMAGE INCREASE (WZ)': 'SEMI-AUTO + AUMENTO DE DAÑO (WZ)',
    'SEMI AUTO + DAMAGE INCREASE': 'SEMI-AUTO + AUMENTO DE DAÑO',
    'SMG CLASS': 'CLASE SUBFUSIL',
    'SMG KIT (MW3 MP)': 'KIT DE SUBFUSIL (MW3 MP)',
    'SMG KIT (WZ)': 'KIT DE SUBFUSIL (WZ)',
    'SNIPER RIFLE (MW3 MP)': 'FUSIL DE PRECISIÓN (MW3 MP)',
    'SNIPER RIFLE (WZ)': 'FUSIL DE PRECISIÓN (WZ)',
    'SNIPER RIFLE CONVERSION (MW3 MP)': 'CONVERSIÓN A FUSIL DE PRECISIÓN (MW3 MP)',
    'SNIPER RIFLE CONVERSION (RANGE)': 'CONVERSIÓN A FUSIL DE PRECISIÓN (ALCANCE)',
    'SNIPER SUPPORT (WZ)': 'APOYO DE SNIPER (WZ)',
    'ZERO BLOOM HIPFIRE': 'DISPARO DE CADERA SIN DISPERSIÓN',

    'WELCOME TO THE ARMORY': 'BIENVENIDO A LA ARMERÍA',
    'THE NEXT GENERATION OF THE ARMORY IS HERE. COME ON IN, IT\'S GOOD TO HAVE YOU. LET\'S GET YOU UP TO SPEED ON HOW WE DO IT AROUND HERE.': 'LA PRÓXIMA GENERACIÓN DE LA ARMERÍA YA ESTÁ AQUÍ. PASA, ES UN GUSTO TENERTE. VAMOS A PONERTE AL TANTO DE CÓMO SE HACEN LAS COSAS POR AQUÍ.',

    'HOME SCREEN': 'PANTALLA DE INICIO',
    'SEARCH WEAPON NAMES, CLASS TYPES OR EVEN A GAME TO SEE ALL OF ITS WEAPONS! UTILIZE THE FILTER BUTTON TO SORT JUST HOW YOU WANT. DON\'T WANT TO SEARCH OR SCROLL EVERYTIME TO GET YOUR FAVOURITES? GO AHEAD AND FAVOURITE THEM SO THEY APPEAR ON TOP!': '¡BUSCA NOMBRES DE ARMAS, TIPOS DE CLASES O INCLUSO UN JUEGO PARA VER TODO SU ARSENAL! UTILIZA EL BOTÓN DE FILTRO PARA ORDENAR A TU GUSTO. ¿NO QUIERES BUSCAR O DESPLAZARTE CADA VEZ? ¡AÑÁDELAS A FAVORITOS PARA QUE APAREZCAN ARRIBA!',

    'SETTINGS DRAWER': 'MENÚ DE AJUSTES',
    'ACCESS MODULES, LOG IN TO ACCESS PREMIUM BENEFITS, READ PATCH NOTES, AND MORE. NEED A REFRESHER? COME BACK HERE WITH THE INTRO SCREEN BUTTON IN CASE YOU EVER GET LOST.': 'ACCEDE A MÓDULOS, INICIA SESIÓN PARA BENEFICIOS PREMIUM, LEE LAS NOTAS DEL PARCHE Y MÁS. ¿NECESITAS UN REPASO? REGRESA AQUÍ CON EL BOTÓN DE INTRODUCCIÓN EN CASO DE QUE TE PIERDAS.',

    'MODULE - META PICKS': 'MÓDULO - SELECCIÓN META',
    'STAY ON TOP OF YOUR GAME AT ALL TIMES. NEVER AGAIN WILL YOU WONDER WHAT THE BEST PICKS ARE, OR BE CONFUSED WHAT\'S WORTH USING ANYMORE FROM OLDER TITLES. ONLY THE BEST MAKE IT ON THIS LIST, AND IT\'S ALWAYS UP TO DATE.': 'MANTENTE EN LA CIMA EN TODO MOMENTO. NUNCA MÁS DUDARÁS CUÁLES SON LAS MEJORES OPCIONES NI TE CONFUNDIRÁS SOBRE QUÉ VALE LA PENA USAR EN TÍTULOS ANTERIORES. SOLO LOS MEJORES ENTRAN EN ESTA LISTA, Y SIEMPRE ESTÁ ACTUALIZADA.',

    'MODULE - RANDOMIZER': 'MÓDULO - ALEATORIZADOR',
    'ADD SOME CHAOS TO GAME NIGHT. GENERATE UP TO 10 WEAPONS AT A TIME, UTILIZE THE EXCLUSION ZONE TO BLOCK ENTIRE GAMES WHEN PICKING WEAPONS, LOCK YOUR CHOICE IN SO YOU ONLY GET RESULTS FOR THE WEAPON YOU WANT, AND MORE.': 'AÑADE CAOS A TUS NOCHES DE JUEGO. GENERA HASTA 10 ARMAS A LA VEZ, UTILIZA LA ZONA DE EXCLUSIÓN PARA BLOQUEAR JUEGOS ENTEROS, BLOQUEA TU ELECCIÓN PARA OBTENER RESULTADOS DE UN ARMA ESPECÍFICA Y MUCHO MÁS.',

    'MODULE - COMBAT DELTA / AEGIS EYE': 'MÓDULO - COMBAT DELTA / AEGIS EYE',
    'THE ULTIMATE COMPARISON TOOL. DIRECTLY COMPARE WEAPONS TO SEE IF YOUR CONTROLLER WILL ENTER ORBIT DURING A FIGHT OR NOT (LOSING IS TOUGH, WE KNOW). TAP AND HOLD TO REMOVE YOUR PICKS IF YOU CHANGED YOUR MIND. SWIPE THE SCREEN TO ACCESS AEGIS EYE, A GLOBAL STAT TRACKER SORTED HOW YOU WANT. HIGHEST VELOCITY? FASTEST TTK AT RANGE 1? YOU GOT IT. TAP THE STAT NUMBERS TO VIEW MORE DETAILS! DEFAULT STAT IS TTK CLOSE.': 'LA HERRAMIENTA DE COMPARACIÓN DEFINITIVA. COMPARA ARMAS DIRECTAMENTE PARA VER SI TU MANDO SALDRÁ VOLANDO EN UNA PELEA (PERDER ES DURO, LO SABEMOS). MANTÉN PRESIONADO PARA ELIMINAR TU SELECCIÓN. DESLIZA LA PANTALLA PARA ACCEDER A AEGIS EYE, UN RASTREADOR DE ESTADÍSTICAS GLOBALES ORDENADO COMO QUIERAS. ¿MAYOR VELOCIDAD? ¿TTK MÁS RÁPIDO A DISTANCIA 1? LO TIENES. ¡TOCA LOS NÚMEROS PARA VER MÁS DETALLES! LA ESTADÍSTICA PREDETERMINADA ES TTK CERCANO.',

    'THEMES': 'TEMAS',
    'MAKE ARMORY APP YOURS. WITH TONS OF THEMES AND EVEN MORE FONT CHOICES, WE TAKE CUSTOMIZATION VERY SERIOUSLY AROUND HERE. PREMIUM MEMBERS WILL HAVE ACCESS TO EXCLUSIVE THEMES THAT TAKE IT A STEP FURTHER.': 'HAZ TUYA LA APP DE LA ARMERÍA. CON TONELADAS DE TEMAS E INCLUSO MÁS OPCIONES DE FUENTES, NOS TOMAMOS LA PERSONALIZACIÓN MUY EN SERIO. LOS MIEMBROS PREMIUM TENDRÁN ACCESO A TEMAS EXCLUSIVOS QUE LLEVAN EL DISEÑO A OTRO NIVEL.',

    'PREMIUM BENEFITS': 'BENEFICIOS PREMIUM',
    'ON TOP OF EXCLUSIVE THEMES, YOU ALSO GET ACCESS TO THE ARMORY\'S ADVANCED WEAPON STATS, A SYSTEM BUILT FOR THOSE THAT REQUIRE ABSOLUTE PRECISION WHEN IT COMES TO MAKING EVERY MILLISECOND IN AN ENGAGEMENT MATTER. HOW FAST WILL THIS GUN DOWN AT 27 METERS? CAN THIS SNIPER ONE SHOT? NOW YOU KNOW.': 'ADEMÁS DE TEMAS EXCLUSIVOS, OBTENDRÁS ACCESO A LAS ESTADÍSTICAS AVANZADAS DE LA ARMERÍA, UN SISTEMA CREADO PARA QUIENES REQUIEREN PRECISIÓN ABSOLUTA CUANDO CADA MILISEGUNDO CUENTA. ¿QUÉ TAN RÁPIDO ABATE ESTE FUSIL A 27 METROS? ¿PUEDE ESTE SNIPER MATAR DE UN TIRO? AHORA LO SABRÁS.',

    'LOGGING IN': 'INICIAR SESIÓN',
    'IF YOU\'RE A PREMIUM MEMBER WITH ARMORY BOT, YOU\'RE IN LUCK BECAUSE ARMORY APP IS MOVING IN NEXT DOOR AND IS VERY EXCITED TO MINGLE. LOG IN WITH YOUR DISCORD ID AND SECRET PIN TO GET ALL YOUR BENEFITS SYNCED UP ACROSS BOTH SERVICES. HOW DO YOU GET YOUR PIN? HEAD ON OVER TO ARMORY BOT AND USE THE /armorypin COMMAND AND IT WILL GET YOU SORTED.': 'SI ERES MIEMBRO PREMIUM DE ARMORY BOT, ESTÁS DE SUERTE. INICIA SESIÓN CON TU ID DE DISCORD Y PIN SECRETO PARA SINCRONIZAR TUS BENEFICIOS EN AMBOS SERVICIOS. ¿CÓMO OBTENER TU PIN? DIRÍGETE AL BOT DE LA ARMERÍA Y USA EL COMANDO /armorypin PARA SOLUCIONARLO.',
    'TIME TO DEPLOY': 'HORA DE DESPLEGAR',
    'WELL DONE, YOU\'VE PASSED INSPECTION. LET\'S GET YOU KITTED UP AND READY TO HIT THE FIELD SPRINTING. STAY FROSTY, YOUR SQUAD DEPENDS ON IT.': 'BIEN HECHO, HAS PASADO LA INSPECCIÓN. VAMOS A EQUIPARTE PARA QUE SALGAS AL CAMPO A TODA VELOCIDAD. MANTENTE ALERTA, TU ESCUADRÓN DEPENDE DE TI.',

    'SYSTEM UPDATES' : 'ACTUALIZACIONES DEL SISTEMA',
    "ARMORY BUG REPORT" : "INFORME DE ERRORES DE ARMORY",
    "DESCRIBE THE ISSUE AND HOW IT OCCURRED.": "Describe el problema y cómo ocurrió.",
    "CANCEL": "CANCELAR",
    "TRANSMIT": "TRANSMITIR",
    "CONNECTING TO ARMORY CORE...": "CONECTANDO AL NÚCLEO DE LA ARMERÍA...",
    "LOADING DATA FOR FIRST BOOT": "CARGANDO DATOS PARA EL PRIMER INICIO",

    'PURCHASE PREMIUM TO ACCESS ADVANCED WEAPON STATS': 'COMPRA PREMIUM PARA ACCEDER A ESTADÍSTICAS AVANZADAS',
    'VERIFYING DATA INTEGRITY...': 'VERIFICANDO INTEGRIDAD DE DATOS...',
    'DOWNLOADING ASSETS...': 'DESCARGANDO ÚLTIMO PARCHE...',
    'PATCH APPLIED. RESTARTING...': 'PARCHE APLICADO. REINICIANDO...',
    'ARMORY HOTFIXES': 'REPARACIONES RÁPIDAS DE LA ARMERÍA',
    "PRELOADING ASSETS...": "PRECARGANDO ACTIVOS...",

    "IF YOU FORGOT YOUR PIN, NO SWEAT. HEAD ON OVER TO A DISCORD SERVER THAT ARMORY BOT IS IN, AND USE THE /ARMORYPIN COMMAND. THIS WILL GRAB YOUR PIN AND DISPLAY IT FOR YOU TO KEEP IN YOUR FANCY NOTEBOOK YOU DEFINITELY REMEMBERED YOU HAD. AND DON'T WORRY ABOUT SOMEONE STEALING IT, THE MESSAGE IS ONLY VISIBLE TO YOU. THEN, JUST COME ON BACK AND LOG IN!": "Si olvidaste tu pin, no pasa nada. Dirígete a un servidor de discord en el que esté el armory bot y usa el comando /armorypin. Esto obtendrá tu pin y lo mostrará para que lo guardes en esa libreta elegante que seguro recordabas que tenías. Y no te preocupes por si alguien te lo roba, el mensaje solo es visible para ti. ¡Luego, solo vuelve e inicia sesión!",
    "RECOVER YOUR PIN": "RECUPERAR TU PIN",
    "ACKNOWLEDGED": "ENTENDIDO",
    'ACCESS RESTRICTED': 'ACCESO RESTRINGIDO',
    'ARMORY DELTA IS A PREMIUM FEATURE.\n PLEASE LOG IN OR PURCHASE PREMIUM TO UNLOCK.': 'ARMORY DELTA ES UNA FUNCIÓN PREMIUM.\n POR FAVOR INICIE SESIÓN O ADQUIERA PREMIUM PARA DESBLOQUEAR.',
    'BACK': 'VOLVER',
    'UPGRADE': 'MEJORAR',
    'NEXT': 'SIGUIENTE',
    'PREVIOUS': 'ANTERIOR',
    "RANDOMIZER GUIDE": "GUÍA DEL ALEATORIZADOR",
    "OR": "O",
    'ENTER DISCORD ID': 'INGRESAR ID DE DISCORD',
    'PROCEED': 'PROCEDER',
    'PREMIUM ACTIVATED': 'PREMIUM ACTIVADO',
    'Your account credentials have been generated:': 'Se han generado tus credenciales de cuenta:',
    'DISCORD ID': 'ID DE DISCORD',
    'ACCESS PIN': 'PIN DE ACCESO',
    'Please save these. You can now log in.': 'Por favor guarda estos datos. Ya puedes iniciar sesión.',
    'PROCEED TO LOGIN': 'PROCEDER AL INICIO',
    "CLOSE": "CERRAR",
    "ALL": "TODO",
    "COMBAT RATINGS": "CALIFICACIONES DE COMBATE",
    "COMPETITIVE CHOICE, BUT NOT AS STRONG AS S TIER.": "OPCIÓN COMPETITIVA, PERO NO TAN FUERTE COMO EL NIVEL S.",
    "USABLE, BUT WILL FEEL NOTICABLY WEAKER THAN OTHER PICKS.": "UTILIZABLE, PERO SE SENTIRÁ NOTABLEMENTE MÁS DÉBIL QUE OTRAS OPCIONES.",
    'PREMIUM ACCESS GRANTED': 'ACCESO PREMIUM CONCEDIDO',
    'FINALIZING WITH ARMORY CORE...': 'FINALIZANDO CON ARMORY CORE...',
    'PURCHASE VERIFIED. PLEASE LOGIN TO ACTIVATE.': 'COMPRA VERIFICADA. INICIE SESIÓN PARA ACTIVAR.',
    "INJECTING HOTFIX DATA...": "INYECTANDO DATOS DE HOTFIX...",

    "ABR A1 FULL AUTO": "ABR A1 AUTOMÁTICA",
    "AEK-973 FULL AUTO MID RANGE": "AEK-973 AUTO ALCANCE MEDIO",
    "DG-58 LSW BULLPUP CONVERSION": "CONVERSIÓN BULLPUP DG-58 LSW",
    "M16 (MW2) FULL AUTO": "M16 (MW2) AUTOMÁTICA",
    "M8A1 SNIPER SUPPORT": "M8A1 APOYO SNIPER",
    "MCW SNIPER SUPPORT": "MCW APOYO SNIPER",
    "RENETTI (MW3) FULL AUTO + ATTACHMENTS": "RENETTI (MW3) AUTO + ACCESORIOS",
    "RENETTI (MW3) SEMI AUTO + DAMAGE INCREASE": "RENETTI (MW3) SEMI-AUTO + DAÑO AUMENTADO",
    "SVD FULL AUTO DMR": "SVD AUTO (DMR)",
    'SYSTEM UP TO DATE.': 'SISTEMA ACTUALIZADO.',
    'PURCHASE PREMIUM TO ACCESS THIS THEME!': '¡COMPRA PREMIUM PARA ACCEDER A ESTE TEMA!',

    "There is no shortage of options within The Armory's Randomizer. It can be intimidating, so refer back to this handy guide whenever you need a refresher.": "No faltan opciones dentro del Aleatorizador de The Armory. Puede ser intimidante, así que consulta esta práctica guía cada vez que necesites un repaso.",

    "This is where you tell the engine \"I don't want to see weapons from this game\". Pick as many as you want, but you need at least one. ": "Aquí es donde le dices al motor: \"No quiero ver armas de este juego\". Elige tantas como quieras, pero necesitas al menos una.",

    "If you only want to get random attachments for one specific weapon, but don't want to hit the button 4 times to do it, this option is what you need.": "Si solo quieres obtener accesorios aleatorios para una arma específica, pero no quieres presionar el botón 4 veces para hacerlo, esta opción es lo que necesitas.",

    "Warzone will allow choices to be picked from each game you have allowed from the Exclusion Zone. Multiplayer will utilize the anchor system,\n      which is a robust filtering logic that will only choose same-era weapons as the first pick.\n\n      So if you randomly (or manually) select a Black Ops 6 weapon, and you have chosen more than 1 weapon to generate, you will only get Black Ops 6 weapons, ensuring that each pick is usable in the game that you are playing.\n      ": "Warzone permitirá que se elijan opciones de cada juego que hayas permitido en la Zona de Exclusión. El modo Multijugador utilizará el sistema de anclaje, una robusta lógica de filtrado que solo elegirá armas de la misma era que la primera elección.\n\nAsí que si seleccionas aleatoriamente (o manualmente) un arma de Black Ops 6, y has elegido generar más de 1 arma, solo obtendrás armas de Black Ops 6, asegurando que cada elección sea utilizable en el juego que estás jugando.",

    "If you select RANDOM WEAPON, you will see this new option appear. This will tell the engine that you only want that specific weapon class.\n      For legacy categories, the game mode is forced to Multiplayer to utilize the anchor logic and stay accurate, and to elminate overlap if you also allow other non-legacy games. You don't want a Cold War shotgun mixed in with your Black Ops 7 sniper now do you?": "Si seleccionas ARMA ALEATORIA, verás aparecer esta nueva opción. Esto le dirá al motor que solo quieres esa clase de arma específica.\nPara las categorías heredadas, el modo de juego se fuerza a Multijugador para utilizar la lógica de anclaje y mantenerse preciso, eliminando el solapamiento si también permites otros juegos no heredados. No querrías una escopeta de Cold War mezclada con tu francotirador de Black Ops 7, ¿verdad?",

    "Speed of the bullet. For snipers, higher values means less bullet drop and leading (shooting ahead of a moving target). For other weapons this also applies, but also means you won't have bullet travel time to slow down your TTK, shifting a gunfight into your favour. Higher is better.": "Velocidad de la bala. Para francotiradores, valores altos significan menos caída de bala y menor necesidad de compensar el movimiento del objetivo. En otras armas, reduce el tiempo de viaje de la bala, mejorando tu TTK. Cuanto más alto, mejor.",

    "ADS SPEED": "VELOCIDAD APUNTADO",
    "Time between when you hit the aim button, and when you are fully aimed in and ready to fire at 100% accuracy. Lower is better.": "Tiempo desde que pulsas el botón de apuntar hasta que estás listo para disparar con 100% de precisión. Cuanto más bajo, mejor.",

    "TTK CLOSE/FAR": "TTK CERCA/LEJOS",
    "Time to Kill. 'Close' is how fast you will kill within the first damage range. 'Far' is how fast you will kill within the second damage range. Lower is better.": "Tiempo para matar (TTK). 'Cerca' es la rapidez de baja en el primer rango de daño. 'Lejos' es en el segundo rango. Cuanto más bajo, mejor.",

    "The number of shots required to kill at 'Close' and 'Far' range. Lower is better.": "Número de disparos necesarios para matar a corta y larga distancia. Cuanto más bajo, mejor.",

    "HITSCAN": "HITSCAN",
    "The distance where bullets connect instantly, meaning there is no delay between pressing the fire button, and seeing a hitmarker. Higher is better.": "Distancia en la que las balas impactan al instante, sin retraso entre el disparo y la marca de impacto. Cuanto más alto, mejor.",

    "STAT TERMINOLOGY": "TERMINOLOGÍA de ESTADÍSTICAS"
  },
  'zh': {
    'SELECT LANGUAGE': '选择语言',
    'LANGUAGE:': '语言:',
    'AEGIS PROTOCOL : ACTIVE': '宙斯盾协议 : 激活',
    'RANDOMIZER': '随机生成器',
    'AUGMENT TREE': '强化树',
    'META PICKS': '版本首选',
    'RANKED PLAY': '排名模式',
    'ARMORY DELTA': '军火库 Delta',
    'HOTFIXES': '热更新',
    'PATCH NOTES': '更新日志',
    'REPORT A BUG': '反馈漏洞',
    'JOIN THE ARMORY DISCORD': '加入军火库 Discord',
    'TRY ME OUT ON DISCORD': '在 Discord 上体验',
    'INTRO SCREEN': '启动界面',
    'PREMIUM STATUS: ACTIVE': '高级状态: 激活',
    'TERMINATE SESSION': '终止会话',
    'DISCORD USER ID': 'Discord 用户 ID',
    'SECRET PIN': '安全 PIN 码',
    'AUTHENTICATE': '身份验证',
    'PURCHASE PREMIUM': '购买高级版',
    'FORGOT PIN?': '忘记 PIN 码?',
    'THE ARMORY DRAWER': '军火库侧栏',
    'THE ARMORY': '军火库',
    'SYSTEM ONLINE': '系统在线',
    'CORE UNREACHABLE': '核心无法连接',
    'LINK OFFLINE': '链接离线',
    'SEARCH WEAPONS OR ARCHETYPES...': '搜索武器或原型...',
    'COMBAT RATING': '战斗评级',
    'TOP TIER PICK FOR ITS CLASS. RELIABLE AND HARD HITTING.': '同类顶级选择。可靠且火力强劲。',
    'COMPETITIVE CHOICE, BUT NOT STRONG ENOUGH FOR S TIER.': '具备竞技力，但不足以列入 S 级。',
    'USABLE, BUT WILL FEEL NOTICEABLY WEAKER THAN OTHER PICKS.': '可用，但明显弱于其他选择。',
    'VASTLY OUTCLASSED. HAVE STEADY AIM IF YOU DARE try.': '完全被碾压。若敢尝试，请保持准头。',
    'MARKSMAN RIFLE': '神射手步枪',
    'SNIPER': '狙击步枪',
    'PISTOL': '手枪',
    'SHOTGUN': '散弹枪',
    'AR RANKING': '突击步枪排名',
    'SMG RANKING': '冲锋枪排名',
    'SHOTGUN RANKING': '散弹枪排名',
    'LMG RANKING': '轻机枪排名',
    'MARKSMAN RIFLE RANKING': '神射手步枪排名',
    'SNIPER RANKING': '狙击步枪排名',
    'PISTOL RANKING': '手枪排名',
    'BATTLE RIFLE RANKING': '战斗步枪排名',
    'ADVANCED WEAPON STATS': '高级武器数据',
    'MULTIPLAYER': '多位玩家',
    'ZOMBIES': '僵尸模式',
    'VELOCITY': '子弹速度',
    'SHOTS TO KILL': '击杀所需弹数',
    'BATTLE RIFLE': '战斗步枪',
    'TACTICAL RIFLE': '战术步枪', 
    'SPECIAL': '特殊',
    'FILTER BY GAME': '按游戏筛选',
    'FILTER BY CATEGORY': '按类别筛选',
    'RESET FILTERS': '重置筛选',
    'MODULE: RANDOMIZER': '模块: 随机生成器',
    'SYSTEM READY: SELECT PARAMETERS': '系统就绪: 选择参数',
    'ALLOWED GAMES:': '允许的游戏:',
    'SEARCH ARMORY...': '搜索军火库...',
    'EXCLUSION ZONE': '禁区',
    'GAMES TO EXCLUDE': '排除的游戏',
    'SELECT': '选择',
    'RANDOM WEAPON': '随机武器',
    'LOCK WEAPON CHOICE': '锁定武器选择',
    'GAME MODE': '游戏模式',
    'CATEGORY': '类别',
    'QUANTITY': '数量',
    'INITIALIZE': '初始化',
    'TYPE WEAPON NAME...': '输入武器名称...',
    'NO MATCHES FOUND': '未找到匹配项',
    'PERKS': '特长',
    'AMMO MODS': '弹药改装',
    'FIELD UPGRADES': '战场升级',
    'CLOSE RANGE (WZ)': '近距离 (战区)',
    'LONG RANGE (WZ)': '远距离 (战区)',
    'RANKED': '排位赛',
    'RANKED PROTOCOL': '排位协议',
    'RANKED LOADOUT': '排位配装',
    'TAP TO VIEW ATTACHMENTS': '点击查看配件',
    'TAP TO RETURN': '点击返回',
    'ATTACHMENTS': '配件',
    'SPECIAL BUILD': '特殊方案',
    'ARMORY COMBAT DELTA': '军火库战斗 Delta',
    'SELECT TWO WEAPONS': '选择两件武器',
    'SWIPE FOR AEGIS EYE': '滑动开启宙斯盾之眼',
    'AEGIS EYE': '宙斯盾之眼', 
    'SLOT A': '槽位 A',
    'SLOT B': '槽位 B',
    'SEARCH FOR WEAPON...': '搜索武器...',
    'FULL AUTO': '全自动',
    'WARZONE PRESTIGE': '战区威望',
    'STOCK': '标准',
    'ARMORY CLASSIC': '军火库经典',
    'DUSK': '黄昏',
    'SLATE': '石板',
    'ROYALTY': '皇室',
    'SCARLET ROSE': '绯红玫瑰',
    'COFFEE': '咖啡',
    'LAVENDER': '薰衣草',
    'PASTEL': '柔和',
    'SHERBET': '果汁冰沙',
    'CHAMELEON': '变色龙',
    'STRAWBERRY': '草莓',
    'GHOST': '幽灵',
    'TOXIN': '毒素',
    'SYSTEM SHOCK': '系统冲击',
    'COLD SNAP': '寒流',
    'MAGMA': '岩浆',
    'MOLTEN GOLD': '熔金',
    'IRIDESCENT': '彩虹色',
    'RAINBOW': '彩虹',
    'VIPER': '毒蛇',
    'NEBULA': '星云',
    'DARK AETHER': '暗影以太',
    'OPAL': '欧泊',
    'NEON': '霓虹',
    'ANEMONE': '海葵',
    'HOLOGRAPHIC': '全息',
    'INTERFACE THEME': '界面主题',
    'CUSTOM NEON ENGINE': '自定义霓虹引擎',
    'HEX': '十六进制',
    'SYSTEM FONT': '系统字体',
    'SIMPLE': '简约',
    '(FAST)': '(快)',
    '(SLOW)': '(慢)',
    '(PRESTIGE)': '(威望)',
    'TTK CLOSE': '近距离击杀耗时',
    'TTK FAR': '远距离击杀耗时',
    'STATS': '属性',
    'HITS TO KILL': '击杀所需命中数',
    'SINGLE': '单发',
    'REBIRTH': '重生',
    'ENDGAME': '终局',
    'SOKOL 545 (FAST)': 'SOKOL 545 (快)',
    'SOKOL 545 (SLOW)': 'SOKOL 545 (慢)',
    'STURMWOLF 45 (PRESTIGE)': 'STURMWOLF 45 (威望)',
    'AK-27 (PRESTIGE)': 'AK-27 (威望)',
    'RAZOR 9MM (PRESTIGE)': 'RAZOR 9MM (威望)',

    '.50 CAL KIT (MW3 MP)': '.50 口径套件 (MW3 多人)',
    '.50 CAL KIT (WZ)': '.50 口径套件 (战区)',
    '2 ROUND BURST (MW3 MP)': '两连发 (MW3 多人)',
    '2 ROUND BURST (WZ)': '两连发 (战区)',
    '3 ROUND BURST (MW3 MP)': '三连发 (MW3 多人)',
    '3 ROUND BURST (WZ)': '三连发 (战区)',
    'AKIMBO': '双持',
    'AKIMBO (MW3 MP)': '双持 (MW3 多人)',
    'AKIMBO MOD (MW3 MP)': '双持改装 (MW3 多人)',
    'AKIMBO MOD (WZ)': '双持改装 (战区)',
    'BINARY TRIGGER': '二元扳机',
    'BINARY TRIGGER + ATTACHMENTS (MW3 MP)': '二元扳机 + 配件 (MW3 多人)',
    'BLUNDERBUSS (SHOTGUN - MW3 MP)': '燧发枪 (散弹枪 - MW3 多人)',
    'BLUNDERBUSS (SHOTGUN - WZ)': '燧发枪 (散弹枪 - 战区)',
    'BULLPUP CONVERSION (MW3 MP)': '无托结构转换套件 (MW3 多人)',
    'BULLPUP CONVERSION (WZ)': '无托结构转换套件 (战区)',
    'BULLPUP CONVERSION': '无托结构转换套件',
    'BURST MOD': '连发改装',
    'BURST MOD (MP)': '连发改装 (多人)',
    'BURST MOD (MW3 MP)': '连发改装 (MW3 多人)',
    'BURST MOD (WZ)': '连发改装 (战区)',
    'CLOSE-MID RANGE ASSAULT RIFLE (WZ)': '中近距离突击步枪 (战区)',
    'DAMAGE INCREASE (MW3 MP)': '伤害提升 (MW3 多人)',
    'DAMAGE INCREASE (WZ)': '伤害提升 (战区)',
    'DOUBLE BARREL MOD': '双管改装',
    'DUAL SHOT (MW3 MP)': '双发齐射 (MW3 多人)',
    'DUAL SHOT (RANGE, ADS - MW3 MP)': '双发齐射 (射程, 开镜 - MW3 多人)',
    'DUAL SHOT (TAC STANCE - MW3 MP)': '双发齐射 (战术姿态 - MW3 多人)',
    'DUAL SHOT (WZ)': '双发齐射 (战区)',
    'EXTREME FIRE RATE INCREASE (MW3 MP)': '极速射速提升 (MW3 多人)',
    'EXTREME FIRE RATE INCREASE (WZ)': '极速射速提升 (战区)',
    'FULL AUTO (MW3 MP)': '全自动 (MW3 多人)',
    'FULL AUTO (WZ)': '全自动 (战区)',
    'FULL AUTO + ATTACHMENTS (MW3 MP)': '全自动 + 配件 (MW3 多人)',
    'FULL AUTO + ATTACHMENTS (WZ)': '全自动 + 配件 (战区)',
    'FULL AUTO DMR': '全自动 DMR',
    'FULL AUTO MID RANGE': '全自动中距离',
    'FULL AUTO MOD': '全自动改装',
    'GRADUAL FIRE RATE INCREASE (MP)': '射速逐渐提升 (多人)',
    'GRADUAL FIRE RATE INCREASE (WZ)': '射速逐渐提升 (战区)',
    'GRADUAL FIRE RATE SPEEDUP (MW3 MP)': '射速逐渐加快 (MW3 多人)',
    'GRADUAL FIRE RATE SPEEDUP (WZ)': '射速逐渐加快 (战区)',
    'HAMR CONVERSION KIT': 'HAMR 转换套件',
    'HEAVY ASSAULT RIFLE (MW3 MP)': '重型突击步枪 (MW3 多人)',
    'HIGH CALIBER CONVERSION': '大口径转换套件',
    'HIGH DAMAGE DMR': '高伤害 DMR',
    'HIGH DAMAGE KIT (MW3 MP)': '高伤害套件 (MW3 多人)',
    'HIGH DAMAGE KIT (WZ)': '高伤害套件 (战区)',
    'JAKOBS SIX SHOOTER (AKIMBO - MW3 MP)': '杰考伯斯六轮手枪 (双持 - MW3 多人)',
    'JAKOBS SIX SHOOTER (MW3 MP)': '杰考伯斯六轮手枪 (MW3 多人)',
    'JAKOBS SIX SHOOTER (WZ)': '杰考伯斯六轮手枪 (战区)',
    'LASER RIFLE (MW3 MP)': '激光步枪 (MW3 多人)',
    'LASER RIFLE (WZ)': '激光步枪 (战区)',
    'LIGHTWEIGHT ASSAULT (MW3 MP)': '轻型突击 (MW3 多人)',
    'LIGHTWEIGHT ASSAULT (WZ)': '轻型突击 (战区)',
    'LIGHTWEIGHT CQB CONVERSION': '轻型 CQB 转换套件',
    'LIGHTWEIGHT MARKSMAN CONVERSION (MW3 MP)': '轻型神射手转换套件 (MW3 多人)',
    'LIGHTWEIGHT MARKSMAN CONVERSION (WZ)': '轻型神射手转换套件 (战区)',
    'LOW RECOIL / LONG RANGE (MW3 MP)': '低后坐力 / 远距离 (MW3 多人)',
    'MID RANGE ASSAULT (MP)': '中距离突击 (多人)',
    'PNEUMATIC RIVERT LAUNCHER (MW3 MP)': '气动铆钉发射器 (MW3 多人)',
    'RAPID FIRE': '快速射击',
    'RAPID FIRE + MARKSMAN CONVERSION (MW3 MP)': '快速射击 + 神射手转换套件 (MW3 多人)',
    'RAPID FIRE + MARKSMAN RIFLE CONVERSION (WZ)': '快速射击 + 神射手步枪转换套件 (战区)',
    'RECOILLESS (MP)': '无后坐力 (多人)',
    'RECOILLESS (WZ)': '无后坐力 (战区)',
    'RIFLE CONVERSION (MW3 MP)': '步枪转换套件 (MW3 多人)',
    'RIFLE CONVERSION (WZ)': '步枪转换套件 (战区)',
    'ROCKET LAUNCHER': '火箭发射器',
    'SEMI AUTO + DAMAGE INCREASE (WZ)': '半自动 + 伤害提升 (战区)',
    'SEMI AUTO + DAMAGE INCREASE': '半自动 + 伤害提升',
    'SMG CLASS': '冲锋枪类',
    'SMG KIT (MW3 MP)': '冲锋枪套件 (MW3 多人)',
    'SMG KIT (WZ)': '冲锋枪套件 (战区)',
    'SNIPER RIFLE (MW3 MP)': '狙击步枪 (MW3 多人)',
    'SNIPER RIFLE (WZ)': '狙击步枪 (战区)',
    'SNIPER RIFLE CONVERSION (MW3 MP)': '狙击步枪转换套件 (MW3 多人)',
    'SNIPER RIFLE CONVERSION (RANGE)': '狙击步枪转换套件 (射程)',
    'SNIPER SUPPORT (WZ)': '狙击支援 (战区)',
    'ZERO BLOOM HIPFIRE': '零扩散腰射',

    'WELCOME TO THE ARMORY': '欢迎来到军火库',
    'THE NEXT GENERATION OF THE ARMORY IS HERE. COME ON IN, IT\'S GOOD TO HAVE YOU. LET\'S GET YOU UP TO SPEED ON HOW WE DO IT AROUND HERE.': '新一代军火库已就绪。欢迎加入，很高兴见到你。让我们带你快速了解这里的运作方式。',

    'HOME SCREEN': '主屏幕',
    'SEARCH WEAPON NAMES, CLASS TYPES OR EVEN A GAME TO SEE ALL OF ITS WEAPONS! UTILIZE THE FILTER BUTTON TO SORT JUST HOW YOU WANT. DON\'T WANT TO SEARCH OR SCROLL EVERYTIME TO GET YOUR FAVOURITES? GO AHEAD AND FAVOURITE THEM SO THEY APPEAR ON TOP!': '搜索武器名称、类别，甚至搜索特定游戏来查看其完整军备！使用筛选按钮按需排序。不想每次都搜索或翻找心仪的武器？直接将其加入收藏，让它们显示在最顶部！',

    'SETTINGS DRAWER': '设置栏',
    'ACCESS MODULES, LOG IN TO ACCESS PREMIUM BENEFITS, READ PATCH NOTES, AND MORE. NEED A REFRESHER? COME BACK HERE WITH THE INTRO SCREEN BUTTON IN CASE YOU EVER GET LOST.': '访问功能模块、登录以获取高级会员权益、阅读更新日志等。需要回顾引导？如果迷路了，随时可以通过“启动界面”按钮返回此处。',

    'MODULE - META PICKS': '模块 - 版本首选',
    'STAY ON TOP OF YOUR GAME AT ALL TIMES. NEVER AGAIN WILL YOU WONDER WHAT THE BEST PICKS ARE, OR BE CONFUSED WHAT\'S WORTH USING ANYMORE FROM OLDER TITLES. ONLY THE BEST MAKE IT ON THIS LIST, AND IT\'S ALWAYS UP TO DATE.': '时刻保持竞技巅峰。无需再纠结哪些是最佳选择，也不必为旧作中哪些武器仍值得使用而感到困惑。只有最强武装才能入选此列表，且数据实时更新。',

    'MODULE - RANDOMIZER': '模块 - 随机生成器',
    'ADD SOME CHAOS TO GAME NIGHT. GENERATE UP TO 10 WEAPONS AT A TIME, UTILIZE THE EXCLUSION ZONE TO BLOCK ENTIRE GAMES WHEN PICKING WEAPONS, LOCK YOUR CHOICE IN SO YOU ONLY GET RESULTS FOR THE WEAPON YOU WANT, AND MORE.': '为你的游戏之夜增添一些随机乐趣。一次最多生成 10 件武器，利用“禁区”功能在选择时排除整款游戏，或者锁定你的选择以仅获取特定武器的结果，功能不止于此。',

    'MODULE - COMBAT DELTA / AEGIS EYE': '模块 - 战斗 Delta / 宙斯盾之眼',
    'THE ULTIMATE COMPARISON TOOL. DIRECTLY COMPARE WEAPONS TO SEE IF YOUR CONTROLLER WILL ENTER ORBIT DURING A FIGHT OR NOT (LOSING IS TOUGH, WE KNOW). TAP AND HOLD TO REMOVE YOUR PICKS IF YOU CHANGED YOUR MIND. SWIPE THE SCREEN TO ACCESS AEGIS EYE, A GLOBAL STAT TRACKER SORTED HOW YOU WANT. HIGHEST VELOCITY? FASTEST TTK AT RANGE 1? YOU GOT IT. TAP THE STAT NUMBERS TO VIEW MORE DETAILS! DEFAULT STAT IS TTK CLOSE.': '终极对比工具。直接对比武器，预判你在交火中是否会因失控而气得“扔出手柄”（我们懂，输掉比赛很难受）。如果改变主意，长按即可移除选择。滑动屏幕开启“宙斯盾之眼”——一个可按需排序的全局数据追踪器。最高初速？1 号射程内最快 TTK？一目了然。点击数据数值可查看更多详情！默认数据显示为近距离 TTK。',

    'THEMES': '主题',
    'MAKE ARMORY APP YOURS. WITH TONS OF THEMES AND EVEN MORE FONT CHOICES, WE TAKE CUSTOMIZATION VERY SERIOUSLY AROUND HERE. PREMIUM MEMBERS WILL HAVE ACCESS TO EXCLUSIVE THEMES THAT TAKE IT A STEP FURTHER.': '打造专属你的军火库 App。我们提供海量主题和丰富的字体选择，非常注重个性化体验。高级会员将获得更进阶的专属主题。',

    'PREMIUM BENEFITS': '高级会员权益',
    'ON TOP OF EXCLUSIVE THEMES, YOU ALSO GET ACCESS TO THE ARMORY\'S ADVANCED WEAPON STATS, A SYSTEM BUILT FOR THOSE THAT REQUIRE ABSOLUTE PRECISION WHEN IT COMES TO MAKING EVERY MILLISECOND IN AN ENGAGEMENT MATTER. HOW FAST WILL THIS GUN DOWN AT 27 METERS? CAN THIS SNIPER ONE SHOT? NOW YOU KNOW.': '除了专属主题外，你还将获得军火库的“高级武器数据”访问权。该系统专为追求极致精准、不放过交战中每一毫秒的玩家打造。这把枪在 27 米处的击倒速度有多快？这把狙击枪能一枪致命吗？现在，你将掌握一切。',

    'LOGGING IN': '登录',
    'IF YOU\'RE A PREMIUM MEMBER WITH ARMORY BOT, YOU\'RE IN LUCK BECAUSE ARMORY APP IS MOVING IN NEXT DOOR AND IS VERY EXCITED TO MINGLE. LOG IN WITH YOUR DISCORD ID AND SECRET PIN TO GET ALL YOUR BENEFITS SYNCED UP ACROSS BOTH SERVICES. HOW DO YOU GET YOUR PIN? HEAD ON OVER TO ARMORY BOT AND USE THE /armorypin COMMAND AND IT WILL GET YOU SORTED.': '如果你是 Armory Bot 的高级会员，那么你很幸运，因为军火库 App 已与其关联。使用你的 Discord ID 和机密 PIN 码登录，即可在两项服务间同步所有权益。如何获取 PIN 码？前往 Armory Bot 频道并使用 /armorypin 命令即可获取。',
    'TIME TO DEPLOY': '准备部署',
    'WELL DONE, YOU\'VE PASSED INSPECTION. LET\'S GET YOU KITTED UP AND READY TO HIT THE FIELD SPRINTING. STAY FROSTY, YOUR SQUAD DEPENDS ON IT.': '干得漂亮，你已通过检查。现在全副武装，准备全速奔赴战场。保持冷静，你的小队全指望你了。',

    'SYSTEM UPDATES' : '系统更新',
    "ARMORY BUG REPORT" : "军火库漏洞反馈",
    "DESCRIBE THE ISSUE AND HOW IT OCCURRED.": "请描述该问题以及它是如何发生的。",
    "CANCEL": "取消",
    'TRANSMIT': '传输',
    "CONNECTING TO ARMORY CORE...": "正在连接至军火库核心...",
    "LOADING DATA FOR FIRST BOOT": "正在加载首次启动数据",
    'PURCHASE PREMIUM TO ACCESS ADVANCED WEAPON STATS': '购买高级版以访问进阶武器数据',
    'VERIFYING DATA INTEGRITY...': '正在验证数据完整性...',
    "DOWNLOADING ASSETS...": "正在下载资源...",
    'PATCH APPLIED. RESTARTING...': '补丁已应用。正在重启...',
    "PRELOADING ASSETS...": "正在预载资源...",
    'ARMORY HOTFIXES': '军械库热修复',
    "IF YOU FORGOT YOUR PIN, NO SWEAT. HEAD ON OVER TO A DISCORD SERVER THAT ARMORY BOT IS IN, AND USE THE /ARMORYPIN COMMAND. THIS WILL GRAB YOUR PIN AND DISPLAY IT FOR YOU TO KEEP IN YOUR FANCY NOTEBOOK YOU DEFINITELY REMEMBERED YOU HAD. AND DON'T WORRY ABOUT SOMEONE STEALING IT, THE MESSAGE IS ONLY VISIBLE TO YOU. THEN, JUST COME ON BACK AND LOG IN!": "忘记 PIN 码了？别担心。前往任一有 Armory Bot 的 Discord 服务器，使用 /armorypin 命令。这会找回你的 PIN 码，方便你记在那个你肯定还记得带在身上的华丽笔记本上。不用担心被盗，该消息仅对你可见。然后，回来登录即可！",
    "RECOVER YOUR PIN": "找回您的 PIN 码",
    "ACKNOWLEDGED": "确认",
    'ACCESS RESTRICTED': '访问受限',
    'ARMORY DELTA IS A PREMIUM FEATURE.\n PLEASE LOG IN OR PURCHASE PREMIUM TO UNLOCK.': 'ARMORY DELTA 是高级版功能。\n请登录或购买高级版以解锁。',
    'BACK': '返回',
    'UPGRADE': '升级',
    'NEXT': '下一步',
    'PREVIOUS': '上一步',
    "RANDOMIZER GUIDE": "随机生成器指南",
    "OR": "或者",
    'ENTER DISCORD ID': '输入 DISCORD ID',
    'PROCEED': '继续',
    'PREMIUM ACTIVATED': '高级版已激活',
    'Your account credentials have been generated:': '您的账户凭据已生成：',
    'DISCORD ID': 'DISCORD ID',
    'ACCESS PIN': '访问密码',
    'Please save these. You can now log in.': '请妥善保存。您现在可以登录了。',
    'PROCEED TO LOGIN': '前往登录',
    "CLOSE": "关闭",
    "ALL": "全部",
    "COMBAT RATINGS": "战斗评级",
    "COMPETITIVE CHOICE, BUT NOT AS STRONG AS S TIER.": "具有竞争力的选择，但不如 S 级强力。",
    "USABLE, BUT WILL FEEL NOTICABLY WEAKER THAN OTHER PICKS.": "勉强可用，但会明显感觉到弱于其他选择。",
    "VASTLY OUTCLASSED. HAVE STEADY AIM IF YOU DARE TRY.": "性能全方位落后。如果非要尝试，请确保你的准头够稳。",
    'PREMIUM ACCESS GRANTED': '已开通高级权限',
    "INJECTING HOTFIX DATA...": "正在注入热修复数据...",
    

    "ABR A1 FULL AUTO": "ABR A1 全自动",
    "AEK-973 FULL AUTO MID RANGE": "AEK-973 全自动中距离配置",
    "DG-58 LSW BULLPUP CONVERSION": "DG-58 LSW 无托化改装",
    "M16 (MW2) FULL AUTO": "M16 (MW2) 全自动",
    "M8A1 SNIPER SUPPORT": "M8A1 狙击辅助配置",
    "MCW SNIPER SUPPORT": "MCW 狙击辅助配置",
    "RENETTI (MW3) FULL AUTO + ATTACHMENTS": "RENETTI (MW3) 全自动 + 附件",
    "RENETTI (MW3) SEMI AUTO + DAMAGE INCREASE": "RENETTI (MW3) 半自动 + 伤害提升",
    "SVD FULL AUTO DMR": "SVD 全自动精确射手步枪",
    'SYSTEM UP TO DATE.': '系统已是最新。',
    'PURCHASE PREMIUM TO ACCESS THIS THEME!': '购买高级版以解锁此主题！',
    'PURCHASE VERIFIED. PLEASE LOGIN TO ACTIVATE.': '购买已验证。请登录以激活。',
    'FINALIZING WITH ARMORY CORE...': '正在与 ARMORY 核心同步...',

    "There is no shortage of options within The Armory's Randomizer. It can be intimidating, so refer back to this handy guide whenever you need a refresher.": "军械库的随机生成器提供了丰富的选项。由于内容较多，欢迎随时查阅本指南以获取帮助。",

    "This is where you tell the engine \"I don't want to see weapons from this game\". Pick as many as you want, but you need at least one. ": "你可以在这里告诉引擎“我不想要这个游戏里的武器”。你可以根据需要选择排除多个游戏，但至少需要保留一个。",

    "If you only want to get random attachments for one specific weapon, but don't want to hit the button 4 times to do it, this option is what you need.": "如果你只想为某件特定武器随机生成配件，而不想重复点击按钮，这个选项就是你需要的。",

    "Warzone will allow choices to be picked from each game you have allowed from the Exclusion Zone. Multiplayer will utilize the anchor system,\n      which is a robust filtering logic that will only choose same-era weapons as the first pick.\n\n      So if you randomly (or manually) select a Black Ops 6 weapon, and you have chosen more than 1 weapon to generate, you will only get Black Ops 6 weapons, ensuring that each pick is usable in the game that you are playing.\n      ": "“战区”模式将从你在排除区域中允许的每个游戏中挑选。 “多人模式”将使用锚定系统，这是一种强大的过滤逻辑，只会选择与首选武器同时代的作品。\n\n因此，如果你随机（或手动）选择了一件《黑色行动 6》武器，并且你选择生成多件武器，系统将只会生成《黑色行动 6》武器，确保每件武器都能在你正在玩的游戏中使用。",

    "If you select RANDOM WEAPON, you will see this new option appear. This will tell the engine that you only want that specific weapon class.\n      For legacy categories, the game mode is forced to Multiplayer to utilize the anchor logic and stay accurate, and to elminate overlap if you also allow other non-legacy games. You don't want a Cold War shotgun mixed in with your Black Ops 7 sniper now do you?": "如果你选择了“随机武器”，就会出现这个新选项。它会告诉引擎你只需要特定的武器类别。\n\n对于旧版类别，游戏模式将强制设定为“多人模式”以使用锚定逻辑并保持准确性，同时消除与其他非旧版游戏的重叠。你肯定不想在《黑色行动 7》的狙击枪里混入一把《冷战》的散弹枪，对吧？",
    
    "Speed of the bullet. For snipers, higher values means less bullet drop and leading (shooting ahead of a moving target). For other weapons this also applies, but also means you won't have bullet travel time to slow down your TTK, shifting a gunfight into your favour. Higher is better.": "子弹的速度。对于狙击手来说，数值越高意味着子弹下坠越小，且更易于“预判”（射击移动目标的前方）。对于其他武器同样适用，这也意味着子弹飞行时间不会拖慢你的 TTK（击杀时间），从而让交火对你更有利。数值越高越好。",

    "ADS SPEED": "开镜速度",
    "Time between when you hit the aim button, and when you are fully aimed in and ready to fire at 100% accuracy. Lower is better.": "从按下瞄准键到完全进入瞄准状态并准备好以 100% 准确度射击之间的时间。数值越低越好。",

    "TTK CLOSE/FAR": "近/远距离 TTK",
    "Time to Kill. 'Close' is how fast you will kill within the first damage range. 'Far' is how fast you will kill within the second damage range. Lower is better.": "击杀所需时间。“近”是指在第一段伤害衰减距离内的击杀速度。“远”是指在第二段伤害衰减距离内的击杀速度。数值越低越好。",

    "The number of shots required to kill at 'Close' and 'Far' range. Lower is better.": "在“近”和“远”距离下击杀目标所需的射击次数。数值越低越好。",

    "HITSCAN": "瞬时判定距离",
    "The distance where bullets connect instantly, meaning there is no delay between pressing the fire button, and seeing a hitmarker. Higher is better.": "子弹瞬间命中的距离，即按下射击键与看到命中标志之间没有延迟。数值越高越好。",

    'STAT TERMINOLOGY': '数据术语'
  },
  'fr': {
    'SELECT LANGUAGE': 'SÉLECTIONNER LA LANGUE',
    'LANGUAGE:': 'LANGUE :',
    'AEGIS PROTOCOL : ACTIVE': 'PROTOCOLE AEGIS : ACTIF',
    'RANDOMIZER': 'ALÉATORISATEUR',
    'AUGMENT TREE': 'ARBRE D’AUGMENTATIONS',
    'META PICKS': 'SÉLECTIONS META',
    'RANKED PLAY': 'PARTIE CLASSÉE',
    'ARMORY DELTA': 'ARMURERIE DELTA',
    'HOTFIXES': 'CORRECTIFS',
    'PATCH NOTES': 'NOTES DE MISE À JOUR',
    'REPORT A BUG': 'SIGNALER UN BOGUE',
    'JOIN THE ARMORY DISCORD': 'REJOINDRE LE DISCORD DE L’ARMURERIE',
    'TRY ME OUT ON DISCORD': 'ESSAYEZ-MOI SUR DISCORD',
    'INTRO SCREEN': 'ÉCRAN D’ACCUEIL',
    'PREMIUM STATUS: ACTIVE': 'STATUT PREMIUM : ACTIF',
    'TERMINATE SESSION': 'TERMINER LA SESSION',
    'DISCORD USER ID': 'ID UTILISATEUR DISCORD',
    'SECRET PIN': 'CODE PIN SECRET',
    'AUTHENTICATE': 'S’AUTHENTIFIER',
    'PURCHASE PREMIUM': 'ACHETER LE PREMIUM',
    'FORGOT PIN?': 'CODE PIN OUBLIÉ ?',
    'THE ARMORY DRAWER': 'LE MENU DE L’ARMURERIE',
    'THE ARMORY': 'L’ARMURERIE',
    'SYSTEM ONLINE': 'SYSTÈME EN LIGNE',
    'CORE UNREACHABLE': 'NOYAU INACCESSIBLE',
    'LINK OFFLINE': 'LIAISON HORS LIGNE',
    'SEARCH WEAPONS OR ARCHETYPES...': 'RECHERCHER ARMES OU ARCHÉTYPES...',
    'COMBAT RATING': 'ÉVALUATION DE COMBAT',
    'TOP TIER PICK FOR ITS CLASS. RELIABLE AND HARD HITTING.': 'SÉLECTION D’ÉLITE. FIABLE ET PUISSANTE.',
    'COMPETITIVE CHOICE, BUT NOT STRONG ENOUGH FOR S TIER.': 'CHOIX COMPÉTITIF, MAIS PAS ASSEZ FORT POUR LE RANG S.',
    'USABLE, BUT WILL feel NOTICEABLY WEAKER THAN OTHER PICKS.': 'UTILISABLE, MAIS NETTEMENT PLUS FAIBLE QUE LES AUTRES CHOIX.',
    'VASTLY OUTCLASSED. HAVE STEADY AIM IF YOU DARE TRY.': 'LARGEMENT DÉPASSÉE. VISEZ JUSTE SI VOUS OSEZ L’ESSAYER.',
    'MARKSMAN RIFLE': 'FUSIL TACTIQUE',
    'SNIPER': 'FUSIL DE PRÉCISION',
    'PISTOL': 'PISTOLET',
    'SHOTGUN': 'FUSIL À POMPE',
    'AR RANKING': 'CLASSEMENT FUSILS D’ASSAUT',
    'SMG RANKING': 'CLASSEMENT MITRAILLETES',
    'SHOTGUN RANKING': 'CLASSEMENT FUSILS À POMPE',
    'LMG RANKING': 'CLASSEMENT MITRAILLEUSES',
    'MARKSMAN RIFLE RANKING': 'CLASSEMENT FUSILS TACTIQUES',
    'SNIPER RANKING': 'CLASSEMENT FUSILS DE PRÉCISION',
    'PISTOL RANKING': 'CLASSEMENT PISTOLETS',
    'BATTLE RIFLE RANKING': 'CLASSEMENT FUSILS DE COMBAT',
    'ADVANCED WEAPON STATS': 'STATS D’ARMES AVANCÉES',
    'MULTIPLAYER': 'MULTIJOUEUR',
    'ZOMBIES': 'ZOMBIES',
    'VELOCITY': 'VÉLOCITÉ',
    'SHOTS TO KILL': 'BALLES POUR TUER',
    'BATTLE RIFLE': 'FUSIL DE COMBAT',
    'TACTICAL RIFLE': 'FUSIL TACTIQUE', 
    'SPECIAL': 'SPÉCIAL',
    'FILTER BY GAME': 'FILTRER PAR JEU',
    'FILTER BY CATEGORY': 'FILTRER PAR CATÉGORIE',
    'RESET FILTERS': 'RÉINITIALISER LES FILTRES',
    'MODULE: RANDOMIZER': 'MODULE : ALÉATORISATEUR',
    'SYSTEM READY: SELECT PARAMETERS': 'SYSTÈME PRÊT : SÉLECTIONNER PARAMÈTRES',
    'ALLOWED GAMES:': 'JEUX AUTORISÉS :',
    'SEARCH ARMORY...': 'CHERCHER DANS L’ARMURERIE...',
    'EXCLUSION ZONE': 'ZONE D’EXCLUSION',
    'GAMES TO EXCLUDE': 'JEUX À EXCLURE',
    'SELECT': 'SÉLECTIONNER',
    'RANDOM WEAPON': 'ARME ALÉATOIRE',
    'LOCK WEAPON CHOICE': 'VERROUILLER LE CHOIX DE L’ARME',
    'GAME MODE': 'MODO DE JEU',
    'CATEGORY': 'CATÉGORIE',
    'QUANTITY': 'QUANTITÉ',
    'INITIALIZE': 'INITIALISER',
    'TYPE WEAPON NAME...': 'ENTRER LE NOM DE L’ARME...',
    'NO MATCHES FOUND': 'AUCUNE CORRESPONDANCE',
    'PERKS': 'ATOUTS',
    'AMMO MODS': 'MODS DE MUNITION',
    'FIELD UPGRADES': 'AMÉLIORATIONS DE COMBAT',
    'CLOSE RANGE (WZ)': 'COURTE PORTÉE (WZ)',
    'LONG RANGE (WZ)': 'LONGUE PORTÉE (WZ)',
    'RANKED': 'CLASSÉ',
    'RANKED PROTOCOL': 'PROTOCOLE CLASSÉ',
    'RANKED LOADOUT': 'CLASSE CLASSÉE',
    'TAP TO VIEW ATTACHMENTS': 'APPUYER POUR VOIR LES ACCESSOIRES',
    'TAP TO RETURN': 'APPUYER POUR RETOURNER',
    'ATTACHMENTS': 'ACCESSOIRES',
    'SPECIAL BUILD': 'CONFIGURATION SPÉCIALE',
    'ARMORY COMBAT DELTA': 'ARMURERIE COMBAT DELTA',
    'SELECT TWO WEAPONS': 'SÉLECTIONNER DEUX ARMES',
    'SWIPE FOR AEGIS EYE': 'BALAYER POUR AEGIS EYE',
    'AEGIS EYE': 'AEGIS EYE', 
    'SLOT A': 'EMPLACEMENT A',
    'SLOT B': 'EMPLACEMENT B',
    'SEARCH FOR WEAPON...': 'RECHERCHER UNE ARME...',
    'FULL AUTO': 'AUTO',
    'WARZONE PRESTIGE': 'PRESTIGE WARZONE',
    'STOCK': 'SÉRIE',
    'ARMORY CLASSIC': 'ARMURERIE CLASSIQUE',
    'DUSK': 'CRÉPUSCULE',
    'SLATE': 'ARDOISE',
    'ROYALTY': 'ROYAUTÉ',
    'SCARLET ROSE': 'ROSE ÉCARLATE',
    'COFFEE': 'CAFÉ',
    'LAVENDER': 'LAVANDE',
    'PASTEL': 'PASTEL',
    'SHERBET': 'SORBET',
    'CHAMELEON': 'CAMÉLÉON',
    'STRAWBERRY': 'FRAISE',
    'GHOST': 'FANTÔME',
    'TOXIN': 'TOXINE',
    'SYSTEM SHOCK': 'CHOC SYSTÈME',
    'COLD SNAP': 'COUP DE FROID',
    'MAGMA': 'MAGMA',
    'MOLTEN GOLD': 'OR FONDU',
    'IRIDESCENT': 'IRIDESCENT',
    'RAINBOW': 'ARC-EN-CIEL',
    'VIPER': 'VIPÈRE',
    'NEBULA': 'NÉBULEUSE',
    'DARK AETHER': 'ÉTHER NOIR',
    'OPAL': 'OPALE',
    'NEON': 'NÉON',
    'ANEMONE': 'ANÉMONE',
    'HOLOGRAPHIC': 'HOLOGRAPHIQUE',
    'INTERFACE THEME': 'THÈME D’INTERFACE',
    'CUSTOM NEON ENGINE': 'MOTEUR NÉON PERSONNALISÉ',
    'HEX': 'HEX',
    'SYSTEM FONT': 'POLICE SYSTÈME',
    'SIMPLE': 'SIMPLE',
    '(FAST)': '(RAPIDE)',
    '(SLOW)': '(LENT)',
    '(PRESTIGE)': '(PRESTIGE)',
    'TTK CLOSE': 'TTK PROCHE',
    'TTK FAR': 'TTK LOIN',
    'STATS': 'STATS',
    'HITS TO KILL': 'BALLES POUR ÉLIMINER',
    'SINGLE': 'COUP PAR COUP',
    'REBIRTH': 'REBIRTH',
    'ENDGAME': 'ENDGAME',
    'SOKOL 545 (FAST)': 'SOKOL 545 (RAPIDE)',
    'SOKOL 545 (SLOW)': 'SOKOL 545 (LENT)',
    'STURMWOLF 45 (PRESTIGE)': 'STURMWOLF 45 (PRESTIGE)',
    'AK-27 (PRESTIGE)': 'AK-27 (PRESTIGE)',
    'RAZOR 9MM (PRESTIGE)': 'RAZOR 9MM (PRESTIGE)',

    '.50 CAL KIT (MW3 MP)': 'KIT CALIBRE .50 (MW3 MP)',
    '.50 CAL KIT (WZ)': 'KIT CALIBRE .50 (WZ)',
    '2 ROUND BURST (MW3 MP)': 'RAFALE DE 2 BALLES (MW3 MP)',
    '2 ROUND BURST (WZ)': 'RAFALE DE 2 BALLES (WZ)',
    '3 ROUND BURST (MW3 MP)': 'RAFALE DE 3 BALLES (MW3 MP)',
    '3 ROUND BURST (WZ)': 'RAFALE DE 3 BALLES (WZ)',
    'AKIMBO': 'AKIMBO',
    'AKIMBO (MW3 MP)': 'AKIMBO (MW3 MP)',
    'AKIMBO MOD (MW3 MP)': 'MOD AKIMBO (MW3 MP)',
    'AKIMBO MOD (WZ)': 'MOD AKIMBO (WZ)',
    'BINARY TRIGGER': 'GÂCHETTE BINAIRE',
    'BINARY TRIGGER + ATTACHMENTS (MW3 MP)': 'GÂCHETTE BINAIRE + ACCESSOIRES (MW3 MP)',
    'BLUNDERBUSS (SHOTGUN - MW3 MP)': 'TROMBLON (FUSIL À POMPE - MW3 MP)',
    'BLUNDERBUSS (SHOTGUN - WZ)': 'TROMBLON (FUSIL À POMPE - WZ)',
    'BULLPUP CONVERSION (MW3 MP)': 'CONVERSION BULLPUP (MW3 MP)',
    'BULLPUP CONVERSION (WZ)': 'CONVERSION BULLPUP (WZ)',
    'BULLPUP CONVERSION': 'CONVERSION BULLPUP',
    'BURST MOD': 'MOD RAFALE',
    'BURST MOD (MP)': 'MOD RAFALE (MP)',
    'BURST MOD (MW3 MP)': 'MOD RAFALE (MW3 MP)',
    'BURST MOD (WZ)': 'MOD RAFALE (WZ)',
    'CLOSE-MID RANGE ASSAULT RIFLE (WZ)': 'FUSIL D’ASSAUT COURTE-MOYENNE PORTÉE (WZ)',
    'DAMAGE INCREASE (MW3 MP)': 'AUGMENTATION DES DÉGÂTS (MW3 MP)',
    'DAMAGE INCREASE (WZ)': 'AUGMENTATION DES DÉGÂTS (WZ)',
    'DOUBLE BARREL MOD': 'MOD DOUBLE CANON',
    'DUAL SHOT (MW3 MP)': 'DOUBLE TIR (MW3 MP)',
    'DUAL SHOT (RANGE, ADS - MW3 MP)': 'DOUBLE TIR (PORTÉE, VISEE - MW3 MP)',
    'DUAL SHOT (TAC STANCE - MW3 MP)': 'DOUBLE TIR (POSTURE TACTIQUE - MW3 MP)',
    'DUAL SHOT (WZ)': 'DOUBLE TIR (WZ)',
    'EXTREME FIRE RATE INCREASE (MW3 MP)': 'AUGMENTATION EXTRÊME CADENCE DE TIR (MW3 MP)',
    'EXTREME FIRE RATE INCREASE (WZ)': 'AUGMENTATION EXTRÊME CADENCE DE TIR (WZ)',
    'FULL AUTO (MW3 MP)': 'AUTO (MW3 MP)',
    'FULL AUTO (WZ)': 'AUTO (WZ)',
    'FULL AUTO + ATTACHMENTS (MW3 MP)': 'AUTO + ACCESSOIRES (MW3 MP)',
    'FULL AUTO + ATTACHMENTS (WZ)': 'AUTO + ACCESSOIRES (WZ)',
    'FULL AUTO DMR': 'DMR AUTO',
    'FULL AUTO MID RANGE': 'AUTO MOYENNE PORTÉE',
    'FULL AUTO MOD': 'MOD AUTO',
    'GRADUAL FIRE RATE INCREASE (MP)': 'AUGMENTATION GRADUELLE CADENCE (MP)',
    'GRADUAL FIRE RATE INCREASE (WZ)': 'AUGMENTATION GRADUELLE CADENCE (WZ)',
    'GRADUAL FIRE RATE SPEEDUP (MW3 MP)': 'ACCÉLÉRATION GRADUELLE CADENCE (MW3 MP)',
    'GRADUAL FIRE RATE SPEEDUP (WZ)': 'ACCÉLÉRATION GRADUELLE CADENCE (WZ)',
    'HAMR CONVERSION KIT': 'KIT DE CONVERSION HAMR',
    'HEAVY ASSAULT RIFLE (MW3 MP)': 'FUSIL D’ASSAUT LOURD (MW3 MP)',
    'HIGH CALIBER CONVERSION': 'CONVERSION GROS CALIBRE',
    'HIGH DAMAGE DMR': 'DMR DÉGÂTS ÉLEVÉS',
    'HIGH DAMAGE KIT (MW3 MP)': 'KIT DÉGÂTS ÉLEVÉS (MW3 MP)',
    'HIGH DAMAGE KIT (WZ)': 'KIT DÉGÂTS ÉLEVÉS (WZ)',
    'JAKOBS SIX SHOOTER (AKIMBO - MW3 MP)': 'JAKOBS SIX SHOOTER (AKIMBO - MW3 MP)',
    'JAKOBS SIX SHOOTER (MW3 MP)': 'JAKOBS SIX SHOOTER (MW3 MP)',
    'JAKOBS SIX SHOOTER (WZ)': 'JAKOBS SIX SHOOTER (WZ)',
    'LASER RIFLE (MW3 MP)': 'FUSIL LASER (MW3 MP)',
    'LASER RIFLE (WZ)': 'FUSIL LASER (WZ)',
    'LIGHTWEIGHT ASSAULT (MW3 MP)': 'ASSAUT LÉGER (MW3 MP)',
    'LIGHTWEIGHT ASSAULT (WZ)': 'ASSAUT LÉGER (WZ)',
    'LIGHTWEIGHT CQB CONVERSION': 'CONVERSION CQB LÉGÈRE',
    'LIGHTWEIGHT MARKSMAN CONVERSION (MW3 MP)': 'CONVERSION TIREUR D’ÉLITE LÉGÈRE (MW3 MP)',
    'LIGHTWEIGHT MARKSMAN CONVERSION (WZ)': 'CONVERSION TIREUR D’ÉLITE LÉGÈRE (WZ)',
    'LOW RECOIL / LONG RANGE (MW3 MP)': 'FAIBLE RECUL / LONGUE PORTÉE (MW3 MP)',
    'MID RANGE ASSAULT (MP)': 'ASSAUT MOYENNE PORTÉE (MP)',
    'PNEUMATIC RIVERT LAUNCHER (MW3 MP)': 'LANCE-RIVETS PNEUMATIQUE (MW3 MP)',
    'RAPID FIRE': 'CADENCE RAPIDE',
    'RAPID FIRE + MARKSMAN CONVERSION (MW3 MP)': 'CADENCE RAPIDE + CONVERSION TIREUR (MW3 MP)',
    'RAPID FIRE + MARKSMAN RIFLE CONVERSION (WZ)': 'CADENCE RAPIDE + CONVERSION FUSIL TACTIQUE (WZ)',
    'RECOILLESS (MP)': 'SANS RECUL (MP)',
    'RECOILLESS (WZ)': 'SANS RECUL (WZ)',
    'RIFLE CONVERSION (MW3 MP)': 'CONVERSION EN FUSIL (MW3 MP)',
    'RIFLE CONVERSION (WZ)': 'CONVERSION EN FUSIL (WZ)',
    'ROCKET LAUNCHER': 'LANCE-ROQUETTES',
    'SEMI AUTO + DAMAGE INCREASE (WZ)': 'SEMI-AUTO + AUGM. DÉGÂTS (WZ)',
    'SEMI AUTO + DAMAGE INCREASE': 'SEMI-AUTO + AUGM. DÉGÂTS',
    'SMG CLASS': 'CLASSE MITRAILLETTE',
    'SMG KIT (MW3 MP)': 'KIT MITRAILLETTE (MW3 MP)',
    'SMG KIT (WZ)': 'KIT MITRAILLETTE (WZ)',
    'SNIPER RIFLE (MW3 MP)': 'FUSIL DE PRÉCISION (MW3 MP)',
    'SNIPER RIFLE (WZ)': 'FUSIL DE PRÉCISION (WZ)',
    'SNIPER RIFLE CONVERSION (MW3 MP)': 'CONVERSION FUSIL DE PRÉCISION (MW3 MP)',
    'SNIPER RIFLE CONVERSION (RANGE)': 'CONVERSION FUSIL DE PRÉCISION (PORTÉE)',
    'SNIPER SUPPORT (WZ)': 'SOUTIEN SNIPER (WZ)',
    'ZERO BLOOM HIPFIRE': 'TIR AU JUGÉ SANS DISPERSION',

    'WELCOME TO THE ARMORY': 'BIENVENUE DANS L’ARMURERIE',
    'THE NEXT GENERATION OF THE ARMORY IS HERE. COME ON IN, IT\'S GOOD TO HAVE YOU. LET\'S GET YOU UP TO SPEED ON HOW WE DO IT AROUND HERE.': 'LA NOUVELLE GÉNÉRATION DE L’ARMURERIE EST ARRIVÉE. ENTREZ, C’EST UN PLAISIR DE VOUS AVOIR PARMI NOUS. VOICI UN PETIT RÉCAPITULATIF DE NOS MÉTHODES.',

    'HOME SCREEN': 'ÉCRAN D’ACCUEIL',
    'SEARCH WEAPON NAMES, CLASS TYPES OR EVEN A GAME TO SEE ALL OF ITS WEAPONS! UTILIZE THE FILTER BUTTON TO SORT JUST HOW YOU WANT. DON\'T WANT TO SEARCH OR SCROLL EVERYTIME TO GET YOUR FAVOURITES? GO AHEAD AND FAVOURITE THEM SO THEY APPEAR ON TOP!': 'RECHERCHEZ DES NOMS D’ARMES, DES CATÉGORIES OU MÊME UN JEU POUR VOIR TOUT SON ARSENAL ! UTILISEZ LE BOUTON DE FILTRE POUR TOUT TRIER À VOTRE GUISE. VOUS NE VOULEZ PAS CHERCHER À CHAQUE FOIS ? AJOUTEZ VOS ARMES PRÉFÉRÉES EN FAVORIS POUR QU’ELLES APPARAISSENT EN HAUT !',

    'SETTINGS DRAWER': 'MENU DES PARAMÈTRES',
    'ACCESS MODULES, LOG IN TO ACCESS PREMIUM BENEFITS, READ PATCH NOTES, AND MORE. NEED A REFRESHER? COME BACK HERE WITH THE INTRO SCREEN BUTTON IN CASE YOU EVER GET LOST.': 'ACCÉDEZ AUX MODULES, CONNECTEZ-VOUS POUR VOS AVANTAGES PREMIUM, LISEZ LES NOTES DE MISE À JOUR ET PLUS ENCORE. BESOIN d’UN RAPPEL ? REPASSEZ PAR ICI VIA LE BOUTON D’ÉCRAN D’ACCUEIL SI VOUS ÊTES PERDU.',

    'MODULE - META PICKS': 'MODULE - SÉLECTIONS META',
    'STAY ON TOP OF YOUR GAME AT ALL TIMES. NEVER AGAIN WILL YOU WONDER WHAT THE BEST PICKS ARE, OR BE CONFUSED WHAT\'S WORTH USING ANYMORE FROM OLDER TITLES. ONLY THE BEST MAKE IT ON THIS LIST, AND IT\'S ALWAYS UP TO DATE.': 'RESTEZ AU SOMMET DE VOTRE FORME. NE VOUS DEMANDEZ PLUS JAMAIS QUELLES SONT LES MEILLEURES OPTIONS, MÊME POUR LES ANCIENS TITRES. SEUL LE MEILLEUR FIGURE DANS CETTE LISTE, ET ELLE EST TOUJOURS À JOUR.',

    'MODULE - RANDOMIZER': 'MODULE - ALÉATORISATEUR',
    'ADD SOME CHAOS TO GAME NIGHT. GENERATE UP TO 10 WEAPONS AT A TIME, UTILIZE THE EXCLUSION ZONE TO BLOCK ENTIRE GAMES WHEN PICKING WEAPONS, LOCK YOUR CHOICE IN SO YOU ONLY GET RESULTS FOR THE WEAPON YOU WANT, AND MORE.': 'AJOUTEZ UN PEU DE CHAOS À VOS SOIRÉES. GÉNÉREZ JUSQU’À 10 ARMES À LA FOIS, UTILISEZ LA ZONE D’EXCLUSION POUR BLOQUER CERTAINS JEUX, OU VERROUILLEZ VOTRE CHOIX POUR N’OBTENIR DES RÉSULTATS QUE POUR L’ARME VOULU.',

    'MODULE - COMBAT DELTA / AEGIS EYE': 'MODULE - COMBAT DELTA / AEGIS EYE',
    'THE ULTIMATE COMPARISON TOOL. DIRECTLY COMPARE WEAPONS TO SEE IF YOUR CONTROLLER WILL ENTER ORBIT DURING A FIGHT OR NOT (LOSING IS TOUGH, WE KNOW). TAP AND HOLD TO REMOVE YOUR PICKS IF YOU CHANGED YOUR MIND. SWIPE THE SCREEN TO ACCESS AEGIS EYE, A GLOBAL STAT TRACKER SORTED HOW YOU WANT. HIGHEST VELOCITY? FASTEST TTK AT RANGE 1? YOU GOT IT. TAP THE STAT NUMBERS TO VIEW MORE DETAILS! DEFAULT STAT IS TTK CLOSE.': 'L’OUTIL DE COMPARAISON ULTIME. COMPAREZ DIRECTEMENT LES ARMES POUR VOIR SI VOTRE MANETTE VA FINIR DANS LE DÉCOR (PERDRE EST DIFFICILE, ON SAIT). MAINTENEZ APPUYÉ POUR RETIRER VOS CHOIX. BALAYEZ L’ÉCRAN POUR ACCÉDER À AEGIS EYE, UN SUIVI DES STATS GLOBALES TRIÉES COMME VOUS LE SOUHAITEZ. VITESSE MAXIMALE ? MEILLEUR TTK À PORTÉE 1 ? TOUT Y EST. APPUYEZ SUR LES CHIFFRES POUR PLUS DE DÉTAILS ! LA STAT PAR DÉFAUT EST LE TTK PROCHE.',

    'THEMES': 'THÈMES',
    'MAKE ARMORY APP YOURS. WITH TONS OF THEMES AND EVEN MORE FONT CHOICES, WE TAKE CUSTOMIZATION VERY SERIOUSLY AROUND HERE. PREMIUM MEMBERS WILL HAVE ACCESS TO EXCLUSIVE THEMES THAT TAKE IT A STEP FURTHER.': 'APPROPRIEZ-VOUS L’APPLICATION ARMORY. AVEC DES TONNES DE THÈMES ET ENCORE PLUS DE POLICES, NOUS NE PLAISANTONS PAS AVEC LA PERSONNALISATION. LES MEMBRES PREMIUM ONT ACCÈS À DES THÈMES EXCLUSIFS ENCORE PLUS AVANCÉS.',

    'PREMIUM BENEFITS': 'AVANTAGES PREMIUM',
    'ON TOP OF EXCLUSIVE THEMES, YOU ALSO GET ACCESS TO THE ARMORY\'S ADVANCED WEAPON STATS, A SYSTEM BUILT FOR THOSE THAT REQUIRE ABSOLUTE PRECISION WHEN IT COMES TO MAKING EVERY MILLISECOND IN AN ENGAGEMENT MATTER. HOW FAST WILL THIS GUN DOWN AT 27 METERS? CAN THIS SNIPER ONE SHOT? NOW YOU KNOW.': 'EN PLUS DES THÈMES EXCLUSIFS, ACCÉDEZ AUX STATISTIQUES D’ARMES AVANCÉES. UN SYSTÈME CONÇU POUR CEUX QUI VEULENT QUE CHAQUE MILLISECONDE COMPTE. À QUELLE VITESSE CETTE ARME ÉLIMINE-T-ELLE À 27 MÈTRES ? CE SNIPER PEUT-IL TUER EN UN COUP ? MAINTENANT, VOUS SAUREZ.',

    'LOGGING IN': 'CONNEXION',
    'IF YOU\'RE A PREMIUM MEMBER WITH ARMORY BOT, YOU\'RE IN LUCK BECAUSE ARMORY APP IS MOVING IN NEXT DOOR AND IS VERY EXCITED TO MINGLE. LOG IN WITH YOUR DISCORD ID AND SECRET PIN TO GET ALL YOUR BENEFITS SYNCED UP ACROSS BOTH SERVICES. HOW DO YOU GET YOUR PIN? HEAD ON OVER TO ARMORY BOT AND USE THE /armorypin COMMAND AND IT WILL GET YOU SORTED.': 'SI VOUS ÊTES MEMBRE PREMIUM D’ARMORY BOT, VOUS AVEZ DE LA CHANCE. CONNECTEZ-VOUS AVEC VOTRE ID DISCORD ET VOTRE CODE PIN SECRET POUR SYNCHRONISER VOS AVANTAGES SUR LES DEUX SERVICES. COMMENT OBTENIR VOTRE PIN ? RENDEZ-VOUS SUR ARMORY BOT ET UTILISEZ LA COMMANDE /armorypin.',
    'TIME TO DEPLOY': 'HEURE DU DÉPLOIEMENT',
    'WELL DONE, YOU\'VE PASSED INSPECTION. LET\'S GET YOU KITTED UP AND READY TO HIT THE FIELD SPRINTING. STAY FROSTY, YOUR SQUAD DEPENDS ON IT.': 'BIEN JOUÉ, L’INSPECTION EST TERMINÉE. ÉQUIPEZ-VOUS ET PRÉPAREZ-VOUS À FONCER SUR LE TERRAIN. RESTEZ AUX AGUETS, VOTRE ESCOUADE COMPTE SUR VOUS.',

    'SYSTEM UPDATES' : 'MISES À JOUR SYSTÈME',
    "ARMORY BUG REPORT" : "RAPPORT DE BOGUE ARMORY",
    "DESCRIBE THE ISSUE AND HOW IT OCCURRED.": "Décrivez le problème et comment il est survenu.",
    "CANCEL": "ANNULER",
    "TRANSMIT": "TRANSMETTRE",
    "CONNECTING TO ARMORY CORE...": "CONNEXION AU NOYAU DE L’ARMURERIE...",
    "LOADING DATA FOR FIRST BOOT": "CHARGEMENT DES DONNÉES POUR LE PREMIER DÉMARRAGE",
    'PURCHASE PREMIUM TO ACCESS ADVANCED WEAPON STATS': 'ACHETEZ LE PREMIUM POUR ACCÉDER AUX STATS AVANCÉES',
    'VERIFYING DATA INTEGRITY...': 'VÉRIFICATION DE L’INTÉGRITÉ DES DONNÉES...',
    "DOWNLOADING ASSETS...": "TÉLÉCHARGEMENT DES COMPOSANTS...",
    'PATCH APPLIED. RESTARTING...': 'PATCH APPLIQUÉ. REDÉMARRAGE...',
    'ARMORY HOTFIXES': 'CORRECTIFS DE L’ARMURERIE',
    "PRELOADING ASSETS...": "PRÉCHARGEMENT DES COMPOSANTS...",
    "INJECTING HOTFIX DATA...": "INJECTION DES DONNÉES CORRECTIVES...",

    "IF YOU FORGOT YOUR PIN, NO SWEAT. HEAD ON OVER TO A DISCORD SERVER THAT ARMORY BOT IS IN, AND USE THE /ARMORYPIN COMMAND. THIS WILL GRAB YOUR PIN AND DISPLAY IT FOR YOU TO KEEP IN YOUR FANCY NOTEBOOK YOU DEFINITELY REMEMBERED YOU HAD. AND DON'T WORRY ABOUT SOMEONE STEALING IT, THE MESSAGE IS ONLY VISIBLE TO YOU. THEN, JUST COME ON BACK AND LOG IN!": "Si vous avez oublié votre pin, pas de panique. rendez-vous sur un serveur discord où se trouve l’armory bot et utilisez la commande /armorypin. Cela récupérera votre code pin pour que vous puissiez le noter dans ce carnet élégant que vous n’aviez bien sûr pas oublié. Et ne vous inquiétez pas, personne ne pourra vous le voler. Le message n’est visible que par vous. Ensuite, revenez simplement ici et connectez-vous !",
    "RECOVER YOUR PIN": "RÉCUPÉRER VOTRE PIN",
    "ACKNOWLEDGED": "COMPRIS",
    'ACCESS RESTRICTED': 'ACCÈS RESTREINT',
    'ARMORY DELTA IS A PREMIUM FEATURE.\n PLEASE LOG IN OR PURCHASE PREMIUM TO UNLOCK.': 'ARMORY DELTA EST UNE FONCTIONNALITÉ PREMIUM.\n VEUILLEZ VOUS CONNECTER OU ACHETER PREMIUM POUR DÉVERROUILLER.',
    'BACK': 'RETOUR',
    'UPGRADE': 'AMÉLIORER',
    'NEXT': 'SUIVANT',
    'PREVIOUS': 'PRÉCÉDENT',
    "RANDOMIZER GUIDE": "GUIDE DE L'ALÉATOIRE",
    "OR": "OU",
    'ENTER DISCORD ID': 'ENTRER L’ID DISCORD',
    'PROCEED': 'CONTINUER',
    'PREMIUM ACTIVATED': 'PREMIUM ACTIVÉ',
    'Your account credentials have been generated:': 'Vos identifiants ont été générés :',
    'DISCORD ID': 'ID DISCORD',
    'ACCESS PIN': 'CODE PIN D\'ACCÈS',
    'Please save these. You can now log in.': 'Veuillez les enregistrer. Vous pouvez maintenant vous connecter.',
    'PROCEED TO LOGIN': 'SE CONNECTER',
    "CLOSE": "FERMER",
    "ALL": "TOUT",
    "COMBAT RATINGS": "ÉVALUATIONS DE COMBAT",
    "COMPETITIVE CHOICE, BUT NOT AS STRONG AS S TIER.": "CHOIX COMPÉTITIF, MAIS MOINS PERFORMANT QUE LE RANG S.",
    "USABLE, BUT WILL FEEL NOTICABLY WEAKER THAN OTHER PICKS.": "UTILISABLE, MAIS NETTEMENT PLUS FAIBLE QUE LES AUTRES OPTIONS.",
    'PREMIUM ACCESS GRANTED': 'ACCÈS PREMIUM ACCORDÉ',
    'PURCHASE VERIFIED. PLEASE LOGIN TO ACTIVATE.': 'ACHAT VÉRIFIÉ. VEUILLEZ VOUS CONNECTER POUR ACTIVER.',

    "ABR A1 FULL AUTO": "ABR A1 AUTOMATIQUE",
    "AEK-973 FULL AUTO MID RANGE": "AEK-973 AUTO PORTÉE MOYENNE",
    "DG-58 LSW BULLPUP CONVERSION": "CONVERSION BULLPUP DG-58 LSW",
    "M16 (MW2) FULL AUTO": "M16 (MW2) AUTOMATIQUE",
    "M8A1 SNIPER SUPPORT": "M8A1 SOUTIEN SNIPER",
    "MCW SNIPER SUPPORT": "MCW SOUTIEN SNIPER",
    "RENETTI (MW3) FULL AUTO + ATTACHMENTS": "RENETTI (MW3) AUTO + ACCESSOIRES",
    "RENETTI (MW3) SEMI AUTO + DAMAGE INCREASE": "RENETTI (MW3) SEMI-AUTO + DÉGÂTS ACCRUS",
    "SVD FULL AUTO DMR": "SVD AUTO (DMR)",
    'SYSTEM UP TO DATE.': 'SYSTÈME À JOUR.',
    'PURCHASE PREMIUM TO ACCESS THIS THEME!': 'ACHETEZ LE PACK PREMIUM POUR ACCÉDER À CE THÈME !',
    'FINALIZING WITH ARMORY CORE...': 'FINALISATION AVEC ARMORY CORE...',

    "There is no shortage of options within The Armory's Randomizer. It can be intimidating, so refer back to this handy guide whenever you need a refresher.": "Les options ne manquent pas dans l'Aléatoire de The Armory. Cela peut être intimidant, alors n'hésitez pas à consulter ce guide pratique chaque fois que vous avez besoin d'un rappel.",

    "This is where you tell the engine \"I don't want to see weapons from this game\". Pick as many as you want, but you need at least one. ": "C'est ici que vous dites au moteur : \"Je ne veux pas voir d'armes de ce jeu\". Choisissez-en autant que vous voulez, mais vous devez en garder au moins une.",

    "If you only want to get random attachments for one specific weapon, but don't want to hit the button 4 times to do it, this option is what you need.": "Si vous souhaitez uniquement obtenir des accessoires aléatoires pour une arme spécifique, sans avoir à appuyer 4 fois sur le bouton, cette option est ce qu'il vous faut.",

    "Warzone will allow choices to be picked from each game you have allowed from the Exclusion Zone. Multiplayer will utilize the anchor system,\n      which is a robust filtering logic that will only choose same-era weapons as the first pick.\n\n      So if you randomly (or manually) select a Black Ops 6 weapon, and you have chosen more than 1 weapon to generate, you will only get Black Ops 6 weapons, ensuring that each pick is usable in the game that you are playing.\n      ": "Warzone permettra de choisir des options dans chaque jeu que vous avez autorisé dans la Zone d'Exclusion. Le mode Multijoueur utilisera le système d'ancrage, une logique de filtrage robuste qui ne choisira que des armes de la même époque que le premier choix.\n\nAinsi, si vous sélectionnez de manière aléatoire (ou manuelle) une arme de Black Ops 6 et que vous avez choisi de générer plus d'une arme, vous n'obtiendrez que des armes de Black Ops 6, garantissant que chaque choix est utilisable dans le jeu auquel vous jouez.",

    "If you select RANDOM WEAPON, you will see this new option appear. This will tell the engine that you only want that specific weapon class.\n      For legacy categories, the game mode is forced to Multiplayer to utilize the anchor logic and stay accurate, and to elminate overlap if you also allow other non-legacy games. You don't want a Cold War shotgun mixed in with your Black Ops 7 sniper now do you?": "Si vous sélectionnez ARME ALÉATOIRE, vous verrez apparaître cette nouvelle option. Cela indiquera au moteur que vous ne voulez que cette classe d'arme spécifique.\nPour les catégories héritées, le mode de jeu est forcé en Multijoueur pour utiliser la logique d'ancrage et rester précis, et pour éliminer les chevauchements si vous autorisez également d'autres jeux non hérités. Vous ne voudriez pas d'un fusil à pompe de Cold War mélangé à votre sniper de Black Ops 7, n'est-ce pas ?",

    "Speed of the bullet. For snipers, higher values means less bullet drop and leading (shooting ahead of a moving target). For other weapons this also applies, but also means you won't have bullet travel time to slow down your TTK, shifting a gunfight into your favour. Higher is better.": "Vitesse de la balle. Pour les snipers, une valeur élevée réduit la chute de balle et facilite l'anticipation du tir. Pour les autres armes, cela réduit le temps de trajet de la balle, améliorant votre TTK et vous donnant l'avantage. Plus c'est élevé, mieux c'est.",

    "ADS SPEED": "VITESSE VISÉE",
    "Time between when you hit the aim button, and when you are fully aimed in and ready to fire at 100% accuracy. Lower is better.": "Temps entre le moment où vous visez et le moment où vous êtes prêt à tirer avec une précision de 100 %. Plus c'est bas, mieux c'est.",

    "TTK CLOSE/FAR": "TTK PROCHE/LOIN",
    "Time to Kill. 'Close' is how fast you will kill within the first damage range. 'Far' is how fast you will kill within the second damage range. Lower is better.": "Temps pour tuer (TTK). 'Proche' est la vitesse de mise à mort à courte portée. 'Loin' est la vitesse à longue portée. Plus c'est bas, mieux c'est.",

    "The number of shots required to kill at 'Close' and 'Far' range. Lower is better.": "Nombre de tirs requis pour tuer à courte et longue portée. Plus c'est bas, mieux c'est.",

    "HITSCAN": "HITSCAN",
    "The distance where bullets connect instantly, meaning there is no delay between pressing the fire button, and seeing a hitmarker. Higher is better.": "Distance à laquelle les balles touchent instantanément, sans délai entre le tir et l'impact. Plus c'est élevé, mieux c'est.",

    "STAT TERMINOLOGY": "TERMINOLOGIE DES STATS"
  },
};

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
    final locale = Provider.of<LocaleController>(context);
    final String code = locale.languageCode;

    final String displayText = (code != 'en' && uiTranslations[code]?.containsKey(text) == true)
        ? uiTranslations[code]![text]!
        : text;

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
            displayText,
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
          displayText,
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
        alignment: _getAlignment(),
        child: textStack,
      );
    }

    return FittedBox(
      fit: BoxFit.scaleDown, 
      alignment: _getAlignment(),
      child: textStack,
    );
  }

  Alignment _getAlignment() {
    if (textAlign == TextAlign.center) return Alignment.center;
    if (textAlign == TextAlign.end) return Alignment.centerRight;
    return Alignment.centerLeft;
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
  String? _currentPatchLang;
  String? get currentPatchLang => _currentPatchLang;

  ArmoryTheme _activeTheme = allThemes.first; 
  ArmoryTheme get activeTheme => _activeTheme;

  Color _customColor = const Color(0xFF00FFCC); 
  Color get customColor => _customColor;
  Color get neonBorderCoreColor => Color.lerp(_customColor, Colors.white, 0.35)!;

  String _activeFont = 'Stock';
  String get activeFont => _activeFont;

  String _lastViewedPatchDate = "";
  bool _hasNewPatch = false;
  Map<String, dynamic>? _currentPatchData;

  bool get hasNewPatch => _hasNewPatch;
  Map<String, dynamic>? get currentPatchData => _currentPatchData;

  Future<void> syncPatchNotes(String serverUrl, String langCode, {bool forceRefresh = false}) async {
    try {
      if (!forceRefresh && _currentPatchLang == langCode && _currentPatchData != null) {
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      _lastViewedPatchDate = prefs.getString('last_viewed_patch_date') ?? "";

      final String suffixPath = (langCode == 'en') ? 'hotfixes.json' : '$langCode/hotfixes_$langCode.json';
      final String cachePrefKey = 'cached_file_$suffixPath';

      if (prefs.containsKey(cachePrefKey)) {
        final String? localContent = prefs.getString(cachePrefKey);
        if (localContent != null && localContent.isNotEmpty) {
          final data = json.decode(localContent);

          _currentPatchData = data;
          _currentPatchLang = langCode;

          String serverDate = data['patch_date'] ?? data['date'] ?? "";
          if (serverDate != _lastViewedPatchDate) {
            _hasNewPatch = true;
          }

          debugPrint("🎯 [PATCH SYNC] Instantly loaded web LocalStorage hotfix notes for: $langCode");
          notifyListeners();
          return; 
        }
      }

      final cleanBaseUrl = serverUrl.endsWith('/') 
          ? serverUrl.substring(0, serverUrl.length - 1) 
          : serverUrl;

      final path = (langCode == 'en')
          ? "$cleanBaseUrl/cdn/hotfixes.json"
          : "$cleanBaseUrl/cdn/$langCode/hotfixes_$langCode.json";

      debugPrint("🛰️ [PATCH SYNC] Web cache missing. Fetching live patch notes: $path");
      final response = await http.get(Uri.parse(path)); 

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        _currentPatchData = data;
        _currentPatchLang = langCode;

        String serverDate = data['patch_date'] ?? data['date'] ?? "";
        if (serverDate != _lastViewedPatchDate) {
          _hasNewPatch = true;
        }

        await prefs.setString(cachePrefKey, response.body);
        notifyListeners();

      } else if (response.statusCode == 404 && langCode != 'en') {
        debugPrint("❌ Localized server notes 404'd. Falling back to English master notes.");
        await syncPatchNotes(serverUrl, 'en', forceRefresh: true);
      }
    } catch (e) {
      debugPrint("Patch Sync Error: $e");
    }
  }

  Future<void> markPatchRead() async {
    if (_currentPatchData == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    String serverDate = _currentPatchData!['patch_date'] ?? _currentPatchData!['date'] ?? "";
    
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

    ArmoryTheme(
      id: 'anemone_tulip',
      name: 'TULIP',
      pickerGradient: [
        const Color.fromRGBO(218, 70, 106, 1),
        const Color.fromRGBO(254, 108, 144, 1),
        const Color.fromRGBO(254, 183, 199, 1),
        const Color.fromRGBO(253, 221, 226, 1),
      ],
      pickerTextColor: Colors.white,
      category: ThemeCategory.anemone,
      backgroundUrl: 'https://res.cloudinary.com/dctlpj7fg/image/upload/v1781719639/255c01ce331f80c354bd828ff5fd8c4f_otbu1a.jpg',
      borderGradient: [
        const Color.fromRGBO(253, 221, 226, 1),
        const Color.fromRGBO(254, 183, 199, 1),
        const Color.fromRGBO(254, 108, 144, 1),
        const Color.fromRGBO(218, 70, 106, 1),

      ],

      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(254, 108, 144, 1),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(254, 108, 144, 1),
          surface: Color.fromRGBO(91, 57, 66, 1)
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
        primaryColor: Color.fromRGBO(236, 185, 43, 1),
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