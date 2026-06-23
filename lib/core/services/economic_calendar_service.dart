import 'dart:convert';
import 'package:http/http.dart' as http;

class EconomicEvent {
  final String name;
  final String currency;
  final String date;
  final String time;
  final String impact;
  final String? forecast;
  final String? previous;

  const EconomicEvent({
    required this.name,
    required this.currency,
    required this.date,
    required this.time,
    required this.impact,
    this.forecast,
    this.previous,
  });

  factory EconomicEvent.fromJson(Map<String, dynamic> j) => EconomicEvent(
        name:     j['event']    as String? ?? '',
        currency: j['currency'] as String? ?? '',
        date:     j['date']     as String? ?? '',
        time:     j['time']     as String? ?? '',
        impact:   j['impact']   as String? ?? 'medium',
        forecast: j['forecast'] as String?,
        previous: j['previous'] as String?,
      );

  bool get isHigh => impact == 'high';

  // Format date as "Mon 23 Jun"
  String get displayDate {
    try {
      final parts = date.split('-');
      if (parts.length < 3) return date;
      final dt = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      const days   = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
      return '${days[dt.weekday - 1]} ${dt.day} ${months[dt.month - 1]}';
    } catch (_) {
      return date;
    }
  }

  // Format time as "14:00 UTC"
  String get displayTime {
    if (time.isEmpty) return '';
    return '${time.substring(0, 5)} UTC';
  }
}

class EconomicCalendarService {
  static const _url = 'https://aixpkthloeafwakiijws.supabase.co/functions/v1/economic-calendar';
  static const _key = 'sb_publishable_Jm9xmIjg1MHhajBFxAxSkw_6aluy7Sa';

  static Future<List<EconomicEvent>> fetchEvents() async {
    try {
      final res = await http.get(
        Uri.parse(_url),
        headers: {'Authorization': 'Bearer $_key'},
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final data   = json.decode(res.body) as Map<String, dynamic>;
        final events = (data['events'] as List? ?? [])
            .map((e) => EconomicEvent.fromJson(e as Map<String, dynamic>))
            .where((e) => e.name.isNotEmpty)
            .toList();
        return events;
      }
    } catch (_) {}
    return [];
  }
}
