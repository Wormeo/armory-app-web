import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AppCacheManager {
  static final CacheManager instance = _createCacheManager();

  static CacheManager _createCacheManager() {
    if (kIsWeb) {
      // On web, return a standard instance. 
      // flutter_cache_manager automatically detects web and uses memory-only.
      return CacheManager(
        Config(
          'armory_cache_web',
          maxNrOfCacheObjects: 100,
          stalePeriod: const Duration(days: 7),
        ),
      );
    } else {
      // On mobile, use the disk-based implementation
      return CacheManager(
        Config(
          'armory_cache_mobile',
          maxNrOfCacheObjects: 200,
          stalePeriod: const Duration(days: 7),
          repo: JsonCacheInfoRepository(databaseName: 'armory_cache_mobile'),
          fileSystem: IOFileSystem('armory_cache_mobile'),
        ),
      );
    }
  }
}