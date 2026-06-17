import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart'; // Used to launch the Stripe fallback page

const String globalNgrokUrl = "https://cherty-frowningly-rickie.ngrok-free.dev";
// Define your Stripe Checkout URL link here
const String stripeCheckoutUrl = "https://checkout.stripe.com/your-custom-link-here";

class PurchaseService {
  static String? _currentDiscordId;
  static String? _verifiedPin;

  static String? get verifiedPin => _verifiedPin;
  static String? get verifiedId => _currentDiscordId;

  static void initialize(String discordId, Function(bool) onPurchaseSuccess) {
    _currentDiscordId = discordId;
    debugPrint("🛠️ PurchaseService: Initialized for $discordId (Web Mode)");
    
    // Strictly Web: Native mobile IAP streams are removed entirely.
    debugPrint("⚠️ PurchaseService: Running on Web platform. Mobile IAP disabled.");
  }

  static void updateDiscordId(String id) {
    _currentDiscordId = id;
    debugPrint("🛠️ PurchaseService: Discord ID updated to $id");
  }
  
  static String? get currentDiscordId => _currentDiscordId;

  static Future<void> buyPremium() async {
    // Strictly Web: Redirect iOS and Web users straight to your Stripe platform
    final Uri url = Uri.parse(stripeCheckoutUrl);
    debugPrint("💳 Redirecting web user to Stripe payment gateway: $url");
    
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication, // Opens cleanly in a fresh Safari/browser tab
        );
      } else {
        debugPrint("❌ Could not launch Stripe checkout URL portal.");
      }
    } catch (e) {
      debugPrint("❌ Error routing payment session: $e");
    }
  }

  static Future<bool?> verifyBackendStatus() async {
    if (_currentDiscordId == null) return false;
    
    try {
      final response = await http.get(
        Uri.parse("$globalNgrokUrl/get-pin?discordId=$_currentDiscordId"),
        headers: {"ngrok-skip-browser-warning": "true"},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['pin'] != null) {
          _verifiedPin = data['pin'].toString();
          return true;
        }
        return false;
      }

      if (response.statusCode >= 400) {
        debugPrint("❌ Fatal Error from Server: Status ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Network/CORS check failure hitting backend: $e");
      return null;
    }
    return false;
  }
}