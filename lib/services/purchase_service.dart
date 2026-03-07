
import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PurchaseService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static const String _premiumId = 'premium_lifetime';
  
  static void initialize(Function(bool) onPurchaseSuccess) {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _handlePurchaseUpdates(purchaseDetailsList, onPurchaseSuccess);
    });
  }

  static Future<void> buyPremium() async {
    final bool available = await _iap.isAvailable();
    if (!available) return;

    final ProductDetailsResponse response = await _iap.queryProductDetails({_premiumId});
    if (response.productDetails.isNotEmpty) {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: response.productDetails.first);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  static void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList, Function(bool) onPurchaseSuccess) async {
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased) {
        // THIS IS THE CRITICAL HANDSHAKE
        bool verified = await _verifyWithServer(purchase);
        if (verified) {
          onPurchaseSuccess(true);
          await _iap.completePurchase(purchase);
        }
      }
    }
  }

  static Future<bool> _verifyWithServer(PurchaseDetails purchase) async {
    // We send the Google Token to YOUR Flask server (Phase 3)
    try {
      final response = await http.post(
        Uri.parse("https://cherty-frowningly-rickie.ngrok-free.dev/google-verify"),
        body: json.encode({
        'purchaseToken': purchase.verificationData.serverVerificationData, // Match Flask
        'discordId': 'YOUR_SAVED_DISCORD_ID', // Match Flask
      }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}