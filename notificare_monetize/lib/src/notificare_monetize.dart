import 'package:flutter/services.dart';
import 'package:notificare_monetize/src/events/notificare_billing_setup_failed_event.dart';
import 'package:notificare_monetize/src/events/notificare_purchase_failed_event.dart';
import 'package:notificare_monetize/src/models/notificare_product.dart';
import 'package:notificare_monetize/src/models/notificare_purchase.dart';

class NotificareMonetize {
  NotificareMonetize._();

  // Channels
  static const _channel = MethodChannel('re.notifica.monetize.flutter/notificare_monetize', JSONMethodCodec());

  // Events
  static final Map<String, EventChannel> _eventChannels = {};
  static final Map<String, Stream<dynamic>> _eventStreams = {};

  static Future<List<NotificareProduct>> get products async {
    final json = await _channel.invokeListMethod<Map<String, dynamic>>('getProducts');
    return json!.map((e) => NotificareProduct.fromJson(e)).toList();
  }

  static Future<List<NotificarePurchase>> get purchases async {
    final json = await _channel.invokeListMethod<Map<String, dynamic>>('getPurchases');
    return json!.map((e) => NotificarePurchase.fromJson(e)).toList();
  }

  static Future<void> refresh() async {
    await _channel.invokeMethod('refresh');
  }

  static Future<void> startPurchaseFlow(NotificareProduct product) async {
    await _channel.invokeMapMethod<String, dynamic>('startPurchaseFlow', product.toJson());
  }

  // Events
  static Stream<dynamic> _getEventStream(String eventType) {
    if (_eventChannels[eventType] == null) {
      final name = 're.notifica.monetize.flutter/events/$eventType';
      _eventChannels[eventType] = EventChannel(name, const JSONMethodCodec());
    }

    if (_eventStreams[eventType] == null) {
      _eventStreams[eventType] = _eventChannels[eventType]!.receiveBroadcastStream();
    }

    return _eventStreams[eventType]!;
  }

  static Stream<List<NotificareProduct>> get onProductsUpdated {
    return _getEventStream('products_updated').map((result) {
      final List<dynamic> items = result;

      return items.map((item) {
        final Map json = item;
        return NotificareProduct.fromJson(json.cast());
      }).toList();
    });
  }

  static Stream<List<NotificarePurchase>> get onPurchasesUpdated {
    return _getEventStream('purchases_updated').map((result) {
      final List<dynamic> items = result;

      return items.map((item) {
        final Map json = item;
        return NotificarePurchase.fromJson(json.cast());
      }).toList();
    });
  }

  static Stream<void> get onBillingSetupFinished {
    return _getEventStream('billing_setup_finished');
  }

  static Stream<NotificareBillingSetupFailedEvent> get onBillingSetupFailed {
    return _getEventStream('billing_setup_failed').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareBillingSetupFailedEvent.fromJson(json.cast());
    });
  }

  static Stream<NotificarePurchase> get onPurchaseFinished {
    return _getEventStream('purchase_finished').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificarePurchase.fromJson(json.cast());
    });
  }

  static Stream<NotificarePurchase> get onPurchaseRestored {
    return _getEventStream('purchase_restored').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificarePurchase.fromJson(json.cast());
    });
  }

  static Stream<void> get onPurchaseCanceled {
    return _getEventStream('purchase_canceled');
  }

  static Stream<NotificarePurchaseFailedEvent> get onPurchaseFailed {
    return _getEventStream('purchase_failed').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificarePurchaseFailedEvent.fromJson(json.cast());
    });
  }
}
