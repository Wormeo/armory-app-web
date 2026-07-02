import 'dart:convert';
import 'package:flutter/services.dart';

class LocalizationService {
  // Cache to prevent re-reading files from disk
  static final Map<String, Map<String, dynamic>> _cache = {};

  static Future<Map<String, dynamic>> loadCategory(String category) async {
    final cleanCategory = category.toLowerCase().replaceAll("'", "");
    if (_cache.containsKey(cleanCategory)) return _cache[cleanCategory]!;

    try {
      final String jsonString = await rootBundle.loadString('assets/localized/$cleanCategory.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      // We store the whole file in the cache
      _cache[cleanCategory] = data;
      return data;
    } catch (e) {
      return {}; // Return empty if file not found
    }
  }
}