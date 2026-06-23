import 'dart:convert';
import 'package:http/http.dart' as http;

class SparklineService {
  static const _url = 'https://aixpkthloeafwakiijws.supabase.co/functions/v1/forex-sparklines';
  static const _key = 'sb_publishable_Jm9xmIjg1MHhajBFxAxSkw_6aluy7Sa';

  static Future<Map<String, List<double>>> fetch() async {
    try {
      final res = await http.get(
        Uri.parse(_url),
        headers: {'Authorization': 'Bearer $_key'},
      ).timeout(const Duration(seconds: 20));

      if (res.statusCode == 200) {
        final raw = json.decode(res.body) as Map<String, dynamic>;
        return raw.map((sym, list) => MapEntry(
          sym,
          (list as List).map((v) => (v as num).toDouble()).toList(),
        ));
      }
    } catch (_) {}
    return {};
  }
}
