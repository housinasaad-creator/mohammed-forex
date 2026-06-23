/// Stub service — wire to a Forex Factory / Myfxbook news API later.
/// Freezes scalping signals ±15 min around high-impact events.
class NewsCalendarService {
  NewsCalendarService._();

  static const int freezeMinutesBefore = 15;
  static const int freezeMinutesAfter  = 15;

  /// Returns [true] when trading should be paused due to nearby news.
  /// Currently returns [false] until a real API is connected.
  static Future<bool> checkEconomicCalendarNews({
    required DateTime tradeTime,
    required String symbol,
  }) async {
    // TODO: Connect to Forex Factory API or Myfxbook Economic Calendar
    // Example endpoint: https://nfs.faireconomy.media/ff_calendar_thisweek.json
    //
    // Logic to implement:
    //   1. Fetch high-impact events for today.
    //   2. Filter by currency pairs matching [symbol].
    //   3. Check if [tradeTime] falls within the freeze window.
    //   4. Return true if inside window, false otherwise.
    return false;
  }

  /// Returns a list of upcoming high-impact events within the next 2 hours.
  static Future<List<NewsEvent>> getUpcomingHighImpactEvents({
    required String symbol,
  }) async {
    // TODO: Parse from live API
    return [];
  }
}

class NewsEvent {
  final String title;
  final String currency;
  final String impact; // "High", "Medium", "Low"
  final DateTime scheduledTime;

  const NewsEvent({
    required this.title,
    required this.currency,
    required this.impact,
    required this.scheduledTime,
  });
}
