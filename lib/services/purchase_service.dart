import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

const String globalNgrokUrl = "https://cherty-frowningly-rickie.ngrok-free.dev";

class PurchaseService {
  static InAppPurchase get _iap => InAppPurchase.instance;

  static String? _currentDiscordId;
  static String? _verifiedPin;

  static String? get verifiedPin => _verifiedPin;
  static String? get verifiedId => _currentDiscordId;

  static void initialize(String discordId, Function(bool) onPurchaseSuccess) {
    _currentDiscordId = discordId;
    debugPrint("🛠️ PurchaseService: Initialized for $discordId");
    
    if (defaultTargetPlatform != TargetPlatform.android && defaultTargetPlatform != TargetPlatform.iOS) {
      debugPrint("⚠️ PurchaseService: Running on non-mobile platform. IAP disabled.");
      return;
    }

    _iap.purchaseStream.listen((List<PurchaseDetails> purchaseDetailsList) {
      _handlePurchaseUpdates(purchaseDetailsList, onPurchaseSuccess);
    }, onError: (error) {
      debugPrint("❌ Stream Error: $error");
    });
  }

  static void updateDiscordId(String id) {
    _currentDiscordId = id;
    debugPrint("🛠️ PurchaseService: Discord ID updated to $id");
  }
  static String? get currentDiscordId => _currentDiscordId;

static void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList, Function(bool) onPurchaseSuccess) async {
  for (var purchase in purchaseDetailsList) {
    if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {

      bool verified = await _pollForVerification(purchase);
      
      if (verified) {
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
        onPurchaseSuccess(true);

      } else {
        onPurchaseSuccess(false);
      }

    } else if (purchase.status == PurchaseStatus.error) {
      if (purchase.error?.message.contains("itemAlreadyOwned") == true) {
        debugPrint("🔄 Item already owned. Forcing a Restore sequence...");
        InAppPurchase.instance.restorePurchases();
      } else {
        debugPrint("❌ IAP Error: ${purchase.error}");
        onPurchaseSuccess(false);
      }
    }
  }
}

static Future<bool> _pollForVerification(PurchaseDetails purchase) async {
  try {
    final verifyResponse = await http.post(
      Uri.parse("$globalNgrokUrl/google_verify"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'purchaseToken': purchase.verificationData.serverVerificationData,
        'discordId': _currentDiscordId ?? 'guest_user',
      }),
    ).timeout(const Duration(seconds: 15));

    return verifyResponse.statusCode == 200;
  } catch (e) {
    debugPrint("❌ Verification Error: $e");
    return false;
  }
}

  static Future<void> buyPremium() async {
    final bool available = await _iap.isAvailable();
    if (!available) return;

    final ProductDetailsResponse response = await _iap.queryProductDetails({'premium_lifetime'});
    if (response.productDetails.isNotEmpty) {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: response.productDetails.first);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
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
      debugPrint("❌ Fatal Error from Server: ${response.statusCode}");
      return null;
    }

  } catch (e) {
    debugPrint("⚠️ Connection error: $e");
  }
  return false;
}
}