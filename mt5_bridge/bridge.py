from flask import Flask, jsonify, request
from flask_cors import CORS
import yfinance as yf
import time

app = Flask(__name__)
CORS(app, resources={r"/*": {
    "origins": "*",
    "allow_headers": ["Content-Type"],
    "methods": ["GET", "POST", "OPTIONS"],
    "supports_credentials": False,
}})

SYMBOL_MAP = {
    'EURUSD': 'EURUSD=X', 'GBPUSD': 'GBPUSD=X', 'AUDUSD': 'AUDUSD=X',
    'NZDUSD': 'NZDUSD=X', 'USDJPY': 'JPY=X',    'USDCHF': 'CHF=X',
    'USDCAD': 'CAD=X',    'USDCNH': 'CNY=X',
    'XAUUSD': 'GC=F',     'XAGUSD': 'SI=F',
    'XPTUSD': 'PL=F',     'XPDUSD': 'PA=F',     'XCUUSD': 'HG=F',
    'BTCUSD': 'BTC-USD',  'ETHUSD': 'ETH-USD',
}

INTERVAL_MAP = {
    '5min':  ('5m',  '5d'),
    '15min': ('15m', '8d'),
    '30min': ('30m', '15d'),
    '1h':    ('1h',  '30d'),
}

# Simple in-memory cache: key -> (timestamp, data)
_cache = {}
CACHE_TTL = 90  # seconds

def _cache_get(key):
    entry = _cache.get(key)
    if entry and (time.time() - entry[0]) < CACHE_TTL:
        return entry[1]
    return None

def _cache_set(key, data):
    _cache[key] = (time.time(), data)

def _ema(values, period):
    if len(values) < period:
        return 0.0
    k = 2.0 / (period + 1)
    ema = sum(values[:period]) / period
    for v in values[period:]:
        ema = v * k + ema * (1 - k)
    return ema

def _rsi(closes, period=14):
    if len(closes) < period + 1:
        return 50.0
    ag = al = 0.0
    for i in range(1, period + 1):
        d = closes[i] - closes[i - 1]
        if d > 0: ag += d
        else: al += abs(d)
    ag /= period
    al /= period
    for i in range(period + 1, len(closes)):
        d = closes[i] - closes[i - 1]
        ag = (ag * (period - 1) + (d if d > 0 else 0)) / period
        al = (al * (period - 1) + (abs(d) if d < 0 else 0)) / period
    return 100.0 if al == 0 else 100 - 100 / (1 + ag / al)

def _macd(closes, fast=12, slow=26, sig=9):
    if len(closes) < slow + sig + 1:
        return 0.0, 0.0, 0.0
    line = [_ema(closes[:len(closes) - sig + i], fast) - _ema(closes[:len(closes) - sig + i], slow) for i in range(sig + 1)]
    mv = line[-1]
    sv = _ema(line, sig)
    return mv, sv, mv - sv

def fetch(yf_sym, interval, period):
    df = yf.Ticker(yf_sym).history(period=period, interval=interval)
    if df.empty:
        return None
    return df

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok'})

@app.route('/indicators', methods=['POST'])
def indicators():
    body     = request.get_json() or {}
    symbol   = body.get('symbol', 'EUR/USD')
    interval = body.get('interval', '15min')

    cache_key = f"{symbol}:{interval}"
    cached = _cache_get(cache_key)
    if cached:
        return jsonify(cached)

    clean    = symbol.replace('/', '').upper()
    yf_sym   = SYMBOL_MAP.get(clean, clean + '=X')
    yf_int, yf_per = INTERVAL_MAP.get(interval, ('15m', '8d'))

    try:
        df = fetch(yf_sym, yf_int, yf_per)
        if df is None or len(df) < 20:
            return jsonify({'error': True, 'message': f'No data for {symbol}'}), 503

        closes = list(df['Close'].astype(float))
        highs  = list(df['High'].astype(float))
        lows   = list(df['Low'].astype(float))
        opens  = list(df['Open'].astype(float))

        rsi = _rsi(closes)
        mv, sv, mh = _macd(closes)

        htf_trend = 'Sideways'
        try:
            htf_key = f"{symbol}:1h"
            h1df_cached = _cache_get(htf_key)
            if h1df_cached:
                h1c = h1df_cached.get('_closes', [])
            else:
                h1df = fetch(yf_sym, '1h', '30d')
                h1c = list(h1df['Close'].astype(float)) if h1df is not None and len(h1df) >= 52 else []
                if h1c:
                    _cache_set(htf_key, {'_closes': h1c})
            if len(h1c) >= 52:
                e1 = _ema(h1c, 50)
                e2 = _ema(h1c[:-1], 50)
                if e2 > 0:
                    p = (e1 - e2) / e2 * 100
                    if p > 0.02: htf_trend = 'Bullish'
                    elif p < -0.02: htf_trend = 'Bearish'
        except Exception:
            pass

        price = closes[-1]
        tol   = price * 0.002
        ph, pl = [], []
        n = len(closes)
        for i in range(2, n - 2):
            if highs[i] > highs[i-1] and highs[i] > highs[i-2] and highs[i] > highs[i+1] and highs[i] > highs[i+2]:
                ph.append(highs[i])
            if lows[i] < lows[i-1] and lows[i] < lows[i-2] and lows[i] < lows[i+1] and lows[i] < lows[i+2]:
                pl.append(lows[i])

        nl = [l for l in pl if abs(price - l) < tol]
        nh = [h for h in ph if abs(price - h) < tol]
        if   len(nl) >= 2: sd = 'strongDemand'
        elif len(nl) == 1: sd = 'weakDemand'
        elif len(nh) >= 2: sd = 'strongSupply'
        elif len(nh) == 1: sd = 'weakSupply'
        else:               sd = 'neutral'

        start   = max(0, n - 100)
        candles = [{'o': opens[i], 'h': highs[i], 'l': lows[i], 'c': closes[i]} for i in range(start, n)]

        result = {
            'rsi': round(rsi, 2), 'macd_value': round(mv, 6),
            'macd_signal': round(sv, 6), 'macd_histogram': round(mh, 6),
            'htf_trend': htf_trend, 'sd_zone': sd,
            'candles': candles, 'pivot_highs': ph[:5], 'pivot_lows': pl[:5],
        }
        _cache_set(cache_key, result)
        return jsonify(result)

    except Exception as e:
        return jsonify({'error': True, 'message': str(e)}), 503

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
