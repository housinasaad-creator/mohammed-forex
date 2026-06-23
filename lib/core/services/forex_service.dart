import 'dart:convert';
import 'package:http/http.dart' as http;

class ForexService {
  static const _fnUrl =
      'https://aixpkthloeafwakiijws.supabase.co/functions/v1/forex-prices';
  static const _anonKey =
      'sb_publishable_Jm9xmIjg1MHhajBFxAxSkw_6aluy7Sa';

  /// Returns {symbol: price} map. Returns empty map on any error.
  static Future<Map<String, double>> fetchPrices() async {
    try {
      final res = await http
          .get(
            Uri.parse(_fnUrl),
            headers: {
              'Authorization': 'Bearer $_anonKey',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode != 200) return {};

      final body = json.decode(res.body);
      if (body is! Map) return {};

      final prices = <String, double>{};
      for (final entry in (body as Map<String, dynamic>).entries) {
        final v = entry.value;
        if (v is Map && v['price'] != null) {
          final p = double.tryParse(v['price'].toString());
          if (p != null) prices[entry.key] = p;
        }
      }
      return prices;
    } catch (_) {
      return {};
    }
  }
}
