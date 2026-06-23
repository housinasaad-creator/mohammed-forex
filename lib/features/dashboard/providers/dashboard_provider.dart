import 'package:flutter/foundation.dart';
import '../models/asset_model.dart';
import '../models/analysis_result.dart';
import '../../../services/analysis_service.dart';
import '../../../core/services/forex_service.dart';

enum AnalysisState { idle, loading, done, error }

class DashboardProvider extends ChangeNotifier {
  // ── State ──────────────────────────────────────────────────────────────────

  Asset _selectedAsset = AssetCatalogue.forexMajor.first;
  Timeframe _selectedTimeframe = Timeframe.m15;
  AnalysisState _state = AnalysisState.idle;
  AnalysisResult? _result;
  String _errorMessage = '';
  bool _mt5Connected = true; // simulated

  // ── Getters ────────────────────────────────────────────────────────────────

  Asset get selectedAsset     => _selectedAsset;
  Timeframe get selectedTimeframe => _selectedTimeframe;
  AnalysisState get state     => _state;
  AnalysisResult? get result  => _result;
  String get errorMessage     => _errorMessage;
  bool get mt5Connected       => _mt5Connected;
  bool get isLoading          => _state == AnalysisState.loading;

  // ── Actions ────────────────────────────────────────────────────────────────

  void selectAsset(Asset asset) {
    if (_selectedAsset.symbol == asset.symbol) return;
    _selectedAsset = asset;
    _result = null;
    _state = AnalysisState.idle;
    notifyListeners();
  }

  void selectTimeframe(Timeframe tf) {
    if (_selectedTimeframe == tf) return;
    _selectedTimeframe = tf;
    _result = null;
    _state = AnalysisState.idle;
    notifyListeners();
  }

  Future<void> runAnalysis({String lang = 'en'}) async {
    if (_state == AnalysisState.loading) return;

    _state = AnalysisState.loading;
    _result = null;
    _errorMessage = '';
    notifyListeners();

    try {
      // Fetch live price before analysis so entry point is real, not hardcoded
      final prices = await ForexService.fetchPrices();
      final livePrice = prices[_selectedAsset.symbol];

      final result = await AnalysisService.analyze(
        asset: _selectedAsset,
        timeframe: _selectedTimeframe,
        lang: lang,
        livePrice: livePrice,
      );
      _result = result;
      _state = AnalysisState.done;
    } catch (e) {
      _errorMessage = 'Analysis failed: ${e.toString()}';
      _state = AnalysisState.error;
    }
    notifyListeners();
  }

  void clearResult() {
    _result = null;
    _state = AnalysisState.idle;
    notifyListeners();
  }

  void toggleMt5Connection() {
    _mt5Connected = !_mt5Connected;
    notifyListeners();
  }
}
